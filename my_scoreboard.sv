`ifndef MY_SCOREBOARD_SV
`define MY_SCOREBOARD_SV

class my_scoreboard extends uvm_scoreboard;

    bit result;
    uvm_blocking_get_port#(my_transaction) bp_exp, bp_act;

    `uvm_component_utils(my_scoreboard)

    function new(string name = "my_scoreboard", uvm_component parent);
        super.new(name, parent);
    endfunction

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        bp_exp = new("bp_exp", this);
        bp_act = new("bp_act", this);
    endfunction
    
    virtual task main_phase(uvm_phase phase);
        my_transaction tr_exp, tr_act;
        super.main_phase(phase);
        while(1) begin
            bp_exp.get(tr_exp);
            bp_act.get(tr_act);
            result = tr_exp.compare(tr_act);
            if(result)
                `uvm_info("my_scoreboard", "comparison passed", UVM_LOW)
            else begin
                `uvm_error("my_scoreboard", "comparison falled");
                $display("dut(o_agt.mon) tr:");
                tr_act.print();
                $display("model(i_agt.drv) tr:");
                tr_exp.print();
            end
        end
    endtask

endclass

`endif