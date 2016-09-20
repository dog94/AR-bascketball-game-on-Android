#include "sound.h"

alt_up_sd_card_dev * device_reference;
alt_up_audio_dev * audio;

short int sd_fileh;
int i, j, k, a, e;
short int read_value;

//short int readname = 0;
//char filename[13];

unsigned int * buf_initial;
unsigned int * buf;
unsigned int * buf_attack;
unsigned int * buf_evolve;
int offset;
unsigned int empty_space_left;
//	unsigned int empty_space_right;

int read_samples;

void av_config_setup() {
	alt_up_av_config_dev * av_config = alt_up_av_config_open_dev(
			"/dev/audio_and_video_config_0");
	while (!alt_up_av_config_read_ready(av_config)) {
	}
	printf("Hello~\n");
	alt_up_audio_reset_audio_core(audio);
	audio = alt_up_audio_open_dev("/dev/audio_0");

}


void initialize_audio_irq() {
	alt_up_audio_disable_read_interrupt(audio);
	alt_up_audio_disable_write_interrupt(audio);

}

void BGM_isr(void* context, alt_u32 id) {
	read_samples = 96;

	for (k = 0; k < read_samples; k++) {
		buf[k] = (((unsigned int) buf_initial[j + 1] << 8)
				| (unsigned int) buf_initial[j]) & 0x0000FFFF;
		j = j + 2;
		if (j >= i) {
			j = 0;
		}
	}

	alt_up_audio_write_fifo(audio, buf, read_samples, ALT_UP_AUDIO_LEFT);
	alt_up_audio_write_fifo(audio, buf, read_samples, ALT_UP_AUDIO_RIGHT);

}


void ballIn_isr(void* context, alt_u32 id) {
	read_samples = 96;

	for (k = 0; k < read_samples; k++) {
		buf[k] = (((unsigned int) buf_evolve[j + 1] << 8)
				| (unsigned int) buf_evolve[j]) & 0x0000FFFF;
		j = j + 2;
		if (j >= e) {
			j = 0;
			alt_up_audio_disable_write_interrupt(audio);
		}
	}

	alt_up_audio_write_fifo(audio, buf, read_samples, ALT_UP_AUDIO_LEFT);
	alt_up_audio_write_fifo(audio, buf, read_samples, ALT_UP_AUDIO_RIGHT);

}

void playBGM() {
	j = 0;
	// register isr
	alt_irq_register(6, 0x0, BGM_isr);
	// enable interrupt
	alt_irq_enable(6);
	alt_up_audio_enable_write_interrupt(audio);
}

void playBallIn() {
	j = 0;
	// register isr
	alt_irq_register(6, 0x0, ballIn_isr);
	// enable interrupt
	alt_irq_enable(6);
	alt_up_audio_enable_write_interrupt(audio);
}



void readSD() {
	short int readname;
	char filename[13];
	device_reference = alt_up_sd_card_open_dev(
			"/dev/Altera_UP_SD_Card_Avalon_Interface_0");
	if (alt_up_sd_card_is_FAT16()) {
		printf("FAT16 file system detected.\n");


		sd_fileh = alt_up_sd_card_fopen("theme3.wav", false);

		readname = alt_up_sd_card_find_first(".", filename);
		printf("File name is: %s\n", filename);
		readname = alt_up_sd_card_find_next(filename);
		printf("File name is: %s\n", filename);
		while (readname == 0) {
			readname = alt_up_sd_card_find_next(filename);
			printf("File name is: %s\n", filename);
		}

		if (sd_fileh < 0)
			printf("Problem reading file. Error %i", sd_fileh);
		else // open the file
		{
			printf("Reading file...\n");
			readname = alt_up_sd_card_find_first(".", filename);
			printf("File name is: %s\n", filename);
			while (readname == 0) {
				readname = alt_up_sd_card_find_next(filename);
				printf("File name is: %s\n", filename);
			}
			read_value = alt_up_sd_card_read(sd_fileh);
			i = 0;
			buf_initial = malloc(999999 * sizeof(unsigned int));
			while (read_value > -1) {

				buf_initial[i] = read_value;
				i++;
				read_value = alt_up_sd_card_read(sd_fileh);
			}
 			alt_up_sd_card_fclose(sd_fileh);
			printf("Theme song's size is: %d bytes\n", i);

			sd_fileh = alt_up_sd_card_fopen("ballIn.wav", false);
			read_value = alt_up_sd_card_read(sd_fileh);
			e = 0;
			buf_evolve = malloc(60000 * sizeof(unsigned int));
			while (read_value > -1) {
				buf_evolve[e] = read_value;
				e++;
				read_value = alt_up_sd_card_read(sd_fileh);
			}

			alt_up_sd_card_fclose(sd_fileh);

			buf = malloc(96 * sizeof(unsigned int));

		}
	}
}
