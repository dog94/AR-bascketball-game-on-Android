#include <stdio.h>
#include <stdlib.h>
#include <altera_up_sd_card_avalon_interface.h>
#include "altera_up_avalon_audio_and_video_config.h"
#include "altera_up_avalon_audio.h"
#include "sys/alt_irq.h"
#include "priv/alt_legacy_irq.h"
void av_config_setup();
void initialize_audio_irq();
void playBGM();
void playBallIn();
void readSD();
