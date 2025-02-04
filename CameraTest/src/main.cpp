/****************************************************
 * 
 *Simple test program for OV7670 library
 *
 *  Saves a VGA image as a .bmp file on SD card
 *  
 *  requires T4.1 with PSRAM as VGA image is 614,400 bytes
 *  which is too large for onboard RAM
 ******************************************************** */
#include <Arduino.h>
#include <OV7670.h>
#include <SD.h>

// function init
void CMSI(void);
void CMCS(void);

// Show Camera Registers
void CMCR(void);
void CMGF(void);

const int ledpin = 13;

//  Put all the buffers in EXTMEM  (PSRAM)
uint8_t fcaptbuff[640l * 480l * 2] EXTMEM;
uint8_t cbuff1[640l * 480l * 2] EXTMEM;
uint8_t cbuff2[640l * 480l * 2] EXTMEM;


const char compileTime [] = " Compiled on " __DATE__ " " __TIME__;

#define SD_CONFIG SdioConfig(DMA_SDIO)

#define  LEDON digitalWriteFast(ledpin, HIGH); // Also marks IRQ handler timing
#define  LEDOFF digitalWriteFast(ledpin, LOW);

tBMPHDR565 fileheader;
File bmpfile;
const int pinCamReset = 14;

void setup() {
  Serial.begin(9600);
  while (!Serial) ; 

  delay(200);
  Wire.begin();

  pinMode(pinCamReset, OUTPUT);
  pinMode(ledpin, OUTPUT);

  digitalWriteFast(pinCamReset, LOW);
  delay(10);
  digitalWriteFast(pinCamReset, HIGH);  // subsequent resets via SCB

  Serial.print("Initializing SD card...");

  if (!SD.begin(BUILTIN_SDCARD)) {
    Serial.println("initialization failed!");
    while (1){
        LEDON; delay(100);
        LEDOFF; delay(100);
      }
  }
  Serial.println("initialization done.");

  if (OV7670.begin(VGA, cbuff1, cbuff2)) {
    Serial.println("OV7670 camera initialized.");
    Serial.printf("cbuff1 at   %p\n", cbuff1);
    Serial.printf("cbuff2 at    %p\n", cbuff2);
    Serial.printf("fcaptbuff at %p\n", fcaptbuff);
  }
  OV7670.ShowCamConfig();

  LEDOFF
}

void loop() {
  // put your main code here, to run repeatedly:

  char ch;
  if (Serial.available()) {
    ch = Serial.read();
    if (ch == 's') CMSI(); // Show CSI registers
    if (ch == 'c') CMCS(); // Show Camera Registers
    if (ch == 'r') CMCR();
    if (ch == 'f') CMGF();
  }

}

void CMSI(void) {
  Serial.printf("\n\nOV7670 Camera  VGA Test 3 %s\n", compileTime);
  OV7670.ShowCamConfig();
}


void CMCS(void) {  // Show CSI registers
  OV7670.ShowCSIRegisters();
}


// Show Camera Registers
void CMCR(void) {
  uint8_t regs[200];
  OV7670.ReadAll(regs);
  OV7670.ShowAll(regs);
}

void CMGF(void) {
  uint32_t imagesize, hdrsize, fbc;

  imagesize = OV7670.ImageSize();

  hdrsize = sizeof(tBMPHDR565);
  Serial.printf("BMP Hdr is %lu bytes at %p \n", hdrsize, OV7670.GetHeaderPtr());
  Serial.printf("Ready to save %lu bytes.\n", imagesize);
  Serial.println("Saving OV7670.bmp ");

  if (SD.exists("OV7670.bmp")) {
    // delete the file:
    Serial.println("Removing old  OV7670.bmp...");
    SD.remove("OV7670.bmp");
  }
  Serial.println("Opening File\n");
  bmpfile = SD.open("OV7670.bmp", FILE_WRITE);
  Serial.printf("bmpfile: %p\n", bmpfile);
  if (bmpfile) {
    Serial.println("Writing...");
  } else {
    Serial.println("Could not open file.");
    return;
  }

  delay(10);
  bmpfile.write((const uint8_t *)OV7670.GetHeaderPtr(), 66);
  bmpfile.write(cbuff2, imagesize);

  Serial.printf("bmpfile: %p\n", bmpfile);
  delay(5);
  Serial.println("Write complete");
    Serial.printf("bmpfile: %p\n", bmpfile);
  delay(5);
  bmpfile.close();
  Serial.printf("bmpfile: %p  closed \n", bmpfile);
  Serial.println("File saved to SD card.");
}




// // /****************************************************

// //     QVGA  test program for OV7670 library

// //     Saves a QVGA image as a .bmp file on SD card

// //     requires T4.1  and saves frames in  DMAMEM
// //     which means that you do not need PSRAM
// //  ******************************************************** */

// // #include <Arduino.h>
// // #include <OV7670.h>
// // #include <SD.h>

// // // function definitions
// // void BlinkForever(void); 
// // void CMSI(void);
// // void CMCS(void);
// // // Show Camera Registers
// // void CMCR(void);
// // void CMGF(void);


// // const int ledpin = 13;

// // //  Put all the buffers in DMAMEM
// // uint8_t fcaptbuff[320l * 240l * 2] DMAMEM;
// // uint8_t cbuff1[320l * 240l * 2] DMAMEM;
// // uint8_t cbuff2[320l * 240l * 2] DMAMEM;


// // const char compileTime [] = " Compiled on " __DATE__ " " __TIME__;

// // #define SD_CONFIG SdioConfig(DMA_SDIO)

// // #define  LEDON digitalWriteFast(ledpin, HIGH); // Also marks IRQ handler timing
// // #define  LEDOFF digitalWriteFast(ledpin, LOW);

// // tBMPHDR565 fileheader;
// // File bmpfile;
// // const int pinCamReset = 14;

// // void setup() {
// //   Serial.begin(9600);
// //   delay(200);

// //   // wait for serial monitor connect
// //   while (!Serial); 

// //   Wire.begin();

// //   pinMode(pinCamReset, OUTPUT);
// //   pinMode(ledpin, OUTPUT);

// //   digitalWriteFast(pinCamReset, LOW);
// //   delay(10);
// //   digitalWriteFast(pinCamReset, HIGH);  // subsequent resets via SCB

// //   Serial.print("\n\nInitializing SD card...");

// //   if (!SD.begin(BUILTIN_SDCARD)) {
// //     Serial.println("initialization failed!");
// //     BlinkForever();
// //   }
// //   Serial.println("initialization done.");

// //   if (OV7670.begin(QVGA, cbuff1, cbuff2)) {
// //     Serial.println("OV7670 camera initialized.");
// //     Serial.printf("cbuff1 at   %p\n", cbuff1);
// //     Serial.printf("cbuff2 at    %p\n", cbuff2);
// //     Serial.printf("fcaptbuff at %p\n", fcaptbuff);
// //   } else {
// //     Serial.println("Error initializing OV7670");
// //     BlinkForever();
// //   }
// //   CMSI();

// //   LEDOFF
// // }

// // void BlinkForever(void) {
// //   while (1) {
// //     LEDON; delay(100);
// //     LEDOFF; delay(100);
// //   }
// // }

// // void loop() {

// //   char ch;
// //   if (Serial.available()) {
// //     ch = Serial.read();
// //     if (ch == 's') CMSI(); // show config 
// //     if (ch == 'c') CMCS(); // show CSI registers
// //     if (ch == 'r') CMCR(); // show camera registers
// //     if (ch == 'f') CMGF(); // take a photo? 
// //   }

// // }

// // void CMSI(void) {
// //   Serial.printf("\n\nOV7670 Camera  QVGA Test 3 %s\n", compileTime);
// //   OV7670.ShowCamConfig();
// // }


// // void CMCS(void) {  // Show CSI registers
// //   OV7670.ShowCSIRegisters();
// // }


// // // Show Camera Registers
// // void CMCR(void) {
// //   uint8_t regs[200];
// //   OV7670.ReadAll(regs);
// //   OV7670.ShowAll(regs);
// // }

// // void CMGF(void) {
// //   uint32_t imagesize, hdrsize;

// //   imagesize = OV7670.ImageSize();

// //   hdrsize = sizeof(tBMPHDR565);
// //   Serial.printf("BMP Hdr is %lu bytes at %p \n", hdrsize, OV7670.GetHeaderPtr());
// //   Serial.printf("Ready to save %lu bytes.\n", imagesize);
// //   Serial.println("Saving OV7670.bmp ");

// //   if (SD.exists("OV76701.bmp")) {
// //     // delete the file:
// //     Serial.println("Removing old  OV7670.bmp...");
// //     SD.remove("OV76701.bmp");
// //   }
// //   Serial.println("Opening File\n");
// //   bmpfile = SD.open("OV76701.bmp", FILE_WRITE);

// //   if (bmpfile) {
// //     Serial.print("Writing...");
// //   } else {
// //     Serial.println("Could not open file.");
// //     return;
// //   }

// //   delay(10);
// //   bmpfile.write((const uint8_t *)OV7670.GetHeaderPtr(), 66);

// //   Serial.println("Wrote header to the bmp file");


// //   OV7670.ClearFrameReady();

// //   Serial.println("wait until cbuff2 is ready");


// //   // wait until cbuff2 is ready
// //   while(OV7670.FrameReady() != 2){}

// //   Serial.println("Frame / cbuff2 ready - copying image to SD ");

// //   // copy the image to the capture buffer
// //   memcpy(fcaptbuff, cbuff2, imagesize);
// //   bmpfile.write(cbuff2, imagesize);
// //   delay(5);
// //   Serial.println("Write complete");

// //   delay(5);
// //   bmpfile.close();
// //   Serial.printf("bmpfile closed \n");
// //   Serial.println("File saved to SD card.");
// // }



// /******************************************************
//  * Capture QVGA .bmp files on detection of motion
//  * in camera field.  Optional use of ILI9341 display
//  * and MTP file transfer
//  */
// // #define USEILI9341 false
// // #define USEMTP fal

// // #ifdef USEMTP
// // #include <MTP.h>
// // #include <Storage.h>
// // #include <usb1_mtp.h>
// // #endif
// #include "OV7670.h"
// #include "SD.h"
// #include <Arduino.h>
// #include <stdint.h>
// #include <Wire.h>
// #include <stdio.h>
// #include <cstdlib>

// #ifdef USEILI9341
// #include <ILI9341_t3n.h>
// #include "ili9341_t3n_font_Arial.h"
// //Specify the pins used for Non-SPI functions
// #define TFT_CS   10  // AD_B0_02
// #define TFT_DC   9  // AD_B0_03
// #define TFT_RST  8
// ILI9341_t3n tft = ILI9341_t3n(TFT_CS, TFT_DC, TFT_RST);
// #endif


// File  bmpfile;

// #define SD_CONFIG SdioConfig(FIFO_SDIO)
// const char compileTime [] = " Compiled on " __DATE__ " " __TIME__;

// const int ledpin = 13;
// const int imarkpin = 32;
// const int pinCamReset = 14;

// #define  LEDON digitalWriteFast(ledpin, HIGH);
// #define LEDOFF  digitalWriteFast(ledpin, LOW);

// #ifdef USEMTP
// MTPStorage_SD storage;
// MTPD       mtpd(&storage);
// #endif

// #define FRAME_WIDTH 320
// #define FRAME_HEIGHT 240
// #define FRAMEBYTES (FRAME_WIDTH * FRAME_HEIGHT *2)

// uint8_t fb1[FRAMEBYTES] DMAMEM;
// uint8_t fb2[FRAMEBYTES] DMAMEM;
// uint8_t fcaptbuff[FRAMEBYTES];  // this one goes in regular memory

// void CMSI(void);
// void CMDI(void);
// // Start Motion Detection
// void CMMD(void);
// // Get a frame of data and write to .bmp file
// void CMGF(void);
// time_t getTeensy3Time() ;
// void dateTime(uint16_t* date, uint16_t* time);

// bool StartSDCard();
// char* NewFileName(void);

// void CheckMotionDetect(void);


// elapsedMillis autoMillis;
// void setup() {
//   Serial.begin(9600);
//   while (!Serial); 
//   delay(400);
//   Wire.begin();

//   pinMode(imarkpin, OUTPUT);
//   pinMode(pinCamReset, OUTPUT);
//   Serial.print("Initializing SD card...");

//   if (!StartSDCard()) {
//     Serial.println("initialization failed!");
//     while (1) {
//       pinMode(ledpin, OUTPUT);
//       LEDON; delay(100);
//       LEDOFF; delay(100);
//     }
//   }
//   Serial.println("initialization done.");

//   delay(100);
// #ifdef USEMTP
//   Serial.println("Starting MTP Responder");
//   usb_mtp_configure();
//   // NOTE: Next line requires the new SD implementation in TD 1.54B4
//   if (!Storage_init(&SD.sdfs)) {
//     Serial.println("Could not initialize MTP Storage!");
//   }
// #endif

// #ifdef USEILI9341
//   // Start ILI9341
//   tft.begin();
//   tft.setRotation(3);  // Need rot = 3 for right-side up on MJB proto board
// #endif

//   digitalWriteFast(pinCamReset, LOW);
//   delay(10);
//   digitalWriteFast(pinCamReset, HIGH);  // subsequent resets via SCB
//   Serial.printf("\n\nOV7670 Camera Motion detection %s\n", compileTime);

//   OV7670.begin(QVGA, fb1, fb2);
//   OV7670.SetCamClock(24);
//   setSyncProvider(getTeensy3Time); // helps put time into file directory data
//   autoMillis = 0;
// }


// #define AUTODELAY 120000  // 2-minute autostart delay
// bool mdflag = false;
// void loop() {
//   char ch;
//   if(autoMillis > AUTODELAY){
//     CMMD(); 
//   }
//   if(mdflag) autoMillis = 0;  // reset the autostart timer if already detecting motion
//   if (Serial.available()) {
//     ch = Serial.read();
//     autoMillis = 0;  // reset the autostart timer if user presses a key
//     if(mdflag){
//       Serial.println("Motion detection halted.");
//       mdflag = false;
//     }

//     if (ch == 's') CMSI(); // buffer locations 
// #ifdef USEMTP
//     if (ch == 'b') CMRB();
// #endif
//     if (ch == 'm') CMMD();
//     if (ch == 'f') CMGF();
//     if (ch == 'd') CMDI();
//   }
// #ifdef USEMTP
//   mtpd.loop();
// #endif
//   if(mdflag) CheckMotionDetect();
// }

// #define THRESHHOLD 300
// #define MDELAY 50
// #define FRAMEDELAY 3000  // wait three seconds between captured frames
// void CheckMotionDetect(void){
//   uint16_t mval;
//   mval = OV7670.CheckMotion(MDELAY);

//   if(mval > THRESHHOLD){
//    Serial.printf("CheckMotion returned %u\n",mval);   
//     CMGF();  // save next frame
//     delay(FRAMEDELAY);
//   } 
// }


// #ifdef USEMTP
// // This command will disconnect and reconnect the USB link.  This
// // will cause the PC to restart MTP and request a rebuild of the 
// // MTP directory.
// void CMRB(void){  
//   LEDON
//   Serial.println("Reconnect serial port or restart Serial Monitor after USB reset.");
//   delay(100);
//   usb_init();  // shuts down USB if already started, then restarts
//   delay(200);
//   Serial.begin(9600);
//   delay(200);
//   LEDOFF

//   usb_mtp_configure();
//   // NOTE: Next line requires the new SD implementation in TD 1.54B4
//   if (!Storage_init(&SD.sdfs)) {
//     Serial.println("Could not initialize MTP Storage!");
//   }
//   Serial.println("USB disconnected and reconnected to force MTP update");
// }
// #endif

// void CMSI(void) {
//   Serial.printf("\n\nOV7670 Motion Detection 3 %s\n", compileTime);
//   Serial.printf("buff1 at %p   buff2 at %p\n", &fb1, &fb2);

// }


// void CMDI(void){
//   Serial.println("SD Card Directory");
//   SD.sdfs.ls(LS_DATE | LS_SIZE);
//   Serial.println();
// }

// // Start Motion Detection
// void CMMD(void){
//   Serial.println("Starting Motion Detection.");
//   Serial.println("Press any key to halt motion detection");
//   mdflag = true;
// }



// // Get a frame of data and write to .bmp file
// void CMGF(void) {
//   uint32_t imagesize;
//   uint16_t buffnum;
//   imagesize = OV7670.ImageSize();
//   char * fname;

//   fname = NewFileName();
//   Serial.printf("Saving %s\n",fname);
//   if (SD.exists(fname)) {
//     // delete the file:
//     Serial.printf("Removing %s...", fname);
//     SD.remove(fname);
//   }
//   bmpfile = SD.open(fname, FILE_WRITE);
//   bmpfile.write((const uint8_t *)OV7670.GetHeaderPtr(), sizeof(tBMPHDR565));
//   OV7670.ClearFrameReady();
//   // wait until buffer 2 has just been filled
//   do {
//     buffnum = OV7670.FrameReady();
//   } while (buffnum != 2);
//   bmpfile.write(fb2, imagesize);
//   bmpfile.close();
//   #ifdef USEILI9341
//   ILIShowFrame();
//   #endif
// }


// /*****************************************************************************
//    Read the Teensy RTC and return a time_t (Unix Seconds) value

//  ******************************************************************************/
// time_t getTeensy3Time() {
//   return Teensy3Clock.get();
// }

// //------------------------------------------------------------------------------
// /*
//    User provided date time callback function.
//    See SdFile::dateTimeCallback() for usage.
// */
// void dateTime(uint16_t* date, uint16_t* time) {
//   // use the year(), month() day() etc. functions from timelib

//   // return date using FAT_DATE macro to format fields
//   *date = FAT_DATE(year(), month(), day());

//   // return time using FAT_TIME macro to format fields
//   *time = FAT_TIME(hour(), minute(), second());
// }

// bool StartSDCard() {

//   if (!SD.begin(254)) {
//     Serial.println("\nSdFs File initialization failed.\n");
//     return false;
//   } else  Serial.println("initialization done.");


//   // set date time callback function
//   SdFile::dateTimeCallback(dateTime);
//   return true;
// }

// char* NewFileName(void) {
//   static char fname[36];
//   time_t nn;
//   nn = now();
//   int mo = month(nn);
//   int dd = day(nn);
//   int hh = hour(nn);
//   int mn = minute(nn);
//   int ss = second(nn)/4 ;
//   char secchar = 'A' + ss;
//   sprintf(fname, "MD_%02d%02d%02d%02d%c.bmp", mo, dd, hh, mn, secchar);

//   return &fname[0];
// }


// #ifdef USEILI9341
// // Generate a time stamp string for ILI9341
// void MakeTimeStamp(char *str) {
//   time_t nn;
//   nn = now();
//   int yr = year(nn);
//   int mo = month(nn);
//   int dd = day(nn);
//   int hh = hour(nn);
//   int mn = minute(nn);
//   int se = second(nn);
//   sprintf(str, "%02d/%02d/%04d  %02d:%02d:%02d", mo, dd, yr, hh, mn, se);

// }

// void ILIShowFrame(void ) {
//   static char tmsg[32] = "01/01/2020 01:00:00";
//   MakeTimeStamp(tmsg);
//   memcpy(fcaptbuff, fb2, OV7670.ImageSize());
//   uint32_t *tsptr = (uint32_t *)&fb2 ;
//   // put the time stamp into first 4 bytes of image
//   *tsptr = now();

//   tft.setFont(Arial_12);
//   tft.writeRect(0, 0, tft.width(), tft.height(), (uint16_t *)fcaptbuff);
//   tft.setTextColor(ILI9341_GREEN);
//   tft.drawString(tmsg, 5, 226);

// }

// #endif
