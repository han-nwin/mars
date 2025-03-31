#include <stdio.h>
#include <stdlib.h>
#include <time.h>
#include "print.h"
#include "game.h"
#include "wincheck.h"
#include "playermove.h"
#include "computermove.h"

int main() {
    srand(time(NULL));
    printf("Welcome to Multiplication Four!\n");
    printf("Move your marker (1-9) to claim cells. Four in a row wins!\n");
    printf("You are X, the computer is O.\n");
    printf("Press Enter to start...");
    while (getchar() != '\n');
    
    init_game();
    while (1) {
        // Player's turn
        display_game_state("Your turn (X)");
        if (!player_turn()) {
            printf("Invalid move! Cell not available.\n");
            continue;
        }
        
        if (check_win(1)) {
            display_game_state("Game Over");
            printf("You win!\n");
            break;
        }
        if (is_board_full()) {
            display_game_state("Game Over");
            printf("It's a tie!\n");
            break;
        }

        // Computer's turn
        display_game_state("Computer's turn (O)");
        int row, col;
        computer_turn(&row, &col);
        if (row == -1) {
            display_game_state("Game Over");
            printf("You win! (Computer has no moves)\n");
            break;
        }
        set_ownership(row, col, 2);

        if (check_win(2)) {
            display_game_state("Game Over");
            printf("Computer wins!\n");
            break;
        }
        if (is_board_full()) {
            display_game_state("Game Over");
            printf("It's a tie!\n");
            break;
        }
    }
    return 0;
}
