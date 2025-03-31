#ifndef GAME_H
#define GAME_H

void init_game();
int get_grid_value(int row, int col);
int get_ownership(int row, int col);
void set_ownership(int row, int col, int player);
int get_top_marker();
int get_bottom_marker();
void set_top_marker(int pos);
void set_bottom_marker(int pos);
void find_cell(int product, int* row, int* col);

#endif
