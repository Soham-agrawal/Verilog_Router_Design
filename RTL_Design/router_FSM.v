`define DECODE_ADDRESS     4'd0
`define LOAD_FIRST_DATA    4'd1
`define LOAD_DATA          4'd2
`define LOAD_PARITY        4'd3
`define FIFO_FULL_STATE    4'd4
`define LOAD_AFTER_FULL    4'd5
`define WAIT_TILL_EMPTY    4'd6
`define CHECK_PARITY_ERROR 4'd7

module FSM(
input		clock,
		resetn,
		pkt_valid,
		parity_done,
		soft_reset_0,
		soft_reset_1,
		soft_reset_2,
		fifo_full,
		low_pkt_valid,
		fifo_empty_0,
		fifo_empty_1,
		fifo_empty_2,
input [1:0]     data_in,
output		busy,
		detect_add,
		ld_state,
		laf_state,
		full_state,
		write_enb_reg,
		rst_int_reg,
		lfd_state);

reg [2:0] pre_state,next_state;
reg [1:0] data_in_temp;


always @(posedge clock)
    begin
	if(detect_add)
	    data_in_temp<=data_in;
    end

always @(posedge clock)
    begin
	if(!resetn)
	    pre_state<=`DECODE_ADDRESS;
	else if(((data_in_temp==0) & soft_reset_0) | ((data_in_temp==1) & soft_reset_1) | ((data_in_temp==2) & soft_reset_2))
	    pre_state<=`DECODE_ADDRESS;
	else
	    pre_state<=next_state;
    end


always @(*)
    begin
	next_state=`DECODE_ADDRESS;
	    case(pre_state)
		`DECODE_ADDRESS     :
					begin
					    if(pkt_valid==1 && (data_in[1:0]==2'b00))
						begin
						    if(fifo_empty_0)
						        next_state=`LOAD_FIRST_DATA;
						    else
						        next_state=`WAIT_TILL_EMPTY;
						end

					    else if(pkt_valid==1 && (data_in[1:0]==2'b01))
						begin
						    if(fifo_empty_1)
						        next_state=`LOAD_FIRST_DATA;
						    else
						        next_state=`WAIT_TILL_EMPTY;
						end
					    else if(pkt_valid==1 && data_in[1:0]==2'b10)
						begin
						    if(fifo_empty_2)
						        next_state=`LOAD_FIRST_DATA;
						    else	
						        next_state=`WAIT_TILL_EMPTY;
						end
					    else
						next_state=`DECODE_ADDRESS;
					end
		`LOAD_FIRST_DATA     :
					begin
					    next_state=`LOAD_DATA;
					end
		`LOAD_DATA           :  
					begin
					    if(fifo_full==1'b1)
						next_state=`FIFO_FULL_STATE;
					    else if(pkt_valid==1'b0)
						next_state=`LOAD_PARITY;
					    else
						next_state=`LOAD_DATA;
					end
		`LOAD_PARITY	     :  
					begin
					    next_state=`CHECK_PARITY_ERROR;
					end
		`FIFO_FULL_STATE     :
					begin
					    if(fifo_full==1'b1)
						next_state=`FIFO_FULL_STATE;
					    else
						next_state=`LOAD_AFTER_FULL;	
					end
		`LOAD_AFTER_FULL     :  
					begin
					    if(parity_done==1'b1)
						next_state=`DECODE_ADDRESS;
					    else if(low_pkt_valid==1'b1)
						next_state=`LOAD_PARITY;
					    else
						next_state=`LOAD_DATA;
					end
		`WAIT_TILL_EMPTY     :  
					begin
					    if((~fifo_empty_0 && (data_in_temp==0)) | (~fifo_empty_1 && (data_in_temp==1)) | (~fifo_empty_2 && (data_in_temp==2)))
						next_state=`WAIT_TILL_EMPTY;
					    else
						next_state=`LOAD_FIRST_DATA;
					end
		`CHECK_PARITY_ERROR  : 
					begin
					    if(~fifo_full)
						next_state=`DECODE_ADDRESS;
					    else
						next_state=`FIFO_FULL_STATE;
					end
	    endcase
	end	
    assign detect_add    = (pre_state==`DECODE_ADDRESS) ? 1'b1: 1'b0;
    assign ld_state      = (pre_state==`LOAD_DATA) ? 1'b1: 1'b0;
    assign lfd_state     = (pre_state==`LOAD_FIRST_DATA) ? 1'b1: 1'b0;
    assign rst_int_reg   = (pre_state==`CHECK_PARITY_ERROR) ? 1'b1: 1'b0;
    assign laf_state     = (pre_state==`LOAD_AFTER_FULL) ? 1'b1: 1'b0;
    assign full_state    = (pre_state==`FIFO_FULL_STATE) ? 1'b1: 1'b0;
    assign write_enb_reg = ((pre_state==`LOAD_DATA) || (pre_state==`LOAD_AFTER_FULL) || (pre_state==`LOAD_PARITY)) ? 1'b1: 1'b0;
    assign busy = ((pre_state==`FIFO_FULL_STATE) || (pre_state==`LOAD_FIRST_DATA)|| (pre_state==`LOAD_AFTER_FULL) || (pre_state==`LOAD_PARITY)
                         || (pre_state==`CHECK_PARITY_ERROR)|| (pre_state==`WAIT_TILL_EMPTY)) ? 1'b1: 1'b0;
endmodule


	



			    














		