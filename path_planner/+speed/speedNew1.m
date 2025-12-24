% Определяет рекомендуемую скорость в зависимости от расстояний до препятствий
function speedNew = speedNew1(minDistObstacle, dangerZone, speedMax)
    % dangerZone - Зоны опасности
    % minDistObstacle - Минимальная дистанция до препятствия
    % speedMax - МАКСИМАЛЬНАЯ СКОРОСТЬ РОБОТА

    % Определяем минимальное значение в матрице (расстояние до ближайшего препятствия
    minDist = minDistObstacle;

    if minDist <= dangerZone(5) % если пятая зона, то скорость нулю
        speedNew = 0;
    elseif minDist < dangerZone(5)*1.01 % если пятая зона, то скорость минимальна
        speedNew = speedMax*0.03;
    elseif minDist < dangerZone(4)
        speedNew = speedMax*0.3;
    elseif minDist < dangerZone(3)
        speedNew = speedMax*0.5;
    elseif minDist < dangerZone(2)
        speedNew = speedMax*0.85;
    else
        speedNew = speedMax;
    end
end
