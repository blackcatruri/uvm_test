`ifndef MY_SEQUENCE_SV
`define MY_SEQUENCE_SV

class my_sequence extends uvm_sequence #(my_transaction);

    my_transaction tr;
    rand int seq_pload_len;

    constraint seq_pload_cons {
        seq_pload_len >= 1;
        seq_pload_len <= 100;
    }

    `uvm_object_utils(my_sequence)

    function new(string name = "my_sequence");
        super.new(name);
        set_automatic_phase_objection(1);
    endfunction

    task pre_start();
        get_starting_phase().raise_objection(this);
    endtask

    virtual task body();
        tr = new("tr");
        `uvm_info("my_sequence", "create sequence", UVM_LOW)
        #5;
        repeat(2) begin
            `uvm_do_with(tr, {tr.pload.size() == seq_pload_len;})
        end
        #1000;  // drop obj后，此phase （所有的main phase）就会停止，
                // 并进入下一个phase，所以为了让mon顺利获取所有值，应该加一个较大的延时
    endtask

    task post_start();
        get_starting_phase().drop_objection(this);
    endtask

endclass

`endif