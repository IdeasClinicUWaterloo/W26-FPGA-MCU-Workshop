// main top module for hdmi pong on the c5g board with adv7513 transmitter
// key0/key1 = player 1 up/down, key2/key3 = player 2 up/down
// reset is moved to the cpu_reset_n pushbutton

`timescale 1 ps / 1 ps

module hdmi_top (
    input  wire        clk_50,        // 50 mhz main board clock
    input  wire        cpu_reset_n,   // pushbutton reset, active-low

    input  wire        key0_n,        // p1 up (active-low)
    input  wire        key1_n,        // p1 down (active-low)
    input  wire        key2_n,        // p2 up (active-low)
    input  wire        key3_n,        // p2 down (active-low)

    output wire [23:0] hdmi_tx_d,     // rgb pixel data
    output wire        hdmi_tx_de,    // data enable
    output wire        hdmi_tx_hs,    // horizontal sync
    output wire        hdmi_tx_vs,    // vertical sync
    output wire        hdmi_tx_clk,   // pixel clock

    inout  wire        i2c_sda,       // i2c data for adv7513
    output wire        i2c_scl        // i2c clock for adv7513
);

    // turn the active-low button into active-high reset
    wire reset = ~cpu_reset_n;

    // pll to turn the 50 mhz input into 74.25 mhz for 720p video
    wire clk_pixel, pll_locked;
    pll_74mhz pll_inst (
        .refclk   (clk_50),
        .rst      (reset),
        .outclk_0 (clk_pixel),
        .locked   (pll_locked)
    );

    // video timing generator for 1280x720 at 60hz
    wire [11:0] hcount, vcount;
    wire        hsync, vsync, de, frame_start;
    video_timing timing_inst (
        .clk         (clk_pixel),
        .reset       (~pll_locked), // hold in reset until pll is locked
        .hcount      (hcount),      // current horizontal pixel position
        .vcount      (vcount),      // current vertical line position
        .hsync       (hsync),       // hsync signal
        .vsync       (vsync),       // vsync signal
        .de          (de),          // data enable signal
        .frame_start (frame_start)  // pulse at start of each frame
    );

    // main pong game logic
    wire [10:0] p1_y, p2_y;   // paddle positions (top y coordinate)
    wire [10:0] ball_x, ball_y; // ball position
    wire [3:0]  score_l, score_r; // scores
    pong_logic #(
        .H_ACTIVE(1280), .V_ACTIVE(720) // match the resolution
    ) game (
        .clk         (clk_pixel),
        .reset       (~pll_locked | reset), // reset if pll not locked or button pressed
        .frame_start (frame_start),         // update game state each frame
        .p1_up       (~key2_n),             // player 1 up button (active high inside)
        .p1_dn       (~key3_n),             // player 1 down button
        .p2_up       (~key0_n),             // player 2 up button
        .p2_dn       (~key1_n),             // player 2 down button
        .p1_y        (p1_y),
        .p2_y        (p2_y),
        .ball_x      (ball_x),
        .ball_y      (ball_y),
        .score_l     (score_l),
        .score_r     (score_r)
    );

    // renderer turns game state into rgb pixels
    renderer #(
        .H_ACTIVE(1280), .V_ACTIVE(720)
    ) draw (
        .hcount   (hcount),
        .vcount   (vcount),
        .de       (de),
        .p1_y     (p1_y),
        .p2_y     (p2_y),
        .ball_x   (ball_x),
        .ball_y   (ball_y),
        .score_l  (score_l),
        .score_r  (score_r),
        .rgb      (hdmi_tx_d) // output rgb pixels
    );

    // connect sync/data signals directly to hdmi outputs
    assign hdmi_tx_de  = de;
    assign hdmi_tx_hs  = hsync;
    assign hdmi_tx_vs  = vsync;
    assign hdmi_tx_clk = clk_pixel;

    // configure the adv7513 transmitter over i2c
    i2c_config config_inst (
        .clk   (clk_pixel),
        .reset (~pll_locked | reset),
        .scl   (i2c_scl),
        .sda   (i2c_sda)
    );
endmodule
