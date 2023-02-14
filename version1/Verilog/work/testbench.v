module tb();

reg [15:0] data;
wire [15:0] dataBus;
reg [23:0] address;
reg loadEnable;
reg readEnable;

reg clk;
reg reset;

assign dataBus = data;

initial begin
	data <= 16'dz;
	address <= 24'h001000;
	reset = 0;
	clk <= 1;
	loadEnable <= 0;
	readEnable <= 0;
	
	#1 reset = 1;
end

wire [15:0] regOut;
wire loadEnable_io;
wire iomatch;

register testReg(
	.data_in(dataBus),
	.data_out(regOut),

	.load(loadEnable_io),
	.clear(reset),
	.clk(clk)
);

busSwitch #(
	.mask(24'hfff000),
	.comp(24'h03f000)
) ioBusSwitch (
	.address(address),
	.data(dataBus),
	.loadEnable(loadEnable),
	.outputEnable(readEnable),
	.clk(clk),
	.reset(reset),
	
	.data_from_storage(regOut),
	.load_out(loadEnable_io),
	.outputDisable(1'd0),
	.match(iomatch)
);

busSwitch #(
	.mask(24'hffc000),
	.comp(24'h03c000)
) romBusSwitch1 (
	.address(address),
	.data(dataBus),
	.loadEnable(loadEnable),
	.outputEnable(readEnable),
	.clk(clk),
	.reset(reset),
	
	.data_from_storage(16'd0),
	.load_out(),
	.outputDisable(iomatch),
	.match()
);





always @ (clk) #5 clk <= ~clk;

always @ (address) #10 address <= address + 24'h000100;

endmodule

