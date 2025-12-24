clc; clear; close all;
% Размеры поля
width = 300;
height = 300;
depth = 300;
% Виды препятствий 
% numType - номер типа препятствия 
% 0 - случайные одиночные препятствия.
% 1 - случайные препятствия по четыре сферы
% 2 - препятствие ловушка
% 3 - препятствия в виде плоскостей
% 4 - препятствия в виде плоскостей
% 5 - препятствия в виде плоскостей
%
% Тип препятствий
numType = 8;

%++++++++++++++++++++++++++++++++++++++++++++++++++
% ПАРАМЕТРЫ
%+++++++++++++
% радиус препятствия
obstaclesRadius = 4; 
% Количество препятствий
numObstacles = 22;

% сектор вокруг направления движения (радар)
degrees = 101; % угол в градусах  
sectorAngle = deg2rad(degrees); % преобразование в радианы 

% Дистанция сканирования (радиус сектора радара)
scanRange = 55; 
% Максимальная Скорость движения робота
speedMax = 1; 
% Скорость препятствий
speedMultiplier = 0; 
% Разбиение сектора радара  
numSectors = 101;   
% Отображать ли радар
display_radar = true; 
% Записывать видео
video_flag = false;
% Хранить историю
flagHistory = true;

if numType == 8
    speedMax = 1; 
    speedMultiplier = 1; 
    obstaclesRadius = 12;
    speedObstacles = [-0.5, -0.5, 0];
    % Начальная точка робота 
    startX = 150;
    startY = 0;
    startZ = 200;
    %  целевая точка
    targetX = 150;
    targetY = height - 0.5;
    targetZ = 200;  
elseif numType == 2
    speedMultiplier = 0; 
    obstaclesRadius = 6;
    speedObstacles = [1, 0, 0];
    % Начальная точка робота 
    startX = 150;
    startY = 0;
    startZ = 150;
    %  целевая точка
    targetX = 150;
    targetY = height - 0.5;
    targetZ = 150;
elseif numType == 6
    speedMultiplier = 0.5; 
    obstaclesRadius = 10;
    speedObstacles = [0, -1, 0];
    % Начальная точка робота 
    startX = 150;
    startY = 0;
    startZ = 200;
    %  целевая точка
    targetX = 150;
    targetY = height - 0.5;
    targetZ = 200;
elseif numType == 7 
    speedObstacles = [1, 0, 0];
     % Начальная точка робота 
    startX = width/2;
    startY = width/2;
    startZ = depth;
    %  целевая точка
    targetX = width/2;
    targetY = width/2;
    targetZ = 0;
elseif numType == 0
    % радиус препятствия
    obstaclesRadius = 6; 
    speedObstacles = [0, 0.7, 0.3];
    width = 100;
    height = 100;
    depth = 100;
    % Начальная точка робота 
    startX = 0.5;
    startY = height;
    startZ = 0.5;
    %  целевая точка
    targetX = width;
    targetY = 0.5;
    targetZ = depth;
else
    speedObstacles = [0, 0.7, 0.3];
    width = 100;
    height = 100;
    depth = 100;
    % Начальная точка робота 
    startX = 0.5;
    startY = height;
    startZ = 0.5;
    %  целевая точка
    targetX = width;
    targetY = 0.5;
    targetZ = depth;
end
speedObstacles = speedMultiplier * speedObstacles/norm(speedObstacles);

% Зоны опасности
dangerZone = [scanRange, scanRange*0.9, scanRange*0.6, scanRange*0.2, obstaclesRadius];

% 1.3  Визуализация перемещения робота
visualiseMove(width, height, depth, startX, startY, startZ, targetX, targetY, ...
    targetZ, speedMax, sectorAngle, scanRange, numSectors, obstaclesRadius, ...
    display_radar, speedObstacles, numType, dangerZone, numObstacles, video_flag, flagHistory);



