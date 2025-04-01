if {[catch {

# define run engine funtion
source [file join {C:/lscc/radiant/2023.1} scripts tcl flow run_engine.tcl]
# define global variables
global para
set para(gui_mode) 1
set para(prj_dir) "Z:/senior_design/0v7670_Verilog/vga_radiant"
# synthesize IPs
# synthesize VMs
# propgate constraints
file delete -force -- vga_radiant_impl_1_cpe.ldc
run_engine_newmsg cpe -f "vga_radiant_impl_1.cprj" "mypll.cprj" -a "iCE40UP"  -o vga_radiant_impl_1_cpe.ldc
# synthesize top design
file delete -force -- vga_radiant_impl_1.vm vga_radiant_impl_1.ldc
run_engine_newmsg synthesis -f "vga_radiant_impl_1_lattice.synproj"
run_postsyn [list -a iCE40UP -p iCE40UP5K -t SG48 -sp High-Performance_1.2V -oc Industrial -top -w -o vga_radiant_impl_1_syn.udb vga_radiant_impl_1.vm] "Z:/senior_design/0v7670_Verilog/vga_radiant/impl_1/vga_radiant_impl_1.ldc"

} out]} {
   runtime_log $out
   exit 1
}
