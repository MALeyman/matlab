% ШАГ 8 углы отклонений  оптимального направления (выбирает из матрицы дистанций)
function [horizontalAngle,verticalAngle, movementSelection] = directionOpt(matrixDistance, numSectors, azimuthAngleTarget, elevationAngleDiffTarget, scanRange)
    % matrixDistance - матрица дистанций
    % numSectors - количество секторов (разбиение радара)
    % azimuthAngleTarget, elevationAngleDiffTarget - углы отклонения на цель
    % horizontalAngle - горизонтальное отклонение в матрице, от курса на Цель
    % verticalAngle - вертикальное отклонение в матрице, от курса на Цель

    % Шаг 7 если направление на цель выходит за пределы матрицы, выбирает  ближайшие значения (координаты в матрице)
    
    % центр матрицы (текущее курсовое направление)
    num = ceil(numSectors/2); 

    % Горизонтальная координата
    roundX = round(azimuthAngleTarget);
    X = roundX + num;
    if X < 1
        X = 1; 
    elseif X > numSectors
        X = numSectors; 
    end  
    % Вертикальная координата
    roundY = round(elevationAngleDiffTarget);
    Y = roundY + num;
    if Y < 1
        Y = 1; 
    elseif Y > numSectors
        Y = numSectors; 
    end
      
    % Находим максимальные значения в каждом столбце  
    maxValues = max(matrixDistance(:));  
    % Если прохода нет то выбираем крайнее правое направление движемся вправо
        % горизонтально (порачиваем)
        if maxValues < scanRange
            horizontalAngle = num;
            verticalAngle = 0;
            movementSelection = 1;
            return;    
        else
            movementSelection = 0;
        end

    % Шаг 8  Поиск ближайшего направления к нужному
    [closestMaxCoord] = plannerMove.findClosestMaxValue(matrixDistance, [X, Y], scanRange, numSectors);
    if closestMaxCoord(1) == -1
        horizontalAngle = num;
        verticalAngle = 0;
    else
        horizontalAngle = closestMaxCoord(1)-num;
        verticalAngle = closestMaxCoord(2)-num;
    end

    disp(['Горизонтальный Угол отклонения ', num2str(horizontalAngle)]);
    disp(['Вертикальный Угол отклонения ', num2str(verticalAngle)]);
   
end
