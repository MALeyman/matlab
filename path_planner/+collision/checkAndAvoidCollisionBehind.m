
function [collisionDetected, newDirection] = checkAndAvoidCollisionBehind(robotPosition, directionMove, clustersNew, tolerance, currentTime)
    collisionDetected = false;
    newDirection = directionMove;

    for idx = 1:length(clustersNew)
        if isfield(clustersNew{idx}, 'movement') && clustersNew{idx}.movement.isMoving
            % Траектория препятствия
            centerCurr = mean(clustersNew{idx}.points, 1); % Центр кластера
            displacement = clustersNew{idx}.movement.displacement; % Смещение

            % Проверяем пересечение курса робота и траектории препятствия
            [t_robot, t_obstacle, minDist] = collision.solveIntersection(robotPosition, directionMove, ...
                                                               centerCurr, displacement, currentTime);

            % Если есть пересечение в будущем
            if t_robot >= 0 && t_obstacle >= 0 && minDist < tolerance
                collisionDetected = true;

                % Вычисляем направление обхода сзади
                newDirection = avoidObstacleBehind(directionMove, displacement);
                break;
            end
        end
    end
end

function newDirection = avoidObstacleBehind(directionMove, displacement)
    % Меняем направление движения робота, чтобы обойти препятствие сзади

    % Нормализуем векторы
    directionMove = directionMove / norm(directionMove);
    displacement = displacement / norm(displacement);

    % Находим вектор, направленный "против" движения препятствия
    oppositeVector = -displacement;

    % Комбинируем его с текущим направлением
    newDirection = oppositeVector;

    % Нормализуем новое направление
    if norm(newDirection) > 1e-6
        newDirection = newDirection / norm(newDirection);
    else
        % Если вектор нулевой, используем фиксированный обход
        newDirection = [0, 0, 1]; % Например, сдвиг вверх
    end
end
