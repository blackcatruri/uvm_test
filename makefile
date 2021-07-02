TEST_CASE = my_base_test
# TEST_CASE = 


all: com sim

com:
	vcs -f filelist.f -timescale=1ns/1ps -ntb_opts uvm-1.2 +vcs+vcdpluson -l com.log

sim:
	./simv -l sim.log +UVM_TESTNAME=${TEST_CASE}

dve:
	dve -vpd *.vpd &

clean:
	rm -rf csrc DVE* simv* ucli* *.vpd  vc_hdrs* *.log .inter.vpd.uvm
