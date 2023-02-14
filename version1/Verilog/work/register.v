module register(
	input [15:0] data_in,
	output [15:0] data_out,

	input load,
	input clear,
	input clk
);

reg [15:0] storage;

assign data_out = storage;

always @ (posedge clk or negedge clear) begin
	if(~clear)
		storage <= 16'd0;
	else if(load)
		storage <= data_in;
	
end

endmodule
