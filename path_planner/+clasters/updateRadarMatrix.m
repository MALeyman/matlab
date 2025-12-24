
function radarMatrixCurr1 = updateRadarMatrix(radarMatrixCurr, clustersNew, numSectors, scanRange, directionMoves, positionHistory)
    % Центр матрицы
    center = ceil(numSectors / 2);
    radarMatrixCurr1 = radarMatrixCurr;

    % Нормализуем направление движения робота
    directionMove = directionMoves / norm(directionMoves);

    % Поворотная матрица для выравнивания осей к directionMove
    [xAxis, yAxis, zAxis] = orthogonalizeAxes1(directionMove);

    % Матрица перехода к системе координат радара
    R = [xAxis; yAxis; zAxis];
 
    % % Сдвиг в индексовой системе матрицы
    % colShift = round(-rad2deg(phiShift)); % Сдвиг по вертикали
    % rowShift = round(thetaShift / (pi / 4) * (center - 1)); % Сдвиг по горизонтали

    % Обрабатываем каждый кластер
    for idx = 1:length(clustersNew)
        % Получаем точки текущего кластера и направление его движения
        if isfield(clustersNew{idx}, 'movement') && isfield(clustersNew{idx}.movement, 'displacement')
            displacement = clustersNew{idx}.movement.displacement; % Смещение кластера
        else
            continue; % Если поле отсутствует
        end

        % Проверяем, равен ли вектор смещения нулю
        if norm(displacement) > 0
            displacement = displacement / norm(displacement); % Нормализуем вектор смещения
        else
            continue; % Если смещение равно нулю
        end

        % Преобразуем направление смещения кластера в локальное направление индексов
        displacementLocal = R * displacement'; % Вектор в локальных координатах радара

        % Преобразуем displacementLocal в смещение индексов
        thetaShift = atan2(displacementLocal(2), displacementLocal(3));
        phiShift = atan2(displacementLocal(1), sqrt(displacementLocal(3)^2 + displacementLocal(2)^2));
        shiftVector = [thetaShift, phiShift] / norm([thetaShift, phiShift]);

        if abs(thetaShift) > 0
            thetaShift = thetaShift/abs(thetaShift); % Вертикальный угол
        else
            thetaShift = 0;
        end
        if abs(phiShift) > 0
            phiShift = -phiShift/abs(phiShift);  % Горизонтальный угол
        else
            phiShift = 0;
        end

        % Получаем индексы точек кластера
        clusterIndices = clustersNew{idx}.indices; % [N x 2] массив индексов
        
        % Для каждой точки кластера добавляем смещение
        for i = 1:size(clusterIndices, 1)
            rowIdx = clusterIndices(i, 1);
            colIdx = clusterIndices(i, 2);
            
            % Расширяем точку в сторону смещения
            for step = 0:numSectors
                newRowIdx = rowIdx + step * thetaShift;
                newColIdx = colIdx + step * phiShift;

                % Ограничиваем индексы в пределах матрицы
                newRowIdx = max(1, min(numSectors, newRowIdx));
                newColIdx = max(1, min(numSectors, newColIdx));
                
                % Обновляем значение в матрице
                radarMatrixCurr1(rowIdx, newColIdx) = min(radarMatrixCurr1(rowIdx, newColIdx), radarMatrixCurr(rowIdx, colIdx));
            end
            % for step = 0:numSectors
            %     newRowIdx = rowIdx + step * thetaShift;
            %     newColIdx = colIdx + step * phiShift;
            % 
            %     % Ограничиваем индексы в пределах матрицы
            %     newRowIdx = max(1, min(numSectors, newRowIdx));
            %     newColIdx = max(1, min(numSectors, newColIdx));
            % 
            %     % Обновляем значение в матрице
            %     radarMatrixCurr1(newRowIdx, newColIdx) = min(radarMatrixCurr1(newRowIdx, newColIdx), radarMatrixCurr(rowIdx, colIdx));
            % end
        end
    end
end







function [xAxis, yAxis, zAxis] = orthogonalizeAxes1(directionMove)
    % Создание ортонормированного базиса из направления движения
    zAxis = directionMove / norm(directionMove); % Направление движения

    % Создаем временный вектор, гарантированно не коллинеарный с zAxis
    if abs(zAxis(3)) < 0.99
        tempVec = [0, 0, 1]; % Используем ось Z, если zAxis не коллинеарен Z
    else
        tempVec = [1, 0, 0]; % Иначе используем ось Y
    end

    % Вычисляем ортогональные оси
    xAxis1 = cross(tempVec, zAxis); % Перпендикуляр к zAxis
    xAxis = xAxis1 / norm(xAxis1); % Нормируем xAxis
    yAxis2 = cross(zAxis, xAxis); % yAxis автоматически будет ортогональным
    yAxis = yAxis2 / norm(yAxis2); % Нормируем yAxis для стабильности
end
