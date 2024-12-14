if {[catch {

# define run engine funtion
source [file join {C:/lscc/radiant/2023.1} scripts tcl flow run_engine.tcl]
# define global variables
global para
set para(gui_mode) 1
set para(prj_dir) "Z:/es4_ta_resources/nunchuck_testing"
# synthesize IPs
# synthesize VMs
# synthesize top design
file delete -force -- nunchuck_testing_impl_1.vm nunchuck_testing_impl_1.ldc
run_engine_newmsg synthesis -f "nunchuck_testing_impl_1_lattice.synproj"
run_postsyn [list -a iCE40UP -p iCE40UP5K -t SG48 -sp High-Performance_1.2V -oc Industrial -top -w -o nunchuck_testing_impl_1_syn.udb nunchuck_testing_impl_1.vm] "Z:/es4_ta_resources/nunchuck_testing/impl_1/nunchuck_testing_impl_1.ldc"

} out]} {
   runtime_log $out
   exit 1
}
