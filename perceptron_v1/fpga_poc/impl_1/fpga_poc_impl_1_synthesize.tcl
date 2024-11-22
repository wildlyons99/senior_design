if {[catch {

# define run engine funtion
source [file join {C:/lscc/radiant/2023.1} scripts tcl flow run_engine.tcl]
# define global variables
global para
set para(gui_mode) 1
set para(prj_dir) "Z:/senior_design/perceptron_v1/fpga_poc"
# synthesize IPs
# synthesize VMs
# synthesize top design
file delete -force -- fpga_poc_impl_1.vm fpga_poc_impl_1.ldc
run_engine_newmsg synthesis -f "fpga_poc_impl_1_lattice.synproj"
run_postsyn [list -a iCE40UP -p iCE40UP5K -t SG48 -sp High-Performance_1.2V -oc Industrial -top -w -o fpga_poc_impl_1_syn.udb fpga_poc_impl_1.vm] "Z:/senior_design/perceptron_v1/fpga_poc/impl_1/fpga_poc_impl_1.ldc"

} out]} {
   runtime_log $out
   exit 1
}
