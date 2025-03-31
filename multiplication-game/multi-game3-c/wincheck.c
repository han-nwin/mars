#include "wincheck.h"
#include "game.h"

int check_win(int player) {
    // Check horizontal
    for (int row = 0; row < 6; row++) {
        for (int col = 0; col <= 2; col++) {
            int win = 1;
            for (int i = 0; i < 4; i++) {
                if (get_ownership(row, col + i) != player) {
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
                if (get_ownership(row + i, col) != player) {
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
                if (get_ownership(row + i, col + i) != player) {
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
                if (get_ownership(row + i, col - i) != player) {
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
            if (get_ownership(row, col) == 0) return 0;
        }
    }
    return 1;
}
