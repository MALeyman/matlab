% Шаг 2 Разница между направлением на цель и курсовым направлениме робота (вертикальное и горизонтальное отклонени
function [azimuthAngle, elevationAngleDiff] = calculateAnglesBetweenDirections(robotDir, obstacleDir)  
    % robotDir - направление движения робота
    % obstacleDir - направление на препятствие

    % Нормализуем направления
    robotDir = robotDir / norm(robotDir);
    obstacleDir = obstacleDir / norm(obstacleDir);
    % disp(['robotDir: ', num2str(robotDir)]);
    % disp(['obstacleDir: ', num2str(obstacleDir)]);
    
   % Проверка вертикальности направлений робота и препятствия
    isRobotDirVertical = abs(robotDir(1)) < 1e-6 && abs(robotDir(2)) < 1e-6;  % Только Z-компонента ненулевая
    isObstacleDirVertical = abs(obstacleDir(1)) < 1e-6 && abs(obstacleDir(2)) < 1e-6;
    
    if isRobotDirVertical && isObstacleDirVertical
        % Оба направления строго вертикальны, азимутальный угол устанавливается в 0
        azimuthAngle = 0;
        elevationAngleDiff=0;
        return
    else
        % Проекция на плоскость XY для вычисления азимутального угла
        if isRobotDirVertical
            % Если направление робота вертикально, используем только направление препятствия
            obstacleDirXY = [obstacleDir(1), obstacleDir(2), 0];
            azimuthAngle = acosd(obstacleDirXY(1) / norm(obstacleDirXY));  % Азимут для горизонтальной проекции препятствия
        elseif isObstacleDirVertical
            % Если направление препятствия вертикально, используем только направление робота
            azimuthAngle = 0;
            robotDirXY = [robotDir(1), robotDir(2), 0];

            %azimuthAngle = acosd(robotDirXY(1) / norm(robotDirXY));  % Азимут для горизонтальной проекции робота
        else
            % Оба направления не вертикальны, обычный расчет проекций на плоскость XY
            robotDirXY = [robotDir(1), robotDir(2), 0];
            obstacleDirXY = [obstacleDir(1), obstacleDir(2), 0];
    
            % Нормализация проекций
            robotDirXY = robotDirXY / norm(robotDirXY);
            obstacleDirXY = obstacleDirXY / norm(obstacleDirXY);
    
            % Азимутальный угол между проекциями направлений
            azimuthAngle = acosd(dot(robotDirXY, obstacleDirXY));
    
            % Определение знака азимута с использованием векторного произведения
            crossProduct = cross(robotDirXY, obstacleDirXY);

            if crossProduct(3) > 0  % Если z-компонента векторного произведения отрицательна, угол отрицательный
                azimuthAngle = -azimuthAngle;
            end


        end
    end
    
    % Вертикальный угол (угол возвышения) для направления на препятствие
    obstacleElevationAngle = asind(obstacleDir(3));
    
    % Вертикальный угол для направления робота
    robotElevationAngle = asind(robotDir(3));
    
    % Разница в вертикальных углах (углах возвышения)
    elevationAngleDiff = robotElevationAngle - obstacleElevationAngle;
    
    % Возвращаем горизонтальный и вертикальный углы

end

