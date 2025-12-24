function projectedCoords = projectObstaclesToBase(obstaclePoints, apex, center, v1, v2)
    % obstaclePoints - список координат центров препятствий [x, y, z]
    % apex - вершина пирамиды [x0, y0, z0]
    % center - центр основания пирамиды
    % v1, v2 - ортогональные векторы основания
    % возвращает координаты проекций в системе координат основания

    numObstacles = size(obstaclePoints, 1);
    projectedCoords = zeros(numObstacles, 2);

    for i = 1:numObstacles
        % Вектор от вершины пирамиды к препятствию
        toObstacle = obstaclePoints(i, :) - apex;

        % Проекция вектора на основание
        projOnBase = toObstacle - dot(toObstacle, center - apex) * (center - apex) / norm(center - apex)^2;

        % Вычисляем координаты в системе координат, связанной с основанием
        projectedCoords(i, 1) = dot(projOnBase, v1);  % координата по v1
        projectedCoords(i, 2) = dot(projOnBase, v2);  % координата по v2
    end
end
