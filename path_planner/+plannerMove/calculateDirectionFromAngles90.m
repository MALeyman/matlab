% 1.3.9 Вектор нового курса по текущему курсу и углам отклонений
function robotNewDir = calculateDirectionFromAngles90(robotDir, azimuthAngle, elevationAngleDiff, movementSelection, numSectors)
    % robotDir - курсовое направление движения робота
    % azimuthAngle - горизонтальный угол отклонения для нового маршрута (в градусах)
    % elevationAngleDiff - вертикальный угол отклонения для нового маршрута (в градусах)
    % movementSelection - особый случай
    
    % 1. Нормализуем текущее курсовое направление робота
    robotDir = robotDir / norm(robotDir);

    % 2. Вычисляем проекцию вектора на плоскость XY
    projectionXY = sqrt(robotDir(1)^2 + robotDir(2)^2);

    % 3. Вычисляем текущий азимутальный угол (в плоскости XY) с помощью atan2
    % atan2 возвращает угол между вектором и осью X
    currentAzimuth = atan2d(robotDir(2), robotDir(1));  % В градусах
    % 4. Вычисляем текущий угол возвышения % В градусах
    % Если прохода нет то движемся вправо и параллельно XY
    % Текущий вертикальный угол возвышения
    if movementSelection == 3
        currentElevation = 0;
    else
        currentElevation = atan2d(robotDir(3), projectionXY);  
    end

    % 5. Прибавляем углы отклонения к азимутальному углу и углу возвышения
    newElevation = currentElevation - elevationAngleDiff;
    if newElevation > 40
            newElevation = 40;
            % центр матрицы (текущее курсовое направление)
            num = ceil(numSectors/2); 
            azimuthAngle = num;
        elseif newElevation < -40
            newElevation = -40;
            % центр матрицы (текущее курсовое направление)
            num = ceil(numSectors/2); 
            azimuthAngle = num;
    end
    newAzimuth = currentAzimuth - azimuthAngle;


    % 6. Рассчитываем новые компоненты курсового вектора
    % Используем косинус и синус для восстановления вектора
    robotNewDir = [
        cosd(newAzimuth) * cosd(newElevation);  % X компонент
        sind(newAzimuth) * cosd(newElevation);  % Y компонент
        sind(newElevation)                     % Z компонент
    ];

    % 7. Нормализуем новый вектор направления
    robotNewDir = robotNewDir / norm(robotNewDir);

    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    elevationAngle2 = atan2d(robotDir(3), projectionXY);  % Угол в градусах
    % Вывод результата
    disp(['Угол возвышения относительно плоскости XY: ', num2str(elevationAngle2), ' градусов']);
    % 2. Вычисляем азимутальный угол относительно оси X
    azimuthAngle2 = atan2d(robotDir(2), robotDir(1));  % Угол в градусах
    % Вывод результата
    disp(['Азимутальный угол относительно оси X: ', num2str(azimuthAngle2), ' градусов']);

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % 2. Вычисляем проекцию на плоскость XY
    projectionXY1 = sqrt(robotNewDir(1)^2 + robotNewDir(2)^2);    
    % 3. Вычисляем угол возвышения относительно плоскости XY
    elevationAngle1 = atan2d(robotNewDir(3), projectionXY1);  % Угол в градусах
    % Вывод результата
    disp(['НОВЫЙ Угол возвышения относительно плоскости XY: ', num2str(elevationAngle1), ' градусов']);

    % 2. Вычисляем азимутальный угол относительно оси X
    azimuthAngle1 = atan2d(robotNewDir(2), robotNewDir(1));  % Угол в градусах
    % Вывод результата
    disp(['НОВЫЙ Азимутальный угол относительно оси X: ', num2str(azimuthAngle1), ' градусов']);

end
