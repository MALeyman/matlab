% 1.3.11 Обновление координат с использованием вектора направления движения
function [currentX, currentY, currentZ] = newCoordinate(currentX, currentY, currentZ, directionMove, speedCurent)
    % directionMove - вектор нового направления движения [dx, dy, dz]
    % speedCurent - величина шага движения, текущая скорость робота


    % Нормализуем вектор направления движения
    directionMove = directionMove / norm(directionMove);

    % Вычисляем шаг перемещения по осям X, Y и Z
    stepX = directionMove(1) * speedCurent;
    stepY = directionMove(2) * speedCurent;
    stepZ = directionMove(3) * speedCurent;

    % Обновляем координаты объекта
    currentX = currentX + stepX;
    currentY = currentY + stepY;
    currentZ = currentZ + stepZ;
end
