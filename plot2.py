import matplotlib.pyplot as plt
import pandas as pd

data = {
    "Program": ["cat", "mycat1", "mycat2", "mycat3", "mycat4", "mycat5", "mycat6"],
    "Time_s": [0.4269, 0.0, 2.483, 2.411, 2.439, 0.5123, 0.6123]
}

df = pd.DataFrame(data)

plt.figure(figsize=(10, 6))
bars = plt.bar(df["Program"], df["Time_s"], color=['#1f77b4', '#ff7f0e', '#2ca02c', '#d62728', '#9467bd', '#8c564b', '#e377c2'])
plt.xlabel("Program")
plt.ylabel("Run Time (seconds)")
plt.title("Performance Comparison of cat and mycat1–mycat6")
plt.grid(True, axis='y', linestyle='--', alpha=0.7)
plt.yscale('log') 
plt.ylim(0.1, 10000)  
for bar in bars:
    height = bar.get_height()
    plt.text(bar.get_x() + bar.get_width()/2, height, f'{height:.2f}', ha='center', va='bottom')
plt.tight_layout()
plt.savefig("performance_comparison.png")
plt.show()