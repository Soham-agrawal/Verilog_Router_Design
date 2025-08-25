class router_wr_driver extends uvm_driver #(write_xtn);

    //FACTORY REGISTRATION
    uvm_component_utils(router_wr_driver)

    //VIRTUAL INTERFACE
    virtual router_if.WDR_MP vif;

    //AGT CONFIGURATION
    router_wr_agt_config m_cfg;

    //METHODS
    extern function new(string name="router_wr_driver", uvm_component parent);
    extern function void build_phase(uvm_phase phase);
    extern function void connect_phase(uvm_phase phase);
    extern task run_phase(uvm_phase phase);
    extern task send_to_dut(write_xtn xtn);
    extern function void report_phase(uvm_phase phase);
endclass