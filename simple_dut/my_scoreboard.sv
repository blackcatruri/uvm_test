`ifndef MY_SCOREBOARD_SV
`define MY_SCOREBOARD_SV

class my_scoreboard extends uvm_scoreboard;

    bit result;
    uvm_blocking_get_port#(my_transaction) bgp_exp, bgp_act;

    `uvm_component_utils(my_scoreboard)

    function new(string name = "my_scoreboard", uvm_component parent);
        super.new(name, parent);
    endfunction

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        bgp_exp = new("bgp_exp", this);
        bgp_act = new("bgp_act", this);
    endfunction
    
    virtual task main_phase(uvm_phase phase);
        my_transaction tr_exp, tr_act;
        super.main_phase(phase);
        while(1) begin
            bgp_exp.get(tr_exp);
            bgp_act.get(tr_act);
            // tr_act.print();
            result = tr_exp.compare(tr_act);
            if(result)
                `uvm_info("my_scoreboard", "comparison passed", UVM_HIGH)
            else begin
                `uvm_error("my_scoreboard", "comparison falled");
                // $display("dut(o_agt.mon) tr:");
                // tr_act.print();
                // $display("model(i_agt.drv) tr:");
                // tr_exp.print();
            end
        end
    endtask

endclass

`endif