#include "lcd.h"

alt_up_character_lcd_dev * char_lcd_dev;

void printLCD(char * message) {
	// open the Character LCD port
	char_lcd_dev = alt_up_character_lcd_open_dev("/dev/LCD");
	if (char_lcd_dev == NULL)
		alt_printf("Error: could not open character LCD device\n");
	else
		alt_printf("Opened character LCD device\n");

	/* Initialise the character display */
	alt_up_character_lcd_init(char_lcd_dev);

	alt_up_character_lcd_string(char_lcd_dev, "Player:");

	/* Write in the second row */
	alt_up_character_lcd_set_cursor_pos(char_lcd_dev, 0, 1);
	int i;
	for (i = 0; i < 16; i++) {
		alt_up_character_lcd_erase_pos(char_lcd_dev, i, 1); //erase the previous message
	}

	alt_up_character_lcd_string(char_lcd_dev, message);
}
