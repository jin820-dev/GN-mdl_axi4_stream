// ------------------------------------------------------------
// File    : gn_mdl_axis_mst.sv
// Author  : jin820
// Created : 2026-01-01
// Updated :
// History:
// 2026-01-01  Initial version
// ------------------------------------------------------------

module gn_mdl_axis_mst #(
    parameter P_DWIDTH = 32'd32
)(
     input  logic                 clk
    ,input  logic                 reset_n 
    ,output logic [P_DWIDTH-1:0]  tx_axis_tdata 
    ,output logic                 tx_axis_tvalid
    ,input  logic                 tx_axis_tready
);

    // config time
    timeunit        1ps;
    timeprecision   1ps;

    `include "gn_mdl_axis_mst_tasks.svh"

endmodule

