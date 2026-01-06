// draws the pong paddles, ball, border, and the scores using a tiny 8x12 font
module renderer #(parameter H_ACTIVE=1280, V_ACTIVE=720) (
    input  wire [11:0] hcount,   // current pixel x from video_timing
    input  wire [11:0] vcount,   // current pixel y from video_timing
    input  wire        de,       // data enable: 1 when inside visible area
    input  wire [10:0] p1_y,     // paddle 1 top y
    input  wire [10:0] p2_y,     // paddle 2 top y
    input  wire [10:0] ball_x,   // ball x position
    input  wire [10:0] ball_y,   // ball y position
    input  wire [3:0]  score_l,  // left player's score
    input  wire [3:0]  score_r,  // right player's score
    output reg  [23:0] rgb       // rgb pixel output (8 bits each channel)
);

    // object sizes / positions
    localparam PADDLE_H = 100;                              // paddle height
    localparam PADDLE_W = 12;                               // paddle width
    localparam BALL_S   = 10;                               // ball size
    localparam integer P1_X = 40;                           // p1 paddle x
    localparam integer P2_X = H_ACTIVE - 40 - PADDLE_W;     // p2 paddle x
    localparam integer BORDER = 8;                          // border thickness

    // detect if current pixel is in the border area
    wire on_border =
        (hcount < BORDER) || (hcount >= H_ACTIVE - BORDER) || // left/right edges
        (vcount < BORDER) || (vcount >= V_ACTIVE - BORDER);   // top/bottom edges

    // detect if current pixel is inside p1 paddle
    wire on_p1 = (hcount >= P1_X) && (hcount < P1_X + PADDLE_W) &&
                 (vcount >= p1_y) && (vcount < p1_y + PADDLE_H);

    // detect if current pixel is inside p2 paddle
    wire on_p2 = (hcount >= P2_X) && (hcount < P2_X + PADDLE_W) &&
                 (vcount >= p2_y) && (vcount < p2_y + PADDLE_H);

    // detect if current pixel is inside ball
    wire on_ball = (hcount >= ball_x) && (hcount < ball_x + BALL_S) &&
                   (vcount >= ball_y) && (vcount < ball_y + BALL_S);

    // draw scores using an 8x12 font
    // each score_draw instance says whether the current pixel should be lit
    wire pix_score_l, pix_score_r;
    score_draw #(.X0( (H_ACTIVE/2)-60 ), .Y0(20)) drawL (
        .x(hcount), .y(vcount), .digit(score_l), .pix(pix_score_l)
    );
    score_draw #(.X0( (H_ACTIVE/2)+36 ), .Y0(20)) drawR (
        .x(hcount), .y(vcount), .digit(score_r), .pix(pix_score_r)
    );

    // combinational: decide the color for the current pixel
    always @(*) begin
        if (!de)                          rgb = 24'h000000; // outside visible area = black
        else if (on_border)               rgb = 24'hFFFFFF; // white border
        else if (pix_score_l | pix_score_r) rgb = 24'hFFFFFF; // white score digits
        else if (on_p1 | on_p2)           rgb = 24'hFFFFFF; // white paddles
        else if (on_ball)                 rgb = 24'hFFFF00; // yellow ball
        else                              rgb = 24'h000040; // dark blue background
    end
endmodule
