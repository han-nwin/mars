#include <stdio.h>
#include "playermove.h"
#include "game.h"

int player_turn() {
    printf("Enter a number (1-9) to move your marker: ");
    int new_pos;
    scanf("%d", &new_pos);
    while (getchar() != '\n'); // Clear buffer

    if (new_pos < 1 || new_pos > 9) {
        printf("Invalid input! Please enter a number between 1 and 9.\n");
        return 0;
    }

    set_top_marker(new_pos);
    int product = get_top_marker() * get_bottom_marker();
    int row, col;
    find_cell(product, &row, &col);

    if (row == -1 || get_ownership(row, col) != 0) {
        return 0;
    }

    set_ownership(row, col, 1);
    return 1;
}
