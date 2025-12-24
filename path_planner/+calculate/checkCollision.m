% 1.3.3 Проверка на столкновения
function collided = checkCollision(currentX, currentY, currentZ, obstaclesX, obstaclesY, obstaclesZ, obstaclesRadius)
    collided = false;
    radius = obstaclesRadius; % Радиус сферического препятствия
    for i = 1:length(obstaclesX)
        if calculate.calculateDistance(currentX, currentY, currentZ, obstaclesX(i), obstaclesY(i), obstaclesZ(i)) < radius
            collided = true;
            return;
        end
    end
end
