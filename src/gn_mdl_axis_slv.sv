// ------------------------------------------------------------
// File    : gn_mdl_axis_slv.sv
// Author  : jin820
// Created : 2026-01-01
// Updated :
// History:
// 2026-01-01  Initial version
// 2025-01-05  Added fluctuation function
// ------------------------------------------------------------

module gn_mdl_axis_slv #(
     parameter P_DWIDTH                 = 32'd32
    ,parameter P_MAX_WORDS              = 32'd256
    ,parameter int P_TRDY_MIN_CYC       = 1
    ,parameter int P_TRDY_MAX_CYC       = 8
    ,parameter int P_TRDY_ASSERT_PCT    = 100
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
    int tready_cnt;


    always @(posedge clk) begin
        if (!reset_n) begin
            rx_axis_tready  <= 1'b0;
        end else begin
            if (tready_cnt == 0) begin
                rx_axis_tready <= ($urandom_range(0,99) < P_TRDY_ASSERT_PCT);
            end
        end
    end

    always @(posedge clk) begin
        if (!reset_n) begin
            tready_cnt      <= 0;
        end else begin
            if (tready_cnt == 0) begin
                tready_cnt <= $urandom_range(P_TRDY_MIN_CYC, P_TRDY_MAX_CYC);
            end else begin
                tready_cnt <= tready_cnt - 1;
            end
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
