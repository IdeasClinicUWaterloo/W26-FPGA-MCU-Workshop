-- draws the pong paddles, ball, border, and the scores using a tiny 8x12 font

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity renderer is
	generic (
		H_ACTIVE: NATURAL := 1280;	-- active horizontal area, cols of pixels
		V_ACTIVE: NATURAL := 720	-- active vertical area, rows of pixels
	);
	port (
		hcount:	in INTEGER;						-- current horizontal position on the screen
		vcount:	in INTEGER;						-- current vertical position on the screen
		de: 		in STD_LOGIC;					-- whether we're in the visible area of the screen
		
		-- game data, to be uncommented in part 6
--		pl_y: 	in INTEGER;						-- the left player's current y pos
--		pr_y: 	in INTEGER;						-- the right player's current y pos
--		ball_x: 	in INTEGER;						-- the ball's current x position
--		ball_y: 	in INTEGER;						-- the ball's current y position
--		score_l: in NATURAL;	-- the left player's score
--		score_r: in NATURAL;	-- the right player's score
		
		rgb: out STD_LOGIC_VECTOR(23 downto 0)	-- the color of the current pixel
	);
end renderer;

architecture procedural of renderer is
	-- drawing component definitions, to be used in part 6
	component rect_display is
		port (
			hcount: 	in INTEGER;		-- horizontal position of current pixel
			vcount: 	in INTEGER;		-- vertical position of current pixel
			x1: 		in INTEGER;		-- left edge position
			x2: 		in INTEGER;		-- right edge position
			y1: 		in INTEGER;		-- top edge position
			y2: 		in INTEGER;		-- bottom edge position
			lit: 		out STD_LOGIC	-- whether pixel is inside specified rectangle
		);
	end component;

	component numeric_display is
		port (
			num: in UNSIGNED(3 downto 0);	-- number to display
			pos_x: in INTEGER;				-- horizontal pos of top-left corner of score
			pos_y: in INTEGER;				-- vertical pos of top-left corner of score
			hcount, vcount: in INTEGER; 	-- current pixel position
			lit: out STD_LOGIC				-- whether the current pixel should be lit by the displayed number
		);
	end component;

	-- constants for drawing the game -- used in Part 6
	constant PADDLE_H: 	NATURAL := 100;	-- width of the paddles, in px
	constant PADDLE_W: 	NATURAL := 12;		-- height of the paddles, in px
	constant BALL_R: 		INTEGER := 10;		-- radius of the ball, in px
	constant PL_X: 		INTEGER := 40;									-- position of the left player on screen
	constant PR_X: 		INTEGER := H_ACTIVE - 40 - PADDLE_W;	-- position of the right player on screen
	
	-- indexable versions of hcount and vcount, to make test patterns easier
	signal hcount_vec: STD_LOGIC_VECTOR(31 downto 0);
	signal vcount_vec: STD_LOGIC_VECTOR(31 downto 0);
	
	-- signals to track what game object occupies the current pixel
	signal on_scorel, on_scorer, on_pl, on_pr, on_ball: STD_LOGIC;
begin
	-- components to draw game, to be uncommented in part 6
--	-- component to render left score
--	score_l_render: numeric_display
--		port map (
--			pos_x => H_ACTIVE/2 - 16,
--			pos_y => 16,
--			hcount => hcount,
--			vcount => vcount,
--			num => to_unsigned(score_l, 4),
--			lit => on_scorel
--		);
--	
--	-- component to render right score
--	score_r_render: numeric_display
--		port map (
--			pos_x => H_ACTIVE/2 + 16,
--			pos_y => 16,
--			hcount => hcount,
--			vcount => vcount,
--			num => to_unsigned(score_r, 4),
--			lit => on_scorer
--		);


--	paddle_l: rect_display port map (
--		hcount => hcount,
--		vcount => vcount,
--		x1 => PL_X,
--		x2 => PL_X + PADDLE_W,
--		y1 => pl_y,
--		y2 => pl_y + PADDLE_H,
--		lit => on_pl
--	);
--	
--	paddle_r: rect_display port map (
--		hcount => hcount,
--		vcount => vcount,
--		x1 => PR_X,
--		x2 => PR_X + PADDLE_W,
--		y1 => pr_y,
--		y2 => pr_y + PADDLE_H,
--		lit => on_pr
--	);
--
--	ball: rect_display port map (
--		hcount => hcount,
--		vcount => vcount,
--		x1 => ball_x - BALL_R,
--		x2 => ball_x + BALL_R,
--		y1 => ball_y - BALL_R,
--		y2 => ball_y + BALL_R,
--		lit => on_ball
--	);

	-- indexable versions of hcount and vcount, to make test patterns easier
	hcount_vec <= std_logic_vector(to_unsigned(hcount, 32));
	vcount_vec <= std_logic_vector(to_unsigned(vcount, 32));
	
	-- process runs every time current pixel changes
	process(hcount, vcount, de) is
	begin

		if de = '0' then
			-- do not output color when we're outside visible area
			rgb <= x"000000";
		else
			-- logic for test pattern/choosing a color goes here
			rgb <= x"FFFFFF";
		end if;
		
	end process;
end procedural;