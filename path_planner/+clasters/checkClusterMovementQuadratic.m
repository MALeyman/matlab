% Вычисление нового положения кластера
function [movementDetails, clustersNew] = checkClusterMovementQuadratic(clustersOld, clustersPrev, clustersCurr, ...
    associationsOldPrev, associationsPrevCurr, T1, T2, tolerance, directionMoves, positionHistory, numSectors, scanRange)

    numOld = length(clustersOld);
    numPrev = length(clustersPrev);
    numCurr = length(clustersCurr);

    % Результаты
    movementDetails = cell(numOld, 1);
    clustersNew = clustersCurr; % Инициализируем обновлённые кластеры

    % Центры кластеров
    centersOld = cellfun(@(c) mean(c.points, 1), clustersOld, 'UniformOutput', false);
    centersOld = vertcat(centersOld{:});

    centersPrev = cellfun(@(c) mean(c.points, 1), clustersPrev, 'UniformOutput', false);
    centersPrev = vertcat(centersPrev{:});
    centersPrevTransformed = centersPrev;

    centersCurr = cellfun(@(c) mean(c.points, 1), clustersCurr, 'UniformOutput', false);
    centersCurr = vertcat(centersCurr{:});
    centersCurrTransformed = centersCurr;

    % Проверка на пустые ассоциации
    if isempty(associationsOldPrev)
        associationsOldPrev = -ones(numOld, 1); % Заполняем отсутствующими связями
    end

    if isempty(associationsPrevCurr)
        associationsPrevCurr = -ones(numPrev, 1); % Заполняем отсутствующими связями
    end

    % Обработка каждого кластера
    for i = 1:numOld
        prevIdx = associationsOldPrev(i);

        % Если старый кластер исчез
        if prevIdx == -1
            movementDetails{i} = [-2, 0, 0, 0, 0];
            %  % Добавляем данные о движении в clustersNew
            % clustersNew{currIdx}.movement = struct('isMoving', 0, ...
            %                                        'deviation', 0, ...
            %                                        'displacement', [0, 0, 0]);
            continue;
        end

        % Проверяем, если индекс `prevIdx` выходит за пределы
        if prevIdx > length(associationsPrevCurr) || prevIdx < 1
            movementDetails{i} = [-2, 0, 0, 0, 0];
             % Добавляем данные о движении в clustersNew
            % clustersNew{currIdx}.movement = struct('isMoving', 0, ...
            %                                        'deviation', 0, ...
            %                                        'displacement', [0, 0, 0]);
            continue;
        end

        currIdx = associationsPrevCurr(prevIdx);

        % Если текущий кластер исчез
        if currIdx == -1
            movementDetails{i} = [-1, 0, 0, 0, 0];
             % Добавляем данные о движении в clustersNew
            % clustersNew{currIdx}.movement = struct('isMoving', 0, ...
            %                                        'deviation', 0, ...
            %                                        'displacement', [0, 0, 0]);
            continue;
        end

        % Получение координат центра
        centerOld = centersOld(i, :);
        centerPrev = centersPrevTransformed(prevIdx, :);
        centerCurr = centersCurrTransformed(currIdx, :);

        % Временные точки 
        T = [0; 1; 2];
        X = [centerOld(1); centerPrev(1); centerCurr(1)];
        Y = [centerOld(2); centerPrev(2); centerCurr(2)];
        Z = [centerOld(3); centerPrev(3); centerCurr(3)];

        % Квадратичная аппроксимация
        px = polyfit(T, X, 2);
        py = polyfit(T, Y, 2);
        pz = polyfit(T, Z, 2);

        % Прогнозируемое положение
        futureT = 3;
        futurePos = [polyval(px, futureT), polyval(py, futureT), polyval(pz, futureT)];

        deviation = norm(centerCurr - futurePos);

        % Обновление информации о кластере
        if deviation > tolerance
            movementDetails{i} = [1, deviation, ...
                       centerCurr(1) - futurePos(1), ...
                       centerCurr(2) - futurePos(2), ...
                       centerCurr(3) - futurePos(3)];

            % Добавляем данные о движении в clustersNew
            clustersNew{currIdx}.movement = struct('isMoving', 1, ...
                                                   'deviation', deviation, ...
                                                   'displacement', futurePos - centerCurr);
            % Смещение всех точек кластера
            displacement = clustersNew{currIdx}.movement.displacement;  
            clustersNew{currIdx}.points = clustersNew{currIdx}.points - displacement;

        else
            % Обновление информации о кластере, если кластер не движется
            movementDetails{i} = [0, deviation, ...
                       centerCurr(1) - futurePos(1), ...
                       centerCurr(2) - futurePos(2), ...
                       centerCurr(3) - futurePos(3)];
            
            % Добавляем данные о движении в clustersNew
            clustersNew{currIdx}.movement = struct('isMoving', 0, ...
                                                   'deviation', 0, ...
                                                   'displacement', [0, 0, 0]);
        end
    end

    % Добавляем новые кластеры
    newClusters = setdiff(1:numCurr, associationsPrevCurr);
    for j = newClusters
        movementDetails{end + 1} = [2, 0, 0, 0, 0];

        % Помечаем новые кластеры
        clustersNew{j}.movement = struct('isMoving', 2, ...
                                         'deviation', 0, ...
                                         'displacement', [0, 0, 0]);
    end
end


function pointsTransformed = transformPoints(points, T)
    % Преобразует точки с использованием матрицы трансформации
    numPoints = size(points, 1);
    homogeneousPoints = [points, ones(numPoints, 1)]; % Добавляем координату 1
    transformedHomogeneous = (T * homogeneousPoints')'; % Применяем трансформацию
    pointsTransformed = transformedHomogeneous(:, 1:3); % Убираем последнюю координату
end