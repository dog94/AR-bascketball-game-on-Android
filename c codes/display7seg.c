#define switches (volatile char *) 0x00024a0
#define leds (char *) 0x00024b0
#define hex0 (char *) 0x0002490
#define hex1 (char *) 0x0002480
#define hex2 (char *) 0x0002470
#define hex3 (char *) 0x0002460
#define hex4 (char *) 0x0002450
#define hex5 (char *) 0x0002440
#define hex6 (char *) 0x0002430
#define hex7 (char *) 0x0002420

void display7seg(unsigned char * s, int i) {
	char * hex;
	while (i > -1) {
		hex = hex0 - 16 * i; // determine from hex0 to hex7, which one to display on
		if (s[i] == '0') {
			*leds = 0;
			*hex = 63;
		} else if (s[i] == '1') {
			*leds = 1;
			*hex = 121; // 1111001
		} else if (s[i] == '2') {
			*leds = 2;
			*hex = 36;
		} else if (s[i] == '3') {
			*leds = 3;
			*hex = 48;
		} else if (s[i] == '4') {
			*leds = 4;
			*hex = 25;
		} else if (s[i] == '5') {
			*leds = 5;
			*hex = 18;
		} else if (s[i] == '6') {
			*leds = 6;
			*hex = 2;
		} else if (s[i] == '7') {
			*leds = 7;
			*hex = 120;
		} else if (s[i] == '8') {
			*leds = 8;
			*hex = 0;
		} else if (s[i] == '9') {
			*leds = 9;
			*hex = 16;
		} else if (s[i] == 'p') {
			*leds = 255;
			*hex = 12;
			playBallIn(); // if the player shoot in the hoop, play the music to congratulate
		} else {
			*leds = 0;
			*hex0 = 255;
		}
		i--;
	}
}

