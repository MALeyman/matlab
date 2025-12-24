
% 1.2 Визуализация препятствий
function obstacleObjects = visualizeField(fig, width, height, depth, obstaclesX, obstaclesY, obstaclesZ, obstaclesRadius, obstaclesType)
    % Устанавливаем текущую фигуру для рисования
    figure(fig);
    hold on;
    axis([-1, width + 2, -1, height + 2, -1, depth + 2]);

    view(3);  % Устанавливаем 3D вид
    grid on;
    
    % Массив для хранения объектов препятствий
    obstacleObjects = [];

    for i = 1:length(obstaclesX)
        [X, Y, Z] = sphere;
        % Создаем сферическое препятствие и сохраняем его в массиве
        obstacleObjects(i) = surf(obstaclesRadius * X + obstaclesX(i), obstaclesRadius * Y + obstaclesY(i), obstaclesRadius * Z + obstaclesZ(i), 'FaceColor', 'g', 'EdgeColor', 'none');
    end

    title('Поле с препятствиями');
end


% % 1.2 Визуализация   препятствий
% function obstacleObjects = visualizeField(fig, width, height, depth, obstaclesX, obstaclesY, obstaclesZ, obstaclesRadius, obstaclesType)
% 
% 
% fig = figure;
% % Устанавливаем размер и положение окна
% set(fig, 'Position', [100, 100, 1000, 800]); % [x, y, width, height]
% hold on;
% axis([-1 width+2 -1 height+2 -1 depth+2]);
% view(3);  % Устанавливаем 3D вид
% grid on;
% % Массив для хранения объектов препятствий
% 
% obstacleObjects = [];
% 
% 
% for i = 1:length(obstaclesX)
%     [X, Y, Z] = sphere;
%     % Создаем сферическое препятствие и сохраняем его в массиве
%     obstacleObjects(i) = surf(obstaclesRadius*X + obstaclesX(i), obstaclesRadius*Y + obstaclesY(i), obstaclesRadius*Z + obstaclesZ(i), 'FaceColor', 'g', 'EdgeColor', 'none');
% end
% 
%     title('Поле с препятствиями');
% end  
% 




