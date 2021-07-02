`ifndef MY_MONITOR_SV
`define MY_MONITOR_SV

class my_monitor extends uvm_monitor;

    int pload_len;
    virtual my_if vif;

    uvm_analysis_port#(my_transaction) ap;

    `uvm_component_utils(my_monitor)
    function new(string name = "my_monitor", uvm_component parent = null);
        super.new(name, parent);
    endfunction

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        assert_test:assert(uvm_config_db#(virtual my_if)::get(this, "", "vif", vif))
        else `uvm_fatal("my_monitor", "Interface should not be used in class unless it's virtual ")
        uvm_config_db#(int)::get(this, "", "pload_len", pload_len);
        ap = new("ap", this);
    endfunction

    extern virtual task main_phase(uvm_phase phase);
    extern virtual task collect_one_pkt(my_transaction tr);

endclass

task my_monitor::main_phase(uvm_phase phase);
    my_transaction tr;

    
    while(1) begin
        tr = new("tr");
        collect_one_pkt(tr);
        ap.write(tr);
    end
endtask

task my_monitor::collect_one_pkt(my_transaction tr);

    byte unsigned data_q[$];
    byte unsigned data_a[];

    while(1) begin
        @(posedge vif.clk);
        if(vif.valid) break;
    end

    `uvm_info("my_monitor", "begin to collect one pkg", UVM_LOW)
    while(vif.valid) begin
        data_q.push_back(vif.data);
        @(posedge vif.clk);
    end
    // $display("data_q : %p; \n data_q.size = %d", data_q, data_q.size());

    // uvm pack_bytes、unpack_bytes的参数必须是动态数组，且应为unsigned（0-255）
    data_a = new[data_q.size];
    for(int i = 0; i < data_q.size; i++) begin
        data_a[i] = data_q[i];
    end

    // {>> 8{tr.dmac, tr.smac, tr.ether_type, tr.pload 
    //     with [0 +: pload_len], tr.crc}}    = data_q;
    tr.pload = new[pload_len];
    tr.unpack_bytes(data_a);
    $display("mon, tr unpack, print tr:");
    tr.print();

    `uvm_info("my_monitor", "end collect one pkg", UVM_LOW)
    // `uvm_info("my_monitor", "end collect one pkg, now print it", UVM_LOW)
    // tr.print_result();

endtask

`endif