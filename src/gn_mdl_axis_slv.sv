// ------------------------------------------------------------
// File    : gn_mdl_axis_slv.sv
// Author  : jin820
// Created : 2026-01-01
// Updated :
// History:
// 2026-01-01  Initial version
// ------------------------------------------------------------

module gn_mdl_axis_slv #(
    parameter P_DWIDTH    = 32'd32
   ,parameter P_MAX_WORDS = 32'd256
)(
     input  logic                   clk
    ,input  logic                   reset_n 
    ,input  logic [P_DWIDTH-1:0]    rx_axis_tdata 
    ,input  logic                   rx_axis_tvalid
    ,output logic                   rx_axis_tready
);

    // config time
    timeunit        1ps;
    timeprecision   1ps;

    // internal logic
    logic [P_DWIDTH-1:0] rx_queue[$];
    logic [P_DWIDTH-1:0] rx_shadow [0:P_MAX_WORDS-1];
    int rx_shadow_size;

    // gen tready
    always @(posedge clk) begin
        if (!reset_n) begin
            rx_axis_tready <= 1'b0;
        end else begin
            rx_axis_tready <= 1'b1;
        end
    end

    // capture tdata
    always @(posedge clk) begin
        if (!reset_n) begin
            rx_queue.delete();
        end else if (rx_axis_tvalid && rx_axis_tready) begin
            rx_queue.push_back(rx_axis_tdata);
            $display("[%0t] RX PUSH = 0x%02h (size=%0d)",
                     $time, rx_axis_tdata, rx_queue.size());
        end
    end

    // Show queue for sim
    always @(posedge clk) begin
        if (!reset_n) begin
            rx_shadow_size <= 0;
        end else if (rx_axis_tvalid && rx_axis_tready) begin
            rx_shadow[rx_shadow_size] <= rx_axis_tdata;
            rx_shadow_size <= rx_shadow_size + 1;
        end
    end

    `include "gn_mdl_axis_slv_tasks.svh"

endmodule
