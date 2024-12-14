#include <Arduino.h>
#include <Wire.h>

#define NUNCHUCK_ADDR 0x52 // I2C address of the Nunchuck

void readNunchuck(uint8_t* nunchuckData);
void initializeNunchuck();

void setup() {
    Serial.begin(9600);    // Initialize serial communication
    Wire.begin();          // Initialize I2C
    initializeNunchuck();  // Send initialization sequence to the Nunchuck
    delay(100);
}

void loop() {

    // initializeNunchuck();

    // delay(1000); 
    
    // return; 


    uint8_t nunchuckData[6];
    readNunchuck(nunchuckData);

    // Extract joystick data
    int joystickX = nunchuckData[0];
    int joystickY = nunchuckData[1];

    // Extract accelerometer data (optional)
    int accelX = (nunchuckData[2] << 2) | ((nunchuckData[5] >> 2) & 0x03);
    int accelY = (nunchuckData[3] << 2) | ((nunchuckData[5] >> 4) & 0x03);
    int accelZ = (nunchuckData[4] << 2) | ((nunchuckData[5] >> 6) & 0x03);

    // Extract button states
    bool buttonC = !(nunchuckData[5] & 0x02); // C button is bit 1
    bool buttonZ = !(nunchuckData[5] & 0x01); // Z button is bit 0

    // Print data to serial monitor
    Serial.print("Joystick X: ");
    Serial.print(joystickX);
    Serial.print(" | Y: ");
    Serial.println(joystickY);

    Serial.print("Accelerometer X: ");
    Serial.print(accelX);
    Serial.print(" | Y: ");
    Serial.print(accelY);
    Serial.print(" | Z: ");
    Serial.println(accelZ);

    Serial.print("Button C: ");
    Serial.print(buttonC ? "Pressed" : "Not pressed");
    Serial.print(" | Button Z: ");
    Serial.println(buttonZ ? "Pressed" : "Not pressed");

    delay(100);  // Delay between readings
}

// Alternative initialization method (for some Nunchucks)
void initializeNunchuckalt() {
    Wire.beginTransmission(NUNCHUCK_ADDR);
    Wire.write(0x40);
    Wire.write(0x00);
    int ack = Wire.endTransmission();

    Serial.println(ack ? "Nack" : "Ack"); 
}

// Initialize the Nunchuck
void initializeNunchuck() {
    Wire.beginTransmission(NUNCHUCK_ADDR);
    Wire.write(0xF0);
    Wire.write(0x55);
    Wire.endTransmission();

    delay(1);

    Wire.beginTransmission(NUNCHUCK_ADDR);
    Wire.write(0xFB);
    Wire.write(0x00);
    Wire.endTransmission();
}

// Read data from the Nunchuck
void readNunchuck(uint8_t* nunchuckData) {
    Wire.beginTransmission(NUNCHUCK_ADDR);
    Wire.write(0x00);  // Signal the Nunchuck to start a new measurement
    Wire.endTransmission();
    
    Wire.requestFrom(NUNCHUCK_ADDR, 6);
    for (int i = 0; i < 6; i++) {
        if (Wire.available()) {
            nunchuckData[i] = Wire.read();
        }
    }
    
}
