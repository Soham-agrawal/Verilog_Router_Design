class read_xtn extends uvm_sequence_item;

    uvm_object_utils(read_xtn)
    //..........
    bit [7:0]header;
    bit [7:0]payload_data;
    bit [7:0]parity;
    rand bit[5:0]no_ofcycles;

endclass : read_xtn