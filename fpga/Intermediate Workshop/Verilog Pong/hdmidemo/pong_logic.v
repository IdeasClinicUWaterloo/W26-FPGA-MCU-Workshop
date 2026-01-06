module pong_logic #(parameter H_ACTIVE=1280, V_ACTIVE=720) (
    input  wire        clk,
    input  wire        reset,        // active-high sync reset
    input  wire        frame_start,  // 1 tick each frame from video_timing
    input  wire        p1_up, p1_dn, // player 1 controls
    input  wire        p2_up, p2_dn, // player 2 controls
    output reg  [10:0] p1_y,         // paddle 1 top y
    output reg  [10:0] p2_y,         // paddle 2 top y
    output reg  [10:0] ball_x,       // ball x position
    output reg  [10:0] ball_y,       // ball y position
    output reg  [3:0]  score_l,      // left score (p1)
    output reg  [3:0]  score_r       // right score (p2)
);
    // --- constants ---
    localparam PADDLE_H = 100;                // paddle height in px
    localparam PADDLE_W = 12;                 // paddle width in px
    localparam BALL_S   = 10;                 // ball size (square)
    localparam integer P1_X = 40;             // p1 paddle x position
    localparam integer P2_X = H_ACTIVE - 40 - PADDLE_W; // p2 paddle x

    // simple game state machine
    localparam ST_PLAY  = 2'd0;  // ball moving, normal play
    localparam ST_SERVE = 2'd1;  // pause at center before serve

    reg [1:0] state;             // current game state
    reg [7:0] serve_cnt;         // small countdown before serving

    // velocities (signed so we can go left/right, up/down)
    reg signed [10:0] vx, vy;        // current velocities
    reg signed [10:0] vx_next, vy_next; // velocity to use after serve

    // helper: clamp vy so it never becomes zero or too large
    function integer clamp_vy;
        input integer v;
        begin
            if (v == 0)            v = 2;     // avoid perfectly flat bounces
            if (v > 7)             v = 7;     // cap up speed
            if (v < -7)            v = -7;    // cap down speed
            if (v > -1 && v < 1)   v = (v >= 0) ? 2 : -2; // nudge tiny values
            clamp_vy = v;
        end
    endfunction

    always @(posedge clk) begin
        if (reset) begin
            // on reset, center paddles and ball, set starting speeds and state
            p1_y     <= (V_ACTIVE-PADDLE_H)/2;
            p2_y     <= (V_ACTIVE-PADDLE_H)/2;
            ball_x   <= H_ACTIVE/2;
            ball_y   <= V_ACTIVE/2;
            vx       <= 11'sd4;        // default horizontal speed
            vy       <= 11'sd3;        // default vertical speed
            vx_next  <= 11'sd4;        // next serve goes to the right
            vy_next  <= 11'sd2;
            score_l  <= 4'd0;
            score_r  <= 4'd0;
            state    <= ST_SERVE;      // start in serve state
            serve_cnt<= 8'd40;         // ~2/3 sec @ 60 fps
        end else if (frame_start) begin
            // update only once per frame for consistent motion
            integer p1y_n, p2y_n; // proposed next paddle positions
            integer bx_n, by_n;   // proposed next ball position
            integer vx_n, vy_n;   // proposed next velocities
            integer nx, ny;       // tentative next ball pos (pre-collisions)

            // default next values = current values
            p1y_n = p1_y;  p2y_n = p2_y;
            bx_n  = ball_x; by_n  = ball_y;
            vx_n  = vx;     vy_n  = vy;

            // paddle movement with simple saturation (no out-of-bounds)
            if (p1_up)
                p1y_n = (p1y_n >= 6) ? (p1y_n - 6) : 0;
            else if (p1_dn)
                p1y_n = (p1y_n <= V_ACTIVE - PADDLE_H - 6) ? (p1y_n + 6) : (V_ACTIVE - PADDLE_H);

            if (p2_up)
                p2y_n = (p2y_n >= 6) ? (p2y_n - 6) : 0;
            else if (p2_dn)
                p2y_n = (p2y_n <= V_ACTIVE - PADDLE_H - 6) ? (p2y_n + 6) : (V_ACTIVE - PADDLE_H);

            case (state)
                // ----------------- serve: hold ball at center, short delay -----------------
                ST_SERVE: begin
                    bx_n = H_ACTIVE/2;   // keep ball centered
                    by_n = V_ACTIVE/2;

                    if (serve_cnt != 0) begin
                        // still counting down, keep ball stopped
                        serve_cnt <= serve_cnt - 8'd1;
                        vx_n = 0; vy_n = 0;
                    end else begin
                        // countdown finished: launch the ball with preset velocity
                        vx_n = vx_next;
                        vy_n = vy_next;
                        state <= ST_PLAY;
                    end

                    // commit state for this frame
                    p1_y   <= p1y_n;      p2_y   <= p2y_n;
                    ball_x <= bx_n[10:0]; ball_y <= by_n[10:0];
                    vx     <= vx_n[10:0]; vy     <= vy_n[10:0];
                end

                // ----------------- play: regular movement, collisions, scoring -----------------
                default: begin // ST_PLAY
                    // tentative next position
                    nx = bx_n + vx_n;
                    ny = by_n + vy_n;

                    // bounce off top and bottom (snap just inside to avoid sticking)
                    if (ny < 0) begin
                        ny   = 1;
                        vy_n = -vy_n;
                    end else if (ny + BALL_S > V_ACTIVE) begin
                        ny   = V_ACTIVE - BALL_S - 1;
                        vy_n = -vy_n;
                    end

                    // left paddle collision (only matters if ball moving left)
                    if (vx_n < 0 &&
                        nx <= P1_X + PADDLE_W && nx + BALL_S >= P1_X &&
                        ny + BALL_S >= p1y_n && ny <= p1y_n + PADDLE_H) begin
                        nx   = P1_X + PADDLE_W + 1; // push ball just outside paddle
                        vx_n = -vx_n;               // reflect horizontally
                        // add a bit of spin/english based on paddle motion
                        if (p1_up) vy_n = vy_n - 1;
                        if (p1_dn) vy_n = vy_n + 1;
                    end

                    // right paddle collision (only if ball moving right)
                    if (vx_n > 0 &&
                        nx + BALL_S >= P2_X && nx <= P2_X + PADDLE_W &&
                        ny + BALL_S >= p2y_n && ny <= p2y_n + PADDLE_H) begin
                        nx   = P2_X - BALL_S - 1;
                        vx_n = -vx_n;
                        if (p2_up) vy_n = vy_n - 1;
                        if (p2_dn) vy_n = vy_n + 1;
                    end

                    // keep vertical speed reasonable and non-zero
                    vy_n = clamp_vy(vy_n);

                    // -------- scoring (ball passed beyond edges) ----------
                    if (nx < 0) begin
                        // right player scores
                        if (score_r == 9) begin
                            // hit 10: reset both scores (simple race-to-10)
                            score_r  <= 4'd0;
                            score_l  <= 4'd0;
                        end else begin
                            score_r  <= score_r + 1;
                        end

                        state     <= ST_SERVE;
                        serve_cnt <= 8'd40;

                        // reset ball to center and stop; next serve heads right
                        bx_n = H_ACTIVE/2; by_n = V_ACTIVE/2; vx_n = 0; vy_n = 0;
                        vx_next = 11'sd4;  vy_next = 11'sd2;
                    end
                    else if (nx + BALL_S > H_ACTIVE) begin
                        // left player scores
                        if (score_l == 9) begin
                            score_r  <= 4'd0;
                            score_l  <= 4'd0;
                        end else begin
                            score_l  <= score_l + 1;
                        end

                        state     <= ST_SERVE;
                        serve_cnt <= 8'd40;

                        bx_n = H_ACTIVE/2; by_n = V_ACTIVE/2; vx_n = 0; vy_n = 0;
                        vx_next = -11'sd4; vy_next =  11'sd2; // next serve heads left
                    end
                    else begin
                        // normal move: accept the tentative next pos
                        bx_n = nx; by_n = ny;
                    end

                    // commit for this frame
                    p1_y   <= p1y_n;      p2_y   <= p2y_n;
                    ball_x <= bx_n[10:0]; ball_y <= by_n[10:0];
                    vx     <= vx_n[10:0]; vy     <= vy_n[10:0];
                end
            endcase
        end
    end
endmodule
