`ifndef MY_ENV_SV
`define MY_ENV_SV

class my_env extends uvm_env;

    my_agent i_agt, o_agt;
    my_model mdl;
    my_scoreboard scb;
    // my_sequence seq;
    
    uvm_tlm_analysis_fifo#(my_transaction) agt_mdl_fifo, agt_scb_fifo, mdl_scb_fifo;

    `uvm_component_utils(my_env)

    function new(string name = "my_env", uvm_component parent);
        super.new(name, parent);
    endfunction

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        // seq = new("seq");
        i_agt = my_agent::type_id::create("i_agt", this);
        o_agt = my_agent::type_id::create("o_agt", this);
        i_agt.is_active = UVM_ACTIVE;
        o_agt.is_active = UVM_PASSIVE;
        mdl = my_model::type_id::create("mdl", this);
        scb = my_scoreboard::type_id::create("scb", this);
        agt_mdl_fifo = new("agt_mdl_fifo", this);
        agt_scb_fifo = new("agt_scb_fifo", this);
        mdl_scb_fifo = new("mdl_scb_fifo", this);  

        // uvm_config_db#(int)::set(this, "o_agt.mon", "pload_len", `PLOAD_LEN);

        //  如果使用自动化生成seq，应该吧uvm_sequence_base换成uvm_object_wrapper,第四个参数换成my_sequence::type_id_get()
        // uvm_config_db#(uvm_sequence_base)::set(this,
        //                                         "i_agt.sqr.main_phase",
        //                                         "default_sequence",
        //                                         seq);
    endfunction

    virtual function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        i_agt.ap.connect(agt_mdl_fifo.analysis_export);
        mdl.bgp.connect(agt_mdl_fifo.blocking_get_export);
        mdl.ap.connect(mdl_scb_fifo.analysis_export);
        scb.bgp_exp.connect(mdl_scb_fifo.blocking_get_export);
        o_agt.ap.connect(agt_scb_fifo.analysis_export);
        scb.bgp_act.connect(agt_scb_fifo.blocking_get_export);
    endfunction

endclass

`endif