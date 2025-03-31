#include "game.h"

static int GRID[6][6] = {
    {1, 2, 3, 4, 5, 6},
    {7, 8, 9, 10, 12, 14},
    {15, 16, 18, 20, 21, 24},
    {25, 27, 28, 30, 32, 35},
    {36, 40, 42, 45, 48, 49},
    {54, 56, 63, 64, 72, 81}
};

static int ownership[6][6] = {0};
static int top_marker = 1;
static int bottom_marker = 1;

void init_game() {
    for (int i = 0; i < 6; i++)
        for (int j = 0; j < 6; j++)
            ownership[i][j] = 0;
    top_marker = 1;
    bottom_marker = 1;
}

int get_grid_value(int row, int col) {
    return GRID[row][col];
}

int get_ownership(int row, int col) {
    return ownership[row][col];
}

void set_ownership(int row, int col, int player) {
    ownership[row][col] = player;
}

int get_top_marker() {
    return top_marker;
}

int get_bottom_marker() {
    return bottom_marker;
}

void set_top_marker(int pos) {
    top_marker = pos;
}

void set_bottom_marker(int pos) {
    bottom_marker = pos;
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
