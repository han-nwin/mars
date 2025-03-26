#include <stdio.h>
#include <stdlib.h>
#include <time.h>
#include <string.h>

// ANSI escape codes for colors
#define RED "\033[31m"  // Red for Player (X)
#define BLUE "\033[34m"  // Blue for Computer (O)
#define RESET "\033[0m"  // Reset color

// Initialize the 6x6 grid with the products
int GRID[6][6] = {
    {1, 2, 3, 4, 5, 6},
    {7, 8, 9, 10, 12, 14},
    {15, 16, 18, 20, 21, 24},
    {25, 27, 28, 30, 32, 35},
    {36, 40, 42, 45, 48, 49},
    {54, 56, 63, 64, 72, 81}
};

// Track cell ownership: 0 = empty, 1 = Player (X), 2 = Computer (O)
int ownership[6][6] = {0};

// Initialize marker positions (start at 1 for both)
int top_marker = 1;  // Player controls the top marker
int bottom_marker = 1;  // Computer controls the bottom marker

void clear_console() {
    #ifdef _WIN32
        system("cls");
    #else
        system("clear");
    #endif
}

void display_grid() {
    for (int row = 0; row < 6; row++) {
        for (int col = 0; col < 6; col++) {
            if (ownership[row][col] == 1) {
                printf(" %sX%s ", RED, RESET);  // Player's marker in red
            } else if (ownership[row][col] == 2) {
                printf(" %sO%s ", BLUE, RESET);  // Computer's marker in blue
            } else {
                int num = GRID[row][col];
                if (num < 10) {
                    printf(" %d ", num);  // Single digits
                } else {
                    printf("%d ", num);  // Double digits
                }
            }
            if (col < 5) printf("|");
        }
        printf("\n");
    }
    printf("\n");
}

void display_number_line() {
    // Calculate the position of the arrows
    // "Number line: " is 12 characters long, then each number is 2 characters apart
    int top_position = 13 + (top_marker - 1) * 2;
    int bottom_position = 13 + (bottom_marker - 1) * 2;

    // Top marker (v for Player)
    for (int i = 0; i < top_position; i++) printf(" ");
    printf("v\n");

    // Number line
    printf("Number line: 1 2 3 4 5 6 7 8 9\n");

    // Bottom marker (^ for Computer)
    for (int i = 0; i < bottom_position; i++) printf(" ");
    printf("^\n");

    // Show the current product
    int product = top_marker * bottom_marker;
    printf("Product: %d x %d = %d\n", top_marker, bottom_marker, product);
    printf("\n");
}

void display_game_state(const char* turn_message) {
    clear_console();
    printf("%s\n", turn_message);
    display_grid();
    display_number_line();
}

void show_message(const char* message) {
    printf("%s\n", message);
    printf("Press Enter to continue...");
    while (getchar() != '\n');  // Clear input buffer and wait for Enter
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

void play_game() {
    while (1) {
        // Player's turn
        display_game_state("Your turn (X)");

        // Prompt the player to move the top marker
        int new_pos;
        int valid_input = 0;
        while (!valid_input) {
            printf("Move the top marker to a number (1-9): ");
            if (scanf("%d", &new_pos) == 1 && new_pos >= 1 && new_pos <= 9) {
                valid_input = 1;
            } else {
                show_message("Invalid input, enter a number between 1 and 9.");
                display_game_state("Your turn (X)");
            }
            // Clear input buffer
            while (getchar() != '\n');
        }

        // Update the top marker position
        top_marker = new_pos;

        // Calculate the product and find the cell
        int product = top_marker * bottom_marker;
        int row, col;
        find_cell(product, &row, &col);

        // Check if the cell exists and is available
        if (row == -1) {
            show_message("Product not in the grid, try again.");
            continue;
        }
        if (ownership[row][col] != 0) {
            show_message("Cell already taken, try again.");
            continue;
        }

        // Claim the cell for the player
        ownership[row][col] = 1;
        char claim_msg[50];
        snprintf(claim_msg, sizeof(claim_msg), "You claim %d!", product);
        show_message(claim_msg);

        // Check for a win
        if (check_win(1)) {
            display_game_state("Your turn (X)");
            show_message("You win!");
            break;
        }

        // Check for a tie
        if (is_board_full()) {
            display_game_state("Your turn (X)");
            show_message("It's a tie!");
            break;
        }

        // Computer's turn
        display_game_state("Computer's turn (O)");

        // Computer makes a move
        computer_move(&row, &col);
        if (row == -1) {
            show_message("Computer has no valid moves left!");
            break;
        }

        product = top_marker * bottom_marker;
        ownership[row][col] = 2;
        snprintf(claim_msg, sizeof(claim_msg), "Computer claims %d!", product);
        show_message(claim_msg);

        // Check for a win
        if (check_win(2)) {
            display_game_state("Computer's turn (O)");
            show_message("Computer wins!");
            break;
        }

        // Check for a tie
        if (is_board_full()) {
            display_game_state("Computer's turn (O)");
            show_message("It's a tie!");
            break;
        }
    }
}

int main() {
    srand(time(NULL));  // Seed the random number generator
    printf("Welcome to Multiplication Four!\n");
    printf("Move the top marker on the number line to claim cells. Four in a row wins!\n");
    printf("You are X (red), the computer is O (blue).\n");
    printf("Press Enter to start the game...");
    while (getchar() != '\n');  // Wait for Enter
    play_game();
    return 0;
}
