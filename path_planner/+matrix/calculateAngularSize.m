% Вычисление углового размера препятствия по размеру препятствия и расстоянию до него
function angularSizeDegrees = calculateAngularSize(objectSize, distance)
    % objectSize - размер препятствия
    % distance - расстояние до препятствия

    % Вычисляем угловой размер в радианах
    angularSizeRadians =  atan(2 * objectSize / distance);
    
    % Преобразование углового размера из радиан в градусы
    angularSizeDegrees =  rad2deg(angularSizeRadians);
end