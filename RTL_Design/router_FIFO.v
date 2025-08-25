module FIFO #(parameter WIDTH=8, DEPTH=16)
(input 			clock,
			resetn, 
			write_enb, 
			soft_reset, 
			read_enb, 
			lfd_state,
input [(WIDTH-1):0] 	data_in,
output 			empty,
			full,
output reg [(WIDTH-1):0]data_out);


reg [8:0] memory [(DEPTH-1):0];
reg [4:0] read_ptr, write_ptr;
reg [6:0] count;
integer i;
reg lfd_state_dl;

always @(posedge clock)
    lfd_state_dl<=lfd_state;

assign empty= (write_ptr==read_ptr)?1'b1:1'b0;
assign full= (write_ptr=={~read_ptr[4],read_ptr[3:0]})?1'b1:1'b0;
//fifo write operation
always @(posedge clock) begin
	if(!resetn) 
		begin
			write_ptr<=0;
			for(i=0;i<16;i=i+1) 
				begin
					memory[i]<=0;
				end
		end
	else if(soft_reset)
		begin
			write_ptr<=0;
			for(i=0;i<16;i=i+1) 
				begin
					memory[i]=0;
				end
		end
	else
		begin
			if(write_enb && ~full)
				begin
					write_ptr<=write_ptr+1;
					memory[write_ptr[3:0]]<={lfd_state_dl,data_in};

				end
		end
	end	

//fifo read opertation
always @(posedge clock)  begin
	if(!resetn)
		begin
			read_ptr<=0;
			data_out<=8'h00;
		end
	else if(soft_reset)	
		begin
			read_ptr<=0;
			data_out<=8'hzz;
		end
	else 
		begin
			if(read_enb && ~empty)
				begin
					read_ptr<=read_ptr+1;

				end
			if((count==0) && (data_out!=0))
				begin
					data_out<=8'dz;
				end
			else if(read_enb && ~empty) 
				begin
					data_out<=memory[read_ptr[3:0]];
				end
		end
	end
always @(posedge clock) begin
	if(!resetn)
		begin
			count<=0;

		end
	else if(soft_reset)
		begin
		        count<=0;
		end
	else if(read_enb & ~empty)
		begin
			if(memory[read_ptr[3:0]][8]==1'b1)
				begin
					count<=memory[read_ptr[3:0]][7:2]+1'b1;
				end
			else if(count!=0)
				begin
					count<=count-1'b1;
				end
		end
	end

endmodule
