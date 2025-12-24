% 1.3.4.1  Создаём основание перпендикулярное курсовому пути
function base_vertices = createPerpendicularSquare(center, directionMove, side_length)
    % center - координаты центра основания пирамиды
    % directionMove - курсовой вектор, перпендикулярный основанию пирамиды
    % side_length - длина стороны квадрата (основания пирамиды)

    % Нормализуем курсовой вектор
    directionMove = directionMove / norm(directionMove);
    
    % Находим вектор, ортогональный курсовому вектору (например, вдоль оси Z)
    arbitrary_vector = [0, 0, 1];
    if dot(arbitrary_vector, directionMove) > 0.99  % Если направление очень близко к Z
        arbitrary_vector = [1, 0, 0];  % Берем другой произвольный вектор
    end
    
    % Используем векторное произведение для нахождения ортогональных
    % векторов  Вектор перпендикулярен курсовому  вектору и оси Z
    v1 = cross(directionMove, arbitrary_vector);
    v1 = v1 / norm(v1);  % Нормализуем
    
    % Второй ортогональный вектор, тоже перпендикулярный directionMove
    v2 = cross(directionMove, v1);
    v2 = v2 / norm(v2);  % Нормализуем

    % Половина длины стороны квадрата
    half_side = side_length / 2;

    % Строим вершины квадрата
    base_vertices = [
        center + half_side * (-v1 - v2);  % Нижний левый
        center + half_side * ( v1 - v2);  % Нижний правый
        center + half_side * ( v1 + v2);  % Верхний правый
        center + half_side * (-v1 + v2);  % Верхний левый
    ];
end
