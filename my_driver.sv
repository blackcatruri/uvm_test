`ifndef MY_DRIVER_SV
`define MY_DRIVER_SV

class my_driver extends uvm_driver #(my_transaction);

    virtual my_if vif;
    uvm_analysis_port #(my_transaction) ap;

    `uvm_component_utils(my_driver)
    function new(string name = "my_driver", uvm_component parent = null);
        super.new(name, parent);
        `uvm_info("my_driver", "new is called", UVM_LOW)
    endfunction

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        // $display("my_drv build_phase full_name = %s", get_full_name());
        `uvm_info("my_driver", "build phase is called", UVM_LOW)
        if(!uvm_config_db#(virtual my_if)::get(this, "", "vif", vif))
            `uvm_fatal("my_driver", "Interface should not be used in class unless it's virtual ")
        ap = new("ap", this);
    endfunction

    extern virtual task main_phase(uvm_phase phase);
    extern virtual task driver_one_pkg(my_transaction tr);
endclass

task my_driver::main_phase(uvm_phase phase);
    vif.data <= 8'b0;
    vif.valid <= 1'b0;
    while(!vif.rst_n)
        @(posedge vif.clk);
    while(1) begin
        seq_item_port.try_next_item(req);
        if(req == null)
            @(posedge vif.clk);
        else begin
            driver_one_pkg(req);
            ap.write(req);
            seq_item_port.item_done();
        end
    end
    // $display("my_drv main_phase full_name = %s",get_full_name());
endtask

task my_driver::driver_one_pkg(my_transaction tr);
    // pack into bitstream(bytestream?), Big-endian format
    // byte data_q[$];
    // data_q = { >> 8{tr.dmac, tr.smac, tr.ether_type, tr.pload, tr.crc}};
    
    // uvm pack_bytes、unpack_bytes的参数必须是动态数组，且应为unsigned（0-255）
    byte unsigned data_a[];

    // data_a = new[];
    tr.pack_bytes(data_a);
    $display("drv, pack tr, print tr:");
    tr.print();
    // $display("drv data_a : %p", data_a);
    // $display("data_a.size = %d", data_a.size());


    `uvm_info("my_driver", "begin to drive one pkg", UVM_LOW)
    repeat(5) @(posedge vif.clk);

    // while(data_q.size() > 0) begin
    //     @(posedge vif.clk);
    //     vif.valid <= 1'b1;
    //     vif.data <= data_q.pop_front();
    // end

    for(int i = 0; i < data_a.size(); i++) begin
        @(posedge vif.clk);
        vif.valid <= 1'b1;
        vif.data <= data_a[i];
    end
    
    @(posedge vif.clk);
    vif.valid <= 1'b0;
    `uvm_info("my_driver", "end drive", UVM_LOW)

endtask

`endif