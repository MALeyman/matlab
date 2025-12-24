% Рассчёт расстояния до препятствия или цели
function distance = calculateDistance(currentX, currentY, currentZ, obstacleX, obstacleY, obstacleZ)
    distance = sqrt((obstacleX - currentX)^2 + (obstacleY - currentY)^2 + (obstacleZ - currentZ)^2);
end
