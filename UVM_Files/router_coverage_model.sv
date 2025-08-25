covergroup router_fcov;
    option.per_instance=1;

    ADDRESS : coverpoint cov_data.header[1:0]{
	bins low= {2'b00};
	bins mid1= {2'b01};
	bins mid2= {2'b10};}

    PAYLOAD_SIZE: coverpoint cov_data.header[7:2] {
	bins small_packet = {[1:13]};
	bins medium_packet= {[14:30]};
	bins large_packet= {[31:63]};

    ADDRESS X PAYLOAD_SIZE : cross ADDRESS, PAYLOAD_SIZE;
endgroup : router_fcov