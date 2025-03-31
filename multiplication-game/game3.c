#include <stdio.h>
#include <stdlib.h>
#include <time.h>

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

// Initialize marker positions
int top_marker = 1;    // Player controls the top marker
int bottom_marker = 1; // Computer controls the bottom marker

void display_grid() {
    for (int row = 0; row < 6; row++) {
        for (int col = 0; col < 6; col++) {
            if (ownership[row][col] == 1) {
                printf(" X ");  // Player's marker
            } else if (ownership[row][col] == 2) {
                printf(" O ");  // Computer's marker
            } else {
                int num = GRID[row][col];
                if (num < 10) printf(" %d ", num);
                else printf("%d ", num);
            }
            if (col < 5) printf("|");
        }
        printf("\n");
    }
    printf("\n");
}

void display_number_line() {
    // Calculate positions for arrows (13 spaces for "Number line: ", then 2 spaces per number)
    int top_position = 13 + (top_marker - 1) * 2;
    int bottom_position = 13 + (bottom_marker - 1) * 2;

    // Top arrow (v for Player)
    for (int i = 0; i < top_position; i++) printf(" ");
    printf("v\n");

    // Number line
    printf("Number line: 1 2 3 4 5 6 7 8 9\n");

    // Bottom arrow (^ for Computer)
    for (int i = 0; i < bottom_position; i++) printf(" ");
    printf("^\n\n");
}

void display_game_state(const char* turn_message) {
    printf("=== %s ===\n", turn_message);
    display_grid();
    display_number_line();
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
            if (ownership[row][col] == 0) return 0;
        }
    }
    return 1;
}

int simulate_move(int marker_pos, int is_top, int player) {
    int original_top = top_marker;
    int original_bottom = bottom_marker;

    if (is_top) top_marker = marker_pos;
    else bottom_marker = marker_pos;

    int product = top_marker * bottom_marker;
    int row, col;
    find_cell(product, &row, &col);

    top_marker = original_top;
    bottom_marker = original_bottom;

    if (row == -1 || ownership[row][col] != 0) return 0;

    ownership[row][col] = player;
    int win = check_win(player);
    ownership[row][col] = 0;

    return win;
}

void computer_move(int* row, int* col) {
    // Random valid move only
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
        printf("Enter a number (1-9) to move your marker: ");

        int new_pos;
        scanf("%d", &new_pos);
        while (getchar() != '\n'); // Clear buffer

        if (new_pos < 1 || new_pos > 9) {
            printf("Invalid input! Please enter a number between 1 and 9.\n");
            continue;
        }

        top_marker = new_pos;
        int product = top_marker * bottom_marker;
        int row, col;
        find_cell(product, &row, &col);

        if (row == -1 || ownership[row][col] != 0) {
            printf("Invalid move! Cell not available.\n");
            continue;
        }

        ownership[row][col] = 1;

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
        computer_move(&row, &col);
        if (row == -1) {
            display_game_state("Game Over");
            printf("You win! (Computer has no moves)\n");
            break;
        }

        ownership[row][col] = 2;

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
}

int main() {
    srand(time(NULL));
    printf("Welcome to Multiplication Four!\n");
    printf("Move your marker (1-9) to claim cells. Four in a row wins!\n");
    printf("You are X, the computer is O.\n");
    printf("Press Enter to start...");
    while (getchar() != '\n');
    play_game();
    return 0;
}
