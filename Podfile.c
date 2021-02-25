#include "device_read.h"
#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include <unistd.h>
#include <signal.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <syslog.h>
#include <xdo.h>


char mapping[16][10];

int generate_mapping() {
	char line[20];
	char * key;
	int i;
	FILE * config = fopen("/home/parallels/Desktop/ds4/key_map.config", "r");
	if(config == NULL) {
		fprintf(stderr, "Configuration file missing.");
		return(-1);
	}
	for(i = 0; i < 16; i++){
		fscanf(config, "%s", line);
		key = strtok(line, ":");
		key = strtok(NULL, ":");
		strcpy(mapping[i], key);
	}
	fclose(config);
	return(0);
}

void send_key(xdo_t * x, char key[10]) {
	if(strcmp("mouse_u", key) == 0) {
		xdo_mouse_down(x, CURRENTWINDOW, 1);
		xdo_mouse_up(x, CURRENTWINDOW, 1);
		xdo_move_mouse_relative(x, 0, -10);
	} else if (strcmp("mouse_r", key) == 0) {
		xdo_mouse_down(x, CURRENTWINDOW, 1);
		xdo_mouse_up(x, CURRENTWINDOW, 1);
		xdo_move_mouse_relative(x, 10, 0);
	} else if (strcmp("mouse_d", key) == 0) {
		xdo_mouse_down(x, CURRENTWINDOW, 1);
		xdo_mouse_up(x, CURRENTWINDOW, 1);
		xdo_move_mouse_relative(x, 0, 10);
	} else if (strcmp("mouse_l", key) == 0) {
		xdo_mouse_down(x, CURRENTWINDOW, 1);
		xdo_mouse_up(x, CURRENTWINDOW, 1);
		xdo_move_mouse_relative(x, -10, 0);
	} else {

		xdo_send_keysequence_window(x, CURRENTWINDOW, key, 0);
	}
}

void press_key(int face_buttons, int misc_buttons, xdo_t * x) {

	switch (misc_buttons) {
		case L1_BTN: 
			send_key(x, mapping[8]);
			break;
		case R1_BTN: 
			send_key(x, mapping[9]);
			break;
		case L2_BTN:
			send_key(x, mapping[10]);
			break;
		case R2_BTN:
			send_key(x, mapping[11]);
			break;
		case SHARE_BTN:
			send_key(x, mapping[12]);
			break;
		case OPTIONS_BTN:
			send_key(x, mapping[13]);
			break;
		case L3_BTN:
			send_key(x, mapping[14]);
			break;
		case R3_BTN:
			send_key(x, mapping[15]);
			break;
	}

	switch (face_buttons) {
		case UP_BTN: 
			send_key(x, mapping[0]);
			break;
		case RIGHT_BTN: 
			send_key(x, mapping[1]);
			break;
		case DOWN_BTN:
			send_key(x, mapping[2]);
			break;
		case LEFT_BTN:
			send_key(x, mapping[3]);
			break;
		case SQUARE_BTN:
			send_key(x, mapping[4]);
			break;
		case X_BTN:
			send_key(x, mapping[5]);
			break;
		case CIRCLE_BTN:
			send_key(x, mapping[6]);
			break;
		case TRIANGLE_BTN:
			send_key(x, mapping[7]);
			break;
	}
}

int main (void) {
	pid_t process_id = 0;
	pid_t sid = 0;

	process_id = fork();

	if (process_id < 0)
	{
		printf("fork failed!\n");
		exit(1);
	}

	if (process_id > 0)
	{
		exit(0);
	}

	umask(0);
	sid = setsid();
	if(sid < 0)
	{
		exit(1);
	}

	chdir("/");

	close(STDIN_FILENO);
	close(STDOUT_FILENO);
	close(STDERR_FILENO);
	
	char buf[100];
	int fd;
	xdo_t * x = xdo_new(NULL);
	if(generate_mapping() != 0) {
		fprintf(stderr, "Error loading key configuration. Quitting...");
		return(-1);
	}
	while(1) {
		fd = open("/dev/ds4-device", O_RDONLY);
		read(fd, &buf, 7);

		if(buf[5] != 8 || buf[6] != 0) {
			press_key(buf[5], buf[6], x);
			printf("\t");

			while(buf[5] != 8 || buf[6] != 0){
				fd = open("/dev/ds4-device", O_RDONLY);
				read(fd, &buf, 7);
				close(fd);
			}
		}
		close(fd);	
	}
	xdo_free(x);
	return EXIT_SUCCESS;
}


