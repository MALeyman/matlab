%  Заполнение матрицы дистанций
function [matrixDistance, minDistObstacle, detectedObstacles] = matrixDistance(directionMove, obstaclesInfo, obstaclesRadius, detectedObstacles, matrixDistance, scanRange, numSectors, minDistObstacle, currentX, currentY, currentZ, speedCurent)
    % directionMove - текущее курсовое направление
    % obstaclesRadius - массив с информацией о препятствиях
    % detectedObstacles - массив с информацией обнаружено или нет препятствие
    % obstaclesRadius - радиус препятствия
    % matrixDistance - матрица дистанций
    % scanRange - дальность радара
    % numSectors - разбиение радара
    disp('Обнаружены препятствия:');
    
    % ЗАПОЛНЕНИЕ МАТРИЦЫ ДИСТАНЦИЙ
    for i = 1:length(obstaclesInfo)
        obstacleData = obstaclesInfo{i};
        % fprintf('Препятствие %d:\n', obstacleData{1});
        % fprintf('Координаты: [%f, %f, %f]\n', obstacleData{2});
        % fprintf('Расстояние: %f\n', obstacleData{3});
        % fprintf('Направление ПРЕПЯТСТВИЕ: [%f, %f, %f]\n', obstacleData{4});
        % fprintf('координаты препятствия в матрице: [%f, %f, %f]\n', obstacleData{5});
        % fprintf('Направление на ЦЕЛЬ: [%f, %f, %f]\n', directionTarget);
    
        % Если препятствие попало в поле радара, отмечаем его как "обнаруженное"
        detectedObstacles(obstacleData{1}) = 1;  % Отмечаем препятствие как обнаруженное
        % 1.3.5 Разница направлений движения робота и направления на препятствия горизонтальный и вертикальный углы
        [azimuthAngle, elevationAngleDiff] = calculate.calculateAnglesBetweenDirections(directionMove, obstacleData{4});
        
        % Вычисление углового размера препятствия
        angularSizeDegrees = matrix.calculateAngularSize(obstaclesRadius, obstacleData{3});
        if abs(azimuthAngle) < angularSizeDegrees && abs(elevationAngleDiff) < angularSizeDegrees
        %     if movementSelection == 2 || movementSelection == 3 
        %         movementSelection = 3;
        %     else
        %         movementSelection = 1; % Если препятствие по курсу обнаружено
        %     end
            disp('   ================================================   Препятствие по курсу     =============');
            if minDistObstacle > obstacleData{3}
                minDistObstacle = obstacleData{3};
            end
        end
    
        % 1.3.6 Визуализация направлений
        %visualizeAnglesAndDirections(directionMove, obstacleData{4}, [currentX, currentY, currentZ])
    
        %%%%%%%%
        % Заполнение матрицы данными
        %%%%%%%%
        %  1.3.7 заполнение новой матрицы дистанций
        matrixDistance = matrix.fillMatrixDistance(matrixDistance, scanRange, elevationAngleDiff, azimuthAngle, obstacleData{3}, obstaclesRadius, numSectors, angularSizeDegrees, obstacleData{5}, speedCurent);
    end    
end



