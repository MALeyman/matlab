
function [t_robot, t_obstacle, minDist] = solveIntersection(robotPosition, directionMove, centerCurr, displacement, currentTime)
    % Вычисляем пересечение курсов и минимальное расстояние

    % Параметрическое уравнение: robotPosition + t_robot * directionMove
    %                           = centerCurr + t_obstacle * displacement

    %displacement = [1, 0, 0];
    % Нормализация displacement
    if norm(displacement) > 0
        displacement = displacement / norm(displacement);
    end
    A = [directionMove', - displacement'];
    b = (centerCurr - robotPosition)';

    % Решаем систему уравнений
    if rank(A) == 2
        t = A \ b; % Решаем систему уравнений для t_robot и t_obstacle
        t_robot = t(1);
        t_obstacle = t(2);
    else
        % Если траектории параллельны или пересечения нет
        t_robot = Inf;
        t_obstacle = Inf;
    end

    % Проверяем корректность времени
    if t_robot < 0 || t_obstacle < 0
        % Если пересечение произошло в прошлом, игнорируем
        t_robot = Inf;
        t_obstacle = Inf;
        minDist = Inf;
        return;
    end

    % Вычисляем позиции на траекториях в моменты t_robot и t_obstacle
    pointOnRobot = robotPosition + t_robot * directionMove;
    pointOnObstacle = centerCurr + t_obstacle * displacement;

    % Вычисляем минимальное расстояние между точками на траекториях
    minDist = norm(pointOnRobot - pointOnObstacle);
end







