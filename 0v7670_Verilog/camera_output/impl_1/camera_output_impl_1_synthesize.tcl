if {[catch {

# define run engine funtion
source [file join {C:/lscc/radiant/2023.1} scripts tcl flow run_engine.tcl]
# define global variables
global para
set para(gui_mode) 1
set para(prj_dir) "Z:/senior_design/0v7670_Verilog/camera_output"
# synthesize IPs
# synthesize VMs
# propgate constraints
file delete -force -- camera_output_impl_1_cpe.ldc
run_engine_newmsg cpe -f "camera_output_impl_1.cprj" "mypll.cprj" -a "iCE40UP"  -o camera_output_impl_1_cpe.ldc
# synthesize top design
file delete -force -- camera_output_impl_1.vm camera_output_impl_1.ldc
run_engine synpwrap -prj "camera_output_impl_1_synplify.tcl" -log "camera_output_impl_1.srf"
run_postsyn [list -a iCE40UP -p iCE40UP5K -t SG48 -sp High-Performance_1.2V -oc Industrial -top -w -o camera_output_impl_1_syn.udb camera_output_impl_1.vm] "Z:/senior_design/0v7670_Verilog/camera_output/impl_1/camera_output_impl_1.ldc"

} out]} {
   runtime_log $out
   exit 1
}
