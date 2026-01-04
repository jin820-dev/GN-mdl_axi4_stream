// ------------------------------------------------------------
// File    : gn_mdl_axis_slv_tasks.svh
// Author  : jin820
// Created : 2026-01-01
// Updated :
// History:
// 2026-01-01  Initial version
// ------------------------------------------------------------

task automatic rx_mdl_test ();
    $display ("Hello World recv");
endtask

task automatic check_rx_all(
    input byte golden[$]
);
    int i;

    if (i_mdl_axis_slv.rx_queue.size() != golden.size()) begin
        $error("SIZE MISMATCH exp=%0d got=%0d",
               golden.size(),
               i_mdl_axis_slv.rx_queue.size());
    end

    for (i = 0; i < golden.size(); i++) begin
        if (i_mdl_axis_slv.rx_queue[i] !== golden[i]) begin
            $error("MISMATCH[%0d] exp=%02h got=%02h",
                   i, golden[i], i_mdl_axis_slv.rx_queue[i]);
        end
    end
endtask
