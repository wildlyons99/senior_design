if {[catch {

# define run engine funtion
source [file join {C:/lscc/radiant/2023.1} scripts tcl flow run_engine.tcl]
# define global variables
global para
set para(gui_mode) 1
set para(prj_dir) "Z:/senior_design/0v7670_Verilog/full_vga"
# synthesize IPs
# synthesize VMs
# propgate constraints
file delete -force -- full_vga_impl_1_cpe.ldc
run_engine_newmsg cpe -f "full_vga_impl_1.cprj" "mypll.cprj" -a "iCE40UP"  -o full_vga_impl_1_cpe.ldc
# synthesize top design
file delete -force -- full_vga_impl_1.vm full_vga_impl_1.ldc
run_engine synpwrap -prj "full_vga_impl_1_synplify.tcl" -log "full_vga_impl_1.srf"
run_postsyn [list -a iCE40UP -p iCE40UP5K -t SG48 -sp High-Performance_1.2V -oc Industrial -top -w -o full_vga_impl_1_syn.udb full_vga_impl_1.vm] "Z:/senior_design/0v7670_Verilog/full_vga/impl_1/full_vga_impl_1.ldc"

} out]} {
   runtime_log $out
   exit 1
}
