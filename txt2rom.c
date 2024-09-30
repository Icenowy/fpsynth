#include <stdio.h>
#include <ctype.h>
#include <math.h>
#include <string.h>

#define CPS 48e6
#define A4_FREQ 440.0

/* A4 is 0 */
int note_to_semitone(char *note)
{
	if (!strncmp(note, "C#", 2))
		return -8 + (note[2] - '4') * 12;
	else if (!strncmp(note, "C", 1))
		return -9 + (note[1] - '4') * 12;
	else if (!strncmp(note, "D#", 2))
		return -6 + (note[2] - '4') * 12;
	else if (!strncmp(note, "D", 1))
		return -7 + (note[1] - '4') * 12;
	else if (!strncmp(note, "E", 1))
		return -5 + (note[1] - '4') * 12;
	else if (!strncmp(note, "F#", 2))
		return -3 + (note[2] - '4') * 12;
	else if (!strncmp(note, "F", 1))
		return -4 + (note[1] - '4') * 12;
	else if (!strncmp(note, "G#", 2))
		return -1 + (note[2] - '4') * 12;
	else if (!strncmp(note, "G", 1))
		return -2 + (note[1] - '4') * 12;
	else if (!strncmp(note, "A#", 2))
		return 1 + (note[2] - '4') * 12;
	else if (!strncmp(note, "A", 1))
		return 0 + (note[1] - '4') * 12;
	else if (!strncmp(note, "B", 1))
		return 2 + (note[1] - '4') * 12;
	else
		return 0;
}

double note_to_freq(char *note)
{
	int semitone = note_to_semitone(note);

	return A4_FREQ * pow(2.0, semitone / 12.0);
}

int main()
{
	double bpm;
	char note[16];
	double beats;
	scanf("%lf", &bpm);

	while (scanf("%s%lf", note, &beats) == 2) {
		double freq = note_to_freq(note);
		printf("%08x\n", (unsigned int) round(CPS * 60 / bpm * beats));
		printf("%08x\n", (unsigned int) round(CPS / freq / 64));
	}
}
