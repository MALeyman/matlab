function obstaclesInfo = scanPyramidForObstacles(vertex, directionMove, directionTarget, ...
    scanRange, sectorAngle, display_radar, pyramidPatch, pyramidVertices, obstaclesX, ...
    obstaclesY, obstaclesZ, obstaclesRadius, robotFigure)
    % vertex: координаты вершины пирамиды [x0, y0, z0]
    % directionMove: направление высоты пирамиды (направление движение робота) [dx, dy, dz]
    % directionTarget - Направление на цель
    % scanRange: длина высоты пирамиды
    % sectorAngle: угол между противоположными гранями пирамиды в радианах
    % display_radar: логическое значение (true/false), управляет отображением пирамиды
    % pyramidPatch  
    % pyramidVertices 
    % obstaclesX, obstaclesY, obstaclesZ - координаты препятствий
    % obstaclesRadius - размер сферы препятствия
    % obstaclesType - Тип препятствий 

    % Начальный массив для хранения информации о препятствиях
    obstaclesInfo = {};

    % Вычисляем центр основания пирамиды
    base_center = vertex + scanRange * directionMove;

    % Вычисляем длину стороны квадрата основания
    base_side = 2 * scanRange * tan(sectorAngle / 2);

    % Создаём основание пирамиды перпендикулярное курсовому пути и одна
    % сторона основания перпендикулярна оси Z
    base_vertices = radar.createPerpendicularSquare(base_center, directionMove, base_side);

    % Определим ортогональные векторы v1 и v2 для системы координат основания
    arbitrary_vector = [0, 0, 1];
    if dot(arbitrary_vector, directionMove) > 0.99
        arbitrary_vector = [1, 0, 0];
    end
    v1 = cross(directionMove, arbitrary_vector);
    v1 = v1 / norm(v1);  % Нормализуем
    v2 = cross(directionMove, v1);
    v2 = v2 / norm(v2);  % Нормализуем

    % Проверка препятствий
    numObstacles = length(obstaclesX);
    for k = 1:numObstacles
        % Координаты центра сферы препятствия
        obstaclePoint = [obstaclesX(k), obstaclesY(k), obstaclesZ(k)];

        % Проверка, находится ли препятствие внутри пирамиды
        if is_sphere_inside_pyramid(obstaclePoint, vertex, base_vertices, scanRange, obstaclesRadius)
            % Вычисляем расстояние до препятствия
            distanceToObstacle = norm(obstaclePoint - vertex);

            % Вычисляем направление на препятствие
            directionToObstacle = (obstaclePoint - vertex) / distanceToObstacle;

            % Вектор от вершины пирамиды к центру препятствия
            toObstacle = obstaclePoint - vertex;
            
            % Находим параметр t для точки пересечения
            t = dot(base_center - vertex, directionMove) / dot(toObstacle, directionMove);
            
            % Находим точку пересечения с основанием пирамиды
            intersectionPoint = vertex + t * toObstacle;
            
            % Преобразуем intersectionPoint в локальные координаты (localX, localY)
            projOnBase = intersectionPoint - base_center;
            localX = dot(projOnBase, v1);
            localY = dot(projOnBase, v2);
            
            % Добавляем в массив информации о препятствиях с локальными координатами
            obstaclesInfo{end+1} = {k, obstaclePoint, distanceToObstacle, directionToObstacle, [localX, localY]};

        end
    end

    % Отображение пирамиды, если требуется
    persistent heightLineHandle;
    if display_radar
        % Получаем текущую ось robotFigure
        radarAxes = get(robotFigure, 'CurrentAxes');
        
        axes(radarAxes);  % Устанавливаем активной ось радара перед отрисовкой
        set(pyramidPatch, 'XData', base_vertices(:,1));
        set(pyramidPatch, 'YData', base_vertices(:,2));
        set(pyramidPatch, 'ZData', base_vertices(:,3));

        % Рисуем стороны пирамиды
        for i = 1:4
            next_i = mod(i, 4) + 1;
            set(pyramidVertices(i), 'XData', [vertex(1), base_vertices(i,1), base_vertices(next_i,1)]);
            set(pyramidVertices(i), 'YData', [vertex(2), base_vertices(i,2), base_vertices(next_i,2)]);
            set(pyramidVertices(i), 'ZData', [vertex(3), base_vertices(i,3), base_vertices(next_i,3)]);
        end

        % Если линия высоты пирамиды еще не создана, создаем её
        if isempty(heightLineHandle) || ~isvalid(heightLineHandle)
            heightLineHandle = line([vertex(1), base_center(1)], ...
                [vertex(2), base_center(2)], ...
                [vertex(3), base_center(3)], 'Color', 'yellow', 'LineWidth', 1);
        else
            % Обновляем данные линии высоты пирамиды
            set(heightLineHandle, 'XData', [vertex(1), base_center(1)], ...
                'YData', [vertex(2), base_center(2)], ...
                'ZData', [vertex(3), base_center(3)]);
        end
    end
    drawnow;
end



% Проверка нахождения препятствия СФЕРА внутри пирамиды
function is_inside = is_sphere_inside_pyramid(point, apex, base_vertices, scanRange, obstacleRadius)
    % point - координаты центра сферы препятствия
    % apex - координаты вершины пирамиды [x0, y0, z0]
    % base_vertices - вершины основания пирамиды
    % scanRange - длина высоты пирамиды
    % obstacleRadius - радиус препятствия (сферы)

    num_faces = 4;  % количество граней пирамиды
    normals = zeros(num_faces, 3);  % нормали к граням пирамиды
    d_values = zeros(num_faces, 1);  % значения D для уравнений граней
    is_inside = false;  % флаг нахождения сферы внутри пирамиды

    % 1. Проверка, находится ли препятствие на расстоянии действия радара
    dist = sqrt(sum((point - apex).^2));  % расстояние от вершины пирамиды до центра сферы
    if dist > scanRange + obstacleRadius  % если сфера находится за пределами пирамиды и радиуса
        return;
    end

    % 2. Вычисление нормалей для каждой грани пирамиды
    for i = 1:num_faces
        p1 = apex;  % вершина пирамиды
        p2 = base_vertices(i, :);  % одна из вершин основания
        p3 = base_vertices(mod(i, num_faces) + 1, :);  % следующая вершина основания

        v1 = p2 - p1;  % вектор от вершины пирамиды к вершине основания
        v2 = p3 - p1;  % вектор к следующей вершине основания
        normal = cross(v1, v2);  % векторное произведение для нахождения нормали
        normal = normal / norm(normal);  % нормализация нормали
        d = dot(normal, p1);  % расстояние до плоскости
        normals(i, :) = normal;
        d_values(i) = d;
    end

    % 3. Проверка, находится ли центр сферы внутри пирамиды
    is_inside = true;  % предполагаем, что сфера внутри пирамиды
    for i = 1:num_faces
        dist1 = dot(normals(i, :), point) - d_values(i);  % расстояние от центра до грани
        if dist1 < 0  % если сфера вне пирамиды относительно этой грани
            is_inside = false;  % центр вне пирамиды

            % 4. Проверка, пересекает ли сфера эту грань (с учетом радиуса)
            if abs(dist1) < obstacleRadius
                is_inside = true;  % сфера пересекает грань пирамиды
            else
                return;  % сфера не пересекает грань, выходим
            end
        end
    end
end
