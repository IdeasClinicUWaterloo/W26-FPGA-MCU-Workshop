// draws one digit (0–9) using an 8x12 pixel bitmap
// top-left corner of the digit is placed at (X0, Y0)
module score_draw #(parameter X0=0, Y0=0) (
    input  wire [11:0] x,      // current pixel x from video_timing
    input  wire [11:0] y,      // current pixel y from video_timing
    input  wire [3:0]  digit,  // digit to draw (0–9)
    output wire        pix     // 1 if this pixel should be lit
);

    // are we inside the 8x12 cell for this digit?
    wire in_cell = (x >= X0) && (x < X0 + 8) &&
                   (y >= Y0) && (y < Y0 + 12);

    // column index inside the digit (0..7)
    wire [3:0] col = x - X0;
    // row index inside the digit (0..11)
    wire [3:0] row = y - Y0;

    reg [7:0] row_bits; // bitmap bits for the current row (bit 7 = leftmost)

    always @(*) begin
        // default row bits = all off
        row_bits = 8'h00;

        // pick the right bitmap for this digit, and then pick the right row
        case (digit)
            // digit 0
            4'd0: case (row)
                0:row_bits=8'b00111100;  1:row_bits=8'b01100110;
                2:row_bits=8'b01100110;  3:row_bits=8'b01100110;
                4:row_bits=8'b01100110;  5:row_bits=8'b01100110;
                6:row_bits=8'b01100110;  7:row_bits=8'b01100110;
                8:row_bits=8'b01100110;  9:row_bits=8'b01100110;
               10:row_bits=8'b01100110; 11:row_bits=8'b00111100;
                default: row_bits=8'h00;
            endcase

            // digit 1
            4'd1: case (row)
                0:row_bits=8'b00011000;  1:row_bits=8'b00111000;
                2:row_bits=8'b00011000;  3:row_bits=8'b00011000;
                4:row_bits=8'b00011000;  5:row_bits=8'b00011000;
                6:row_bits=8'b00011000;  7:row_bits=8'b00011000;
                8:row_bits=8'b00011000;  9:row_bits=8'b00011000;
               10:row_bits=8'b00011000; 11:row_bits=8'b00111100;
                default: row_bits=8'h00;
            endcase

            // digit 2
            4'd2: case (row)
                0:row_bits=8'b00111100;  1:row_bits=8'b01100110;
                2:row_bits=8'b00000110;  3:row_bits=8'b00001100;
                4:row_bits=8'b00011000;  5:row_bits=8'b00110000;
                6:row_bits=8'b01100000;  7:row_bits=8'b01000000;
                8:row_bits=8'b01000000;  9:row_bits=8'b01000000;
               10:row_bits=8'b01111110; 11:row_bits=8'b01111110;
                default: row_bits=8'h00;
            endcase

            // digit 3
            4'd3: case (row)
                0:row_bits=8'b00111100;  1:row_bits=8'b01100110;
                2:row_bits=8'b00000110;  3:row_bits=8'b00000110;
                4:row_bits=8'b00011100;  5:row_bits=8'b00011100;
                6:row_bits=8'b00000110;  7:row_bits=8'b00000110;
                8:row_bits=8'b00000110;  9:row_bits=8'b01100110;
               10:row_bits=8'b01100110; 11:row_bits=8'b00111100;
                default: row_bits=8'h00;
            endcase

            // digit 4
            4'd4: case (row)
                0:row_bits=8'b00001100;  1:row_bits=8'b00011100;
                2:row_bits=8'b00101100;  3:row_bits=8'b01001100;
                4:row_bits=8'b10001100;  5:row_bits=8'b11111110;
                6:row_bits=8'b11111110;  7:row_bits=8'b00001100;
                8:row_bits=8'b00001100;  9:row_bits=8'b00001100;
               10:row_bits=8'b00001100; 11:row_bits=8'b00011110;
                default: row_bits=8'h00;
            endcase

            // digit 5
            4'd5: case (row)
                0:row_bits=8'b01111110;  1:row_bits=8'b01111110;
                2:row_bits=8'b01100000;  3:row_bits=8'b01100000;
                4:row_bits=8'b00111100;  5:row_bits=8'b00000110;
                6:row_bits=8'b00000110;  7:row_bits=8'b00000110;
                8:row_bits=8'b00000110;  9:row_bits=8'b01100110;
               10:row_bits=8'b01100110; 11:row_bits=8'b00111100;
                default: row_bits=8'h00;
            endcase

            // digit 6
            4'd6: case (row)
                0:row_bits=8'b00111100;  1:row_bits=8'b01100110;
                2:row_bits=8'b01100000;  3:row_bits=8'b01100000;
                4:row_bits=8'b01111100;  5:row_bits=8'b01100110;
                6:row_bits=8'b01100110;  7:row_bits=8'b01100110;
                8:row_bits=8'b01100110;  9:row_bits=8'b01100110;
               10:row_bits=8'b01100110; 11:row_bits=8'b00111100;
                default: row_bits=8'h00;
            endcase

            // digit 7
            4'd7: case (row)
                0:row_bits=8'b01111110;  1:row_bits=8'b01111110;
                2:row_bits=8'b00000110;  3:row_bits=8'b00001100;
                4:row_bits=8'b00011000;  5:row_bits=8'b00110000;
                6:row_bits=8'b00110000;  7:row_bits=8'b00110000;
                8:row_bits=8'b00110000;  9:row_bits=8'b00110000;
               10:row_bits=8'b00110000; 11:row_bits=8'b00110000;
                default: row_bits=8'h00;
            endcase

            // digit 8
            4'd8: case (row)
                0:row_bits=8'b00111100;  1:row_bits=8'b01100110;
                2:row_bits=8'b01100110;  3:row_bits=8'b01100110;
                4:row_bits=8'b00111100;  5:row_bits=8'b00111100;
                6:row_bits=8'b01100110;  7:row_bits=8'b01100110;
                8:row_bits=8'b01100110;  9:row_bits=8'b01100110;
               10:row_bits=8'b01100110; 11:row_bits=8'b00111100;
                default: row_bits=8'h00;
            endcase

            // digit 9
            4'd9: case (row)
                0:row_bits=8'b00111100;  1:row_bits=8'b01100110;
                2:row_bits=8'b01100110;  3:row_bits=8'b01100110;
                4:row_bits=8'b01100110;  5:row_bits=8'b00111110;
                6:row_bits=8'b00000110;  7:row_bits=8'b00000110;
                8:row_bits=8'b00000110;  9:row_bits=8'b00000110;
               10:row_bits=8'b01100110; 11:row_bits=8'b00111100;
                default: row_bits=8'h00;
            endcase

            // anything else defaults to blank
            default: row_bits = 8'h00;
        endcase
    end

    // choose the correct bit from row_bits (bit 7 is leftmost column)
    assign pix = in_cell ? row_bits[7 - col] : 1'b0;
endmodule
