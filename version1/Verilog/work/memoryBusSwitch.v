module busSwitch #(
	parameter mask = 24'hfff000,	// default to read only data memory
	parameter comp = 24'h001000		// read only data memory is located from 0x001000 to 0x001FFF
)(
	input [23:0] address,
	inout [15:0] data,
	input loadEnable,
	input outputEnable,
	input clk,
	input reset,
	
	input [15:0] data_from_storage,
	output load_out,
	input outputDisable,
	output match
);

assign match = ~|((mask&address)^(mask&comp));

reg [15:0] data_to_bus;
assign data = data_to_bus;

assign load_out = match & loadEnable;

always @ (posedge clk or negedge reset) begin
	if(~reset)
		data_to_bus <= 16'dz;
	else if(match & outputEnable & ~outputDisable)
		data_to_bus <= data_from_storage;
	else
		data_to_bus <= 16'dz;
end

endmodule

