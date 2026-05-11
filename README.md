# 🐍 SignalSnake

> A MATLAB mini-game where you steer a **sine wave** through a 2D world to collect food — combining signal processing concepts with real-time gameplay.

![MATLAB](https://img.shields.io/badge/MATLAB-R2018a%2B-orange?logo=mathworks&logoColor=white)
![License](https://img.shields.io/github/license/n00rtahsin/SignalSnake)
![Language](https://img.shields.io/github/languages/top/n00rtahsin/SignalSnake)

---

## 📖 Overview

SignalSnake replaces the traditional snake with a **live sine wave** — your snake's shape is defined by amplitude, frequency, and phase, all of which you control in real time. Steer your wave into pulsing food targets, watch the difficulty scale up with each pickup, and enjoy a smooth 60 FPS experience complete with a predictive path line and live HUD.

It's part game, part signal-processing playground.

---

## ✨ Features

- **Sine-wave snake** — The snake body traces `A · sin(f·x + φ)`, updated live as you play
- **Smooth parameter control** — Amplitude and frequency interpolate toward target values, eliminating jerky jumps
- **Predictive path line** — A look-ahead trace shows where your wave will go next
- **Animated food** — Pulsing target with configurable collision radius
- **Live HUD** — Score, parameter readouts, and colored bars for amplitude/frequency/phase
- **Progressive difficulty** — Speed gently ramps with each pickup (`× 1.005` per food)
- **World wrapping & clamping** — Snake wraps on X axis, Y axis is bounded
- **Pause / Reset / Help** — Full game flow controls

---

## 🧰 Requirements

| Requirement | Details |
|---|---|
| MATLAB | R2018a or newer |
| Toolboxes | None — base MATLAB only |
| OS | Windows, macOS, or Linux (any MATLAB-supported platform) |
| Input | Keyboard (game window must have focus) |

---

## 🚀 Quick Start

1. Clone the repository:

   ```bash
   git clone https://github.com/n00rtahsin/SignalSnake.git
   cd SignalSnake
   ```

2. Open MATLAB and navigate to the project folder.

3. Run the game:

   ```matlab
   signalSnakeGame
   ```

4. Steer your sine wave into the red pulsing food. Score rises and speed increases with each pickup.

---

## 🎮 Controls

### Parameter Controls

| Key | Action |
|---|---|
| `↑` / `↓` | Increase / decrease **Amplitude** |
| `←` / `→` | Increase / decrease **Frequency** |
| `Q` / `E` | Shift **Phase** left / right |
| `W` / `S` | Fine **Amplitude** up / down |
| `A` / `D` | Fine **Frequency** up / down |

### Modifiers

| Modifier | Effect |
|---|---|
| `SHIFT` | Fast adjustments (~3×) |
| `CTRL` | Precision adjustments (~0.3×) |

### Game Controls

| Key | Action |
|---|---|
| `SPACE` | Pause / Resume |
| `R` | Reset game (score, speed, parameters) |
| `H` | Print help to Command Window |
| `ESC` | Quit |

---

## ⚙️ Configuration

All tunable parameters are defined at the top of `signalSnakeGame.m`:

| Parameter | Default | Description |
|---|---|---|
| `snakeLength` | `50` | Number of points in the snake body |
| `A`, `f` | `1` | Initial amplitude and frequency |
| `speed` | `0.1` | Base forward movement speed |
| `foodRadius` | `0.3` | Collision radius for eating food |
| `xRange` | `[0, 4π]` | Horizontal world bounds (wraps) |
| `yRange` | `[-2.5, 2.5]` | Vertical bounds (clamped) |
| `ampSensitivity` | `1.5` | Amplitude change rate (per second) |
| `freqSensitivity` | `2.0` | Frequency change rate (per second) |
| `phaseSensitivity` | `4.0` | Phase change rate (per second) |
| `smoothing` | `0.85` | Interpolation factor for smooth control |

**Tuning tips:**
- Want snappier control? Lower `smoothing` (e.g., `0.75`–`0.80`)
- Bigger arena? Expand `xRange` and increase `snakeLength` accordingly
- More challenge? Raise `speed` or shrink `foodRadius`

---

## 🧠 How It Works

```
Each frame (~60 FPS via tic/toc + drawnow limitrate):

  Key input → target A / f / phase
       ↓
  Smoothing: actual = actual + (1 - smoothing) × (target - actual)
       ↓
  Snake advances by `speed` in X
  Y = A · sin(f · x + phase)   [clamped to yRange, wraps on xRange]
       ↓
  Prediction line plotted as a look-ahead segment
       ↓
  Collision: Euclidean distance to food < foodRadius → score++, speed × 1.005
       ↓
  HUD updated: score, parameter bars, snake color shift
```

---

## 📁 File Structure

```
SignalSnake/
├── signalSnakeGame.m   # Main game (recommended entry point)
├── signalSnakeX.m      # Alternate / experimental variant
├── snakess.m           # Earlier prototype
├── LICENSE
└── README.md
```

---

## 🧪 Troubleshooting

| Issue | Solution |
|---|---|
| Keys not responding | Click the game figure window to give it keyboard focus |
| Snake flickers | Close other MATLAB figures; reduce `snakeLength` |
| Poor performance | Increase the loop `pause` duration slightly, or reduce `snakeLength` |
| Too easy / too hard | Tune `speed`, `foodRadius`, and the sensitivity parameters |
| Small HUD on high-DPI | Increase `'MarkerSize'` and `'FontSize'` values in the code |

---

## 📄 License

This project is licensed under the [MIT License](LICENSE).

---

## 🙌 Contributing

Contributions, issues, and feature requests are welcome! Feel free to open a [GitHub Issue](https://github.com/n00rtahsin/SignalSnake/issues) or submit a pull request.

---

*Built with MATLAB · Inspired by signal processing · Powered by sine waves*
