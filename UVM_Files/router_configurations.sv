class wr_agent_config extends uvm_objects;
    //........
    //declare the virtual interface handle vif
    virtual router_if vif;
    static int drv_data_count=0;
    static int mon_data_count=0;
    
    //------------SET UVM ACTIVE--------------//
    uvm_active_passive_enum is_active= UVM_ACTIVE
endclass: wr_agent_config

class rd_agent_config extends uvm_objects;
    //........
    //declare the virtual interface handle vif
    virtual router_if vif;
    static int drv_data_count=0;
    static int mon_data_count=0;
    
    //------------SET UVM ACTIVE--------------//
    uvm_active_passive_enum is_active= UVM_ACTIVE
endclass: rd_agent_config


class router_env_config extends uvm_object;
    //........
    bit has_wagent=1;
    bit has_ragent=1;
    int no_of_write_agent=1;
    int no_of_read_agent=3;
    bit has_virtual_sequencer=1;
    bit has_scoreboard=1;

    wr_agent_config wr_agent_cfg[];
    rd_agent_config rd_agent_cfg[];
endclass : router_env_config


