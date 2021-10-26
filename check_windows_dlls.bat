python --version
pip install --find-links=pandas/pandas/dist --no-index pandas
python -c "import pandas as pd; print(pd.__version__)"
