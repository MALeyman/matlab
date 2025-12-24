% 1.1 Генерация координат препятствий 
function [obstaclesX, obstaclesY, obstaclesZ] = generateObstacles(width, height, depth, numObstacles, obstaclesRadius, obstaclesType)
    % range - диапазон
    % numObstacles - количество препятствий
    % obstaclesRadius - радиус препятствий
    % obstaclesType - вариант препятствий
    
    range = depth-2;
    %  Расстояние между центрами шаров
    spacing = 2 * obstaclesRadius;  
    % direction - направление движения
    direction = [-0.57735, 0.57735, -0.57735];

    % Инициализация массивов координат
    obstaclesX = [];
    obstaclesY = [];
    obstaclesZ = [];
    
    % (случайные одиночные препятствия)
    if obstaclesType == 0
        [obstaclesX, obstaclesY, obstaclesZ] = generateObstacles_0(range, numObstacles);

    % шары по четыре слеплены вместе
    elseif obstaclesType == 1  
        [obstaclesX, obstaclesY, obstaclesZ] = generateObstacles_1(range, numObstacles, obstaclesRadius);

    % В 
    elseif obstaclesType == 2
        [obstaclesX, obstaclesY, obstaclesZ] = generateObstacles_2(width, height, depth, direction,  spacing);

    % В случае плоскость  пяти на пять шаров 
    elseif obstaclesType == 3
        [obstaclesX, obstaclesY, obstaclesZ] = generateObstacles_3(direction,  spacing);

    % 
    elseif obstaclesType == 4
        [obstaclesX, obstaclesY, obstaclesZ] = generateObstacles_4(direction,  spacing);

    % Две плоскости и рандомные препятствия
    elseif obstaclesType == 5
        [obstaclesX, obstaclesY, obstaclesZ] = generateObstacles_5(range, direction,  spacing);
    % В 
    elseif obstaclesType == 6
        [obstaclesX, obstaclesY, obstaclesZ] = generateObstacles_6(width, height, depth, direction,  spacing);

    elseif obstaclesType == 7
            [obstaclesX, obstaclesY, obstaclesZ] = generateObstacles_7(range);

    elseif obstaclesType == 8
            [obstaclesX, obstaclesY, obstaclesZ] = generateObstacles_8(range);        

    else
       [obstaclesX, obstaclesY, obstaclesZ] = generateObstacles_0(range, numObstacles); 

    end 
end


% Нахождение двух векторов, перпендикулярных заданному направлению движения
function [perpendicularVector1, perpendicularVector2] = findPerpendicularVectors(direction)
    
    % Первый перпендикулярный вектор через кросс-продукт
    if norm(cross([1, 0, 0], direction)) > 0.1  % Если direction не параллелен оси X
        perpendicularVector1 = cross([1, 0, 0], direction);
    else
        perpendicularVector1 = cross([0, 1, 0], direction);
    end
    perpendicularVector1 = perpendicularVector1 / norm(perpendicularVector1);  % Нормализация
    
    % Второй перпендикулярный вектор через кросс-продукт
    perpendicularVector2 = cross(direction, perpendicularVector1);
    perpendicularVector2 = perpendicularVector2 / norm(perpendicularVector2);  % Нормализация
end
    
  
% Препятствие случайные одиночные шары
function [obstaclesX, obstaclesY, obstaclesZ] = generateObstacles_0(range, numObstacles)
    % В случае препятствий с типом 0 (случайные одиночные препятствия)
    obstaclesX = randi([-1, range], 1, numObstacles);
    obstaclesY = randi([-50, range - 10], 1, numObstacles);
    obstaclesZ = randi([-10, range - 10], 1, numObstacles); % 3D координаты для шаров
end

% Случайные препятствия по четыре
function [obstaclesX, obstaclesY, obstaclesZ] = generateObstacles_1(range, numObstacles, obstaclesRadius)
    % Инициализация массивов для координат
    obstaclesX = [];
    obstaclesY = [];
    obstaclesZ = [];
    
     % Генерация центральной точки для кластера
     centerX = 30;
     centerY = 70;
     centerZ = 30;

     % Первый шар в кластере (центр)
     obstaclesX = [obstaclesX, centerX];
     obstaclesY = [obstaclesY, centerY];
     obstaclesZ = [obstaclesZ, centerZ];
     %  шар в кластере 
     obstaclesX = [obstaclesX, centerX + ceil(obstaclesRadius)];
     obstaclesY = [obstaclesY, centerY];
     obstaclesZ = [obstaclesZ, centerZ];

      % Третий шар рядом с первым и вторым (в другой плоскости)
      obstaclesX = [obstaclesX, centerX];
      obstaclesY = [obstaclesY, centerY + ceil(obstaclesRadius)];
      obstaclesZ = [obstaclesZ, centerZ];

      % Четвёртый шар шар  (в другой плоскости)
      obstaclesX = [obstaclesX, centerX];
      obstaclesY = [obstaclesY, centerY + ceil(obstaclesRadius)];
      obstaclesZ = [obstaclesZ, centerZ + ceil(obstaclesRadius)];

       % Генерация центральной точки для кластера
     centerX = 80;
     centerY = 20;
     centerZ = 80;

     % Первый шар в кластере (центр)
     obstaclesX = [obstaclesX, centerX];
     obstaclesY = [obstaclesY, centerY];
     obstaclesZ = [obstaclesZ, centerZ];
     %  шар в кластере 
     obstaclesX = [obstaclesX, centerX + ceil(obstaclesRadius)];
     obstaclesY = [obstaclesY, centerY];
     obstaclesZ = [obstaclesZ, centerZ];

      % Третий шар рядом с первым и вторым (в другой плоскости)
      obstaclesX = [obstaclesX, centerX];
      obstaclesY = [obstaclesY, centerY + ceil(obstaclesRadius)];
      obstaclesZ = [obstaclesZ, centerZ];

      % Четвёртый шар шар  (в другой плоскости)
      obstaclesX = [obstaclesX, centerX];
      obstaclesY = [obstaclesY, centerY + ceil(obstaclesRadius)];
      obstaclesZ = [obstaclesZ, centerZ + ceil(obstaclesRadius)];
    for i = 1:numObstacles
            % Генерация центральной точки для кластера
            centerX = randi([2, floor(range - obstaclesRadius)], 1, 1);
            centerY = randi([2, floor(range - obstaclesRadius)], 1, 1);
            centerZ = randi([2, floor(range - obstaclesRadius)], 1, 1);
            
            % Первый шар в кластере (центр)
            obstaclesX = [obstaclesX, centerX];
            obstaclesY = [obstaclesY, centerY];
            obstaclesZ = [obstaclesZ, centerZ];
            
            % Второй шар рядом с первым (на расстоянии радиуса)
            obstaclesX = [obstaclesX, centerX + ceil(obstaclesRadius)];
            obstaclesY = [obstaclesY, centerY];
            obstaclesZ = [obstaclesZ, centerZ];
            
            % Третий шар рядом с первым и вторым (в другой плоскости)
            obstaclesX = [obstaclesX, centerX];
            obstaclesY = [obstaclesY, centerY + ceil(obstaclesRadius)];
            obstaclesZ = [obstaclesZ, centerZ];

            % Четвёртый шар шар  (в другой плоскости)
            obstaclesX = [obstaclesX, centerX];
            obstaclesY = [obstaclesY, centerY + ceil(obstaclesRadius)];
            obstaclesZ = [obstaclesZ, centerZ + ceil(obstaclesRadius)];
     end
end

% плоскости Лабиринт
function [obstaclesX, obstaclesY, obstaclesZ] = generateObstacles_2(width, height, depth, direction, spacing)
    % Инициализация массивов для координат  
    obstaclesX = [];  
    obstaclesY = [];  
    obstaclesZ = [];  
    spacing = spacing*0.7;  

    % gridSize - размер препятствия количество сфер  
    gridSize = 15;  

    fixedY = height/2;
   
    % Определяем начальную позицию (по оси X и Z)  
    initialPosition = [85, fixedY, 85];  % Y фиксированное значение  
    
    % Дно препятствия XZ  
    for i = 0:gridSize-1  
        for j = 0:gridSize-1  
            % Вычисление координат на плоскости XZ  
            centerX = initialPosition(1) + i * spacing;  % изменяется только X  
            centerZ = initialPosition(3) + j * spacing;  % изменяется только Z  
            
            % Добавляем координаты шара  
            obstaclesX = [obstaclesX, centerX];  
            obstaclesY = [obstaclesY, initialPosition(2)];  % y - фиксированное значение  
            obstaclesZ = [obstaclesZ, centerZ];  
        end  
    end 
    
    % Стенка боковая 1 препятствия
    initialPosition = [86, fixedY, 85];  % Y фиксированное значение  
    % Создаем ровной сетки XZ  
    for i = 0:gridSize-1  
        for j = 0:gridSize-1  
            % Вычисление координат на плоскости XZ  
            centerY = initialPosition(2) - i * spacing;  % изменяется только X  
            centerZ = initialPosition(3) + j * spacing;  % изменяется только Z      
            % Добавляем координаты шара  
            obstaclesX = [obstaclesX, initialPosition(1)];  
            obstaclesY = [obstaclesY, centerY];  %  
            obstaclesZ = [obstaclesZ, centerZ];  
        end  
    end 

    % Стенка боковая 2 препятствия
    initialPosition = [200, fixedY, 85];  % Y фиксированное значение  
    % Создаем ровной сетки XZ  
    for i = 0:gridSize-1  
        for j = 0:gridSize-1  
            % Вычисление координат на плоскости XZ  
            centerY = initialPosition(2) - i * spacing;  % изменяется только X  
            centerZ = initialPosition(3) + j * spacing;  % изменяется только Z      
            % Добавляем координаты шара  
            obstaclesX = [obstaclesX, initialPosition(1)];  
            obstaclesY = [obstaclesY, centerY];  % y - фиксированное значение  
            obstaclesZ = [obstaclesZ, centerZ];  
        end  
    end 

    % Стенка нижняя препятствия
    initialPosition = [85, fixedY, 86];  % Y фиксированное значение  
    % Создаем ровной сетки XZ  
    for i = 0:gridSize-1  
        for j = 0:gridSize-1  
            % Вычисление координат на плоскости XZ  
            centerY = initialPosition(2) - i * spacing;  %  
            centerX = initialPosition(1) + j * spacing;  %       
            % Добавляем координаты шара  
            obstaclesX = [obstaclesX, centerX];  
            obstaclesY = [obstaclesY, centerY];  % y - фиксированное значение  
            obstaclesZ = [obstaclesZ, initialPosition(3)];  
        end  
    end 

    % Стенка верхняя препятствия
    initialPosition = [85, fixedY, 200];  % Y фиксированное значение  
    % Создаем ровной сетки XZ  
    for i = 0:gridSize-1  
        for j = 0:gridSize-1  
            % Вычисление координат на плоскости XZ  
            centerY = initialPosition(2) - i * spacing;  %  
            centerX = initialPosition(1) + j * spacing;  %       
            % Добавляем координаты шара  
            obstaclesX = [obstaclesX, centerX];  
            obstaclesY = [obstaclesY, centerY];  % y - фиксированное значение  
            obstaclesZ = [obstaclesZ, initialPosition(3)];  
        end  
    end 

end


%  три плоскости
function [obstaclesX, obstaclesY, obstaclesZ] = generateObstacles_3(direction, spacing)
     % Инициализация массивов для координат
    obstaclesX = [];
    obstaclesY = [];
    obstaclesZ = [];

    spacing = spacing*0.7;
    % gridSize - размер препятствия количество сфер
    gridSize = 7;
    % Генерация случайной начальной позиции
    % initialPosition = randi([2, range], 1, 3);  % Случайная точка в диапазоне [2, range]
    
    initialPosition = [30, 50, 32];
    % Определяем два вектора, перпендикулярных заданному направлению
    [perpendicularVector1, perpendicularVector2] = findPerpendicularVectors(direction);
    
    % Генерация 5x5 шаров в перпендикулярной плоскости
    for i = 0:gridSize-1
        for j = 0:gridSize-1
            % Вычисление координат в перпендикулярной плоскости
            centerX = initialPosition(1) + i * spacing * perpendicularVector1(1) + j * spacing * perpendicularVector2(1);
            centerY = initialPosition(2) + i * spacing * perpendicularVector1(2) + j * spacing * perpendicularVector2(2);
            centerZ = initialPosition(3) + i * spacing * perpendicularVector1(3) + j * spacing * perpendicularVector2(3);
    
            % Добавляем координаты шара
            obstaclesX = [obstaclesX, centerX];
            obstaclesY = [obstaclesY, centerY];
            obstaclesZ = [obstaclesZ, centerZ];
        end
    end
    
    initialPosition = [70, 30, 70];
    % Генерация 5x5 шаров в перпендикулярной плоскости
    for i = 0:gridSize-1
        for j = 0:gridSize-1
            % Вычисление координат в перпендикулярной плоскости
            centerX = initialPosition(1) + i * spacing * perpendicularVector1(1) + j * spacing * perpendicularVector2(1);
            centerY = initialPosition(2) + i * spacing * perpendicularVector1(2) + j * spacing * perpendicularVector2(2);
            centerZ = initialPosition(3) + i * spacing * perpendicularVector1(3) + j * spacing * perpendicularVector2(3);
    
            % Добавляем координаты шара
            obstaclesX = [obstaclesX, centerX];
            obstaclesY = [obstaclesY, centerY];
            obstaclesZ = [obstaclesZ, centerZ];
        end
    end
    
    initialPosition = [30, 5, 50];
    % Генерация 5x5 шаров в перпендикулярной плоскости
    for i = 0:gridSize-1
        for j = 0:gridSize-1
            % Вычисление координат в перпендикулярной плоскости
            centerX = initialPosition(1) + i * spacing * perpendicularVector1(1) + j * spacing * perpendicularVector2(1);
            centerY = initialPosition(2) + i * spacing * perpendicularVector1(2) + j * spacing * perpendicularVector2(2);
            centerZ = initialPosition(3) + i * spacing * perpendicularVector1(3) + j * spacing * perpendicularVector2(3);
    
            % Добавляем координаты шара
            obstaclesX = [obstaclesX, centerX];
            obstaclesY = [obstaclesY, centerY];
            obstaclesZ = [obstaclesZ, centerZ];
        end
    end
end

% 
function [obstaclesX, obstaclesY, obstaclesZ] = generateObstacles_4(direction, spacing)
     % Инициализация массивов для координат
    obstaclesX = [];
    obstaclesY = [];
    obstaclesZ = [];

    spacing = spacing*0.7;
    % gridSize - размер препятствия количество сфер
    gridSize = 10;
    % Генерация случайной начальной позиции
    % initialPosition = randi([2, range], 1, 3);  % Случайная точка в диапазоне [2, range]
    
    initialPosition = [30, 40, 32];
    % Определяем два вектора, перпендикулярных заданному направлению
    [perpendicularVector1, perpendicularVector2] = findPerpendicularVectors(direction);
    
    % Генерация 5x5 шаров в перпендикулярной плоскости
    for i = 0:gridSize-1
        for j = 0:gridSize-1
            % Вычисление координат в перпендикулярной плоскости
            centerX = initialPosition(1) + i * spacing * perpendicularVector1(1) + j * spacing * perpendicularVector2(1);
            centerY = initialPosition(2) + i * spacing * perpendicularVector1(2) + j * spacing * perpendicularVector2(2);
            centerZ = initialPosition(3) + i * spacing * perpendicularVector1(3) + j * spacing * perpendicularVector2(3);
    
            % Добавляем координаты шара
            obstaclesX = [obstaclesX, centerX];
            obstaclesY = [obstaclesY, centerY];
            obstaclesZ = [obstaclesZ, centerZ];
        end
    end
    
    initialPosition = [50, 5, 70];
    gridSize = 8;
    % Генерация 5x5 шаров в перпендикулярной плоскости
    for i = 0:gridSize-1
        for j = 0:gridSize-1
            % Вычисление координат в перпендикулярной плоскости
            centerX = initialPosition(1) + i * spacing * perpendicularVector1(1) + j * spacing * perpendicularVector2(1);
            centerY = initialPosition(2) + i * spacing * perpendicularVector1(2) + j * spacing * perpendicularVector2(2);
            centerZ = initialPosition(3) + i * spacing * perpendicularVector1(3) + j * spacing * perpendicularVector2(3);
    
            % Добавляем координаты шара
            obstaclesX = [obstaclesX, centerX];
            obstaclesY = [obstaclesY, centerY];
            obstaclesZ = [obstaclesZ, centerZ];
        end
    end
end


% две плоскости и рандомные препятствия
function [obstaclesX, obstaclesY, obstaclesZ] = generateObstacles_5(range, direction, spacing)
     % Инициализация массивов для координат
    obstaclesX = [];
    obstaclesY = [];
    obstaclesZ = [];
    obstaclesRadius = spacing/2;
    spacing = spacing*0.7;
    % gridSize - размер препятствия количество сфер
    gridSize = 10;
    % Генерация случайной начальной позиции
    % initialPosition = randi([2, range], 1, 3);  % Случайная точка в диапазоне [2, range]
    
    initialPosition = [15, 55, 25];
    % Определяем два вектора, перпендикулярных заданному направлению
    [perpendicularVector1, perpendicularVector2] = findPerpendicularVectors(direction);
    
    % Генерация 5x5 шаров в перпендикулярной плоскости
    for i = 0:gridSize-1
        for j = 0:gridSize-1
            % Вычисление координат в перпендикулярной плоскости
            centerX = initialPosition(1) + i * spacing * perpendicularVector1(1) + j * spacing * perpendicularVector2(1);
            centerY = initialPosition(2) + i * spacing * perpendicularVector1(2) + j * spacing * perpendicularVector2(2);
            centerZ = initialPosition(3) + i * spacing * perpendicularVector1(3) + j * spacing * perpendicularVector2(3);
    
            % Добавляем координаты шара
            obstaclesX = [obstaclesX, centerX];
            obstaclesY = [obstaclesY, centerY];
            obstaclesZ = [obstaclesZ, centerZ];
        end
    end
    
    initialPosition = [65, 10, 80];
    gridSize = 6;
    % Генерация 5x5 шаров в перпендикулярной плоскости
    for i = 0:gridSize-1
        for j = 0:gridSize-1
            % Вычисление координат в перпендикулярной плоскости
            centerX = initialPosition(1) + i * spacing * perpendicularVector1(1) + j * spacing * perpendicularVector2(1);
            centerY = initialPosition(2) + i * spacing * perpendicularVector1(2) + j * spacing * perpendicularVector2(2);
            centerZ = initialPosition(3) + i * spacing * perpendicularVector1(3) + j * spacing * perpendicularVector2(3);
    
            % Добавляем координаты шара
            obstaclesX = [obstaclesX, centerX];
            obstaclesY = [obstaclesY, centerY];
            obstaclesZ = [obstaclesZ, centerZ];
        end
    end

    for i = 1:10
                % Генерация центральной точки для кластера
                centerX = randi([2, floor(range - obstaclesRadius)], 1, 1);
                centerY = randi([2, floor(range - obstaclesRadius)], 1, 1);
                centerZ = randi([2, floor(range - obstaclesRadius)], 1, 1);
                
                % Первый шар в кластере (центр)
                obstaclesX = [obstaclesX, centerX];
                obstaclesY = [obstaclesY, centerY];
                obstaclesZ = [obstaclesZ, centerZ];
                
                % Второй шар рядом с первым (на расстоянии радиуса)
                obstaclesX = [obstaclesX, centerX + floor(obstaclesRadius)];
                obstaclesY = [obstaclesY, centerY];
                obstaclesZ = [obstaclesZ, centerZ];
                
                % Третий шар рядом с первым и вторым (в другой плоскости)
                obstaclesX = [obstaclesX, centerX];
                obstaclesY = [obstaclesY, centerY + floor(obstaclesRadius)];
                obstaclesZ = [obstaclesZ, centerZ];
    
                % Четвёртый шар шар  (в другой плоскости)
                obstaclesX = [obstaclesX, centerX];
                obstaclesY = [obstaclesY, centerY];
                obstaclesZ = [obstaclesZ, centerZ - floor(obstaclesRadius)];
     end
end

    % плоскость
    function [obstaclesX, obstaclesY, obstaclesZ] = generateObstacles_6(width, height, depth, direction, spacing)
        % Инициализация массивов для координат  
        obstaclesX = [];  
        obstaclesY = [];  
        obstaclesZ = [];  
        spacing = spacing*0.7;  
    
        % gridSize - размер препятствия количество сфер  
        gridSize = 20;  
    
        fixedY = height/2;
        % Определяем начальную позицию (по оси X и Z)  
        
        
        % Стенка нижняя препятствия
        initialPosition = [55, 150, 55];  % Y фиксированное значение
        % Дно препятствия XZ
        for i = 0:gridSize-1
            for j = 0:gridSize-1
                % Вычисление координат на плоскости XZ
                centerX = initialPosition(1) + i * spacing;  % изменяется только X
                centerZ = initialPosition(3) + j * spacing;  % изменяется только Z

                % Добавляем координаты шара
                obstaclesX = [obstaclesX, centerX];
                obstaclesY = [obstaclesY, initialPosition(2)];  % y - фиксированное значение
                obstaclesZ = [obstaclesZ, centerZ];
            end
        end
    end

    % Препятствие случайные одиночные шары
function [obstaclesX, obstaclesY, obstaclesZ] = generateObstacles_7(range)
    obstaclesX = [];  
    obstaclesY = [];  
    obstaclesZ = [];

    obstaclesX = [obstaclesX, 170];
    obstaclesY = [obstaclesY, 110];  
    obstaclesZ = [obstaclesZ, 260];

    % obstaclesX = [obstaclesX, 150];
    % obstaclesY = [obstaclesY, 100];  
    % obstaclesZ = [obstaclesZ, 260];
end


    % Препятствие случайные одиночные шары
function [obstaclesX, obstaclesY, obstaclesZ] = generateObstacles_8(range)
    obstaclesX = [];  
    obstaclesY = [];  
    obstaclesZ = [];

    obstaclesX = [obstaclesX, 150];
    obstaclesY = [obstaclesY, 320];  % y - фиксированное значение
    obstaclesZ = [obstaclesZ, 200];

    obstaclesX = [obstaclesX, 100];
    obstaclesY = [obstaclesY, 100];  % y - фиксированное значение
    obstaclesZ = [obstaclesZ, 210];


    obstaclesX = [obstaclesX, 200];
    obstaclesY = [obstaclesY, 100];  % y - фиксированное значение
    obstaclesZ = [obstaclesZ, 200];
end