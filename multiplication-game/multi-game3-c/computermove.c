#include <stdlib.h>
#include "computermove.h"
#include "game.h"

void computer_turn(int* row, int* col) {
    int valid_moves[9];
    int count = 0;
    for (int pos = 1; pos <= 9; pos++) {
        int temp_row, temp_col;
        set_bottom_marker(pos);
        int product = get_top_marker() * get_bottom_marker();
        find_cell(product, &temp_row, &temp_col);
        if (temp_row != -1 && get_ownership(temp_row, temp_col) == 0) {
            valid_moves[count++] = pos;
        }
    }

    if (count > 0) {
        set_bottom_marker(valid_moves[rand() % count]);
        int product = get_top_marker() * get_bottom_marker();
        find_cell(product, row, col);
    } else {
        *row = -1;
        *col = -1;
    }
}
