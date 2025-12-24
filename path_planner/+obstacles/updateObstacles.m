% % 1.3.13 Обновление  отображения препятствий
function updateObstacles(obstacleObjects, obstaclesX, obstaclesY, obstaclesZ, obstaclesRadius, detectedObstacles)

    for i = 1:length(obstacleObjects)
        % Проверяем, если препятствие в поле радара, то меняем его цвет на красный
        if detectedObstacles(i)
            obstacleColor = 'r';  % Красный цвет для обнаруженных препятствий
        else
            obstacleColor = 'g';  % Зеленый цвет для не обнаруженных препятствий
        end
        [X, Y, Z] = sphere;
        % Обновляем координаты существующих объектов
        set(obstacleObjects(i), 'XData', obstaclesRadius*X + obstaclesX(i), 'YData', obstaclesRadius*Y + obstaclesY(i), 'ZData', obstaclesRadius*Z + obstaclesZ(i), 'FaceColor', obstacleColor);
    end
    drawnow;
end


