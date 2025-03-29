if {[catch {

# define run engine funtion
source [file join {C:/lscc/radiant/2023.1} scripts tcl flow run_engine.tcl]
# define global variables
global para
set para(gui_mode) 1
set para(prj_dir) "Z:/senior_design/max_verilog"
# synthesize IPs
# synthesize VMs
# synthesize top design
file delete -force -- max_verilog_impl_1.vm max_verilog_impl_1.ldc
run_engine_newmsg synthesis -f "max_verilog_impl_1_lattice.synproj"
run_postsyn [list -a iCE40UP -p iCE40UP5K -t SG48 -sp High-Performance_1.2V -oc Industrial -top -w -o max_verilog_impl_1_syn.udb max_verilog_impl_1.vm] "Z:/senior_design/max_verilog/impl_1/max_verilog_impl_1.ldc"

} out]} {
   runtime_log $out
   exit 1
}
