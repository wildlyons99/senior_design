if {[catch {

# define run engine funtion
source [file join {C:/lscc/radiant/3.2} scripts tcl flow run_engine.tcl]
# define global variables
global para
set para(gui_mode) 1
set para(prj_dir) "C:/Users/jacob/Downloads/Tufts/Senior Design/demo_memory"
# synthesize IPs
# synthesize VMs
# synthesize top design
run_postsyn [list -a iCE40UP -p iCE40UP5K -t SG48 -sp High-Performance_1.2V -oc Industrial -top -w -o demo_memory_impl_1_syn.udb demo_memory_impl_1.vm] "C:/Users/jacob/Downloads/Tufts/Senior Design/demo_memory/impl_1/demo_memory_impl_1.ldc"

} out]} {
   runtime_log $out
   exit 1
}
