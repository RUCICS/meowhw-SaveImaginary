import matplotlib.pyplot as plt
import pandas as pd

data = pd.read_csv("buffer_rates.csv")
data = data[data["Rate_MBps"] > 0]

multipliers = data["Multiplier"]
buffer_sizes = data["BufferSize"]
rates = data["Rate_MBps"]

plt.figure(figsize=(10, 6))
plt.plot(multipliers, rates, marker='o', linestyle='-', color='#1f77b4')
plt.xlabel("Multiplier (A)")
plt.ylabel("Read/Write Rate (MB/s)")
plt.title("Read/Write Rate vs Buffer Size Multiplier")
plt.grid(True, linestyle='--', alpha=0.7)
plt.xticks(multipliers)
plt.tight_layout()
plt.savefig("buffer_rates.png")
plt.show()