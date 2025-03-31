#include "game.h"

int check_win(int player) {
    // Check horizontal
    for (int row = 0; row < 6; row++) {
        for (int col = 0; col <= 2; col++) {
            int win = 1;
            for (int i = 0; i < 4; i++) {
                if (ownership[row][col + i] != player) {
                    win = 0;
                    break;
                }
            }
            if (win) return 1;
        }
    }

    // Check vertical
    for (int row = 0; row <= 2; row++) {
        for (int col = 0; col < 6; col++) {
            int win = 1;
            for (int i = 0; i < 4; i++) {
                if (ownership[row + i][col] != player) {
                    win = 0;
                    break;
                }
            }
            if (win) return 1;
        }
    }

    // Check diagonal (top-left to bottom-right)
    for (int row = 0; row <= 2; row++) {
        for (int col = 0; col <= 2; col++) {
            int win = 1;
            for (int i = 0; i < 4; i++) {
                if (ownership[row + i][col + i] != player) {
                    win = 0;
                    break;
                }
            }
            if (win) return 1;
        }
    }

    // Check diagonal (top-right to bottom-left)
    for (int row = 0; row <= 2; row++) {
        for (int col = 3; col < 6; col++) {
            int win = 1;
            for (int i = 0; i < 4; i++) {
                if (ownership[row + i][col - i] != player) {
                    win = 0;
                    break;
                }
            }
            if (win) return 1;
        }
    }

    return 0;
}

int is_board_full() {
    for (int row = 0; row < 6; row++) {
        for (int col = 0; col < 6; col++) {
            if (ownership[row][col] == 0) {
                return 0;
            }
        }
    }
    return 1;
}

int simulate_move(int marker_pos, int is_top, int player) {
    int original_top = top_marker;
    int original_bottom = bottom_marker;

    // Simulate the move
    if (is_top) {
        top_marker = marker_pos;
    } else {
        bottom_marker = marker_pos;
    }

    int product = top_marker * bottom_marker;
    int row, col;
    find_cell(product, &row, &col);

    // Restore original positions
    top_marker = original_top;
    bottom_marker = original_bottom;

    // Check if the move is valid
    if (row == -1 || ownership[row][col] != 0) {
        return 0;  // Invalid move
    }

    // Simulate claiming the cell
    ownership[row][col] = player;
    int win = check_win(player);
    ownership[row][col] = 0;  // Undo the move

    return win;
}
