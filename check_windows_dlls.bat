python --version
# Install dependencies first
pip install pytz six numpy python-dateutil
# Force install from our wheel
pip install --find-links=pandas/pandas/dist --no-index pandas
python -c "import pandas as pd; print(pd.__version__)"
