// ------------------------------------------------------------
// File    : gn_mdl_axis_mst_taskd.svh
// Author  : jin820
// Created : 2026-01-01
// Updated :
// History:
// 2026-01-01  Initial version
// 2026-01-04  Add a sending task
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

        // post process
        tx_axis_tvalid <= 1'b0;
    end
endtask


task automatic send_words_fixed (
     input logic [31:0] data
    ,input int unsigned num_words
);
    int unsigned count;

    begin
        count = 0;
        if (num_words == 0) begin
            return;
        end

        while (count < num_words-1) begin
            @(posedge clk);
            tx_axis_tvalid <= 1'b1;
            tx_axis_tdata  <= data;
            if (tx_axis_tvalid && tx_axis_tready) begin
                count++;
            end
        end

        // post process
        @(posedge clk);
        tx_axis_tvalid <= 1'b0;
    end
endtask


// generate random date
task automatic send_words_random(
    input int unsigned num_words
);
    int unsigned count;

    begin
        count = 0;
        if (num_words == 0) return;

        while (count < num_words-1) begin
            @(posedge clk);

            tx_axis_tvalid <= 1'b1;
            tx_axis_tdata  <=  $urandom;

            if (tx_axis_tvalid && tx_axis_tready) begin
                count++;
            end
        end

        @(posedge clk);
        tx_axis_tvalid <= 1'b0;
    end
endtask

task automatic send_file(
    input string filename,              // Text file to read
    input int unsigned tdata_width,     // AXI4-Stream data width (<=32 assumed)
    input int unsigned max_words = 256  // Maximum number of words to send
);
    int unsigned count;                 // Number of transmitted words
    int          file;                  // File descriptor
    string       line;                  // One line buffer
    logic [31:0] value32;               // Parsed 32-bit value from file
    logic [31:0] tdata_tmp;             // Data to be driven on AXI stream
    logic        have_word;             // Indicates buffered data is valid
    logic        done;                  // End-of-file or termination flag

    begin
        // Initialize internal state
        count     = 0;
        have_word = 0;
        done      = 0;

        // Initialize AXI-Stream signals (blocking assignment for TB driving)
        tx_axis_tvalid = 1'b0;
        tx_axis_tdata  = '0;

        // Open input text file
        file = $fopen(filename, "r");
        if (file == 0) begin
            $display("ERROR: Cannot open file '%s'", filename);
            disable send_file;
        end

        // Main transmit loop
        while (!done) begin
            // Stop if maximum word count is reached
            if (count >= max_words)
                break;

            // Load next data word from file if no buffered word exists
            if (!have_word) begin
                bit got = 0;
                while (!got) begin
                    // fgets returns 0 on EOF
                    if ($fgets(line, file) == 0) begin
                        done = 1;       // EOF confirmed
                        break;
                    end

                    // Skip empty lines or line breaks
                    if (line.len() == 0)   continue;
                    if (line == "\n")      continue;
                    if (line == "\r\n")    continue;

                    // Parse hexadecimal value; skip invalid lines
                    if ($sscanf(line, "%h", value32) != 1)
                        continue;

                    // Apply zero-padding or masking based on data width
                    if (tdata_width < 32)
                        tdata_tmp = value32 & ((32'h1 << tdata_width) - 1);
                    else
                        tdata_tmp = value32;

                    have_word = 1;          // Data is ready to transmit
                    got       = 1;
                end
            end

            // Exit if no more data is available
            if (done || !have_word)
                break;

            // ===== AXI4-Stream transmission (posedge only) =====
            @(posedge clk);

            // Drive valid and data using blocking assignment
            // This guarantees data is stable within the same clock edge
            tx_axis_tvalid = 1'b1;
            tx_axis_tdata  = tdata_tmp;

            // Check handshake completion in the same cycle
            if (tx_axis_tready) begin
                count++;                // One word successfully transferred
                have_word = 0;          // Fetch next word from file
            end
            // If tready is low, keep the same data and retry next cycle
        end

        // Deassert AXI-Stream signals after completion
        @(posedge clk);
        tx_axis_tvalid = 1'b0;
        tx_axis_tdata  = '0;
        @(posedge clk);

        // Close file and report result
        $fclose(file);
        $display("INFO: Sent %0d words from '%s'", count, filename);
    end
endtask

