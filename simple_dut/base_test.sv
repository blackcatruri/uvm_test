`ifndef MY_TEST_SV
`define MY_TEST_SV

// `define PLOAD_LEN 5

class base_test extends uvm_test;

    my_env env;
    // my_sequence seq;

    `uvm_component_utils(base_test)

    function new(string name = "base_test", uvm_component parent);
        super.new(name, parent);
    endfunction

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        env = my_env::type_id::create("env", this);
        // seq = new("seq");

        // uvm_config_db#(int)::set(this, "env.o_agt.mon", "pload_len", `PLOAD_LEN);

        // uvm_config_db#(uvm_sequence_base)::set( this,
        //                                         "env.i_agt.sqr.main_phase",
        //                                         "default_sequence",
        //                                         seq);
        // `uvm_config_db#(uvm_object_wrapper)::set(this, 
        //                                         "env.i_agt.sqr.main_phase",
        //                                         "default_sequence",
        //                                         my_sequence::type_id::get())  // 注意参数2应该定位到sqr的main_phase
    endfunction

    task main_phase(uvm_phase phase);
        // assert(seq.randomize() with {seq.seq_pload_len == `PLOAD_LEN;});
        // if (seq.seq_pload_len != `PLOAD_LEN)
        //     `uvm_fatal("my_env", "sequence did not receive seq_pload_len")
    endtask

    function void report_phase(uvm_phase phase);        
        int  err_num;
        uvm_report_server server;

        super.report_phase(phase);
        server = get_report_server();
        err_num = server.get_severity_count(UVM_ERROR);
        if(err_num) begin
            $display("####################");
            $display("TEST FAILDED");
            $display("####################");
        end else begin
            $display("####################");
            $display("TEST PASSED");
            $display("####################");
        end
    endfunction

endclass

`endif