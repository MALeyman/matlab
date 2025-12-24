% Плавное изменение скорости
function speedCurent = changeSpeed(speedCurent, speedNew, speedMax)
    % speedCurent - величина шага движения, текущая скорость робота
    % speedNew - Новая скорость робота
    % deltaSpeed - величина изменения скорости (ускорение)

    deltaSpeed = 0.05;
    if speedCurent < speedMax*0.1 
        deltaSpeed = 0.01;
    elseif speedCurent < speedMax*0.2
        deltaSpeed = 0.05;
    elseif speedCurent < speedMax*0.3
        deltaSpeed = 0.08;
    elseif speedCurent > speedMax*0.9
        deltaSpeed = 0.01;    
    end

    % новая скорость, постепенное изменение скорости
    if speedCurent > speedNew % если новая скорость меньше, то уменьшаем скорость
        speedCurent = speedCurent - deltaSpeed;
    elseif speedCurent < speedNew % если новая скорость больше, то увеличиваем скорость
        speedCurent = speedCurent + deltaSpeed;
    end
    if speedCurent < 0
        speedCurent = 0;
    elseif speedCurent > speedMax
        speedCurent = speedMax;
    end
end

