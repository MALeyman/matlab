% 1.3  Визуализация перемещения
function visualiseMove(width, height, depth, startX, startY, startZ, targetX, ...
    targetY, targetZ, speedMax, sectorAngle, scanRange, numSectors, obstaclesRadius, ...
    display_radar, speedObstacles, numType, dangerZone, numObstacles, video_flag, flagHistory)

    %  obstaclesType - Тип препятствий
    % dangerZone - Зоны опасности

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Запись видео
    if video_flag
        % Параметры для записи видео из двух окон
        videoFileRobot = 'robot_view.avi';  % Название видео для окна робота
        videoFileRadar = 'radar_view.avi';  % Название видео для окна радара
        % Параметры для записи итогового видео
        videoFileCombined = 'combined_view.avi';  % Название итогового видео
        frameRate = 15;  % Количество кадров в секунду
      
        % Создаём объект для записи видео
        vidCombined = VideoWriter(videoFileCombined);
        vidCombined.FrameRate = frameRate;
        open(vidCombined);

        % Создаём объекты для записи двух видеофайлов
        vidRobot = VideoWriter(videoFileRobot);
        vidRadar = VideoWriter(videoFileRadar);
        vidRobot.FrameRate = frameRate;
        vidRadar.FrameRate = frameRate;
        open(vidRobot);
        open(vidRadar);
    end

    % Создаём две отдельные фигуры для каждого окна
    robotFigure = figure('Name', 'Robot View');
    set(robotFigure, 'Position', [20, 50, 900, 900]); % [x, y, width, height]
    hold on;
    radarFigure = figure('Name', 'Radar View');
    set(radarFigure, 'Position', [930, 500, 500, 500]); % [x, y, width, height]
    hold on;

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % НАЧАЛЬНАЯ ИНИЦИАЛИЗАЦИЯ
    % ШАГ 0 - Текущая скорость робота и текущие координаты
    speedCurent = speedMax;
    currentX = startX;
    currentY = startY;
    currentZ = startZ;
    pathX = startX;  % массив для хранения координат X пути
    pathY = startY;  % массив для хранения координат Y пути
    pathZ = startZ;  % массив для хранения координат Z пути
    obstaclesInfo = []; % массив для хранения информации о препятствиях
    % movementSelection  Вид направления
    % 0 - Проход есть, движение к цели
    % 1 - Прохода нет, движение к цели
    % 2 - Проход есть, Направление движения более 90 градусов от направления на цель
    % 3 - Прохода нет, Направление движения более 90 градусов от направления на цель
    movementSelection = 0;

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % СОЗДАНИЕ точек робота с целью и пирамиды
    % Начальная точка
    % Установка текущей фигуры перед отрисовкой начальной точки, целевой точки и линии до цели
    figure(robotFigure);
    hold on;
    % Создание начальной точки, целевой точки и линии до цели в фигуре robotFigure
    start = plot3( startX, startY, startZ, 'bo', 'MarkerSize', 9, 'MarkerFaceColor', 'b');
    target = plot3( targetX, targetY, targetZ, 'gX', 'MarkerSize', 15);
    line = plot3([startX, targetX], [startY, targetY], [startZ, targetZ], 'k--');

    % Создание графического объекта линии для пути
    pathLine = plot3(startX, startY, startZ, 'b-', 'LineWidth', 1); 
    
    % Создание начальных объектов пирамиды
    pyramidVertices = gobjects(4, 1);
    for i = 1:4
        pyramidVertices(i) = plot3([0, 0], [0, 0], [0, 0], 'r', 'LineWidth', 1, 'LineStyle', '-');
    end
    pointPlot = plot3([], [], [], 'ko', 'MarkerFaceColor', 'g', 'MarkerSize', 8);
    
    % Добавление названий координат
    xlabel('X');
    ylabel('Y');
    zlabel('Z');

    % Создание начального объекта для пирамиды
    pyramidPatch = patch('XData', [], 'YData', [], 'ZData', [], 'FaceColor', 'b', 'FaceAlpha', 0.1, 'EdgeColor', 'none');

    % 1.1 Создание координат препятствий
    [obstaclesX, obstaclesY, obstaclesZ]  = obstacles.generateObstacles(width, height, depth, numObstacles, obstaclesRadius, numType);

    % 1.2 Визуализация  препятствий и сохранение объектов
    obstacleObjects = obstacles.visualizeField(robotFigure, width, height, depth, obstaclesX, obstaclesY, obstaclesZ, obstaclesRadius, numType);

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % ШАГ 0 НАЧАЛЬНЫЕ Направления
    %========
    % 1.3.2 Вычисление  направления на цель    
    directionTarget = calculate.calculateDirectionTarget(currentX, currentY, currentZ, targetX, targetY, targetZ);
    %========
    % 1.3.2  Вычисление курсового направления на старте совпадает с направлением на цель
    directionMove = calculate.calculateDirectionTarget(currentX, currentY, currentZ, targetX, targetY, targetZ);
    % disp(directionMove);
    
    % Если использовать историю.
    if flagHistory
        % Шаг времени
        deltaTime = 1; % Например, каждая итерация занимает 0.1 секунды
        currentTime = 0; % Изначально текущее время равно 0
        % Инициализация истории матриц
        numMatrices = 3; % Количество матриц в истории
        distanceHistory = cell(1, numMatrices); % Создаем ячейковый массив для хранения
        positionHistory = zeros(4, 3); %  строки для позиций [x, y, z]
        directionMoves = zeros(3, 3); %  строки для направлений
        directionMoves = [directionMoves(2:end, :); directionMove];
        directionMoves = [directionMoves(2:end, :); directionMove]; 
        % Заполнение матриц 
        for i = 1:numMatrices
            distanceHistory{i} = (scanRange + 10) * ones(numSectors, numSectors);
        end
    end

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % ОСНОВНОЙ ЦИКЛ
    % Пока не достигнута цель
    while sqrt((currentX - targetX)^2 + (currentY - targetY)^2 + (currentZ - targetZ)^2) > speedCurent
        % Инициализируем массив как "необнаруженные"
        detectedObstacles = zeros(1, length(obstaclesX)); 
        % 1.3.3 Проверка на столкновение с препятствием
        if calculate.checkCollision(currentX, currentY, currentZ, obstaclesX, obstaclesY, obstaclesZ, obstaclesRadius)
            disp('Произошло столкновение!');
            return;
        end
        minDistObstacle = scanRange;
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % ШАГ 1  ПОЛУЧЕНИЕ ДАННЫХ С РАДАРА 
        % Обновление радара - информация о препятствиях
        figure(robotFigure);
        hold on;
        obstaclesInfo = radar.scanPyramidForObstacles([currentX, currentY, currentZ], ...
            directionMove, directionTarget, scanRange, sectorAngle, display_radar, ...
            pyramidPatch, pyramidVertices, obstaclesX, obstaclesY, obstaclesZ, obstaclesRadius, robotFigure);
   
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % ШАГ 2  ВЫЧИСЛЕНИЕ НАПРАВЛЕНИЯ
        %   Вычисление вектора направления на цель    
        directionTarget = calculate.calculateDirectionTarget(currentX, currentY, currentZ, targetX, targetY, targetZ);
        
        % ШАГ 2 Разница между направлением на цель и курсовым направлениме робота (вертикальное и горизонтальное отклонения)
        [azimuthAngleTarget, elevationAngleDiffTarget] = calculate.calculateAnglesBetweenDirections(directionMove, directionTarget);
        
        % Если движение в сторону
        if abs(azimuthAngleTarget) > 90 || abs(elevationAngleDiffTarget) > 90
            movementSelection = 2;
        else % Если движение на цель
            movementSelection = 0;
        end

        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % ШАГ 1  Заполнение  матрицы дистанций от радара
        % Создание матрицы дистанций
        matrixDistance = (scanRange + 10) * ones(numSectors, numSectors);
        % Проверка массива с информацией о препятствиях, если препятствия есть то изменяем матрицу дистанций
        if ~isempty(obstaclesInfo)
            % ЗАПОЛНЕНИЕ МАТРИЦЫ ДИСТАНЦИЙ
            [matrixDistance, minDistObstacle, detectedObstacles] = matrix.matrixDistance(directionMove, obstaclesInfo, obstaclesRadius, detectedObstacles, matrixDistance, scanRange, numSectors, minDistObstacle, currentX, currentY, currentZ, speedCurent);           
            
        end

        % Если использовать историю.
        if flagHistory
            % Увеличение текущего времени
            currentTime = currentTime + deltaTime;
            % Список матриц дистанций для хранения историй
            distanceHistory = [{matrixDistance}, distanceHistory(1:end-1)];
            disp("distanceHistory")
            disp(distanceHistory)
            % Список позиций робота
            positionRobot =[currentX, currentY, currentZ];
           % positionHistory = [positionHistory(2:end, :); positionRobot];  % Добавляем текущую позицию, сдвигая массив вверх
            directionMove = directionMove/norm(directionMove); % Направление движения робота (нормализованный вектор)
            directionMoves = [directionMoves(2:end, :); directionMove];     % Добавляем текущее направление, сдвигая массив вверх
            % Расчёт следующего положения
            positionRobotNew = positionRobot + speedCurent * directionMove;
            positionHistory = [positionHistory(2:end, :); positionRobotNew];  % Добавляем Будущую  позицию, сдвигая массив вверх
            % рассчёт новой матрицы на основе предыдущих (учитывается
            % движение перпятствий
            disp("positionHistory"); 
            disp( positionHistory);
            disp("directionMoves")
            disp(directionMoves);
            [matrixDistance, clustersNew] = clasters.claster(distanceHistory,  numSectors, scanRange+ 10,  directionMoves, speedCurent, positionHistory, obstaclesRadius);

           [collisionDetected, newDirection] = collision.checkAndAvoidCollisionBehind(positionHistory(4,:), directionMoves(3,:), clustersNew, obstaclesRadius, currentTime);
           if collisionDetected
                disp("МЕНЯЕМ направление");
                % directionMoveNew = newDirection;
           end
        end

        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % ПЛАНИРОВЩИК
        %%%%%
        % Шаг 3 Вычисляем новое курсовое направление если ОБНАРУЖЕНЫ ПРЕПЯТСТВИЯ
        if ~isempty(obstaclesInfo)
            % проход есть ПРЯМО ПО КУРСУ ДВИЖЕНИЯ
            if movementSelection == 0
                % 1.3.8 координаты отклонений  оптимального направления в матрице
                [horizontalAngle, verticalAngle, movementSelection] = plannerMove.directionOpt(matrixDistance, numSectors, azimuthAngleTarget, elevationAngleDiffTarget, scanRange + 10);

                % ШАГ 8 - Вычисление нового курсового направления
                directionMoveNew = plannerMove.calculateDirectionFromAngles(directionMove,  horizontalAngle, verticalAngle, movementSelection, numSectors);
                directionMoveNew = directionMoveNew';
                % Прохода нет, движение к цели
            elseif movementSelection == 1
                % 1.3.8 координаты отклонений  оптимального направления в матрице
                [horizontalAngle, verticalAngle, movementSelection] = plannerMove.directionOpt(matrixDistance, numSectors, azimuthAngleTarget, elevationAngleDiffTarget, scanRange + 10);

                % ШАГ 8  Вычисление нового курсового направления
                directionMoveNew = plannerMove.calculateDirectionFromAngles(directionMove, horizontalAngle, verticalAngle, movementSelection, numSectors);
                directionMoveNew = directionMoveNew';
            % Проход есть, Направление движения более 90 градусов от направления на цель
            elseif movementSelection == 2
                % горизонтальное Отклонение от курсового до крайнего возможного левого направления
                [horizontalAngle, verticalAngle, movementSelection] = plannerMove.directionOpt90(matrixDistance, numSectors, scanRange+10);

                % ШАГ 8  Вычисление нового курсового направления
                directionMoveNew = plannerMove.calculateDirectionFromAngles90(directionMove, horizontalAngle, verticalAngle, movementSelection, numSectors);
                directionMoveNew = directionMoveNew';
            % Прохода нет, Направление движения более 90 градусов от направления на цель
            elseif movementSelection == 3
                % горизонтальное Отклонение от курсового до крайнего возможного левого направления
                [horizontalAngle, verticalAngle, movementSelection] = plannerMove.directionOpt90(matrixDistance, numSectors, scanRange+10);

                directionMoveNew = plannerMove.calculateDirectionFromAngles90(directionMove, horizontalAngle, verticalAngle, movementSelection, numSectors);
                directionMoveNew = directionMoveNew';
            end

            % ПЕРЕДЕЛАТЬ
        else
            % ШАГ 8  Вычисление курсового направления если нет препятствий (курс на цель)
            directionMoveNew = calculate.calculateDirectionTarget(currentX, currentY, currentZ, targetX, targetY, targetZ);
            horizontalAngle = azimuthAngleTarget;
            verticalAngle = elevationAngleDiffTarget;
        end

        fprintf('Горизонтальное отклонение направления на ЦЕЛь : %.2f \n', azimuthAngleTarget);
        fprintf('Вертикальное отклонение направления на ЦЕЛь : %.2f \n', elevationAngleDiffTarget); 
        fprintf('Горизонтальное отклонение направления ДВИЖЕНИЯ : %.2f \n', horizontalAngle);
        fprintf('Вертикальное отклонение направления ДВИЖЕНИЯ : %.2f \n', verticalAngle);

        if flagHistory
            if collisionDetected
                speedNew = speedMax * 0.1;
                directionMoveNew = newDirection;
            else
        
                % Вычисление новой скорости (чем ближе препятствие тем ниже скорость
                speedNew = speed.speedNew1(minDistObstacle, dangerZone, speedMax);  
            end
        else
                % Вычисление новой скорости (чем ближе препятствие тем ниже скорость
                speedNew = speed.speedNew1(minDistObstacle, dangerZone, speedMax);  
        end
        %  Шаг 9  Новое курсовое направление робота (постепенное изменение курса)
        directionMove = rotateDirectionByOneDegree(directionMove, directionMoveNew);
        % Постепенное изменение скорости
        speedCurent = speed.changeSpeed(speedCurent, speedNew, speedMax);
      

        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %  Шаг 6 ПЕРЕМЕЩЕНИЕ РОБОТА 
        %==============
        % 1.3.11 Перемещение робота на шаг (используя курсовое  направление)
        [currentX, currentY, currentZ] = newCoordinate(currentX, currentY, currentZ, directionMove, speedCurent);


        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % ВЫВОД ГРАФИКОВ
        %=============
        % Обновляем данные текущего положения робота на графике
        set(start, 'XData', currentX);
        set(start, 'YData', currentY);
        set(start, 'ZData', currentZ);

        % Обновляем линию до цели
        set(line, 'XData', [currentX, targetX]);
        set(line, 'YData', [currentY, targetY]);
        set(line, 'ZData', [currentZ, targetZ]);

        % Обновляем линию пути
        pathX = [pathX, currentX];
        pathY = [pathY, currentY];
        pathZ = [pathZ, currentZ];
        set(pathLine, 'XData', pathX, 'YData', pathY, 'ZData', pathZ);

        % disp(['Текущее положение: (', num2str(currentX), ', ', num2str(currentY), ', ', num2str(currentZ), ')']);
        
        %
        % ПЕРЕМЕЩЕНИЕ ПРЕПЯТСТВИЙ
        %============
        % 1.3.12 Обновляем координаты препятствий
        [obstaclesX, obstaclesY, obstaclesZ] = obstacles.moveObstacles(directionMove, obstaclesX, obstaclesY, obstaclesZ, speedObstacles);
        % 1.3.13 Обновляем отображение препятствий
        obstacles.updateObstacles(obstacleObjects, obstaclesX, obstaclesY, obstaclesZ, obstaclesRadius, detectedObstacles);

        if video_flag
            frameRobot = getframe(robotFigure);   % Кадр вида радара
            writeVideo(vidRobot, frameRobot);     % Запись кадра в видеофайл радара
        end

        % Визуализация матрицы дистанций
        displayDistanceMatrix(matrixDistance, scanRange, numSectors, azimuthAngleTarget, elevationAngleDiffTarget, horizontalAngle, verticalAngle,speedCurent, speedNew, radarFigure);
        % Захват кадра радара и запись его в видеофайл радара
    
        if video_flag
            frameRadar = getframe(radarFigure);   % Кадр вида радара
            writeVideo(vidRadar, frameRadar);     % Запись кадра в видеофайл радара

            % Преобразование кадров в изображения
            imgRobot = frameRobot.cdata;  % Изображение из вида робота
            imgRadar = frameRadar.cdata; % Изображение из вида радара
            % Приведение изображений к одинаковой высоте
            heightRobot = size(imgRobot, 1);
            heightRadar = size(imgRadar, 1);
            % Определяем общую высоту (например, максимальную)
            commonHeight = max(heightRobot, heightRadar);
            % Масштабируем изображения
            imgRobotResized = imresize(imgRobot, [commonHeight NaN]); % Масштабирование по высоте
            imgRadarResized = imresize(imgRadar, [commonHeight NaN]); % Масштабирование по высоте

            % Объединение изображений (по горизонтали)
            combinedFrame = [imgRobotResized, imgRadarResized];  % Склеиваем кадры рядом

            % Запись объединённого кадра в итоговое видео
            writeVideo(vidCombined, combinedFrame);
        end    
    end
    disp('Достигнута цель!');
    if video_flag
        % Закрываем видеофайлы после завершения записи
        close(vidRobot);
        close(vidRadar);
        close(vidCombined);
    end
end