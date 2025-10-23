# Pathfind: Flight Route Finder

## Overview
Pathfind is a hybrid MeTTa/Python project for finding optimal flight routes between cities based on duration, cost, distance, or a combined score. It uses symbolic reasoning (MeTTa) and a simple web interface (Python/FastAPI) to let users query and visualize flight paths from a dataset.

## Features
- **Flexible pathfinding:** Find all possible routes or the shortest route between cities.
- **Multiple criteria:** Optimize by duration, cost, distance, or a normalized overall score.
- **Data normalization:** Optionally preprocess flight data for fair comparison.
- **Web interface:** Query routes and view results in your browser.
- **Extensible:** Easily add new cities or flights to `data.metta`.

## Project Structure
```
Pathfind/
  main.py           # Python web server (Flask)
  utils.py          # Python utilities
  requirements.txt  # Python dependencies
  data.metta        # Flight data (MeTTa format)
  main.metta        # MeTTa logic for pathfinding
  static/
    index.html      # Web UI
  context           # (Optional) MeTTa context file
  .env              # (Optional) Environment variables
```

## Getting Started

### 1. Install Python dependencies
```bash
pip install -r requirements.txt
```

### 2. Run the web server
```bash
python main.py
```

### 3. Open the UI
Visit [http://localhost:8000](http://localhost:8000) in your browser.

## How It Works
- **MeTTa engine:** The core pathfinding logic is in `main.metta`. It loads flight data from `data.metta` and computes all possible paths, then selects the optimal one based on your chosen metric.
- **Python/FastAPI:** Handles user requests, invokes MeTTa logic, and serves the results via a simple web page.

## Data Format
Flight data is stored in `data.metta` as facts:
```
(flight-route CityA CityB (Duration D Cost C Distance S))
```
Example:
```
(flight-route Jimma Addis (Duration 2 Cost 1500 Distance 200))
```

## Customization
- **Add flights:** Edit `data.metta` to add new routes.
- **Change logic:** Modify `main.metta` for new pathfinding strategies.
- **UI tweaks:** Edit `static/index.html` for a custom look.


## Credits
- MeTTa language: https://github.com/trueagi-io/metta
- Flask web framework: https://flask.palletsprojects.com/
