🐍 Signal Snake Game — Enhanced MATLAB Sine-Wave Snake

A keyboard-controlled, sine-wave “snake” game with smooth parameter interpolation, predictive path hints, animated food, and a clean HUD.

🔎 Overview

Signal Snake Game is a MATLAB mini-game where you steer a sine wave in real time to collect food. Tune Amplitude, Frequency, and Phase with fast/precise modifiers, watch a prediction line of your next path, and rack up a high score as difficulty gently scales.

✨ Features

Tight controls: Arrow keys for primary control, WASD for fine control, Q/E for phase

Smooth feel: Interpolated targets for amplitude & frequency (smoothing factor)

Predictive line: See where the next segment of your sine wave will go

Animated food: Pulsing target with collision radius

HUD: Score, live parameter text, and colored parameter bars

Difficulty curve: Subtle speed ramp with each pickup

Pause/Reset/Help: SPACE, R, H for better gameplay flow

Safe bounds & wrapping: Clean world wrapping on X, clamped Y

🧰 Requirements

MATLAB R2018a or newer (base MATLAB; no extra toolboxes required)

OS: Windows/macOS/Linux supported by MATLAB graphics

Keyboard input focus on the game window

🚀 Quick Start

Save the file as signalSnakeGame.m.

From MATLAB:

signalSnakeGame


Collect the red pulsing food by steering your sine wave into it.
Score increases and speed gently ramps with each pickup.

🎮 Controls

Primary

↑ / ↓ — Increase / decrease Amplitude

← / → — Increase / decrease Frequency

Q / E — Shift Phase left / right

Fine Adjustments

W / S — Fine amplitude up / down

A / D — Fine frequency up / down

Modifiers

SHIFT — Fast adjustments (≈3×)

CTRL — Precision adjustments (≈0.3×)

Game

SPACE — Pause / resume

R — Reset game (score, speed, parameters)

H — Print help in the Command Window

ESC — Quit

⚙️ Tunable Parameters (top of the file)
Name	Default	Purpose
snakeLength	50	Number of points in the snake body
A, f	1	Base amplitude/frequency (for init)
speed	0.1	Forward movement speed (scales with score)
foodRadius	0.3	Collision radius for eating food
xRange	[0, 4*pi]	Horizontal world bounds (wraps)
yRange	[-2.5, 2.5]	Vertical bounds (clamped)
ampSensitivity	1.5	Amplitude change rate (per second)
freqSensitivity	2.0	Frequency change rate (per second)
phaseSensitivity	4.0	Phase change rate (per second)
smoothing	0.85	Interpolation factor for smooth control

Tips

Want snappier control? Lower smoothing (e.g., 0.75–0.8).

Bigger arena? Expand xRange and adjust snakeLength accordingly.

More challenge? Increase speed or decrease foodRadius.

🧠 How It Works

Continuous loop updates at ~60 FPS target using tic/toc and drawnow limitrate.

Keys set target values; actual userAmplitude/userFrequency smoothly track using smoothing.

The snake advances in X by speed; Y is computed as A·sin(f·x + phase) and clamped.

Prediction line plots a short look-ahead to help you steer.

Collision with food uses Euclidean distance < foodRadius.

Each food increases score, nudges speed (×1.005), and subtly shifts snake color.

🧪 Known Behaviors & Tips

Keyboard focus: Make sure the MATLAB figure window is active; otherwise key events won’t register.

High-DPI displays: If markers/bars appear small, adjust 'MarkerSize' and text 'FontSize'.

Performance: If you see stutter, reduce snakeLength, or slightly increase the pause in the loop.

🧯 Troubleshooting

No response to keys: Click the game window to focus it; confirm KeyPressFcn/KeyReleaseFcn are set (they are in the code).

Snake flicker: Ensure you’re not running heavy background plots; try closing other figures.

Too hard / too easy: Tweak speed, foodRadius, and/or sensitivities.
