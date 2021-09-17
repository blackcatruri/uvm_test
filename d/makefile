TEST_CASE = seq_config.sv

CASE_CLASS = my_case0

UVM_VER = uvm-1.1

# NONE, LOW, MEDIUM, HIGH, FULL, DEBUG
UVM_VERBOSITY = MEDIUM


all: com sim

com:
	vcs -full64 -sverilog -LDFLAGS -Wl,--no-as-needed -debug_all +vcs+vcdpluson -f filelist_d.f ${TEST_CASE} -timescale=1ns/1ps -ntb_opts uvm-1.1 -l com.log

sim:
	./simv -l sim.log +UVM_TESTNAME=${CASE_CLASS} +UVM_VERBOSITY=${UVM_VERBOSITY}

dve:
	dve -vpd *.vpd &

clean:
	rm -rf csrc DVE* simv* ucli* *.vpd  vc_hdrs* *.log .inter.vpd.uvm
