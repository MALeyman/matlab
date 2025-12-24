% 1.3.7 Заполняет матрицу расстояниями до препятствий
function matrixDistance = fillMatrixDistance(matrixDistance, scanRange, elevationAngleDiff, azimuthAngle, obstacleDistance, obstaclesRadius, numSectors, angularSizeDegrees, obstacleData, speedCurent)
    % matrixDistance  - матрица дистанций
    % elevationAngleDiff - вертикальный угол отклонения от направления на препятствие
    % azimuthAngle  - горизонтальный угол отклонения от направления на препятствие
    % obstacleDistance - расстояние до препятствия
    % obstaclesRadius - Радиус препятствий
    % scanRange - дальность радара
    % numSectors -разбиение угла радара на сектора 
    %disp(["numSectors", num2str(numSectors)])
    num = ceil(numSectors/2);
    % Координаты центра препятствия в матрице
    x = num + azimuthAngle;
    y = num + elevationAngleDiff;
    
    % Приближение препятствий
    if speedCurent > 0.99
        obstacleDistance = obstacleDistance - 11;
    elseif speedCurent > 0.8
        obstacleDistance = obstacleDistance - 10;
    elseif speedCurent > 0.6
        obstacleDistance = obstacleDistance - 8;
    elseif speedCurent > 0.4
        obstacleDistance = obstacleDistance - 6;
    else 
        obstacleDistance = obstacleDistance - 4;
    end
    
    % Угловое расширение препятствий
    if obstacleDistance > scanRange/2 
        dist = 1;
    elseif obstacleDistance > scanRange/3
        dist = 2;
    elseif obstacleDistance > obstaclesRadius * 3
        dist = 3;
    elseif obstacleDistance > obstaclesRadius * 2
        dist = 4;
    elseif  obstacleDistance > obstaclesRadius * 1.7
        dist = 5;
    elseif obstacleDistance > obstaclesRadius * 1.5
        dist = 6;
    elseif obstacleDistance > obstaclesRadius*1.1
        dist = 10;
    else
        dist = 11;
    end
    % x = num + obstacleData(1);
    % y = num + obstacleData(2);

    % Вычисление углового размера препятствия 
    angularSizeDegrees = angularSizeDegrees*2;
    disp(["Угловой размер препятствия - ", num2str(angularSizeDegrees)]);
    
    disp(["Координаты   ", num2str(azimuthAngle), num2str(elevationAngleDiff)])

    % Левая граница
    leftX = floor(x - angularSizeDegrees/2);
    leftX = leftX - dist;
    if leftX < 1
        leftX = 1;    
    end
    % Правая граница
    rightX = ceil(x + angularSizeDegrees/2); 
    rightX = rightX + dist;
    if rightX > numSectors
        rightX = numSectors;
    elseif rightX < 1
        rightX = 1;
    end
    % Верхняя граница
    upY = floor(y - angularSizeDegrees/2);
    upY = upY - dist;
    if upY < 1
        upY = 1;
    end
    % Нижняя граница
    downY = ceil(y + angularSizeDegrees/2);
    downY = downY + dist;
    if downY > numSectors
        downY = numSectors;
    end

    % disp(["upY", num2str(upY)]);
    % disp(["downY",  num2str(downY)]);
    % disp(["leftX", num2str(leftX)]);
    % disp(["rightX",  num2str(rightX)]);

    % Логическое индексирование для обновления матрицы
    subMatrix = matrixDistance(upY:downY, leftX:rightX);  % Извлекаем подматрицу
    mask = obstacleDistance < subMatrix;  % Создаем логическую маску для сравнения
    subMatrix(mask) = obstacleDistance;  % Обновляем только те элементы, которые удовлетворяют условию
    matrixDistance(upY:downY, leftX:rightX) = subMatrix;  % Записываем обратно в матрицу

end



