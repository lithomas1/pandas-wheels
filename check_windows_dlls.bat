python --version
pip install --find-links=pandas/dist pandas
python -c "import pandas as pd; print(pd.__version__)"
