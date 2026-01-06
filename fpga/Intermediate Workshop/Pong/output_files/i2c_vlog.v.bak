module i2c_config (
    input  wire clk,     // 74.25 mhz pixel clock
    input  wire reset,   // active-high reset
    output wire scl,     // i2c clock line (push-pull, but board has pull-ups)
    inout  wire sda      // i2c data line (open-drain style)
);

    
    // timing setup

    parameter integer CLK_HZ  = 74250000;  // clock speed coming in
    parameter integer I2C_HZ  = 100000;    // target i2c speed (100 khz)
    // scl toggles every DIV ticks, so full period = 2*DIV ticks
    parameter integer DIV     = (CLK_HZ/(I2C_HZ*2)); // ~371 for 74.25 mhz

    // adv7513's i2c write address: 7-bit 0x39 => 8-bit 0x72 for write
    localparam [7:0] I2C_ADDR_WR = 8'h72;

    
    // init table (register address + data value)

    localparam N_PAIRS = 3; // how many reg/data pairs to send
    reg [7:0] reg_addr [0:N_PAIRS-1];
    reg [7:0] reg_data [0:N_PAIRS-1];

    // fill the table
    initial begin
        reg_addr[0] = 8'h41; reg_data[0] = 8'h10; // power up
        reg_addr[1] = 8'h15; reg_data[1] = 8'h01; // rgb 4:4:4 + de/hs/vs pins
        reg_addr[2] = 8'hAF; reg_data[2] = 8'h06; // hdmi mode enable
    end


    // open-drain sda + push-pull scl
 
    reg scl_r;               // actual driven scl line
    reg sda_drive_low;       // when 1, drive sda low; when 0, release (hi-z)
    assign scl = scl_r;
    assign sda = sda_drive_low ? 1'b0 : 1'bz;
    wire sda_in = sda;       // read current level on sda


    // clock divider to create a 'tick' at half scl period
  
    reg [15:0] div_cnt;
    reg        tick; // goes high for 1 clk cycle every half scl period

    always @(posedge clk) begin
        if (reset) begin
            div_cnt <= 16'd0;
            tick    <= 1'b0;
        end else begin
            if (div_cnt == DIV-1) begin
                div_cnt <= 16'd0;
                tick    <= 1'b1; // time to advance i2c state machine
            end else begin
                div_cnt <= div_cnt + 16'd1;
                tick    <= 1'b0;
            end
        end
    end

  
    // simple i2c state machine for: START -> send 3 bytes -> STOP

    localparam ST_IDLE       = 4'd0;
    localparam ST_START1     = 4'd1;
    localparam ST_START2     = 4'd2;
    localparam ST_LOAD_BYTE  = 4'd3;
    localparam ST_BIT_LOW    = 4'd4;
    localparam ST_BIT_HIGH   = 4'd5;
    localparam ST_BIT_DONE   = 4'd6;
    localparam ST_ACK_LOW    = 4'd7;
    localparam ST_ACK_HIGH   = 4'd8;
    localparam ST_ACK_DONE   = 4'd9;
    localparam ST_STOP1      = 4'd10;
    localparam ST_STOP2      = 4'd11;
    localparam ST_NEXT_BYTE  = 4'd12;
    localparam ST_NEXT_PAIR  = 4'd13;
    localparam ST_DONE       = 4'd14;

    reg [3:0] state;         // current fsm state
    reg [7:0] tx_byte;       // current byte being shifted out
    reg [3:0] bit_cnt;       // counts down from 7 to 0 for each bit
    reg [1:0] byte_idx;      // which byte in the write (0=addr, 1=reg, 2=data)
    reg [7:0] pair_idx;      // which reg/data pair in init table

    // shortcut wires to current reg/data
    wire [7:0] cur_reg  = reg_addr[pair_idx];
    wire [7:0] cur_data = reg_data[pair_idx];

    // main state machine

    always @(posedge clk) begin
        if (reset) begin
            // reset everything to idle
            state         <= ST_IDLE;
            scl_r         <= 1'b1;  // scl high
            sda_drive_low <= 1'b0;  // sda released
            bit_cnt       <= 4'd7;
            byte_idx      <= 2'd0;
            pair_idx      <= 8'd0;
            tx_byte       <= 8'h00;
        end else begin
            if (tick) begin // only step on tick pulses
                case (state)

                    // bus idle, get ready to send addr/reg/data
                    ST_IDLE: begin
                        scl_r         <= 1'b1;
                        sda_drive_low <= 1'b0;
                        bit_cnt       <= 4'd7;
                        byte_idx      <= 2'd0;
                        state         <= ST_START1;
                    end

                    // start condition: sda high -> low while scl high
                    ST_START1: begin
                        sda_drive_low <= 1'b1;
                        state         <= ST_START2;
                    end

                    // pull scl low to start bit transfer phase
                    ST_START2: begin
                        scl_r   <= 1'b0;
                        state   <= ST_LOAD_BYTE;
                    end

                    // load the byte we’re about to send
                    ST_LOAD_BYTE: begin
                        case (byte_idx)
                            2'd0: tx_byte <= I2C_ADDR_WR; // device address (write)
                            2'd1: tx_byte <= cur_reg;     // register address
                            default: tx_byte <= cur_data; // data value
                        endcase
                        state   <= ST_BIT_LOW;
                    end

                    // scl low: set sda to the current bit
                    ST_BIT_LOW: begin
                        sda_drive_low <= (tx_byte[bit_cnt] == 1'b0);
                        state         <= ST_BIT_HIGH;
                    end

                    // scl high: clock the bit into the slave
                    ST_BIT_HIGH: begin
                        scl_r  <= 1'b1;
                        state  <= ST_BIT_DONE;
                    end

                    // scl low again: move to next bit or ack
                    ST_BIT_DONE: begin
                        scl_r <= 1'b0;
                        if (bit_cnt != 0) begin
                            bit_cnt <= bit_cnt - 4'd1;
                            state   <= ST_BIT_LOW; // send next bit
                        end else begin
                            // done sending 8 bits: release sda for ack
                            sda_drive_low <= 1'b0;
                            state         <= ST_ACK_LOW;
                        end
                    end

                    // ack phase: scl low, sda released
                    ST_ACK_LOW: begin
                        scl_r  <= 1'b1;   // raise scl to sample ack
                        state  <= ST_ACK_HIGH;
                    end

                    // sample ack bit while scl high (we ignore result here)
                    ST_ACK_HIGH: begin
                        state <= ST_ACK_DONE;
                    end

                    // scl low again after ack
                    ST_ACK_DONE: begin
                        scl_r <= 1'b0;
                        if (byte_idx != 2'd2) begin
                            // still have more bytes to send in this write
                            byte_idx <= byte_idx + 2'd1;
                            bit_cnt  <= 4'd7;
                            state    <= ST_LOAD_BYTE;
                        end else begin
                            // last byte done, time for stop condition
                            state <= ST_STOP1;
                        end
                    end

                    // stop condition part 1: scl high with sda low
                    ST_STOP1: begin
                        sda_drive_low <= 1'b1;
                        scl_r         <= 1'b1;
                        state         <= ST_STOP2;
                    end

                    // stop condition part 2: release sda high while scl high
                    ST_STOP2: begin
                        sda_drive_low <= 1'b0;
                        state         <= ST_NEXT_PAIR;
                    end

                    // move to next reg/data pair or finish
                    ST_NEXT_PAIR: begin
                        if (pair_idx < (N_PAIRS-1)) begin
                            pair_idx <= pair_idx + 8'd1;
                            bit_cnt  <= 4'd7;
                            byte_idx <= 2'd0;
                            state    <= ST_START1;
                        end else begin
                            state    <= ST_DONE;
                        end
                    end

                    // all pairs sent, bus idle forever
                    ST_DONE: begin
                        scl_r         <= 1'b1;
                        sda_drive_low <= 1'b0;
                    end

                    default: state <= ST_IDLE;
                endcase
            end
        end
    end
endmodule
