from machine import Pin, PWM, I2C
import time

''' I2C Setup '''
# # Initialize I2C on GP4 (SDA) and GP5 (SCL)
# i2c = I2C(0, scl=Pin(1), sda=Pin(0))

# # Scan for devices on I2C bus
# devices = i2c.scan()
# print("I2C devices found:", devices)

'''External Clock (XCLK) '''
xclk = PWM(Pin(10))
xclk.freq(24000000)  # Set to 24 MHz for high-resolution mode
xclk.duty_u16(32768)  # 50% duty cycle (half the time high)

''' Set Data Pins (D0 - D7) '''
data_pins = [Pin(i, Pin.IN) for i in range(2, 10)]  # D0-D7

''' Input Signals (VSYNC, HSYNC, PCLK) '''
vsync = Pin(12, Pin.IN)
hsync = Pin(11, Pin.IN)
pclk = Pin(13, Pin.IN)

# Define frame resolution
width = 640
height = 480

def capture_frame():
    newFrame = 0
    prevClock = 0
    rising_edge_pclk = 0
    pixel_data = 0
    frame_data = []
    count = 0

    while True:

        rising_edge_pclk = pclk.value() == 1 and prevClock == 0        
        prevClock = pclk.value()

        # Wait for declaration of new frame
        if vsync.value() == 1:
            newFrame = 1

        # Ensure that there is a new frame, hsync is high, and pclk is on a rising edge
        if newFrame == 1:
            if hsync.value() == 1:
                if rising_edge_pclk and not count % 2:
                    for i in range(8):  # Read all 8 bits (D0-D7)
                        pixel_data |= (data_pins[i].value() << i)
                    # pixel_data = data_pins[0].value()
                    frame_data.append(pixel_data)
                    pixel_data = 0
                count += 1
                print(count)
            else:
                count = 0

        if len(frame_data) >= 307200:
        # if len(frame_data) >= 10:
                break
        
    return frame_data

            
        

# Function to save frame data to a file
def save_frame_to_file(frame_data, filename):
    with open(filename, 'wb') as f:
        f.write(bytes(frame_data))  # Write raw frame data to the file
    print(f"Frame data saved to {filename}")

# Main loop to capture and save frames
while True:
    print("Capturing frame...")
    frame_data = capture_frame()
    print(f"Captured {len(frame_data)} pixels")
    print(frame_data[:10])

    # Generate a new filename for each photo (e.g., photo1.bin, photo2.bin, ...)
    timestamp = time.ticks_ms()  # Get the current time in milliseconds
    filename = f"/photo_{timestamp}.bin"  # Use timestamp for unique filenames

    # Save the frame data to a file
    # save_frame_to_file(frame_data, filename)
    
    # break
