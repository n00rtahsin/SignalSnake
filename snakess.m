function signalSnakeLite()
    % Minimal Signal Snake Game - Working Version

    snakeLength = 50;
    A = 1; f = 1; phase = 0; speed = 0.1;
    foodRadius = 0.3;
    
    xRange = [0, 4*pi];
    yRange = [-2.5, 2.5];

    % Initialize snake
    snakeX = linspace(0, 2, snakeLength);
    snakeY = zeros(1, snakeLength);
    
    % Create figure
    fig = figure('Name', 'Signal Snake 🐍 Lite', 'Color', 'k', ...
        'NumberTitle', 'off', 'KeyPressFcn', @keyPress, ...
        'CloseRequestFcn', @(src, evt) close(fig));

    ax = axes('Parent', fig, 'XColor', 'w', 'YColor', 'w', ...
        'Color', 'k', 'XLim', xRange, 'YLim', yRange);
    hold(ax, 'on');
    title('Signal Snake - Sine Control', 'Color', 'w');

    snakePlot = plot(ax, snakeX, snakeY, 'Color', [0 1 0], 'LineWidth', 4);
    headPlot = plot(ax, snakeX(end), snakeY(end), 'yo', 'MarkerSize', 14, ...
        'MarkerFaceColor', 'yellow');

    foodPlot = plot(ax, NaN, NaN, 'ro', 'MarkerSize', 12, ...
        'MarkerFaceColor', 'r');

    [food_x, food_y] = generateFood();
    score = 0;
    scoreText = text(xRange(1)+0.5, yRange(2)-0.3, ...
        sprintf('Score: %d', score), 'Color', 'yellow', 'FontSize', 14);

    % Game loop
    while ishandle(fig)
        phase = phase + 0.2;

        newX = snakeX(end) + speed;
        if newX > xRange(2)
            newX = xRange(1);  % wrap around
        end
        newY = A * sin(f * newX + phase);
        newY = max(yRange(1), min(yRange(2), newY));

        % Update snake position
        snakeX = [snakeX(2:end), newX];
        snakeY = [snakeY(2:end), newY];

        % Plot updates
        set(snakePlot, 'XData', snakeX, 'YData', snakeY);
        set(headPlot, 'XData', newX, 'YData', newY);
        set(foodPlot, 'XData', food_x, 'YData', food_y);

        % Collision check
        dist = sqrt((newX - food_x)^2 + (newY - food_y)^2);
        if dist < foodRadius
            score = score + 1;
            set(scoreText, 'String', sprintf('Score: %d', score));
            [food_x, food_y] = generateFood();
        end

        drawnow limitrate
        pause(0.01);
    end

    function [fx, fy] = generateFood()
        fx = rand() * (xRange(2) - 1);
        fy = rand() * diff(yRange) + yRange(1);
    end

    function keyPress(~, event)
        switch event.Key
            case 'uparrow', A = min(A + 0.1, 3);
            case 'downarrow', A = max(A - 0.1, 0.2);
            case 'leftarrow', f = max(f - 0.1, 0.1);
            case 'rightarrow', f = min(f + 0.1, 5);
        end
    end
end
