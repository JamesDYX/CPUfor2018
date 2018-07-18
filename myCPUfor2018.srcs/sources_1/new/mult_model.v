`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2017/08/08 20:31:40
// Design Name: 
// Module Name: mult_model
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module mult_model(
    input clk,
    input reset,
    input start,    //开始计算
    input mult_op,   //0: 无符号  1：有符号
    input [31:0] rs,
    input [31:0] rt,
    output reg result_ok,
    output [31:0] hi,   
    output [31:0] lo    
    );
    
    wire rs_symbol;     //0正 1负
    wire rt_symbol;
    assign rs_symbol = rs[31];
    assign rt_symbol = rt[31];
    
    reg local_op;
    reg local_start;
    reg [31:0] local_rs;
    reg [31:0] local_rt;
    reg [31:0] local_hi;
    reg [31:0] local_lo;
    
    always@(posedge clk)
        begin
            if(reset)
                begin
                    result_ok <= 0;
                    local_op <= 0;
                    local_start <= 0;
                    local_rs <= 32'd0;
                    local_rt <= 32'd0;
                    local_hi <= 32'd0;
                    local_lo <= 32'd0;
                end
            else if(start)
                begin
                    result_ok <= 0;
                    local_op <= mult_op;
                    local_start <= 1;
                    if(mult_op)
                        begin
                            local_rs <= rs[31] ? (~rs + 32'd1) : rs;
                            local_rt <= rt[31] ? (~rt + 32'd1) : rt;
                        end
                    else
                        begin
                            local_rs <= rs;
                            local_rt <= rt;
                        end
                end
            else if(local_start)
                begin
                    local_start <= 0;
                    result_ok <= 1;
                    {local_hi,local_lo} <= $unsigned(local_rs) * $unsigned(local_rt);
                end
            else
                begin
                     result_ok <= 0;
                end
        end
    
        assign {hi,lo} = ~local_op ? {local_hi,local_lo} :      //无符号
                    (rs_symbol == rt_symbol) ? {local_hi,local_lo} :      //有符号，符号相同
                    ~({local_hi,local_lo} - 64'd1);
    
endmodule
