
% Размерность входов
inputSize = [91 91 1];  % Матрица дистанций
targetInputSize = 2;    % Направление на цель (два индекса)
outputSize = 2;         % Углы отклонения

% Входной слой для матрицы дистанций
distanceMatrixLayers = [
    imageInputLayer(inputSize, 'Name', 'DistanceMatrixInput', 'Normalization', 'none')
    
    % Первый сверточный блок
    convolution2dLayer(3, 16, 'Padding', 'same', 'Name', 'Conv1')
    reluLayer('Name', 'Relu1')
    maxPooling2dLayer(2, 'Stride', 2, 'Name', 'MaxPool1')

    % Второй сверточный блок
    convolution2dLayer(3, 32, 'Padding', 'same', 'Name', 'Conv2')
    reluLayer('Name', 'Relu2')
    maxPooling2dLayer(2, 'Stride', 2, 'Name', 'MaxPool2')

    % Полносвязные слои
    fullyConnectedLayer(128, 'Name', 'FC1')
    reluLayer('Name', 'ReluFC1')
];

% Входной слой для целевых индексов (2 числа)
targetDirectionLayers = [
    featureInputLayer(targetInputSize, 'Name', 'TargetDirection')
    fullyConnectedLayer(32, 'Name', 'FC2')
    reluLayer('Name', 'ReluFC2')
];

% Слой объединения
concatLayer = concatenationLayer(1, 2, 'Name', 'Concat');

% Последовательность после объединения
finalLayers = [
    fullyConnectedLayer(64, 'Name', 'FC3')
    reluLayer('Name', 'ReluFC3')
    fullyConnectedLayer(outputSize, 'Name', 'Output')
    regressionLayer('Name', 'RegressionOutput') % Регрессионный выход
];

% Создание графа слоёв
layers = layerGraph();

% Добавление всех частей в граф
layers = addLayers(layers, distanceMatrixLayers);
layers = addLayers(layers, targetDirectionLayers);
layers = addLayers(layers, concatLayer);
layers = addLayers(layers, finalLayers);

% Соединение слоёв
layers = connectLayers(layers, 'ReluFC1', 'Concat/in1');
layers = connectLayers(layers, 'ReluFC2', 'Concat/in2');
layers = connectLayers(layers, 'Concat', 'FC3');












% Пример данных
numSamples = 1000;
% Размеры данных
numSamples = 1000; % Общее количество примеров
validationSplit = 0.2; % Доля данных на валидацию

% Генерация матриц дистанций (входы)
allData = rand(91, 91, 1, numSamples); % Случайные нормализованные данные (0; 1)

% Генерация направлений (входы)
allDirections = randi([1 91], numSamples, 2); % Индексы направления на цель

% Генерация целевых углов (выходы)
allAngles = rand(numSamples, 2); % Случайные углы в диапазоне [0; 1]

% Разделение на обучающие и валидационные данные
numValidation = round(numSamples * validationSplit);

valData = allData(:, :, :, 1:numValidation); % Данные для валидации
valDirections = allDirections(1:numValidation, :);
valAngles = allAngles(1:numValidation, :);

trainData = allData(:, :, :, numValidation+1:end); % Данные для обучения
trainDirections = allDirections(numValidation+1:end, :);
trainAngles = allAngles(numValidation+1:end, :);


% Опции обучения
% Параметры обучения
options = trainingOptions('adam', ...
    'MaxEpochs', 20, ...
    'MiniBatchSize', 32, ...
    'ValidationData', { {valData, valDirections}, valAngles }, ...
    'Plots', 'training-progress', ...
    'Verbose', false);

% Обучение сети
trainInputs = {trainData, trainDirections}; % Входы: матрицы + направления
trainOutputs = trainAngles; % Выходы: углы

net = trainNetwork(trainInputs, trainOutputs, layers, options);



% Прогноз
testMatrix = rand(91, 91, 1); % Пример входной матрицы
testDirection = [45, 45];     % Пример направления
predictedAngles = predict(net, {testMatrix, testDirection});
disp('Предсказанные углы отклонения:');
disp(predictedAngles);
















