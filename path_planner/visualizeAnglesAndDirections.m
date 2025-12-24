% 1.3.6 Визуализация направлений
function visualizeAnglesAndDirections(robotDir, obstacleDir, robotPos)
    % Вычисляем направление на препятствие
    %targetDir = robotPos - targetPos;
    
    % Нормализуем направления
    robotDir = robotDir / norm(robotDir);
    obstacleDir = obstacleDir / norm(obstacleDir);
    
    % Проекция на плоскость XY для азимутального угла
    robotDirXY = [robotDir(1), robotDir(2), 0];
    targetDirXY = [obstacleDir(1), obstacleDir(2), 0];
    
    % Нормализуем проекции
    robotDirXY = robotDirXY / norm(robotDirXY);
    targetDirXY = targetDirXY / norm(targetDirXY);
    
    % Горизонтальный угол (азимут) между проекциями направлений
    azimuthAngle = acosd(dot(robotDirXY, targetDirXY));
    
    % Вертикальный угол (угол возвышения) направления на цель
    targetElevationAngle = asind(obstacleDir(3));

    % Вертикальный угол для направления робота
    robotElevationAngle = asind(robotDir(3));

    % Разница в вертикальных углах (углах возвышения)
    elevationAngleDiff = targetElevationAngle - robotElevationAngle;


    
    % Визуализация 3D пространства
    figure;
    hold on;
    grid on;
    
    % Визуализация робота
    quiver3(robotPos(1), robotPos(2), robotPos(3), robotDir(1), robotDir(2), robotDir(3), 0, 'r', 'LineWidth', 2, 'DisplayName', 'Robot Direction');
    
    % Визуализация направления на цель
    quiver3(robotPos(1), robotPos(2), robotPos(3), obstacleDir(1), obstacleDir(2), obstacleDir(3), 0, 'b', 'LineWidth', 2, 'DisplayName', 'Target Direction');
    
    % Визуализация проекций на плоскость XY
    quiver3(robotPos(1), robotPos(2), robotPos(3), robotDirXY(1), robotDirXY(2), 0, 'g--', 'LineWidth', 1, 'DisplayName', 'Robot Dir XY Projection');
    quiver3(robotPos(1), robotPos(2), robotPos(3), targetDirXY(1), targetDirXY(2), 0, 'm--', 'LineWidth', 1, 'DisplayName', 'Target Dir XY Projection');
    
    % Настройка осей
    axis equal;
    xlabel('X');
    ylabel('Y');
    zlabel('Z');
    
    % Добавляем легенду
    legend;
    
    % Настройка названия графика
    title(sprintf('Azimuth: %.2f°, Elevation: %.2f°', azimuthAngle, elevationAngleDiff));
    
    % Отображение сетки
    view(3);
end

