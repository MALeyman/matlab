
% Позиция робота и направление движения
robotPosition = [0, 0, 0];
directionMove = [0, 1, 0]; % Робот движется вдоль оси Y






% Создаём несколько кластеров (препятствий), движущихся в разных направлениях
clustersNew = {
    struct('points', [-1, 3, 0], ...
           'movement', struct('isMoving', 1, ...
                              'displacement', [1, 0, 0])),   % Препятствие 1 движется по диагонали
    struct('points', [2, 2, 0], ...
           'movement', struct('isMoving', 1, ...
                              'displacement', [1, 0, 0])),   % Препятствие 2 движется вниз
    struct('points', [3, 1, 0], ...
           'movement', struct('isMoving', 1, ...
                              'displacement', [1, 0, 0]))    % Препятствие 3 движется вправо
};








tolerance = 0.005;

[collisionDetected, newDirection] = collision.checkAndAvoidCollisionBehind(robotPosition, directionMove, clustersNew, tolerance);

if collisionDetected
    disp(collisionDetected);
    disp('New direction:');
    disp(newDirection);
else
    disp(collisionDetected);
end
