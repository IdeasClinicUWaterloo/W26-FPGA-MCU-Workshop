// generates timing signals for a 1280x720 @ 60hz video output
// also gives you a one-tick 'frame_start' pulse at the top-left pixel

module video_timing (
    input  wire clk,        // pixel clock (74.25 mhz for 720p)
    input  wire reset,      // resets counters back to zero
    output reg  [11:0] hcount, // current horizontal pixel position
    output reg  [11:0] vcount, // current vertical line position
    output reg  hsync,      // horizontal sync signal
    output reg  vsync,      // vertical sync signal
    output reg  de,         // data enable (high when inside visible area)
    output reg  frame_start // 1 clock tick at start of frame
);

    // visible horizontal pixels
    parameter H_ACTIVE = 1280;
    // front porch: idle pixels after active area, before sync pulse
    parameter H_FP     = 110;
    // horizontal sync pulse width
    parameter H_SYNC   = 40;
    // back porch: idle pixels after sync, before visible area starts
    parameter H_BP     = 220;
    // total pixels per line = active + porches + sync
    localparam H_TOTAL = H_ACTIVE + H_FP + H_SYNC + H_BP;

    // same idea but vertical (in lines instead of pixels)
    parameter V_ACTIVE = 720;
    parameter V_FP     = 5;
    parameter V_SYNC   = 5;
    parameter V_BP     = 20;
    localparam V_TOTAL = V_ACTIVE + V_FP + V_SYNC + V_BP;

    // this always block steps through hcount/vcount every clock tick
    always @(posedge clk) begin
        if (reset) begin
            // if reset, go back to top-left
            hcount <= 0;
            vcount <= 0;
            frame_start <= 1'b0;
        end else begin
            // default: no frame_start unless we trigger it below
            frame_start <= 1'b0;

            // reached end of line?
            if (hcount == H_TOTAL-1) begin
                hcount <= 0; // wrap to start of line

                // reached end of frame?
                if (vcount == V_TOTAL-1) begin
                    vcount <= 0;      // wrap to first line
                    frame_start <= 1'b1; // pulse at top-left pixel
                end else begin
                    vcount <= vcount + 1; // next line
                end
            end else begin
                hcount <= hcount + 1; // move to next pixel in line
            end
        end
    end

    // this block makes the sync pulses and data enable
    always @(posedge clk) begin
        // hsync is high during horizontal sync range
        hsync <= (hcount >= H_ACTIVE + H_FP) &&
                 (hcount <  H_ACTIVE + H_FP + H_SYNC);

        // vsync is high during vertical sync range
        vsync <= (vcount >= V_ACTIVE + V_FP) &&
                 (vcount <  V_ACTIVE + V_FP + V_SYNC);

        // de (data enable) is high only inside active display area
        de    <= (hcount < H_ACTIVE) &&
                 (vcount < V_ACTIVE);
    end
endmodule
