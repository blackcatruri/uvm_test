`ifndef MY_AGENT_SV
`define MY_AGENT_SV

class my_agent extends uvm_agent;

    my_sequencer sqr;
    my_driver drv;
    my_monitor mon;

    uvm_analysis_port#(my_transaction) ap;

    `uvm_component_utils(my_agent)

    function new(string name = "my_agent", uvm_component parent);
        super.new(name, parent);
    endfunction

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        if(is_active == UVM_ACTIVE) begin
            sqr = my_sequencer::type_id::create("sqr", this);
            drv = my_driver::type_id::create("drv", this);
        end
        else
            mon = my_monitor::type_id::create("mon", this);
    endfunction

    virtual function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        if(is_active == UVM_ACTIVE) begin
            drv.seq_item_port.connect(sqr.seq_item_export);
            ap = drv.ap;
        end else
            ap = mon.ap;
    endfunction

endclass

`endif