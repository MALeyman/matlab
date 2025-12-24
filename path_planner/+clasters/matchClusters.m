function associations = matchClusters(clustersPrev, clustersCurr, T, maxDist)
    % Сопоставляет кластеры из предыдущего и текущего сканов
    
    if isempty(clustersPrev) || isempty(clustersCurr)
        associations = []; % Возвращаем пустой массив, если нет кластеров
        return;
    end

    numPrev = length(clustersPrev);
    numCurr = length(clustersCurr);
    associations = -ones(numPrev, 1); % -1 означает отсутствие соответствия
    
    % Преобразуем кластеры предыдущего скана
    centersPrev = cellfun(@(c) mean(c.points, 1), clustersPrev, 'UniformOutput', false);
    centersPrev = vertcat(centersPrev{:});
    
    % Проверяем, что есть данные для трансформации
    if isempty(centersPrev)
        associations = [];
        return;
    end
    
    centersPrevTransformed = transformPoints(centersPrev, T);
    
    % Центры текущих кластеров
    centersCurr = cellfun(@(c) mean(c.points, 1), clustersCurr, 'UniformOutput', false);
    centersCurr = vertcat(centersCurr{:});
    
    if isempty(centersCurr)
        associations = [];
        return;
    end

    % Сравнение расстояний между центрами
    for i = 1:numPrev
        %distances = sqrt(sum((centersCurr - centersPrevTransformed(i, :)).^2, 2));
        disp("centersCurr");
        disp(centersCurr);
        disp("centersPrev");
        disp(centersPrev);
        distances = sqrt(sum((centersCurr - centersPrev(i, :)).^2, 2));
        [minDist, idx] = min(distances);
        if minDist < maxDist
            associations(i) = idx;
        end
    end
end



function pointsTransformed = transformPoints(points, T)
    % Преобразует точки с использованием матрицы трансформации
    if isempty(points)
        pointsTransformed = []; % Возвращаем пустой массив, если нет точек
        return;
    end
    
    numPoints = size(points, 1);
    homogeneousPoints = [points, ones(numPoints, 1)]; % Добавляем координату 1
    transformedHomogeneous = (T * homogeneousPoints')'; % Применяем трансформацию
    pointsTransformed = transformedHomogeneous(:, 1:3); % Убираем последнюю координату
end

