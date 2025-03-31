#include <stdio.h>
#include <stdlib.h>
#include <time.h>
#include "game.h"

int main() {
    srand(time(NULL));  // Seed the random number generator
    printf("Welcome to Multiplication Four!\n");
    printf("Move the top marker on the number line to claim cells. Four in a row wins!\n");
    printf("You are X (red), the computer is O (blue).\n");
    printf("Press Enter to start the game...");
    while (getchar() != '\n');  // Wait for Enter
    play_game();
    return 0;
}
