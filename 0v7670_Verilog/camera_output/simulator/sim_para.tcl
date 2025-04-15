lappend auto_path "C:/lscc/radiant/2023.1/scripts/tcl/simulation"
package require simulation_generation
set ::bali::simulation::Para(DEVICEPM) {ice40tp}
set ::bali::simulation::Para(DEVICEFAMILYNAME) {iCE40UP}
set ::bali::simulation::Para(PROJECT) {simulator}
set ::bali::simulation::Para(PROJECTPATH) {Z:/senior_design/0v7670_Verilog/camera_output}
set ::bali::simulation::Para(FILELIST) {"Z:/senior_design/0v7670_Verilog/camera_output/source/impl_1/my_pll.v" "Z:/senior_design/0v7670_Verilog/camera_output/source/impl_1/vga.v" "Z:/senior_design/0v7670_Verilog/camera_output/source/impl_1/camera_read.v" "Z:/senior_design/0v7670_Verilog/camera_output/source/impl_1/OV7670_config.v" "Z:/senior_design/0v7670_Verilog/camera_output/source/impl_1/OV7670_config_rom.v" "Z:/senior_design/0v7670_Verilog/camera_output/source/impl_1/SCCB_interface.v" "Z:/senior_design/0v7670_Verilog/camera_output/mypll/rtl/mypll.v" "Z:/senior_design/0v7670_Verilog/camera_output/source/impl_1/pattern_gen.v" "Z:/senior_design/0v7670_Verilog/camera_output/source/impl_1/single_capture.v" }
set ::bali::simulation::Para(GLBINCLIST) {}
set ::bali::simulation::Para(INCLIST) {"none" "none" "none" "none" "none" "none" "none" "none" "none"}
set ::bali::simulation::Para(WORKLIBLIST) {"work" "work" "work" "work" "work" "work" "work" "work" "work" }
set ::bali::simulation::Para(COMPLIST) {"VERILOG" "VERILOG" "VERILOG" "VERILOG" "VERILOG" "VERILOG" "VERILOG" "VERILOG" "VERILOG" }
set ::bali::simulation::Para(LANGSTDLIST) {"Verilog 2001" "Verilog 2001" "Verilog 2001" "Verilog 2001" "Verilog 2001" "Verilog 2001" "" "Verilog 2001" "Verilog 2001" }
set ::bali::simulation::Para(SIMLIBLIST) {pmi_work ovi_ice40up}
set ::bali::simulation::Para(MACROLIST) {}
set ::bali::simulation::Para(SIMULATIONTOPMODULE) {top}
set ::bali::simulation::Para(SIMULATIONINSTANCE) {}
set ::bali::simulation::Para(LANGUAGE) {VERILOG}
set ::bali::simulation::Para(SDFPATH)  {}
set ::bali::simulation::Para(INSTALLATIONPATH) {C:/lscc/radiant/2023.1}
set ::bali::simulation::Para(MEMPATH) {Z:/senior_design/0v7670_Verilog/camera_output/mypll}
set ::bali::simulation::Para(UDOLIST) {}
set ::bali::simulation::Para(ADDTOPLEVELSIGNALSTOWAVEFORM)  {1}
set ::bali::simulation::Para(RUNSIMULATION)  {1}
set ::bali::simulation::Para(SIMULATIONTIME)  {100}
set ::bali::simulation::Para(SIMULATIONTIMEUNIT)  {ns}
set ::bali::simulation::Para(ISRTL)  {1}
set ::bali::simulation::Para(HDLPARAMETERS) {}
::bali::simulation::ModelSim_Run
