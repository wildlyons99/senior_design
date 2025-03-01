import time
from numba import jit

start = time.time()
count = 0

while time.time() - start <= 1000:
    count += 1

print(count)
