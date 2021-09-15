`ifndef MY_MODEL_SV
`define MY_MODEL_SV

class my_model extends uvm_component;

    uvm_analysis_port#(my_transaction) ap;
    uvm_blocking_get_port#(my_transaction) bgp;

    `uvm_component_utils(my_model)

    function new(string name = "my_modle", uvm_component parent);
        super.new(name, parent);
    endfunction

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        ap = new("ap", this);
        bgp = new("bgp", this);
    endfunction

    virtual task main_phase(uvm_phase phase);
        my_transaction tr;
        my_transaction tr_cp;
        super.main_phase(phase);
        while(1) begin
            bgp.get(tr);
            tr_cp = new("tr_cp");
            tr_cp.copy(tr);
            // tr_cp.crc = 1;
            `uvm_info("my_model", "get one transaction", UVM_HIGH)
            // `uvm_info("my_model", "get one transaction, now print it", UVM_LOW)
            // tr_cp.print_result();
            ap.write(tr_cp);
        end
    endtask

endclass

`endif