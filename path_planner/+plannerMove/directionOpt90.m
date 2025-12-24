% 1.3.8 углы отклонений оптимального направления (выбирает из матрицы дистанций)
function [horizontal, vertical, movementSelection] = directionOpt90(matrixDistance, numSectors, scanRange)
    % matrixDistance - матрица дистанций
    % numSectors - количество секторов (разбиение радара)
    % robotDir - Текущее КУРСОВОЕ Направление робота  
    % azimuthAngleTarget, elevationAngleDiffTarget - углы отклонения на цель
    
    % Если отклонение курсового направления от направления на цель больше
    % 90 градусов то движемся всегда чтобы препятствие было слева.
    
    %+++++++++++++++++++++++++++++
    delta = 10;
    % центр матрицы (текущее курсовое направление)
    num = ceil(numSectors/2); 

    % Находим максимальные значения в каждом столбце  
    maxValues = max(matrixDistance(:));  
    
    % Инициализируем индекс самого левого столбца  
    horizontal = -1;  
    vertical = -1;
    
    % Если прохода нет то выбираем крайнее правое направление движемся вправо
    % горизонтально (порачиваем)
    if maxValues < scanRange
        horizontal = num;
        vertical = 0;
        movementSelection = 3;
        return;

    else
        movementSelection = 2;
    end
    
    % Если проход есть, движемся вправо так чтобы препятствие было всегда слева
    
    % Определяем диапазон строк для поиска (близкий к середине)
    rowRange = max(1, num - delta):min(numSectors, num + delta);
    
    % Ограничиваем логическую матрицу диапазоном строк
    limitedMatrix = matrixDistance(rowRange, :);


    % Горизонтальная координата
    % Логическая матрица  
    logicalMatrix = (limitedMatrix >= scanRange);
    % Индексы столбцов, содержащих искомое значение  
    columnsWithValue = find(any(logicalMatrix, 1)); 

    % Найти самый левый столбец, если такой существует  
    if ~isempty(columnsWithValue)
        horizontal = columnsWithValue(1);
        % Находим строки в самом левом столбце в диапазоне rowRange, где есть значение scanRange
        targetRows = find(logicalMatrix(:, horizontal));

        % Переводим строку в исходные координаты
        targetRows = targetRows + rowRange(1) - 1;
        
        % Вычисляем горизонтальное отклонение относительно центра
        horizontal = horizontal - num;

        % Если строки найдены, выбираем ближайшую к центру строку
        if ~isempty(targetRows)
            [~, closestRowIndex] = min(abs(targetRows - num));
            vertical = targetRows(closestRowIndex) - num;
        else
            vertical = 0;  % Если значение не найдено
        end
    else 
        horizontal = num; % Если прохода нет 
        movementSelection = 3;
    end

    disp(['Горизонтальный Угол отклонения ', num2str(horizontal)]);
    disp(['Вертикальный Угол отклонения ', num2str(vertical)]);
    
end
