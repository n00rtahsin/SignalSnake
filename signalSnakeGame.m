function signalSnakeGame()
    % Signal Snake Game - Enhanced Version with Improved Controls
    % A game where you control a sinusoidal wave snake to collect food
    
    %% Game Parameters
    snakeLength = 50;    % Number of points in snake body
    A = 1;               % Base amplitude
    f = 1;               % Base frequency  
    speed = 0.1;         % Forward movement speed
    foodRadius = 0.3;    % Collision detection radius
    
    %% Initialize game state
    xRange = [0, 4*pi];
    yRange = [-2.5, 2.5];  % Slightly expanded for better movement
    
    % Snake position tracking
    snakeX = linspace(0, 2, snakeLength);  % Initial snake x positions
    snakeY = zeros(1, snakeLength);        % Initial snake y positions
    
    % Control variables with improved ranges
    userAmplitude = 1;     % User-controlled amplitude (0.2 to 2.5)
    userFrequency = 1;     % User-controlled frequency (0.3 to 5.0)
    userPhase = 0;         % User-controlled phase
    targetAmplitude = 1;   % Smooth interpolation target
    targetFrequency = 1;   % Smooth interpolation target
    
    % Control sensitivity settings
    ampSensitivity = 1.5;
    freqSensitivity = 2.0;
    phaseSensitivity = 4.0;
    smoothing = 0.85;      % Smoothing factor for interpolation
    
    %% Create Figure with improved UI
    fig = figure('Name', 'Signal Snake Game 🐍', ...
                'NumberTitle', 'off', ...
                'Color', 'k', ...
                'MenuBar', 'none', ...
                'KeyPressFcn', @keyPressCallback, ...
                'KeyReleaseFcn', @keyReleaseCallback, ...
                'CloseRequestFcn', @closeCallback, ...
                'Position', [100, 100, 1200, 700]);
    
    % Main game area
    ax = axes('Parent', fig, ...
             'Position', [0.08 0.25 0.84 0.65]);
    hold(ax, 'on');
    axis(ax, [xRange, yRange]);
    ax.XColor = 'w';
    ax.YColor = 'w';
    ax.Color = 'k';
    xlabel(ax, 'X Position', 'Color', 'w', 'FontSize', 12);
    ylabel(ax, 'Y Position', 'Color', 'w', 'FontSize', 12);
    title(ax, 'Signal Snake Game - Master the sine wave controls!', 'Color', 'w', 'FontSize', 14);
    grid(ax, 'on');
    ax.GridColor = [0.2 0.2 0.2];
    
    %% Initialize game objects
    % Snake visualization with gradient effect
    snakePlot = plot(ax, snakeX, snakeY, 'g-', 'LineWidth', 6);
    headPlot = plot(ax, snakeX(end), snakeY(end), 'yo', 'MarkerSize', 18, ...
                   'MarkerFaceColor', 'yellow', 'MarkerEdgeColor', 'black', 'LineWidth', 2);
    
    % Food with pulsing animation
    foodPlot = plot(ax, NaN, NaN, 'ro', 'MarkerSize', 22, ...
                   'MarkerFaceColor', 'red', 'MarkerEdgeColor', 'white', 'LineWidth', 3);
    
    % Target indicator (shows where snake will go)
    targetPlot = plot(ax, NaN, NaN, '--', 'Color', [0.5 0.5 1], 'LineWidth', 2);
    
    %% Game state variables
    score = 0;
    gameRunning = true;
    gamePaused = false;
    foodPulse = 0; % For food animation
    
    % Enhanced key state tracking
    keys = struct('up', false, 'down', false, 'left', false, 'right', false, ...
                 'w', false, 's', false, 'a', false, 'd', false, ...
                 'q', false, 'e', false, 'shift', false, 'ctrl', false);
    
    %% Generate initial food
    [food_x, food_y] = generateFood();
    
    %% Enhanced UI Elements
    % Score and stats
    scoreText = text(ax, xRange(1) + 0.3, yRange(2) - 0.3, sprintf('Score: %d', score), ...
                    'Color', 'yellow', 'FontSize', 18, 'FontWeight', 'bold');
    
    % Real-time parameter display with visual bars
    paramPanel = uipanel('Parent', fig, 'Position', [0.08 0.02 0.84 0.2], ...
                        'BackgroundColor', 'k', 'BorderType', 'line', 'HighlightColor', 'w');
    
    % Control instructions
    controlText1 = text(ax, xRange(1) + 0.3, yRange(1) + 0.6, ...
        '🎮 CONTROLS:', 'Color', 'cyan', 'FontSize', 12, 'FontWeight', 'bold');
    controlText2 = text(ax, xRange(1) + 0.3, yRange(1) + 0.4, ...
        '↑↓ Amplitude | ←→ Frequency | Q/E Phase | WASD Fine Control', ...
        'Color', 'cyan', 'FontSize', 10);
    controlText3 = text(ax, xRange(1) + 0.3, yRange(1) + 0.2, ...
        'SHIFT+keys = Fast | CTRL+keys = Slow | SPACE = Pause | R = Reset', ...
        'Color', 'cyan', 'FontSize', 10);
    
    % Parameter display
    paramText = text(ax, xRange(2) - 4, yRange(2) - 0.3, '', ...
                    'Color', [0.5 1 0.5], 'FontSize', 12, 'FontWeight', 'bold');
    
    % Visual parameter bars
    ampBarBg = rectangle(ax, 'Position', [xRange(2)-3.5, yRange(2)-0.8, 2, 0.1], ...
                        'FaceColor', [0.2 0.2 0.2], 'EdgeColor', 'w');
    ampBar = rectangle(ax, 'Position', [xRange(2)-3.5, yRange(2)-0.8, 0.8, 0.1], ...
                      'FaceColor', [0 1 0], 'EdgeColor', 'none'); % Green
    ampLabel = text(ax, xRange(2)-3.5, yRange(2)-0.6, 'AMP', 'Color', 'w', 'FontSize', 8);
    
    freqBarBg = rectangle(ax, 'Position', [xRange(2)-3.5, yRange(2)-1.0, 2, 0.1], ...
                         'FaceColor', [0.2 0.2 0.2], 'EdgeColor', 'w');
    freqBar = rectangle(ax, 'Position', [xRange(2)-3.5, yRange(2)-1.0, 0.4, 0.1], ...
                       'FaceColor', [0 0 1], 'EdgeColor', 'none'); % Blue
    freqLabel = text(ax, xRange(2)-3.5, yRange(2)-1.2, 'FREQ', 'Color', 'w', 'FontSize', 8);
    
    %% Game Loop
    fprintf('🐍 Enhanced Signal Snake Game Started!\n');
    fprintf('New Controls:\n');
    fprintf('  ↑↓ = Amplitude | ←→ = Frequency | Q/E = Phase\n');
    fprintf('  WASD = Fine adjustments | SHIFT = Fast mode | CTRL = Precision mode\n');
    fprintf('  SPACE = Pause | R = Reset | ESC = Quit\n\n');
    
    tic; % Start timer
    lastTime = toc;
    
    while ishandle(fig) && gameRunning
        currentTime = toc;
        deltaTime = currentTime - lastTime;
        lastTime = currentTime;
        
        if ~gamePaused && deltaTime > 0.016  % 60 FPS target
            %% Handle continuous key presses with improved sensitivity
            handleContinuousInput(deltaTime);
            
            %% Smooth parameter interpolation
            userAmplitude = userAmplitude * smoothing + targetAmplitude * (1 - smoothing);
            userFrequency = userFrequency * smoothing + targetFrequency * (1 - smoothing);
            
            %% Move snake forward
            % Shift all positions forward
            for i = 1:snakeLength-1
                snakeX(i) = snakeX(i+1);
                snakeY(i) = snakeY(i+1);
            end
            
            % Calculate new head position using user-controlled parameters
            newX = snakeX(end) + speed;
            
            % Keep snake within bounds (wrap around)
            if newX > xRange(2)
                newX = xRange(1) + (newX - xRange(2));
                % Shift entire snake
                snakeX = snakeX - (xRange(2) - xRange(1));
            end
            
            % Calculate new Y position using sine wave
            newY = userAmplitude * sin(userFrequency * newX + userPhase);
            
            % Clamp Y within bounds
            newY = max(yRange(1), min(yRange(2), newY));
            
            % Update head position
            snakeX(end) = newX;
            snakeY(end) = newY;
            
            %% Update visual elements
            set(snakePlot, 'XData', snakeX, 'YData', snakeY);
            set(headPlot, 'XData', snakeX(end), 'YData', snakeY(end));
            
            %% Update target prediction line
            updateTargetLine();
            
            %% Animate food (pulsing effect)
            foodPulse = foodPulse + 0.3;
            foodSize = 20 + 5 * sin(foodPulse);
            set(foodPlot, 'MarkerSize', foodSize);
            
            %% Check food collision
            head_x = snakeX(end);
            head_y = snakeY(end);
            
            dist = sqrt((head_x - food_x)^2 + (head_y - food_y)^2);
            
            if dist < foodRadius
                % Food eaten!
                score = score + 1;
                [food_x, food_y] = generateFood();
                
                % Update score display
                set(scoreText, 'String', sprintf('Score: %d  🏆', score));
                
                % Enhanced visual feedback
                set(headPlot, 'MarkerSize', 25, 'MarkerFaceColor', [0 1 0]); % Lime green
                pause(0.05);
                set(headPlot, 'MarkerSize', 18, 'MarkerFaceColor', 'yellow');
                
                fprintf('🍎 Food eaten! Score: %d\n', score);
                
                % Progressive difficulty increase
                speed = speed * 1.005;  % Gentler speed increase
                
                % Color change for achievement
                snakeColor = [0, 1, min(1, score/20)]; % Green to cyan
                set(snakePlot, 'Color', snakeColor);
            end
            
            %% Update food and parameter display
            set(foodPlot, 'XData', food_x, 'YData', food_y);
            
            % Update parameter text with emoji indicators
            modifierText = '';
            if keys.shift, modifierText = '⚡ FAST '; end
            if keys.ctrl, modifierText = '🎯 PRECISE '; end
            
            set(paramText, 'String', sprintf('%sAmp: %.2f | Freq: %.2f | Speed: %.3f', ...
                                            modifierText, userAmplitude, userFrequency, speed));
            
            %% Update parameter bars
            ampNorm = (userAmplitude - 0.2) / (2.5 - 0.2); % Normalize to 0-1
            freqNorm = (userFrequency - 0.3) / (5.0 - 0.3);
            
            set(ampBar, 'Position', [xRange(2)-3.5, yRange(2)-0.8, ampNorm * 2, 0.1]);
            set(freqBar, 'Position', [xRange(2)-3.5, yRange(2)-1.0, freqNorm * 2, 0.1]);
            
            % Color coding for parameter bars
            ampColor = [1-ampNorm, ampNorm, 0]; % Red to green
            freqColor = [0, freqNorm, 1-freqNorm]; % Blue to cyan
            set(ampBar, 'FaceColor', ampColor);
            set(freqBar, 'FaceColor', freqColor);
        end
        
        pause(0.001);
        drawnow limitrate;
    end
    
    %% Game over
    if ishandle(fig)
        gameOverText = text(ax, mean(xRange), 0, sprintf('🎮 GAME OVER! 🎮\nFinal Score: %d\nPress R to restart', score), ...
             'Color', 'red', 'FontSize', 24, 'FontWeight', 'bold', ...
             'HorizontalAlignment', 'center', 'BackgroundColor', 'black', ...
             'EdgeColor', 'white', 'Margin', 10);
        fprintf('🎮 Game Over! Final Score: %d\n', score);
    end
    
    %% Nested Functions
    
    function [fx, fy] = generateFood()
        % Generate food at a strategic position
        fx = xRange(1) + 0.5 + rand() * (xRange(2) - xRange(1) - 1);
        fy = yRange(1) + 0.5 + rand() * (yRange(2) - yRange(1) - 1);
        
        % Ensure food is reachable and not too close to snake head
        if exist('snakeX', 'var') && length(snakeX) > 0
            attempts = 0;
            while (sqrt((fx - snakeX(end))^2 + (fy - snakeY(end))^2) < 1.5 || ...
                   abs(fy) > 2) && attempts < 20
                fx = xRange(1) + 0.5 + rand() * (xRange(2) - xRange(1) - 1);
                fy = yRange(1) + 0.5 + rand() * (yRange(2) - yRange(1) - 1);
                attempts = attempts + 1;
            end
        end
    end
    
    function updateTargetLine()
        % Show prediction of snake path
        if length(snakeX) > 0
            futureX = linspace(snakeX(end), snakeX(end) + 2, 20);
            futureY = userAmplitude * sin(userFrequency * futureX + userPhase);
            futureY = max(yRange(1), min(yRange(2), futureY));
            set(targetPlot, 'XData', futureX, 'YData', futureY);
        end
    end
    
    function handleContinuousInput(dt)
        % Enhanced input handling with modifiers and sensitivity
        
        % Base speeds
        baseAmpSpeed = ampSensitivity * dt;
        baseFreqSpeed = freqSensitivity * dt;
        basePhaseSpeed = phaseSensitivity * dt;
        
        % Apply modifiers
        modifier = 1.0;
        if keys.shift
            modifier = 3.0;  % Fast mode
        elseif keys.ctrl
            modifier = 0.3;  % Precision mode
        end
        
        ampSpeed = baseAmpSpeed * modifier;
        freqSpeed = baseFreqSpeed * modifier;
        phaseSpeed = basePhaseSpeed * modifier;
        
        % Primary controls (Arrow Keys)
        if keys.up
            targetAmplitude = min(targetAmplitude + ampSpeed, 2.5);
        end
        if keys.down
            targetAmplitude = max(targetAmplitude - ampSpeed, 0.2);
        end
        if keys.right
            targetFrequency = min(targetFrequency + freqSpeed, 5.0);
        end
        if keys.left
            targetFrequency = max(targetFrequency - freqSpeed, 0.3);
        end
        
        % Phase control (Q/E keys)
        if keys.q
            userPhase = userPhase - phaseSpeed;
        end
        if keys.e
            userPhase = userPhase + phaseSpeed;
        end
        
        % Fine control (WASD)
        if keys.w
            targetAmplitude = min(targetAmplitude + ampSpeed * 0.5, 2.5);
        end
        if keys.s
            targetAmplitude = max(targetAmplitude - ampSpeed * 0.5, 0.2);
        end
        if keys.d
            targetFrequency = min(targetFrequency + freqSpeed * 0.5, 5.0);
        end
        if keys.a
            targetFrequency = max(targetFrequency - freqSpeed * 0.5, 0.3);
        end
    end
    
    function keyPressCallback(~, event)
        % Enhanced key press handling
        switch lower(event.Key)
            case 'space'
                gamePaused = ~gamePaused;
                if gamePaused
                    title(ax, 'Signal Snake Game - ⏸️ PAUSED (SPACE to resume)', 'Color', 'yellow');
                    fprintf('⏸️  Game Paused\n');
                else
                    title(ax, 'Signal Snake Game - Master the sine wave controls!', 'Color', 'w');
                    fprintf('▶️  Game Resumed\n');
                end
                
            case 'escape'
                gameRunning = false;
                fprintf('👋 Game quit by user\n');
                
            % Primary controls
            case 'uparrow', keys.up = true;
            case 'downarrow', keys.down = true;
            case 'leftarrow', keys.left = true;
            case 'rightarrow', keys.right = true;
                
            % Fine controls
            case 'w', keys.w = true;
            case 's', keys.s = true;
            case 'a', keys.a = true;
            case 'd', keys.d = true;
                
            % Phase controls
            case 'q', keys.q = true;
            case 'e', keys.e = true;
                
            % Modifiers
            case 'shift', keys.shift = true;
            case 'control', keys.ctrl = true;
                
            case 'r'
                % Enhanced reset
                resetGame();
                
            case 'h'
                % Help toggle
                showHelp();
        end
    end
    
    function keyReleaseCallback(~, event)
        % Handle key release events
        switch lower(event.Key)
            case 'uparrow', keys.up = false;
            case 'downarrow', keys.down = false;
            case 'leftarrow', keys.left = false;
            case 'rightarrow', keys.right = false;
            case 'w', keys.w = false;
            case 's', keys.s = false;
            case 'a', keys.a = false;
            case 'd', keys.d = false;
            case 'q', keys.q = false;
            case 'e', keys.e = false;
            case 'shift', keys.shift = false;
            case 'control', keys.ctrl = false;
        end
    end
    
    function resetGame()
        % Enhanced game reset
        score = 0;
        speed = 0.1;
        targetAmplitude = 1;
        targetFrequency = 1;
        userAmplitude = 1;
        userFrequency = 1;
        userPhase = 0;
        snakeX = linspace(0, 2, snakeLength);
        snakeY = zeros(1, snakeLength);
        [food_x, food_y] = generateFood();
        set(scoreText, 'String', sprintf('Score: %d', score));
        set(snakePlot, 'Color', 'g');
        fprintf('🔄 Game Reset - Good luck!\n');
    end
    
    function showHelp()
        % Display help information
        fprintf('\n🎮 ENHANCED CONTROLS GUIDE:\n');
        fprintf('═══════════════════════════════\n');
        fprintf('PRIMARY CONTROLS:\n');
        fprintf('  ↑↓ Arrow Keys    = Adjust Amplitude (wave height)\n');
        fprintf('  ←→ Arrow Keys    = Adjust Frequency (wave density)\n');
        fprintf('  Q/E Keys         = Adjust Phase (wave offset)\n\n');
        fprintf('FINE CONTROLS:\n');
        fprintf('  W/S Keys         = Fine amplitude adjustment\n');
        fprintf('  A/D Keys         = Fine frequency adjustment\n\n');
        fprintf('MODIFIERS:\n');
        fprintf('  SHIFT + controls = Fast mode (3x speed)\n');
        fprintf('  CTRL + controls  = Precision mode (0.3x speed)\n\n');
        fprintf('GAME CONTROLS:\n');
        fprintf('  SPACE            = Pause/Resume\n');
        fprintf('  R                = Reset game\n');
        fprintf('  H                = Show this help\n');
        fprintf('  ESC              = Quit\n');
        fprintf('═══════════════════════════════\n\n');
    end
    
    function closeCallback(~, ~)
        % Handle figure close event
        gameRunning = false;
        fprintf('🚪 Game window closed - Thanks for playing!\n');
        delete(fig);
    end

end

% Example usage:
% signalSnakeGame()