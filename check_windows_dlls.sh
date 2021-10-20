#!/bin/bash
python --version
pip install --find-links=pandas panda
python -c "import pandas as pd; print(pd.__version__)"
