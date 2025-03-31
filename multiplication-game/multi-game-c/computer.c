#include <stdlib.h>
#include "game.h"

void computer_move(int* row, int* col) {
    // Try to win
    for (int pos = 1; pos <= 9; pos++) {
        if (simulate_move(pos, 0, 2)) {  // Computer is player 2
            bottom_marker = pos;
            int product = top_marker * bottom_marker;
            find_cell(product, row, col);
            return;
        }
    }

    // Try to block the player
    for (int pos = 1; pos <= 9; pos++) {
        if (simulate_move(pos, 1, 1)) {  // Simulate player's move
            int block_row, block_col;
            for (int block_pos = 1; block_pos <= 9; block_pos++) {
                int temp_top = top_marker;
                bottom_marker = block_pos;
                int product = top_marker * bottom_marker;
                find_cell(product, &block_row, &block_col);
                top_marker = temp_top;
                if (block_row == pos && ownership[block_row][block_col] == 0) {
                    bottom_marker = block_pos;
                    *row = block_row;
                    *col = block_col;
                    return;
                }
            }
        }
    }

    // Random valid move
    int valid_moves[9];
    int count = 0;
    for (int pos = 1; pos <= 9; pos++) {
        int temp_row, temp_col;
        bottom_marker = pos;
        int product = top_marker * bottom_marker;
        find_cell(product, &temp_row, &temp_col);
        if (temp_row != -1 && ownership[temp_row][temp_col] == 0) {
            valid_moves[count++] = pos;
        }
    }

    if (count > 0) {
        bottom_marker = valid_moves[rand() % count];
        int product = top_marker * bottom_marker;
        find_cell(product, row, col);
    } else {
        *row = -1;
        *col = -1;
    }
}
