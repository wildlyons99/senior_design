`timescale 100 ps/100 ps
module MAC16 (
  O31,
  O30,
  O29,
  O28,
  O27,
  O26,
  O25,
  O24,
  O23,
  O22,
  O21,
  O20,
  O19,
  O18,
  O17,
  O16,
  O15,
  O14,
  O13,
  O12,
  O11,
  O10,
  O9,
  O8,
  O7,
  O6,
  O5,
  O4,
  O3,
  O2,
  O1,
  O0,
  A15,
  A14,
  A13,
  A12,
  A11,
  A10,
  A9,
  A8,
  A7,
  A6,
  A5,
  A4,
  A3,
  A2,
  A1,
  A0,
  B15,
  B14,
  B13,
  B12,
  B11,
  B10,
  B9,
  B8,
  B7,
  B6,
  B5,
  B4,
  B3,
  B2,
  B1,
  B0,
  C15,
  C14,
  C13,
  C12,
  C11,
  C10,
  C9,
  C8,
  C7,
  C6,
  C5,
  C4,
  C3,
  C2,
  C1,
  C0,
  D15,
  D14,
  D13,
  D12,
  D11,
  D10,
  D9,
  D8,
  D7,
  D6,
  D5,
  D4,
  D3,
  D2,
  D1,
  D0,
  CLK,
  CE,
  IRSTTOP,
  IRSTBOT,
  ORSTTOP,
  ORSTBOT,
  AHOLD,
  BHOLD,
  CHOLD,
  DHOLD,
  OHOLDTOP,
  OHOLDBOT,
  OLOADTOP,
  OLOADBOT,
  ADDSUBTOP,
  ADDSUBBOT,
  CO,
  CI,
  ACCUMCI,
  ACCUMCO,
  SIGNEXTIN,
  SIGNEXTOUT
)
;
output O31 ;
output O30 ;
output O29 ;
output O28 ;
output O27 ;
output O26 ;
output O25 ;
output O24 ;
output O23 ;
output O22 ;
output O21 ;
output O20 ;
output O19 ;
output O18 ;
output O17 ;
output O16 ;
output O15 ;
output O14 ;
output O13 ;
output O12 ;
output O11 ;
output O10 ;
output O9 ;
output O8 ;
output O7 ;
output O6 ;
output O5 ;
output O4 ;
output O3 ;
output O2 ;
output O1 ;
output O0 ;
input A15 ;
input A14 ;
input A13 ;
input A12 ;
input A11 ;
input A10 ;
input A9 ;
input A8 ;
input A7 ;
input A6 ;
input A5 ;
input A4 ;
input A3 ;
input A2 ;
input A1 ;
input A0 ;
input B15 ;
input B14 ;
input B13 ;
input B12 ;
input B11 ;
input B10 ;
input B9 ;
input B8 ;
input B7 ;
input B6 ;
input B5 ;
input B4 ;
input B3 ;
input B2 ;
input B1 ;
input B0 ;
input C15 ;
input C14 ;
input C13 ;
input C12 ;
input C11 ;
input C10 ;
input C9 ;
input C8 ;
input C7 ;
input C6 ;
input C5 ;
input C4 ;
input C3 ;
input C2 ;
input C1 ;
input C0 ;
input D15 ;
input D14 ;
input D13 ;
input D12 ;
input D11 ;
input D10 ;
input D9 ;
input D8 ;
input D7 ;
input D6 ;
input D5 ;
input D4 ;
input D3 ;
input D2 ;
input D1 ;
input D0 ;
input CLK ;
input CE ;
input IRSTTOP ;
input IRSTBOT ;
input ORSTTOP ;
input ORSTBOT ;
input AHOLD ;
input BHOLD ;
input CHOLD ;
input DHOLD ;
input OHOLDTOP ;
input OHOLDBOT ;
input OLOADTOP ;
input OLOADBOT ;
input ADDSUBTOP ;
input ADDSUBBOT ;
output CO ;
input CI ;
input ACCUMCI ;
output ACCUMCO ;
input SIGNEXTIN ;
output SIGNEXTOUT ;
endmodule /* MAC16 */

module SP256K (
  AD,
  DI,
  MASKWE,
  WE,
  CS,
  CK,
  STDBY,
  SLEEP,
  PWROFF_N,
  DO
)
;
input [13:0] AD ;
input [15:0] DI ;
input [3:0] MASKWE ;
input WE ;
input CS ;
input CK ;
input STDBY ;
input SLEEP ;
input PWROFF_N ;
output [15:0] DO ;
endmodule /* SP256K */

module PLL_B (
  REFERENCECLK,
  FEEDBACK,
  DYNAMICDELAY7,
  DYNAMICDELAY6,
  DYNAMICDELAY5,
  DYNAMICDELAY4,
  DYNAMICDELAY3,
  DYNAMICDELAY2,
  DYNAMICDELAY1,
  DYNAMICDELAY0,
  BYPASS,
  RESET_N,
  SCLK,
  SDI,
  LATCH,
  INTFBOUT,
  OUTCORE,
  OUTGLOBAL,
  OUTCOREB,
  OUTGLOBALB,
  SDO,
  LOCK
)
;
input REFERENCECLK ;
input FEEDBACK ;
input DYNAMICDELAY7 ;
input DYNAMICDELAY6 ;
input DYNAMICDELAY5 ;
input DYNAMICDELAY4 ;
input DYNAMICDELAY3 ;
input DYNAMICDELAY2 ;
input DYNAMICDELAY1 ;
input DYNAMICDELAY0 ;
input BYPASS ;
input RESET_N ;
input SCLK ;
input SDI ;
input LATCH ;
output INTFBOUT ;
output OUTCORE ;
output OUTGLOBAL ;
output OUTCOREB ;
output OUTGLOBALB ;
output SDO ;
output LOCK ;
endmodule /* PLL_B */

