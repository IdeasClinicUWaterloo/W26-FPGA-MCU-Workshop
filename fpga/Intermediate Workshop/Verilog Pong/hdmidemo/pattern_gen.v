// pattern_gen.v — white border, blue fill
module pattern_gen (
    input  wire [11:0] hcount,  // 0..1279 in active
    input  wire [11:0] vcount,  // 0..719  in active
    output reg  [23:0] rgb
);
    // Active area
    localparam H_ACTIVE = 1280;
    localparam V_ACTIVE = 720;

    // Border thickness in pixels
    localparam integer BORDER = 8;

    wire in_active = (hcount < H_ACTIVE) && (vcount < V_ACTIVE);

    wire on_border =
        (hcount < BORDER) || (hcount >= H_ACTIVE - BORDER) ||
        (vcount < BORDER) || (vcount >= V_ACTIVE - BORDER);

    always @(*) begin
        if (!in_active) begin
            rgb = 24'h000000;          // black outside active (DE=0 anyway)
        end else if (on_border) begin
            rgb = 24'hFFFFFF;          // white border
        end else begin
            rgb = 24'hFF00FF;          // blue interior
        end
    end
endmodule
