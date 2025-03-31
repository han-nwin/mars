#include <stdio.h>
#include <stdlib.h>
#include "print.h"
#include "game.h"

void display_grid() {
    for (int row = 0; row < 6; row++) {
        for (int col = 0; col < 6; col++) {
            if (get_ownership(row, col) == 1) {
                printf(" X ");
            } else if (get_ownership(row, col) == 2) {
                printf(" O ");
            } else {
                int num = get_grid_value(row, col);
                if (num < 10) printf(" %d ", num);
                else printf("%d ", num);
            }
            if (col < 5) printf("|");
        }
        printf("\n");
    }
    printf("\n");
}

void display_number_line() {
    int top_position = 13 + (get_top_marker() - 1) * 2;
    int bottom_position = 13 + (get_bottom_marker() - 1) * 2;

    for (int i = 0; i < top_position; i++) printf(" ");
    printf("v\n");

    printf("Number line: 1 2 3 4 5 6 7 8 9\n");

    for (int i = 0; i < bottom_position; i++) printf(" ");
    printf("^\n\n");
}

void display_game_state(const char* turn_message) {
    printf("=== %s ===\n", turn_message);
    display_grid();
    display_number_line();
}
