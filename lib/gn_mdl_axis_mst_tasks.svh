// ------------------------------------------------------------
// File    : gn_mdl_axis_mst_taskd.svh
// Author  : jin820
// Created : 2026-01-01
// Updated :
// History:
// 2026-01-01  Initial version
// ------------------------------------------------------------

task automatic init ();
    begin
        tx_axis_tdata  <= '0;
        tx_axis_tvalid <= 1'b0;
    end
endtask

task automatic send_word (
    input logic [31:0] data
);

    begin
        tx_axis_tdata  <= data;
        tx_axis_tvalid <= 1'b1;

        @(posedge clk);
        while (!tx_axis_tready) begin
            @(posedge clk);
        end

        tx_axis_tvalid <= 1'b0;
    end
endtask
