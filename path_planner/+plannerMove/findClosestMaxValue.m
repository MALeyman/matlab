% Шаг 8  Поиск ближайшего направления к нужному 
function [closestMaxCoord] = findClosestMaxValue(matrixDistance, currentPos, scanRange, numSectors)
    % matrixDistance - матрица расстояний
    % currentPos - координаты  направления на препятствие в матрице [col, row]

    % Определяем максимальное значение в матрице
    maxValue = max(matrixDistance(:));

    % Если нет прохода движемся вправо
    if maxValue < scanRange
        closestMaxCoord = [-1, -1];
        disp('Не найден проход  поворачиваем')
        return;
    end

    % Находим координаты всех элементов с максимальным значением
    [maxCols, maxRows] = find(matrixDistance == maxValue);

    % Инициализируем переменные для хранения минимального расстояния
    minDistance = Inf;
    closestMaxCoord = [];

    % Перебираем все элементы с максимальным значением
    for i = 1:length(maxRows)
        row = maxRows(i);
        col = maxCols(i);
        
        % Вычисляем расстояние до нужного курса 
        distance = sqrt((row - currentPos(1))^2 + (col - currentPos(2))^2);
        
        % Если это расстояние меньше минимального, обновляем его
        if distance < minDistance
            minDistance = distance;
            closestMaxCoord = [row, col];  % Запоминаем координаты
        end
    end
    disp(['Направление на цель координаты в матрице ', num2str(currentPos)])
    disp(['Координаты оптимального направления в матрице ', num2str(closestMaxCoord)]);
end

