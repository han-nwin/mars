#include <stdio.h>
#include "game.h"
#include <stdlib.h>

void clear_console() {
    #ifdef _WIN32
        system("cls");
    #else
        system("clear");
    #endif
}

void display_grid() {
    for (int row = 0; row < 6; row++) {
        for (int col = 0; col < 6; col++) {
            if (ownership[row][col] == 1) {
                printf(" %sX%s ", RED, RESET);  // Player's marker in red
            } else if (ownership[row][col] == 2) {
                printf(" %sO%s ", BLUE, RESET);  // Computer's marker in blue
            } else {
                int num = GRID[row][col];
                if (num < 10) {
                    printf(" %d ", num);  // Single digits
                } else {
                    printf("%d ", num);  // Double digits
                }
            }
            if (col < 5) printf("|");
        }
        printf("\n");
    }
    printf("\n");
}

void display_number_line() {
    // Calculate the position of the arrows
    // "Number line: " is 12 characters long, then each number is 2 characters apart
    int top_position = 13 + (top_marker - 1) * 2;
    int bottom_position = 13 + (bottom_marker - 1) * 2;

    // Top marker (v for Player)
    for (int i = 0; i < top_position; i++) printf(" ");
    printf("v\n");

    // Number line
    printf("Number line: 1 2 3 4 5 6 7 8 9\n");

    // Bottom marker (^ for Computer)
    for (int i = 0; i < bottom_position; i++) printf(" ");
    printf("^\n");
}

void display_game_state(const char* turn_message) {
    clear_console();
    display_grid();
    display_number_line();
}

void find_cell(int product, int* row, int* col) {
    *row = -1;
    *col = -1;
    for (int r = 0; r < 6; r++) {
        for (int c = 0; c < 6; c++) {
            if (GRID[r][c] == product) {
                *row = r;
                *col = c;
                return;
            }
        }
    }
}
