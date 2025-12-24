
function displayDistanceMatrix(matrixDistance, scanRange, numSectors, azimuthAngleTarget, elevationAngleDiffTarget, horizontalAngle, verticalAngle, speedCurent, speedNew, radarFigure)
    % Объявление объектов как статических для хранения между вызовами
    persistent radarAxes radarImage targetLine directionLine speedTextCurent;

    num = ceil(numSectors / 2); % Центр матрицы
    scanRange = scanRange + 10;

    % Направление на цель
    x_target = azimuthAngleTarget + num;
    y_target = elevationAngleDiffTarget + num;

    % Новое курсовое направление
    x_next = horizontalAngle + num;
    y_next = verticalAngle + num;

    % Проверяем, существуют ли оси и привязаны ли они к окну radarFigure
    if isempty(radarAxes) || ~isgraphics(radarAxes) || radarAxes.Parent ~= radarFigure
        % Очистка всех графических объектов из radarFigure, если это необходимо
        clf(radarFigure);  % Очистка содержимого окна radarFigure

        % Создаем новые оси в переданном окне radarFigure
        radarAxes = axes('Parent', radarFigure);

        % Устанавливаем начальные ограничения для осей
        xlim(radarAxes, [1 numSectors]);
        ylim(radarAxes, [1 numSectors]);
        set(radarAxes, 'YDir', 'reverse');  % Устанавливаем ось Y сверху вниз
        hold(radarAxes, 'on');  % Удерживаем оси для дальнейших графиков
    end

    % Создаем копию матрицы для отображения
    matrixToDisplay = matrixDistance;  

    % Нормализация значений матрицы
    minVal = min(matrixToDisplay(matrixToDisplay < scanRange), [], 'omitnan');
    maxVal = max(matrixToDisplay(matrixToDisplay <= scanRange), [], 'omitnan');

    % Заменяем все значения, превышающие scanRange, на 1
    matrixToDisplay(matrixToDisplay >= scanRange) = 1;  

    if maxVal == minVal
        maxVal = scanRange; % Если данных нет, задаем максимум как scanRange
    elseif isnan(minVal)
        matrixToDisplay(:) = 1;
    else
        matrixToDisplay(matrixToDisplay > 1) = 0.5 * (matrixToDisplay(matrixToDisplay > 1) - minVal) / (maxVal - minVal); 
        matrixToDisplay(matrixToDisplay > 1) = 0.5 - matrixToDisplay(matrixToDisplay > 1);  % инвертируем цвет
    end

    % Устанавливаем значения NaN (отсутствие препятствий) в 1 (белый цвет)
    matrixToDisplay(isnan(matrixDistance)) = 1;

    % Если изображение еще не создано, создаем его в radarAxes
    if isempty(radarImage) || ~isgraphics(radarImage)
        radarImage = imagesc('XData', 1:numSectors, 'YData', 1:numSectors, ...
                             'CData', matrixToDisplay, 'Parent', radarAxes);
        colormap(radarAxes, gray);  % Цветовая карта серого
        axis(radarAxes, 'equal');    % Устанавливаем равные масштабы
    else
        set(radarImage, 'CData', matrixToDisplay);  % Обновляем изображение
    end

    % Проверка корректности координат перед обновлением линии
    if ~isnan(x_target) && ~isnan(y_target) && isreal(x_target) && isreal(y_target)
        if isempty(targetLine) || ~isgraphics(targetLine)
            targetLine = line(radarAxes, [num, x_target], [num, y_target], 'Color', 'r', 'LineWidth', 2, 'Marker', 'o');
        else
            set(targetLine, 'XData', [num, x_target], 'YData', [num, y_target]);
        end
    end

    % Проверка корректности координат перед обновлением линии
    if ~isnan(x_next) && ~isnan(y_next) && isreal(x_next) && isreal(y_next)
        if isempty(directionLine) || ~isgraphics(directionLine)
            directionLine = line(radarAxes, [num, x_next], [num, y_next], 'Color', 'b', 'LineWidth', 2, 'Marker', 'o');
        else
            set(directionLine, 'XData', [num, x_next], 'YData', [num, y_next]);
        end
    end

    % Проверяем наличие текстовых меток и создаем их, если необходимо
    if isempty(speedTextCurent) || ~isvalid(speedTextCurent)
        speedTextCurent = uicontrol('Parent', radarFigure, 'Style', 'text', ...
                                    'String', sprintf('Speed Current: %.2f', speedCurent), ...
                                    'FontSize', 8, 'Units', 'normalized', ...
                                    'Position', [0.35, 0.93, 0.3, 0.05], ...
                                    'BackgroundColor', 'w', 'HorizontalAlignment', 'center');
    else
        set(speedTextCurent, 'String', sprintf('Текущая скорость:  %.2f', speedCurent));
    end

    % Обновляем отображение
    drawnow;
end












% % Создание нового окна для визуализации матрицы дистанций
% function displayDistanceMatrix(matrixDistance, scanRange, numSectors, azimuthAngleTarget, elevationAngleDiffTarget, horizontalAngle, verticalAngle, speedCurent, speedNew, radarFigure)
%     persistent radarFig radarAxes radarImage targetLine directionLine speedTextCurent speedTextNew;
%     num = ceil(numSectors/2); % Центр матрицы
%     scanRange = scanRange + 10;
%     % Направление на цель
%     x_target = azimuthAngleTarget + num;
%     y_target = elevationAngleDiffTarget + num;  % Исправил на elevationAngleDiffTarget
% 
% 
% 
%     % Новое курсовое направление 
%     x_next = horizontalAngle + num;
%     y_next = verticalAngle + num;
% 
%     % Если окно еще не создано, создаем его
%     if isempty(radarFig) || ~isvalid(radarFig)
%         radarFig = figure('Name', '  РАДАР:  Матрица дистанций ', 'NumberTitle', 'off');
%         radarAxes = axes(radarFig);  % Создаем оси для этого окна
%     end
% 
%     % 1. Создаем копию матрицы для отображения
%     matrixToDisplay = matrixDistance;  
% 
%     % 3. Определяем минимальное и максимальное значение в матрице для нормализации
%     % Игнорируем значения равные 1 при поиске максимума
%     minVal = min(matrixToDisplay(matrixToDisplay < scanRange), [], 'omitnan');
%     maxVal = max(matrixToDisplay(matrixToDisplay < scanRange), [], 'omitnan');
% 
%     % 2. Заменяем все значения, превышающие scanRange, на 1
%     matrixToDisplay(matrixToDisplay >= scanRange) = 1;  
%     % Проверка на однообразие данных, чтобы избежать деления на ноль
%     if maxVal == minVal
%         maxVal = scanRange; % Если данных нет, задаем максимум как scanRange
%         % 4. Нормируем остальные значения от 0 до 0.5 (ближе к 0 — темнее)
%         % Мы будем интерпретировать значения, меньше чем scanRange как темные оттенки
%         matrixToDisplay(matrixToDisplay > 1) = 0.5 * (matrixToDisplay(matrixToDisplay > 1) - minVal) / (maxVal - minVal); 
%         matrixToDisplay(matrixToDisplay > 1) = 0.5 - matrixToDisplay(matrixToDisplay > 1);  % инвертируем цвет (черный ближе к 0)
%     elseif isnan(minVal)
%         matrixToDisplay(:) = 1;
%     else
%         matrixToDisplay(matrixToDisplay > 1) = 0.5 * (matrixToDisplay(matrixToDisplay > 1) - minVal) / (maxVal - minVal); 
%         matrixToDisplay(matrixToDisplay > 1) = 0.5 - matrixToDisplay(matrixToDisplay > 1);  % инвертируем цвет (черный ближе к 0)
%     end
% 
%     % 4. Нормируем остальные значения от 0 до 0.5 (ближе к 0 — темнее)
%     % Мы будем интерпретировать значения, меньше чем scanRange как темные оттенки
%     matrixToDisplay(matrixToDisplay > 1) = 0.5 * (matrixToDisplay(matrixToDisplay > 1) - minVal) / (maxVal - minVal); 
%     matrixToDisplay(matrixToDisplay > 1) = 0.5 - matrixToDisplay(matrixToDisplay > 1);  % инвертируем цвет (черный ближе к 0)
% 
%     % 5. Устанавливаем значения NaN (отсутствие препятствий) в 1 (белый цвет)
%     matrixToDisplay(isnan(matrixDistance)) = 1;  % Устанавливаем белый цвет для NaN
% 
%     % Если изображение еще не создано, создаем его
%     if isempty(radarImage) || ~isvalid(radarImage)
%         radarImage = imagesc('XData', 1:numSectors, 'YData', 1:numSectors, ...
%                              'CData', matrixToDisplay, 'Parent', radarAxes);  % Отображаем матрицу
% 
%         colormap(gray);  % Устанавливаем цветовую карту в оттенки серого
% 
%         colorbar('off');  % Отключаем шкалу цветов
%         axis(radarAxes, 'equal');  % Оси равной длины
%         xlim(radarAxes, [1 numSectors]);  % Задаем диапазон по X
%         ylim(radarAxes, [1 numSectors]);  % Задаем диапазон по Y
%     else
%         set(radarImage, 'CData', matrixToDisplay);  % Обновляем изображение
% 
%     end
% 
%     % Устанавливаем ось Y сверху вниз
%     set(radarAxes, 'YDir', 'reverse');
% 
%     % Проверка корректности координат перед обновлением линии
%     if ~isnan(x_target) && ~isnan(y_target) && isreal(x_target) && isreal(y_target)
%         % Отображение направления на цель (красная линия)
%         if isempty(targetLine) || ~isvalid(targetLine)
%             targetLine = line(radarAxes, [num, x_target], [num, y_target], 'Color', 'r', 'LineWidth', 2, 'Marker', 'o');
%         else
%             set(targetLine, 'XData', [num, x_target], 'YData', [num, y_target]);  % Обновляем положение линии
%         end
%     end
% 
%     % Проверка корректности координат перед обновлением линии
%     if ~isnan(x_next) && ~isnan(y_next) && isreal(x_next) && isreal(y_next)
%         % Отображение нового курсового направления (синяя линия)
%         if isempty(directionLine) || ~isvalid(directionLine)
%             directionLine = line(radarAxes, [num, x_next], [num, y_next], 'Color', 'b', 'LineWidth', 2, 'Marker', 'o');
%         else
%             set(directionLine, 'XData', [num, x_next], 'YData', [num, y_next]);  % Обновляем положение линии
%         end
%     end
% 
%     % Проверяем наличие текстовых меток и создаем их, если необходимо
%     if isempty(speedTextCurent) || ~isvalid(speedTextCurent)
%         % Создаем текст для отображения текущей скорости над графиком
%         speedTextCurent = uicontrol('Style', 'text', 'String', sprintf('Speed Current: %.2f', speedCurent), ...
%                                     'FontSize', 8, 'Units', 'normalized', 'Position', [0.35, 0.93, 0.3, 0.05], ...
%                                     'BackgroundColor', 'w', 'HorizontalAlignment', 'center');
%     else
%         % Обновляем текст текущей скорости
%         set(speedTextCurent, 'String', sprintf('Текущая скорость:  %.2f', speedCurent));
%     end
% 
%     % Обновляем отображение
%     drawnow;
% end








