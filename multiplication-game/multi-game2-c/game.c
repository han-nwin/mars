#include <stdio.h>
#include "game.h"

int GRID[6][6] = {
    {1, 2, 3, 4, 5, 6},
    {7, 8, 9, 10, 12, 14},
    {15, 16, 18, 20, 21, 24},
    {25, 27, 28, 30, 32, 35},
    {36, 40, 42, 45, 48, 49},
    {54, 56, 63, 64, 72, 81}
};

int ownership[6][6] = {0};
int top_marker = 1;
int bottom_marker = 1;

void play_game() {
    while (1) {
        // Player's turn
        display_game_state("Your turn (X)");
        int row, col;
        player_move(&row, &col);

        if (row != -1) {
            ownership[row][col] = 1;

            if (check_win(1)) {
                display_game_state("Your turn (X)");
                printf("You win!\n");
                break;
            }
            if (is_board_full()) {
                display_game_state("Your turn (X)");
                printf("It's a tie!\n");
                break;
            }
        }

        // Computer's turn
        display_game_state("Computer's turn (O)");
        computer_move(&row, &col);
        if (row == -1) {
            display_game_state("Computer's turn (O)");
            printf("You win! (Computer has no moves)\n");
            break;
        }

        int product = top_marker * bottom_marker;
        ownership[row][col] = 2;

        if (check_win(2)) {
            display_game_state("Computer's turn (O)");
            printf("Computer wins!\n");
            break;
        }
        if (is_board_full()) {
            display_game_state("Computer's turn (O)");
            printf("It's a tie!\n");
            break;
        }
    }
}
