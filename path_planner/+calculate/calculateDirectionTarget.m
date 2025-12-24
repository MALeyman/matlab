% 1.3.2 Вычисление углов направления на цель и направления на цель
function directionTarget = calculateDirectionTarget(currentX, currentY, currentZ, targetX, targetY, targetZ)
    angleToTargetXY = atan2(targetY - currentY, targetX - currentX);
    distanceXY = sqrt((targetX - currentX)^2 + (targetY - currentY)^2);
    angleToTargetZ = atan2(targetZ - currentZ, distanceXY);

    % Вычисление компонента вектора
    dx = cos(angleToTargetZ) * cos(angleToTargetXY);
    dy = cos(angleToTargetZ) * sin(angleToTargetXY);
    dz = sin(angleToTargetZ);

    % Нормализованный вектор направления
    directionTarget = [dx, dy, dz] / norm([dx, dy, dz]);
end
