#include "usb/usb.h"
#include "altera_up_avalon_usb.h"
#include "system.h"
#include "sys/alt_timestamp.h"
#include <assert.h>
#include "sound.h"
#include "lcd.h"
#include "display7seg.c"

void reverseString(int size, unsigned char * m) {
	int i;
	for (i = 0; i < size / 2; i++) {
		unsigned char temp = m[size - 1 - i];
		m[size - 1 - i] = m[i];
		m[i] = temp;
	}
}

int main() {
	*hex0 = 255;
	*hex1 = 255;
	*hex2 = 255;
	*hex3 = 255;
	*hex4 = 255;
	*hex5 = 255;
	*hex6 = 255;
	*hex7 = 255;
	av_config_setup();
	initialize_audio_irq();
	readSD();
	int i;
	int bytes_expected;
	int bytes_recvd;
	int total_recvd;
	unsigned char data;
	unsigned char message_tx[];
	unsigned char message_rx[100];
	printf("USB Initialization\n");
	alt_up_usb_dev * usb_dev;
	usb_dev = alt_up_usb_open_dev(USB_0_NAME);
	assert(usb_dev);
	usb_device_init(usb_dev, USB_0_IRQ);
	printf("Polling USB device. Run middleman now!\n");
	alt_timestamp_start();
	int clocks = 0;
	while (clocks < 50000000 * 10) {
		clocks = alt_timestamp();
		usb_device_poll();
	}
	printf("Done polling USB\n");
	printf("Sending the message to the Middleman\n");
// Start with the number of bytes in our message
	unsigned char message_length = strlen(message_tx);
	usb_device_send(&message_length, 1);
// Now send the actual message to the Middleman
	usb_device_send(message_tx, message_length);

	while (1) {
// Now receive the message from the Middleman
		printf("Waiting for data to come back from the Middleman\n");
// First byte is the number of characters in our message
		bytes_expected = 1;
		total_recvd = 0;
		while (total_recvd < bytes_expected) {
			bytes_recvd = usb_device_recv(&data, 1);
			if (bytes_recvd > 0)
				total_recvd += bytes_recvd;
		}

		int num_to_receive = (int) data;
		printf("About to receive %d characters:\n", num_to_receive);
		bytes_expected = num_to_receive;
		total_recvd = 0;
		while (total_recvd < bytes_expected) {
			bytes_recvd = usb_device_recv(message_rx + total_recvd, 1);
			if (bytes_recvd > 0)
				total_recvd += bytes_recvd;
		}

		*hex0 = 255;
		*hex1 = 255;
		*hex2 = 255;
		*hex3 = 255;
		*hex4 = 255;
		*hex5 = 255;
		*hex6 = 255;
		*hex7 = 255;

		printLCD(message_rx);

		// reverse the string
		reverseString(num_to_receive, message_rx);

		display7seg(message_rx, num_to_receive);

		printf("Message Echo Complete\n");
	}
	return 0;
}
