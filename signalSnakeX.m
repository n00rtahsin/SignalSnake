function signalSnakeX()
    % SIGNAL SNAKE X - Game with Pause, Reset, Speed Control

    %% Game Parameters
    snakeLength = 60;
    A = 1; f = 1; phase = 0; speed = 0.25;
    xRange = [0, 4*pi];
    yRange = [-2.5, 2.5];
    foodRadius = 0.4;

    % Declare shared variables
    snakeX = linspace(0, 2, snakeLength);
    snakeY = zeros(1, snakeLength);
    score = 0;
    food_x = 0;
    food_y = 0;
    noise_x = 0;
    noise_y = 0;
    paused = false;

    %% Create Figure & Axes
    fig = figure('Name', 'Signal Snake X', 'Color', 'k', ...
        'NumberTitle', 'off', 'Position', [100 100 1000 600], ...
        'CloseRequestFcn', @(src, evt) close(fig));
    ax = axes('Parent', fig, 'Position', [0.08 0.25 0.84 0.7], ...
        'Color', 'k', 'XColor', 'w', 'YColor', 'w', ...
        'XLim', xRange, 'YLim', yRange);
    hold(ax, 'on');
    title(ax, 'Signal Snake X -NNur', 'Color', 'w');

    snakePlot = plot(ax, snakeX, snakeY, 'g-', 'LineWidth', 4);
    headPlot = plot(ax, snakeX(end), snakeY(end), 'yo', 'MarkerSize', 12, 'MarkerFaceColor', 'y');
    foodPlot = plot(ax, NaN, NaN, 'ro', 'MarkerSize', 12, 'MarkerFaceColor', 'r');
    noisePlot = plot(ax, NaN, NaN, 'rx', 'MarkerSize', 20, 'LineWidth', 2);
    scoreText = text(xRange(1)+0.5, yRange(2)-0.3, 'Score: 0', 'Color', 'y', 'FontSize', 14);

    %% UI Controls
    uicontrol('Style', 'text', 'Position', [80 80 100 20], ...
        'String', 'Amplitude', 'BackgroundColor', 'k', 'ForegroundColor', 'w');
    uicontrol('Style', 'slider', 'Min', 0.2, 'Max', 3, 'Value', A, ...
        'Position', [80 60 200 20], ...
        'Callback', @(src,~) setAmp(src.Value));

    uicontrol('Style', 'text', 'Position', [80 35 100 20], ...
        'String', 'Frequency', 'BackgroundColor', 'k', 'ForegroundColor', 'w');
    uicontrol('Style', 'slider', 'Min', 0.2, 'Max', 5, 'Value', f, ...
        'Position', [80 15 200 20], ...
        'Callback', @(src,~) setFreq(src.Value));

    uicontrol('Style', 'text', 'Position', [320 80 100 20], ...
        'String', 'Speed', 'BackgroundColor', 'k', 'ForegroundColor', 'w');
    uicontrol('Style', 'slider', 'Min', 0.05, 'Max', 1, 'Value', speed, ...
        'Position', [320 60 200 20], ...
        'Callback', @(src,~) setSpeed(src.Value));

    uicontrol('Style', 'pushbutton', 'String', '⏸ Pause', ...
        'Position', [550 40 100 40], 'FontSize', 12, ...
        'Callback', @(~,~) togglePause());

    uicontrol('Style', 'pushbutton', 'String', '🔄 Reset', ...
        'Position', [670 40 100 40], 'FontSize', 12, ...
        'Callback', @(~,~) resetGame());

    %% Game Loop
    timerObj = timer('ExecutionMode', 'fixedRate', ...
        'Period', 0.02, 'TimerFcn', @(~,~) gameTick());
    start(timerObj);

    % Call once at start
    resetGame();

    %% NESTED FUNCTIONS
    function gameTick()
        if ~ishandle(fig) || paused, return; end

        phase = phase + 0.2;
        newX = snakeX(end) + speed;
        if newX > xRange(2), newX = xRange(1); end
        newY = A * sin(f * newX + phase);

        snakeX = [snakeX(2:end), newX];
        snakeY = [snakeY(2:end), newY];

        set(snakePlot, 'XData', snakeX, 'YData', snakeY);
        set(headPlot, 'XData', newX, 'YData', newY);
        set(foodPlot, 'XData', food_x, 'YData', food_y);
        set(noisePlot, 'XData', noise_x, 'YData', noise_y);

        if norm([newX - food_x, newY - food_y]) < foodRadius
            score = score + 1;
            set(scoreText, 'String', sprintf('Score: %d', score));
            [food_x, food_y] = placeRandom();
            sound(sin(2*pi*f*(1:500)/44100), 44100);
        end

        if norm([newX - noise_x, newY - noise_y]) < foodRadius
            score = max(score - 1, 0);
            set(scoreText, 'String', sprintf('Score: %d ❌', score));
            [noise_x, noise_y] = placeRandom();
        end

        drawnow limitrate;
    end

    function setAmp(val), A = val; end
    function setFreq(val), f = val; end
    function setSpeed(val), speed = val; end

    function togglePause()
        paused = ~paused;
        btn = findobj('String', {'⏸ Pause','▶ Resume'});
        if paused
            set(btn, 'String', '▶ Resume');
        else
            set(btn, 'String', '⏸ Pause');
        end
    end

    function resetGame()
        snakeX = linspace(0, 2, snakeLength);
        snakeY = zeros(1, snakeLength);
        phase = 0;
        score = 0;
        [food_x, food_y] = placeRandom();
        [noise_x, noise_y] = placeRandom();
        if ishandle(scoreText)
            set(scoreText, 'String', 'Score: 0');
        end
    end

    function [x, y] = placeRandom()
        x = rand() * (xRange(2) - 1);
        y = rand() * diff(yRange) + yRange(1);
    end
end
