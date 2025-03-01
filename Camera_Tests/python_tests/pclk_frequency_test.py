# from machine import Pin
# import time

# pclk = Pin(13, Pin.IN)
# prevClock = 0
# rising_edge_pclk = 0
# count = 0

# nums = []

# start_time = time.ticks_ms()

# while time.ticks_ms() - start_time < 1000:
#     rising_edge_pclk = pclk.value() == 1 and prevClock == 0        
#     prevClock = pclk.value()
#     if rising_edge_pclk:
#         count += 1
#     # nums.append(count)

# print(count)

from machine import Pin, I2C, PWM
import time

# Initialize PWM (XCLK)
xclk = PWM(Pin(10))
xclk.freq(24000000)  # Set to 24 MHz for high-resolution mode
xclk.duty_u16(32768)  # 50% duty cycle (half the time high)

# Set up the input pin
input_pin = Pin(13, Pin.IN)  # Change to the pin you're using for input

# Variable to count the number of rising edges
edge_count = 0

# Interrupt service routine (ISR) to count rising edges
def count_rising_edge(pin):
    print("here")
    global edge_count
    edge_count += 1

# Attach interrupt to input pin for rising edges
input_pin.irq(trigger=Pin.IRQ_RISING, handler=count_rising_edge)

# Measure frequency over 1 second
start_time = time.ticks_ms()  # Get the current time in milliseconds
duration = 1000  # 1 second duration for frequency measurement

# Reset edge count before starting measurement
edge_count = 0

# Wait for the measurement duration
while time.ticks_ms() - start_time < duration:
    pass

# Calculate frequency (edges per second)
frequency = edge_count  # Since we measured for 1 second, edge_count is the frequency
print("Frequency:", frequency, "Hz")

