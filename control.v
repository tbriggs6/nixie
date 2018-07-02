module control(clk, setpoint, actual, adcready, pwm);
				                         
	input clk;
	input [9:0] setpoint;
	input [9:0] actual;
	input adcready;
	output pwm;
					                         
	wire clk;
	wire [9:0] setpoint, actual;
	wire adcready;
	wire pwm;

        
    reg [9:0] time_on;
	reg [9:0] count;
	
	initial begin
		time_on <= 900;
		count <= 0;
	end
	
	always @(posedge clk) begin
                        
		if (count == 1000) begin
			count <= 0;
		end
		else begin
			count <= count + 1;
		end
	end
	
	assign pwm = (count < time_on) ? 1 : 0;
	
		
	always @(posedge adcready) begin                           
		                                                
		if (time_on >= 990) begin
			time_on <= 990;
		end else if (time_on <= 70) begin
			time_on <= 70;
		end else if (actual < setpoint) begin
			time_on <= time_on + (setpoint - actual);
		end else if (actual > setpoint) begin
			time_on <= time_on - (actual - setpoint);
		end
	end		 		                                               

	always @(time_on) begin
		$display("New duty cycle: %d / %f\n", time_on, (time_on * 100.0) / 1000.0);
	end

endmodule