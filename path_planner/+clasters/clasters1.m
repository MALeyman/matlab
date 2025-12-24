function [clustersPrev, clustersCurr, clustersOld] = clasters1(radarMatrixOld, radarMatrixPrev, radarMatrixCurr, numSectors, scanRange, epsilon, minPoints, directionMoves, positionHistory)
    % Преобразование данных радара в декартовые координаты и матричные индексы
    [pointsOld, indicesOld] = polarToCartesianWithIndices(radarMatrixOld, numSectors, scanRange, directionMoves(1,:), positionHistory(1,:));
    [pointsPrev, indicesPrev] = polarToCartesianWithIndices(radarMatrixPrev, numSectors, scanRange, directionMoves(2,:), positionHistory(2,:));
    [pointsCurr, indicesCurr] = polarToCartesianWithIndices(radarMatrixCurr, numSectors, scanRange, directionMoves(3,:), positionHistory(3,:));
    disp("ВЫВОД ПОЗИЦИЙ РОБОТА И НАПРАВЛЕНИЙ")
    disp(positionHistory)
    disp(directionMoves)

    % Кластеризация
    labelsPrev = [];
    labelsCurr = [];
    labelsOld = [];
    if ~isempty(pointsPrev)
        labelsPrev = dbscan(pointsPrev, epsilon, minPoints);
    end

    if ~isempty(pointsCurr)
        labelsCurr = dbscan(pointsCurr, epsilon, minPoints);
    end

    if ~isempty(pointsOld)
        labelsOld = dbscan(pointsOld, epsilon, minPoints);
    end


    % Извлечение кластеров с минимальными расстояниями и матричными координатами (по глобальным координатам)
    clustersPrev = extractClusters(pointsPrev, indicesPrev, labelsPrev, positionHistory(2,:));
    clustersCurr = extractClusters(pointsCurr, indicesCurr, labelsCurr, positionHistory(3,:));
    clustersOld = extractClusters(pointsOld, indicesOld, labelsOld, positionHistory(1,:));
end

%% Функции
function [points, indices] = polarToCartesianWithIndices(radarMatrix, numSectors, scanRange, directionMove, robotPosition)
    % Преобразует полярные данные радара в декартовые координаты с учётом направления движения

    center = ceil(numSectors / 2); % Центр матрицы
    points = []; % Список точек в декартовых координатах
    indices = []; % Список индексов матрицы (i, j)

    % Нормализация направления движения
    directionMove = directionMove / norm(directionMove); % Единичный вектор направления

    % Создаем систему координат, связанную с направлением движения
    [xAxis, yAxis, zAxis] = orthogonalizeAxes1(directionMove);
    R = [xAxis; yAxis; zAxis]; % Матрица перехода

    for i = 1:numSectors
        for j = 1:numSectors
            r = radarMatrix(i, j); % Расстояние до препятствия
            if r < scanRange % Пропускаем "пустые" направления
                % Углы относительно центра матрицы
                phi = -(i - center) / (center - 1) * (pi / 4); % Угол места (вверх/вниз)
                theta = (j - center) / (center - 1) * (pi / 4); % Азимут (влево/вправо)

                % Преобразуем в локальные декартовые координаты (в системе радара)
                zLocal = r * cos(phi) * cos(theta); % Вдоль направления движения робота
                xLocal = r * cos(phi) * sin(theta); % Поперёк (слева/справа)
                yLocal = r * sin(phi);              % Вертикальная компонента


                phi = deg2rad(i - center);
                theta = deg2rad(j - center);


                % Преобразуем в локальные декартовые координаты (в системе радара)
                zLocal = r * cos(phi) * cos(theta); % Вдоль направления движения робота
                xLocal = -r * cos(phi) * sin(theta); % Поперёк (слева/справа)
                yLocal = r * sin(phi);              % Вертикальная компонента




                degrees1 = rad2deg(phi);
                degrees2 = rad2deg(theta);

                % Преобразуем в глобальные координаты
                localCoords = [xLocal; yLocal; zLocal];
                globalCoords = R' * localCoords + robotPosition(:);

                % Сохраняем точки и индексы
                points = [points; globalCoords']; % Добавляем точку
                indices = [indices; i, j];       % Сохраняем индексы матрицы
            end
        end
    end
end

function clusters = extractClusters(points, indices, labels, robotPosition)
    % Извлекает кластеры точек с учётом минимального расстояния и матричных координат
    uniqueLabels = unique(labels(labels > 0)); % Убираем шум (-1)
    clusters = cell(length(uniqueLabels), 1); % Для хранения кластеров и их информации
    
    for i = 1:length(uniqueLabels)
        clusterPoints = points(labels == uniqueLabels(i), :); % Точки кластера
        clusterIndices = indices(labels == uniqueLabels(i), :); % Индексы матрицы кластера
        
        clusters{i}.points = clusterPoints; % Сохраняем точки кластера
        clusters{i}.indices = clusterIndices; % Сохраняем индексы матрицы

        % Расчёт расстояния от робота
        distancesToRobot = sqrt(sum((clusterPoints - robotPosition).^2, 2)); % Расстояния от робота
        clusters{i}.minDistance = min(distancesToRobot); % Минимальное расстояние до кластера
    end
end


function [xAxis, yAxis, zAxis] = orthogonalizeAxes1(directionMove)
    % Создание ортонормированного базиса из направления движения
    zAxis = directionMove / norm(directionMove); % Направление движения

    % Создаем временный вектор, гарантированно не коллинеарный с zAxis
    if abs(zAxis(3)) < 0.99
        tempVec = [0, 0, 1]; % Используем ось Z, если zAxis не коллинеарен Z
    else
        tempVec = [1, 0, 0]; % Иначе используем ось Y
    end

    % Вычисляем ортогональные оси
    xAxis1 = cross(tempVec, zAxis); % Перпендикуляр к zAxis
    xAxis = xAxis1 / norm(xAxis1); % Нормируем xAxis
    yAxis2 = cross(zAxis, xAxis); % yAxis автоматически будет ортогональным
    yAxis = yAxis2 / norm(yAxis2); % Нормируем yAxis для стабильности
end