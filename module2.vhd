-- Implements a simple Nios II system for the DE2 board.
-- Inputs: SW7¡0 are parallel port inputs to the Nios II system.
-- CLOCK_50 is the system clock.
-- KEY0 is the active-low system reset.
-- Outputs: LEDG7¡0 are parallel port outputs from the Nios II system.
-- SDRAM ports correspond to the signals in Figure 2; their names are those
-- used in the DE2 User Manual.

LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_arith.all;
USE ieee.std_logic_unsigned.all;

ENTITY module2 IS
PORT (
SW : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
KEY : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
CLOCK_50 : IN STD_LOGIC;

LEDG : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
HEX0 : OUT STD_LOGIC_VECTOR(6 DOWNTO 0);
HEX1 : OUT STD_LOGIC_VECTOR(6 DOWNTO 0);
HEX2 : OUT STD_LOGIC_VECTOR(6 DOWNTO 0);
HEX3 : OUT STD_LOGIC_VECTOR(6 DOWNTO 0);
HEX4 : OUT STD_LOGIC_VECTOR(6 DOWNTO 0);
HEX5 : OUT STD_LOGIC_VECTOR(6 DOWNTO 0);
HEX6 : OUT STD_LOGIC_VECTOR(6 DOWNTO 0);
HEX7 : OUT STD_LOGIC_VECTOR(6 DOWNTO 0);

DRAM_CLK, DRAM_CKE : OUT STD_LOGIC;
DRAM_ADDR : OUT STD_LOGIC_VECTOR(11 DOWNTO 0);
DRAM_BA_0, DRAM_BA_1 : BUFFER STD_LOGIC;
DRAM_CS_N, DRAM_CAS_N, DRAM_RAS_N, DRAM_WE_N : OUT STD_LOGIC;
DRAM_DQ : INOUT STD_LOGIC_VECTOR(15 DOWNTO 0);
DRAM_UDQM, DRAM_LDQM : BUFFER STD_LOGIC;

SD_DAT,SD_DAT3, SD_CMD : INOUT STD_LOGIC;
SD_CLK : OUT STD_LOGIC;

I2C_SDAT : INOUT STD_LOGIC;
I2C_SCLK : OUT STD_LOGIC;
AUD_XCK  : OUT STD_LOGIC;
CLOCK_27 : IN STD_LOGIC;
AUD_ADCDAT, AUD_ADCLRCK, AUD_BCLK, AUD_DACLRCK : IN STD_LOGIC;
AUD_DACDAT : OUT STD_LOGIC;

OTG_INT1         : in    std_logic                     ;             -- INT1
OTG_DATA         : inout std_logic_vector(15 downto 0) ; -- DATA
OTG_RST_N        : out   std_logic;                                        -- RST_N
OTG_ADDR         : out   std_logic_vector(1 downto 0);                     -- ADDR
OTG_CS_N         : out   std_logic;                                        -- CS_N
OTG_RD_N         : out   std_logic;                                        -- RD_N
OTG_WR_N         : out   std_logic;                                        -- WR_N
OTG_INT0         : in    std_logic;

lcd_DATA                                               : inout std_logic_vector(7 downto 0); -- DATA
lcd_ON                                                 : out   std_logic;                                        -- ON
lcd_BLON                                               : out   std_logic;                                        -- BLON
lcd_EN                                                 : out   std_logic;                                        -- EN
lcd_RS                                                 : out   std_logic;                                        -- RS
lcd_RW                                                 : out   std_logic

 );
END module2;


ARCHITECTURE Structure OF module2 IS
COMPONENT nios2
PORT (
clk_clk : IN STD_LOGIC;
reset_reset_n : IN STD_LOGIC;
sdram_clk_clk : OUT STD_LOGIC;
sdram_wire_addr : OUT STD_LOGIC_VECTOR(11 DOWNTO 0);
sdram_wire_ba : BUFFER STD_LOGIC_VECTOR(1 DOWNTO 0);
sdram_wire_cas_n : OUT STD_LOGIC;
sdram_wire_cke : OUT STD_LOGIC;
sdram_wire_cs_n : OUT STD_LOGIC;
sdram_wire_dq : INOUT STD_LOGIC_VECTOR(15 DOWNTO 0);
sdram_wire_dqm : BUFFER STD_LOGIC_VECTOR(1 DOWNTO 0);
sdram_wire_ras_n : OUT STD_LOGIC;
sdram_wire_we_n : OUT STD_LOGIC;

altera_up_sd_card_avalon_interface_0_conduit_end_b_SD_cmd   : inout std_logic;             -- b_SD_cmd
altera_up_sd_card_avalon_interface_0_conduit_end_b_SD_dat   : inout std_logic;             -- b_SD_dat
altera_up_sd_card_avalon_interface_0_conduit_end_b_SD_dat3  : inout std_logic;             -- b_SD_dat3
altera_up_sd_card_avalon_interface_0_conduit_end_o_SD_clock : out   std_logic;             -- o_SD_clock


up_clocks_0_clk_in_secondary_clk                            : in    std_logic;             -- clk
up_clocks_0_audio_clk_clk                                   : out   std_LOGIC;

audio_and_video_config_0_external_interface_SDAT            : inout std_logic;             -- SDAT
audio_and_video_config_0_external_interface_SCLK            : out   std_logic;             -- SCLK
audio_0_external_interface_ADCDAT                           : in    std_logic;             -- ADCDAT
audio_0_external_interface_ADCLRCK                          : in    std_logic;             -- ADCLRCK
audio_0_external_interface_BCLK                             : in    std_logic;             -- BCLK
audio_0_external_interface_DACDAT                           : out   std_logic;             -- DACDAT
audio_0_external_interface_DACLRCK                          : in    std_logic;              -- DACLRCK

usb_INT1         : in    std_logic                     ;             -- INT1
usb_DATA         : inout std_logic_vector(15 downto 0) ; -- DATA
usb_RST_N        : out   std_logic;                                        -- RST_N
usb_ADDR         : out   std_logic_vector(1 downto 0);                     -- ADDR
usb_CS_N         : out   std_logic;                                        -- CS_N
usb_RD_N         : out   std_logic;                                        -- RD_N
usb_WR_N         : out   std_logic;                                        -- WR_N
usb_INT0         : in    std_logic;

hex0_export                                                 : out   std_logic_vector(6 downto 0);
hex1_export                                                 : out   std_logic_vector(6 downto 0);                     -- export
hex2_export                                                 : out   std_logic_vector(6 downto 0);                     -- export
hex3_export                                                 : out   std_logic_vector(6 downto 0);                     -- export
hex4_export                                                 : out   std_logic_vector(6 downto 0);                     -- export
hex5_export                                                 : out   std_logic_vector(6 downto 0);                     -- export
hex6_export                                                 : out   std_logic_vector(6 downto 0);                     -- export
hex7_export                                                 : out   std_logic_vector(6 downto 0);  
leds_export                                                 : out   std_logic_vector(7 downto 0);                     -- export
switches_export                                             : in    std_logic_vector(7 downto 0);                      -- export

lcd_data_DATA                                               : inout std_logic_vector(7 downto 0); -- DATA
lcd_data_ON                                                 : out   std_logic;                                        -- ON
lcd_data_BLON                                               : out   std_logic;                                        -- BLON
lcd_data_EN                                                 : out   std_logic;                                        -- EN
lcd_data_RS                                                 : out   std_logic;                                        -- RS
lcd_data_RW                                                 : out   std_logic

 );

END COMPONENT;

SIGNAL DQM : STD_LOGIC_VECTOR(1 DOWNTO 0);
SIGNAL BA : STD_LOGIC_VECTOR(1 DOWNTO 0);

BEGIN

DRAM_BA_0 <= BA(0);
DRAM_BA_1 <= BA(1);
DRAM_UDQM <= DQM(1);
DRAM_LDQM <= DQM(0);

-- Instantiate the Nios II system entity generated by the Qsys tool.
NiosII: nios2
PORT MAP (
clk_clk => CLOCK_50,
reset_reset_n => KEY(0),
sdram_clk_clk => DRAM_CLK,
sdram_wire_addr => DRAM_ADDR,
sdram_wire_ba => BA,
sdram_wire_cas_n => DRAM_CAS_N,
sdram_wire_cke => DRAM_CKE,
sdram_wire_cs_n => DRAM_CS_N,
sdram_wire_dq => DRAM_DQ,
sdram_wire_dqm => DQM,
sdram_wire_ras_n => DRAM_RAS_N,
sdram_wire_we_n => DRAM_WE_N, 

altera_up_sd_card_avalon_interface_0_conduit_end_b_SD_cmd => SD_CMD,             -- b_SD_cmd
altera_up_sd_card_avalon_interface_0_conduit_end_b_SD_dat => SD_DAT,             -- b_SD_dat
altera_up_sd_card_avalon_interface_0_conduit_end_b_SD_dat3 => SD_DAT3,            -- b_SD_dat3
altera_up_sd_card_avalon_interface_0_conduit_end_o_SD_clock => SD_CLK,           -- o_SD_clock

up_clocks_0_clk_in_secondary_clk => ClOCK_27,             -- clk
up_clocks_0_audio_clk_clk => AUD_XCK,

audio_and_video_config_0_external_interface_SDAT => I2c_SDAT,
audio_and_video_config_0_external_interface_SCLK => I2c_SCLK,
audio_0_external_interface_ADCDAT  => AUD_ADCDAT,                   
audio_0_external_interface_ADCLRCK => AUD_ADCLRCK,         
audio_0_external_interface_BCLK    => AUD_BCLK,     
audio_0_external_interface_DACDAT  => AUD_DACDAT,  
audio_0_external_interface_DACLRCK => AUD_DACLRCK,


usb_INT1         => OTG_INT1,         --        usb.INT1
usb_DATA         => OTG_DATA,         --           .DATA
usb_RST_N        => OTG_RST_N,        --           .RST_N
usb_ADDR         => OTG_ADDR,         --           .ADDR
usb_CS_N         => OTG_CS_N,         --           .CS_N
usb_RD_N         => OTG_RD_N,         --           .RD_N
usb_WR_N         => OTG_WR_N,         --           .WR_N
usb_INT0         => OTG_INT0,

hex0_export      => hex0,
hex1_export      => hex1,
hex2_export      => hex2,
hex3_export      => hex3,
hex4_export      => hex4,
hex5_export      => hex5,
hex6_export      => hex6,
hex7_export      => hex7,

leds_export      => ledg,                                                 --                                             leds.export
switches_export  => sw,

lcd_data_DATA    => lcd_DATA,                                               --                                         lcd_data.DATA
lcd_data_ON      => lcd_ON,                                                 --                                                 .ON
lcd_data_BLON    => lcd_BLON,                                               --                                                 .BLON
lcd_data_EN      => lcd_EN,                                                 --                                                 .EN
lcd_data_RS      => lcd_RS,                                                 --                                                 .RS
lcd_data_RW      => lcd_RW
);

END Structure;