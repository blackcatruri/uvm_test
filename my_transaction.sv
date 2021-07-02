`ifndef MY_TRANSACTION_SV
`define MY_TRANSACTION_SV

class my_transaction extends uvm_sequence_item;


    rand bit[47:0] dmac;
    rand bit[47:0] smac;
    rand bit[15:0] ether_type;
    rand byte      pload[];
    rand bit[31:0] crc;

    // rand int       pload_size;

    // 使用factory注册后，自带copy、print、compare、pack_bytes、unpack_bytes等方法
    `uvm_object_utils_begin(my_transaction)
        `uvm_field_int(dmac, UVM_ALL_ON)
        `uvm_field_int(smac, UVM_ALL_ON)
        `uvm_field_int(ether_type, UVM_ALL_ON)
        `uvm_field_array_int(pload, UVM_ALL_ON)
        `uvm_field_int(crc, UVM_ALL_ON)
    `uvm_object_utils_end


    constraint pload_cons{
        pload.size >= 1;
        pload.size <= 50;
        // pload_size == pload.size;
    }

    function bit[31:0] calc_crc();
        return 0;
    endfunction

    function void post_randomize();
        crc = calc_crc();
    endfunction

    function new(string name = "my_transaction");
        super.new(name);
    endfunction

    // function void print_result();
    //     $display("dmac = %0h; smac = %0h; ether_type = %0h; pload(dec) = %0p; crc = %0h",
    //         dmac, smac, ether_type, pload, crc);
    //     // $display("dmac = %0h; smac = %0h; ether_type = %0h; crc = %0h",
    //     //    dmac, smac, ether_type, crc);
    //     // for(int i = 0; i < pload.size; i++) begin
    //     //    $display("pload[%0d] = %0h", i, pload[i]);
    //     // end
    // endfunction

    // function void copy(my_transaction tr);
    //     assert(tr!=null);
    //     dmac = tr.dmac;
    //     smac = tr.smac;
    //     ether_type = tr.ether_type;
    //     pload = new[tr.pload.size()];
    //     for(int i = 0; i < tr.pload.size(); i++) begin
    //         pload[i] = tr.pload[i];
    //     end
    //     crc = tr.crc;
    // endfunction

    // function bit compare(my_transaction tr);
    //     if(tr == null)
    //         `uvm_fatal("my_transaction", "get a null transaction")
    //     else if(crc != tr.crc)
    //         `uvm_fatal("my_transaction", "crc is inconsistent")
    //     else if((dmac == tr.dmac) && (smac == tr.smac) && (ether_type)) begin
    //         if(pload.size() != tr.pload.size())
    //             return 0;
    //         for(int i = 0; i < pload.size; i++) begin
    //             if(pload[i] != tr.pload[i])
    //                 return 0;
    //         end
    //         return 1;
    //     end
    //     else return 0;
    // endfunction

endclass

`endif