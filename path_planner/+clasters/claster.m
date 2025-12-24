
function  [radarMatrixNew, clustersNew] = claster(distanceHistory,  numSectors, scanRange,  directionMoves, speedCurent, positionHistory, obstaclesRadius)
    % scanRange - дальность радара
    % distanceHistory - матрицы радара -  radarMatrix
    % numSectors - количество секторов радара
    % directionMoves - курсовое направление робота (направление радара)
    % speedCurent - скорость робота
    % positionHistory  список позиций робота

    % Параметры кластеризации
    epsilon = 2;     % Максимальное расстояние между точками в кластере 
    minPoints = 4;   % Минимальное количество точек для формирования кластера
    tolerance = 1;   % Допустимая погрешность для определения движения
  
    maxDist = 6;
    dt = 1; % Шаг времени 

    % центр матрицы
    num = ceil(numSectors/2);
    maxRange = scanRange;
    
    
    directionMove = directionMoves(2,:);
    % Вычисляем смещения  между старым и прошлым положением
    robotPositionCurr1 = positionHistory(2,:);
    robotPositionPrev1 = positionHistory(1,:);
    dx = robotPositionCurr1(1) - robotPositionPrev1(1);
    dy = robotPositionCurr1(2) - robotPositionPrev1(2);
    dz = robotPositionCurr1(3) - robotPositionPrev1(3);
    % Матрица трансформации робота
    T1 = getTransformationMatrix(dx, dy, dz, directionMove);

    directionMove = directionMoves(3,:);
    % Вычисляем смещения   между прошлым и текущим положением
    robotPositionCurr = positionHistory(3,:);
    robotPositionPrev = positionHistory(2,:);
    dx = robotPositionCurr(1) - robotPositionPrev(1);
    dy = robotPositionCurr(2) - robotPositionPrev(2);
    dz = robotPositionCurr(3) - robotPositionPrev(3);
    % Матрица трансформации робота
    T2 = getTransformationMatrix(dx, dy, dz, directionMove);

    % КЛАСТЕРИЗАЦИЯ точек матрицы
    % % Обработка данных
    % Кластеризация точек с радара
    
    [clustersPrev, clustersCurr, clustersOld] = clasters.clasters1(distanceHistory{3}, distanceHistory{2}, distanceHistory{1}, numSectors, scanRange, epsilon,  minPoints, directionMoves, positionHistory);
   
    % Сопоставление кластеров
    associationsOldPrev = clasters.matchClusters(clustersOld, clustersPrev, T1, maxDist);
    associationsPrevCurr = clasters.matchClusters(clustersPrev, clustersCurr, T2, maxDist);

    % Отслеживание кластеров
    [movementDetails, clustersNew] = clasters.checkClusterMovementQuadratic(clustersOld, clustersPrev, clustersCurr, associationsOldPrev, associationsPrevCurr, T1, T2, tolerance, directionMoves, positionHistory, numSectors, scanRange);

    radarMatrixNew = clasters.updateRadarMatrix(distanceHistory{1}, clustersNew, numSectors, scanRange, directionMoves(3,:), positionHistory);

    
end



%% ФУНКЦИИ

function T = getTransformationMatrix(dx, dy, dz, directionMove)
    % Создает матрицу трансформации с учётом линейного смещения и ориентации
    
    % Нормализуем вектор направления движения
    directionMove = directionMove / norm(directionMove);
    
    % Генерируем ортонормальный базис на основе directionMove
    [xAxis, yAxis, zAxis] = orthogonalizeAxes1(directionMove);
    
    % Создаём матрицу вращения
    R = [xAxis; yAxis; zAxis]; % Матрица 3x3 для ориентации
    
    % Создаём полную матрицу трансформации
    T = eye(4); % Единичная матрица 4x4
    T(1:3, 1:3) = R; % Добавляем матрицу вращения
    T(1:3, 4) = [dx; dy; dz]; % Добавляем смещения
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

