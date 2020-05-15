LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

ENTITY SOLDIER IS
	PORT (
		CLK				:	IN STD_LOGIC;
		RST				:	IN STD_LOGIC;
		PLAYER			:	IN STD_LOGIC;
		ENEMY_A			:	IN STD_LOGIC;
		ENEMY_B			: 	IN STD_LOGIC;
		EN					:	INOUT STD_LOGIC;
		OUTPUT			:	OUT STD_LOGIC
	);
END SOLDIER;

ARCHITECTURE BEHAVIOUR OF SOLDIER IS

TYPE STATE IS (GREEN, YELLOW, RED, INTERRUPT, SEEK, HIDE, BLACK, STORM, AIM, SHOOT, BURST, COVER, AID, FINISH);
SIGNAL PRESENT						: STATE;
SIGNAL NEXT_STATE					: STATE;
SIGNAL TEMP							: STD_LOGIC;
SIGNAL PLAYER_HP					: INTEGER := 30;
SIGNAL ENEMYA_HP					: INTEGER := 14;
SIGNAL ENEMYB_HP					: INTEGER := 5;
SIGNAL PLAYER_AMMO				: INTEGER := 36;
SIGNAL ENEMIES_AMMO				: INTEGER := 72;	

PROCEDURE RECOVER_RESOURCES ( 
		SIGNAL PLAYER_HP		: INOUT INTEGER;
		SIGNAL ENEMYA_HP		: INOUT INTEGER;
		SIGNAL ENEMYB_HP		: INOUT INTEGER;
		SIGNAL PLAYER_AMMO	: INOUT INTEGER;
		SIGNAL ENEMIES_AMMO	: INOUT INTEGER) IS
BEGIN
		--Untuk HP
		IF(PLAYER_HP<36 AND ENEMYA_HP<14 AND ENEMYB_HP<5 AND PRESENT/=AID) THEN
			PLAYER_HP <= PLAYER_HP + (PLAYER_HP / 5 + PLAYER_HP MOD 2);
			ENEMYA_HP <= ENEMYA_HP + (ENEMYA_HP / 4 + ENEMYA_HP MOD 3);
			ENEMYB_HP <= ENEMYB_HP + (ENEMYB_HP / 3 + ENEMYB_HP MOD 3);
		ELSIF(PLAYER_HP<36 AND ENEMYA_HP<14 AND ENEMYB_HP<5 AND PRESENT=AID) THEN
			PLAYER_HP <= PLAYER_HP + (PLAYER_HP / 8 + PLAYER_HP MOD 2);
			ENEMYA_HP <= ENEMYA_HP + (ENEMYA_HP / 6 + ENEMYA_HP MOD 2);
			ENEMYB_HP <= ENEMYB_HP + (ENEMYB_HP / 6 + ENEMYB_HP MOD 2);
		ELSIF(PLAYER_HP>36 OR ENEMYA_HP>14 OR ENEMYB_HP>8) THEN
			PLAYER_HP <= 30;
			ENEMYA_HP <= 14;
			ENEMYB_HP <= 8;
		END IF;
		
		--Untuk ammo
		IF(PLAYER_AMMO<36 AND ENEMIES_AMMO<72) THEN
			PLAYER_AMMO <= PLAYER_AMMO + (PLAYER_AMMO / 4);
			ENEMIES_AMMO <= ENEMIES_AMMO + (ENEMIES_AMMO / 5);
		ELSIF(PLAYER_AMMO>36 OR ENEMIES_AMMO>72) THEN
			PLAYER_AMMO <= 36;
			ENEMIES_AMMO <= 72;
		END IF;
		
END PROCEDURE;

PROCEDURE RANDOMIZE_RED (
			SIGNAL PLAYER_HP 		: INOUT INTEGER;
			SIGNAL ENEMYA_HP		: INOUT INTEGER;
			SIGNAL ENEMYB_HP		: INOUT INTEGER;
			SIGNAL PLAYER_AMMO	: INOUT INTEGER;
			SIGNAL ENEMIES_AMMO	: INOUT INTEGER) IS
BEGIN
			CASE PRESENT IS
				--Saat INTERRUPT atau HIDE
				WHEN INTERRUPT | HIDE =>
					IF(PLAYER='1' AND ENEMY_A='1') THEN
						ENEMIES_AMMO <= ENEMIES_AMMO - 5;
						PLAYER_AMMO <= PLAYER_AMMO - 2;
						PLAYER_HP <= PLAYER_HP - ((60/100) * 8);
						ENEMYA_HP <= ENEMYA_HP - ((85/100) * 2);
					ELSIF(PLAYER='1' AND ENEMY_B='1') THEN
						ENEMIES_AMMO <= ENEMIES_AMMO - 2;
						PLAYER_AMMO <= PLAYER_AMMO - 2;
						PLAYER_HP <= PLAYER_HP - ((95 / 100) * 4);
						ENEMYB_HP <= ENEMYB_HP - ((85 / 100) * 2);
					ELSE
						PLAYER_AMMO <= PLAYER_AMMO;
					END IF;	
				--Saat SEEK
				WHEN SEEK =>
					IF(PLAYER='1' AND EN='1') THEN
						ENEMIES_AMMO <= 12;
						PLAYER_AMMO <= PLAYER_AMMO - 6;
						PLAYER_HP <= PLAYER_HP - (((60/100) * 3) + ((95/100) * 2));
						ENEMYA_HP <= ENEMYA_HP - ((85/100) * 8);
						ENEMYB_HP <= ENEMYB_HP - ((85/100) * 8);
					ELSE
						PLAYER_AMMO <= PLAYER_AMMO;
					END IF;
				WHEN OTHERS => NULL;
			END CASE;
END PROCEDURE;

PROCEDURE RANDOMIZE_BLACK (
			SIGNAL PLAYER_HP 		: INOUT INTEGER;
			SIGNAL ENEMYA_HP		: INOUT INTEGER;
			SIGNAL ENEMYB_HP		: INOUT INTEGER;
			SIGNAL PLAYER_AMMO	: INOUT INTEGER;
			SIGNAL ENEMIES_AMMO	: INOUT INTEGER) IS
BEGIN
			CASE PRESENT IS
				--Saat STORM
				WHEN STORM =>
						PLAYER_AMMO <= PLAYER_AMMO - 6;
						PLAYER_HP <= PLAYER_HP - 12;
						ENEMYA_HP <= ENEMYA_HP - ((85/100) * 5);
						ENEMYB_HP <= ENEMYB_HP - ((85/100) * 5);
				--Saat AIM
				WHEN AIM =>
					IF(PLAYER='0' AND ENEMY_B='1') THEN
						ENEMIES_AMMO <= ENEMIES_AMMO - 1;
						PLAYER_AMMO <= PLAYER_AMMO - 1;
						PLAYER_HP <= PLAYER_HP - ((95/100) * 10);
						ENEMYB_HP <= ENEMYB_HP - ((85/100) * 2);
					ELSE
						PLAYER_AMMO <= PLAYER_AMMO;
					END IF;
				--Saat SHOOT
				WHEN SHOOT =>
					IF(PLAYER='1' AND ENEMY_B='1' AND EN='1') THEN
						ENEMIES_AMMO <= ENEMIES_AMMO - 2;
						PLAYER_AMMO <= PLAYER_AMMO - 3;
						PLAYER_HP <= PLAYER_HP - ((95/100) * 5);
						ENEMYB_HP <= ENEMYB_HP - ((85/100) * 8);
					ELSIF(PLAYER='1' AND ENEMY_A='1') THEN
						ENEMIES_AMMO <= ENEMIES_AMMO - 5;
						PLAYER_AMMO <= PLAYER_AMMO - 2;
						PLAYER_HP <= PLAYER_HP - ((60/100) * 3);
						ENEMYB_HP <= ENEMYB_HP - ((85/100) * 8);
					ELSE
						PLAYER_AMMO <= PLAYER_AMMO;
					END IF;
				--Saat  BURST
				WHEN BURST =>
						ENEMIES_AMMO <= ENEMIES_AMMO - 20;
						PLAYER_AMMO <= PLAYER_AMMO - 10;
						PLAYER_HP <= PLAYER_HP - ((60/100) * 12);
						ENEMYA_HP <= ENEMYA_HP - ((85/100) * 8);
				WHEN OTHERS => NULL;
			END CASE;
END PROCEDURE;

BEGIN

--Cek kondisi
PROCESS(CLK, PRESENT, PLAYER, ENEMY_A, ENEMY_B, EN) IS
	BEGIN
		CASE PRESENT IS
			--Kondisi saat ini 'GREEN'
			WHEN GREEN =>
				IF(PLAYER='0') THEN
					NEXT_STATE <= GREEN;
				ELSIF(PLAYER='1') THEN
					NEXT_STATE <= YELLOW;
				ELSE
					NEXT_STATE <= GREEN;
				END IF;
			--Kondisi saat ini 'YELLOW'
			WHEN YELLOW =>
				IF(PLAYER='0') THEN
					NEXT_STATE <= GREEN;
				ELSIF(PLAYER='1') THEN
					NEXT_STATE <= RED;
				ELSE
					NEXT_STATE <= YELLOW;
				END IF;
			--Kondisi saat ini 'RED'
			WHEN RED =>
				IF(PLAYER='0' AND ENEMY_A='0' AND ENEMY_B='0') THEN
					NEXT_STATE <= INTERRUPT;
				ELSIF((PLAYER='0' AND ENEMY_B='1') OR (PLAYER='0' AND ENEMY_A='1')) THEN
					NEXT_STATE <= SEEK;
				ELSIF(PLAYER='1' AND ENEMY_A='0' AND ENEMY_B='0') THEN
					NEXT_STATE <= HIDE;	
				ELSIF((PLAYER='1' AND ENEMY_B='1') OR (PLAYER='1' AND ENEMY_A='1')) THEN
					NEXT_STATE <= RED;
				ELSIF(PLAYER='1' AND ENEMY_A='1' AND ENEMY_B='1') THEN
					NEXT_STATE <= BLACK;
				ELSE
					NEXT_STATE <= RED;
				END IF;
			--Kondisi saat ini 'INTERRUPT'
			WHEN INTERRUPT =>
				IF(PLAYER='0') THEN
					NEXT_STATE <= RED;
				ELSIF(PLAYER='1' AND ENEMY_A='0' AND ENEMY_B='0') THEN
					NEXT_STATE <= INTERRUPT;
				ELSIF((PLAYER='1' AND ENEMY_B='1') OR (PLAYER='1' AND ENEMY_A='1')) THEN
					NEXT_STATE <= BLACK;
				ELSIF(PLAYER='1' AND ENEMY_A='1' AND ENEMY_B='1') THEN
					NEXT_STATE <= HIDE;
				ELSE
					NEXT_STATE <= INTERRUPT;
				END IF;
			--Kondisi saat ini 'SEEK'
			WHEN SEEK =>
				IF(PLAYER='0') THEN
					NEXT_STATE <= YELLOW;
				ELSIF((PLAYER='1' AND ENEMY_B='1') OR (PLAYER='1' AND ENEMY_A='1')) THEN
					NEXT_STATE <= INTERRUPT;
				ELSIF(PLAYER='1' AND ENEMY_A='1' AND ENEMY_B='1') THEN
					NEXT_STATE <= BLACK;
				ELSE
					NEXT_STATE <= SEEK;
				END IF;
			--Kondisi saat ini 'HIDE'
			WHEN HIDE =>
				IF(PLAYER='0') THEN
					NEXT_STATE <= YELLOW;
				ELSIF((PLAYER='1' AND ENEMY_B='1') OR (PLAYER='1' AND ENEMY_A='1')) THEN
					NEXT_STATE <= RED;
				ELSIF(PLAYER='1' AND ENEMY_A='1' AND ENEMY_B='1') THEN
					NEXT_STATE <= BLACK;
				ELSE
					NEXT_STATE <= HIDE;
				END IF;
			--Kondisi saat ini 'BLACK'
			WHEN BLACK =>
				IF(PLAYER='0' AND ENEMY_A='0' AND ENEMY_B='0') THEN
					NEXT_STATE <= STORM;
				ELSIF(PLAYER='0' AND ENEMY_B='1' AND EN='0') THEN
					NEXT_STATE <= AIM;
				ELSIF(PLAYER='0' AND ENEMY_B='1' AND EN='1') THEN
					NEXT_STATE <= SHOOT;
				ELSIF(PLAYER='0' AND ENEMY_A='1') THEN
					NEXT_STATE <= BURST;
				ELSIF(PLAYER='1' AND ENEMY_A='0' AND ENEMY_B='0') THEN
					NEXT_STATE <= COVER;
				ELSIF(PLAYER='1' AND ENEMY_B='1' AND EN='1') THEN
					NEXT_STATE <= AID;
				ELSIF((PLAYER='0' AND EN='0') OR (PLAYER='1' AND ENEMY_A='1' AND ENEMY_B='1' AND EN='1')) THEN
					NEXT_STATE <= FINISH;
				ELSE
					NEXT_STATE <= BLACK;
				END IF;
			WHEN STORM =>
			--Kondisi saat ini 'STORM'
				IF(PLAYER='0') THEN
					NEXT_STATE <= STORM;
				ELSIF(PLAYER='1') THEN
					NEXT_STATE <= BLACK;
				ELSE
					NEXT_STATE <= STORM;
				END IF;
			WHEN AIM =>
			--Kondisi saat ini 'AIM'
				IF(ENEMY_A='0' AND ENEMY_B='0' AND EN='1') THEN
					NEXT_STATE <= BLACK;
				ELSIF(PLAYER='0') THEN
					NEXT_STATE <= AIM;
				ELSIF((PLAYER='1' AND ENEMY_B='1') OR (PLAYER='1' AND ENEMY_A='1')) THEN
					NEXT_STATE <= COVER;
				ELSE
					NEXT_STATE <= AIM;
				END IF;
			WHEN SHOOT =>
			--Kondisi saat ini 'SHOOT'
				IF(ENEMY_A='0' AND ENEMY_B='0' AND EN='1') THEN
					NEXT_STATE <= BLACK;
				ELSIF(PLAYER='0' AND ENEMY_B='1' AND EN='0') THEN
					NEXT_STATE <= AIM;
				ELSIF(PLAYER='0' AND ENEMY_B='1' AND EN='1') THEN
					NEXT_STATE <= SHOOT;
				ELSIF(PLAYER='1' AND ENEMY_A='1') THEN
					NEXT_STATE <= BURST;
				ELSE
					NEXT_STATE <= SHOOT;
				END IF;
			WHEN BURST =>
			--Kondisi saat ini 'BURST'
				IF(ENEMY_A='0' AND ENEMY_B='0' AND EN='1') THEN
					NEXT_STATE <= BLACK;
				ELSE
					NEXT_STATE <= BURST;
				END IF;
			WHEN COVER =>
			--Kondisi saat ini 'COVER'
				IF(ENEMY_A='0' AND ENEMY_B='0' AND EN='1') THEN
					NEXT_STATE <= BLACK;
				ELSIF(PLAYER='0' AND ENEMY_B='1') THEN
					NEXT_STATE <= AIM;
				ELSIF(ENEMY_A='1') THEN
					NEXT_STATE <= BURST;
				ELSIF(PLAYER='1') THEN
					NEXT_STATE <= COVER;
				ELSE
					NEXT_STATE <= COVER;
				END IF;
			--Kondisi saat ini 'AID'
			WHEN AID =>
				IF(EN='0') THEN
					NEXT_STATE <= BLACK;
				ELSIF(EN='1') THEN
					NEXT_STATE <= AID;
				ELSE
					NEXT_STATE <= AID;
				END IF;
			--Kondisi saat ini 'FINISH'
			WHEN FINISH =>
				NEXT_STATE <= FINISH;
			--Apabila kondisi diluar dari yang telah ditentukan
			WHEN OTHERS => NULL;
		END CASE;
END PROCESS;

PROCESS(CLK, RST, PLAYER_HP, ENEMYA_HP, ENEMYB_HP, PLAYER_AMMO, ENEMIES_AMMO, TEMP) IS
	BEGIN
		
		IF(PLAYER_HP > (ENEMYA_HP + ENEMYB_HP)) THEN
			EN <= '1';
		ELSE
			EN <= '0';
		END IF;
	
		IF(RST='1') THEN
			TEMP 	 <= '0';
		ELSIF(RISING_EDGE(CLK)) THEN
			CASE PRESENT IS
				--Cek apabila nilai present = 'GREEN'
				WHEN GREEN =>
					IF(NEXT_STATE=GREEN) THEN
						RECOVER_RESOURCES(PLAYER_HP, ENEMYA_HP, ENEMYB_HP, PLAYER_AMMO, ENEMIES_AMMO);
						TEMP <= '0';
					ELSIF(NEXT_STATE=YELLOW) THEN
						RECOVER_RESOURCES(PLAYER_HP, ENEMYA_HP, ENEMYB_HP, PLAYER_AMMO, ENEMIES_AMMO);
						TEMP <= '1';
					ELSE
						TEMP <= 'X';
					END IF;
				--Cek apabila nilai present = 'YELLOW'
				WHEN YELLOW =>
					IF(NEXT_STATE=GREEN OR NEXT_STATE=RED) THEN
						RECOVER_RESOURCES(PLAYER_HP, ENEMYA_HP, ENEMYB_HP, PLAYER_AMMO, ENEMIES_AMMO);
						TEMP <= '1';
					ELSE
						TEMP <= 'X';
					END IF;
				--Cek apabila nilai present = 'RED'
				WHEN RED => 
					IF(NEXT_STATE=RED) THEN
						TEMP <= '0';
					ELSIF(NEXT_STATE=INTERRUPT OR NEXT_STATE=SEEK OR NEXT_STATE=HIDE OR NEXT_STATE=BLACK) THEN
						TEMP <= '1';
					ELSE
						TEMP <= 'X';
					END IF;
				--Cek apabila nilai present = 'INTERRUPT'
				WHEN INTERRUPT =>
					IF(NEXT_STATE=INTERRUPT) THEN
						RANDOMIZE_RED(PLAYER_HP, ENEMYA_HP, ENEMYB_HP, PLAYER_AMMO, ENEMIES_AMMO);
						TEMP <= '0';
					ELSIF(NEXT_STATE=RED OR NEXT_STATE=BLACK OR NEXT_STATE=HIDE) THEN
						RANDOMIZE_RED(PLAYER_HP, ENEMYA_HP, ENEMYB_HP, PLAYER_AMMO, ENEMIES_AMMO);
						TEMP <= '1';
					ELSE
						TEMP <= 'X';
					END IF;
				--Cek apabila nilai present = 'SEEK'
				WHEN SEEK =>
					IF(NEXT_STATE=YELLOW OR NEXT_STATE=INTERRUPT OR NEXT_STATE=BLACK) THEN
						RANDOMIZE_RED(PLAYER_HP, ENEMYA_HP, ENEMYB_HP, PLAYER_AMMO, ENEMIES_AMMO);
						TEMP <= '1';
					ELSE
						TEMP <= 'X';
					END IF;
				--Cek apabila nilai present = 'HIDE'
				WHEN HIDE =>
					IF(NEXT_STATE=YELLOW OR NEXT_STATE=RED OR NEXT_STATE=BLACK) THEN
						RECOVER_RESOURCES(PLAYER_HP, ENEMYA_HP, ENEMYB_HP, PLAYER_AMMO, ENEMIES_AMMO);
						RANDOMIZE_RED(PLAYER_HP, ENEMYA_HP, ENEMYB_HP, PLAYER_AMMO, ENEMIES_AMMO);
						TEMP <= '1';
					ELSE
						TEMP <= 'X';
					END IF;
				--Cek apabila nilai present = 'BLACK'
				WHEN BLACK =>
					IF(NEXT_STATE=STORM OR NEXT_STATE=AIM OR NEXT_STATE=SHOOT OR NEXT_STATE=BURST OR NEXT_STATE=COVER OR NEXT_STATE=AID OR NEXT_STATE=FINISH) THEN
						TEMP <= '1';
					ELSE 
						TEMP <= 'X';
					END IF;
				--Cek apabila nilai present = 'STORM'
				WHEN STORM =>
					IF(NEXT_STATE=STORM) THEN
						RANDOMIZE_BLACK(PLAYER_HP, ENEMYA_HP, ENEMYB_HP, PLAYER_AMMO, ENEMIES_AMMO);
						TEMP <= '0';
					ELSIF(NEXT_STATE=BLACK) THEN
						RANDOMIZE_BLACK(PLAYER_HP, ENEMYA_HP, ENEMYB_HP, PLAYER_AMMO, ENEMIES_AMMO);
						TEMP <= '1';
					ELSE
						TEMP <= 'X';
					END IF;
				--Cek apabila nilai present = 'AIM'
				WHEN AIM =>
					IF(NEXT_STATE=AIM) THEN
						RANDOMIZE_BLACK(PLAYER_HP, ENEMYA_HP, ENEMYB_HP, PLAYER_AMMO, ENEMIES_AMMO);
						TEMP <= '0';
					ELSIF(NEXT_STATE=BLACK OR NEXT_STATE=COVER) THEN
						RANDOMIZE_BLACK(PLAYER_HP, ENEMYA_HP, ENEMYB_HP, PLAYER_AMMO, ENEMIES_AMMO);
						TEMP <= '1';
					ELSE
						TEMP <= 'X';
					END IF;
				--Cek apabila nilai present = 'SHOOT'	
				WHEN SHOOT =>
					IF(NEXT_STATE=SHOOT) THEN
						RANDOMIZE_BLACK(PLAYER_HP, ENEMYA_HP, ENEMYB_HP, PLAYER_AMMO, ENEMIES_AMMO);
						TEMP <= '0';
					ELSIF(NEXT_STATE=BLACK OR NEXT_STATE=AIM OR NEXT_STATE=BURST) THEN
						RANDOMIZE_BLACK(PLAYER_HP, ENEMYA_HP, ENEMYB_HP, PLAYER_AMMO, ENEMIES_AMMO);
						TEMP <= '1';
					ELSE
						TEMP <= 'X';
					END IF;
				--Cek apabila nilai present = 'BURST'	
				WHEN BURST =>
					IF(NEXT_STATE=BURST) THEN
						RANDOMIZE_BLACK(PLAYER_HP, ENEMYA_HP, ENEMYB_HP, PLAYER_AMMO, ENEMIES_AMMO);
						TEMP <= '0';
					ELSIF(NEXT_STATE=BLACK) THEN
						RANDOMIZE_BLACK(PLAYER_HP, ENEMYA_HP, ENEMYB_HP, PLAYER_AMMO, ENEMIES_AMMO);
						TEMP <= '1';
					ELSE
						TEMP <= 'X';
					END IF;
				--Cek apabila nilai present = 'COVER'	
				WHEN COVER =>
					IF(NEXT_STATE=COVER) THEN
						RECOVER_RESOURCES(PLAYER_HP, ENEMYA_HP, ENEMYB_HP, PLAYER_AMMO, ENEMIES_AMMO);
						TEMP <= '0';
					ELSIF(NEXT_STATE=BLACK OR NEXT_STATE=AIM OR NEXT_STATE=BURST) THEN
						RECOVER_RESOURCES(PLAYER_HP, ENEMYA_HP, ENEMYB_HP, PLAYER_AMMO, ENEMIES_AMMO);
						TEMP <= '1';
					ELSE
						TEMP <= 'X';
					END IF;
				--Cek apabila nilai present = 'AID'	
				WHEN AID =>
					IF(NEXT_STATE=AID) THEN
					RECOVER_RESOURCES(PLAYER_HP, ENEMYA_HP, ENEMYB_HP, PLAYER_AMMO, ENEMIES_AMMO);
						TEMP <= '0';
					ELSIF(NEXT_STATE=BLACK) THEN
					RECOVER_RESOURCES(PLAYER_HP, ENEMYA_HP, ENEMYB_HP, PLAYER_AMMO, ENEMIES_AMMO);
						TEMP <= '1';
					ELSE
						TEMP <= 'X';
					END IF;	
				--Cek apabila telah 'Win'
				WHEN FINISH =>
					IF(NEXT_STATE=FINISH) THEN
						TEMP <= 'X';
					ELSE
						TEMP <= 'X';
					END IF;
				WHEN OTHERS => NULL;
			END CASE;
			PRESENT <= NEXT_STATE;
		END IF;
END PROCESS;
OUTPUT <= TEMP;
END BEHAVIOUR;