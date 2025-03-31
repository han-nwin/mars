#include <stdio.h>
#include "game.h"

void player_move(int* row, int* col) {
    // Prompt the player to move the top marker
    int new_pos;
    int valid_input = 0;
    while (!valid_input) {
        if (scanf("%d", &new_pos) == 1 && new_pos >= 1 && new_pos <= 9) {
            valid_input = 1;
        }
        // Clear input buffer
        while (getchar() != '\n');
    }

    // Update the top marker position
    top_marker = new_pos;

    // Calculate the product and find the cell
    int product = top_marker * bottom_marker;
    find_cell(product, row, col);

    // Check if the cell exists and is available
    if (*row == -1 || ownership[*row][*col] != 0) {
        *row = -1;  // Indicate invalid move
        *col = -1;
    }
}
