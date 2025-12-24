

% Пример данных
numSamples = 1000;

% Генерация случайных данных
distanceMatrices = rand(91, 91, 1, numSamples); % Набор матриц дистанций
targetDirections = randi([1, 91], [numSamples, 2]); % Случайные индексы
angles = rand(numSamples, 2); % Углы отклонения

% Разделение данных на обучающую, проверочную и тестовую выборки
[trainIdx, valIdx, testIdx] = dividerand(numSamples, 0.7, 0.15, 0.15);
trainData = {distanceMatrices(:, :, :, trainIdx), targetDirections(trainIdx, :)};
trainAngles = angles(trainIdx, :);


% Опции обучения
options = trainingOptions('adam', ...
    'InitialLearnRate', 1e-3, ...
    'MaxEpochs', 50, ...
    'MiniBatchSize', 32, ...
    'ValidationData', {valData, valAngles}, ...
    'Plots', 'training-progress', ...
    'Verbose', false);

% Обучение модели
net = trainNetwork(trainData, trainAngles, layers, options);



% Прогноз
testMatrix = rand(91, 91, 1); % Пример входной матрицы
testDirection = [45, 45];     % Пример направления
predictedAngles = predict(net, {testMatrix, testDirection});
disp('Предсказанные углы отклонения:');
disp(predictedAngles);
