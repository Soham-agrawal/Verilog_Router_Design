class write_xtn extends uvm_sequence_item;
    uvm_object_utils(write_xtn)
    //.........

    rand bit [7:0] header;
    rand bit [7:0] payload_data[];
    bit [7:0] parity;

    function void post_randomize();
	parity=0^header;
	foreach(payload_data[i])
	    parity=payload_data[i]^parity;
    endfunction

    constraint C1{header[1:0]!=3;}
    constraint C2{payload_data.size == header[7:2];}
    constraint C3{header[7:2]!=0;}

endclass : write_wtn
