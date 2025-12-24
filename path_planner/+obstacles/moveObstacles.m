% 1.3.12 Функция вычисления новых координат препятствий
function [updatedObstaclesX, updatedObstaclesY, updatedObstaclesZ] = moveObstacles(directionMove, obstaclesX, obstaclesY, obstaclesZ, speed)
    % Функция перемещает препятствия навстречу роботу
    % obstaclesX, obstaclesY, obstaclesZ - текущие координаты препятствий
    % direction - вектор направления движения  (должен быть нормализован)
    % speed - скорость перемещения препятствий
    updatedObstaclesX = [];
    updatedObstaclesY = [];
    updatedObstaclesZ = [];
    % direction = [0.57735, -0.57735, 0.57735];
    direction = ones(1, length(obstaclesX));
    direction(2) = -1;
    direction(1) = 0;
    for i =1: length(obstaclesX)
        % Обновляем координаты препятствий, перемещая их в направлении, противоположном движению робота
        updatedObstaclesX(end + 1) = obstaclesX(i) + speed(1) * direction(i);
        updatedObstaclesY(end + 1) = obstaclesY(i) + speed(2) ;
        updatedObstaclesZ(end + 1) = obstaclesZ(i) + speed(3) ;

    end
    
end
