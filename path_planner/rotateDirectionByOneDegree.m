% 1.3.10 Функция постепенного изменения направления движения
function nextDir = rotateDirectionByOneDegree(currentDir, targetDir)
    % currentDir - текущее направление (3D вектор)
    % targetDir - новое направление (3D вектор, к которому стремимся)

    % 1. Нормализуем векторы
    currentDir = currentDir / norm(currentDir);
    targetDir = targetDir / norm(targetDir);

    % 2. Вычисляем угол между векторами в градусах
    angleBetweenDirs = acosd(dot(currentDir, targetDir));

    % Если угол между направлениями меньше 2 градуса, просто возвращаем целевой вектор
    if angleBetweenDirs < 2
        nextDir = targetDir;
        return;
    elseif targetDir(1) == 0 && targetDir(2) == 0 && targetDir(3) == 1
        nextDir = currentDir;
        return;
    end

    % 3. Найдём ось вращения (векторное произведение)
    rotationAxis = cross(currentDir, targetDir);
    rotationAxis = rotationAxis / norm(rotationAxis);  % Нормализуем ось

    % Если ось вращения неопределена (векторы коллинеарны)
    if norm(rotationAxis) < 1e-6
        nextDir = currentDir;  % Векторы одинаковы или противоположны, возвращаем текущий
        return;
    end

    % 4. Поворачиваем текущее направление  в сторону targetDir
    DegreeRad = deg2rad(2);  %  градус в радианах
    R = rotationMatrixAroundAxis(rotationAxis, DegreeRad);

    [rows, cols] = size(currentDir);
    if rows == 1 && cols > 1
        currentDir = currentDir';
    elseif cols == 1 && rows > 1
        disp('Не меняем Вектор является столбцом.');
    else
        disp('Это не вектор.');
    end
    % 5. Применяем матрицу поворота к текущему вектору
    nextDir = (R*currentDir)';

    % 6. Нормализуем результат, чтобы сохранить единичную длину
    nextDir = nextDir / norm(nextDir);


    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % displayAngles('Текущий', currentDir);
    % displayAngles('Следующий', nextDir);
    % displayAngles('Целевой', targetDir);



    % 
    % % 2. Вычисляем проекцию на плоскость XY
    % projectionXY3 = sqrt(targetDir(1)^2 + targetDir(2)^2);    
    % % 3. Вычисляем угол возвышения относительно плоскости XY
    % elevationAngle1 = atan2d(targetDir(3), projectionXY3);  % Угол в градусах
    % 
    % % 2. Вычисляем азимутальный угол относительно оси X
    % azimuthAngle1 = atan2d(targetDir(2), targetDir(1));  % Угол в градусах
    % 
    % %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % %  Вычисляем проекцию вектора на плоскость XY
    % projectionXY = sqrt(nextDir(1)^2 + nextDir(2)^2);
    % elevationAngle2 = atan2d(nextDir(3), projectionXY);  % Угол в градусах
    % 
    % % 2. Вычисляем азимутальный угол относительно оси X
    % azimuthAngle2 = atan2d(nextDir(2), nextDir(1));  % Угол в градусах
    % 
    % %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % % 2. Вычисляем проекцию на плоскость XY
    % projectionXY0 = sqrt(currentDir(1)^2 + currentDir(2)^2);    
    % % 3. Вычисляем угол возвышения относительно плоскости XY
    % elevationAngle0 = atan2d(currentDir(3), projectionXY0);  % Угол в градусах
    % 
    % % 2. Вычисляем азимутальный угол относительно оси X
    % azimuthAngle0 = atan2d(currentDir(2), currentDir(1));  % Угол в градусах
    % 
    % % Вывод результата
    % disp(['Азимутальный угол: текуший-следующий-к которому стремится  ', num2str(azimuthAngle0), ' ',  num2str(azimuthAngle2), ' ',  num2str(azimuthAngle1)]);
    % disp(['Вертикальный угол: текуший-следующий-к которому стремится  ', num2str(elevationAngle0), ' ',  num2str(elevationAngle2), ' ',  num2str(elevationAngle1)]);

end

% Функция для вычисления матрицы поворота вокруг оси на заданный угол
function R = rotationMatrixAroundAxis(axis, angle)
    ux = axis(1);
    uy = axis(2);
    uz = axis(3);
    c = cos(angle);
    s = sin(angle);
    t = 1 - c;

    % Матрица поворота
    R = [t*ux*ux + c,    t*ux*uy - s*uz, t*ux*uz + s*uy;
         t*ux*uy + s*uz, t*uy*uy + c,    t*uy*uz - s*ux;
         t*ux*uz - s*uy, t*uy*uz + s*ux, t*uz*uz + c];
end



function displayAngles(vectorName, dir)
    projectionXY = sqrt(dir(1)^2 + dir(2)^2);
    elevationAngle = atan2d(dir(3), projectionXY); % Угол возвышения
    azimuthAngle = atan2d(dir(2), dir(1)); % Азимутальный угол
    disp([vectorName, ': Азимутальный угол = ', num2str(azimuthAngle), ...
          ', Вертикальный угол = ', num2str(elevationAngle)]);
end
