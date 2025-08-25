class router_test extends uvm_test;
    //factory registration
    uvm_component_utils(router_test)
  
    //Handles
    router_env env;
    router_env_config wcfg[];
    router_wr_agt_config wcfg[];
    router_rd_agt_config rcfg[];

    bit has_ragent