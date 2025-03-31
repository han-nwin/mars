#ifndef GAME_H
#define GAME_H

// ANSI escape codes for colors
#define RED "\033[31m"  // Red for Player (X)
#define BLUE "\033[34m" // Blue for Computer (O)
#define RESET "\033[0m" // Reset color

// Initialize the 6x6 grid with the products
extern int GRID[6][6];

// Track cell ownership: 0 = empty, 1 = Player (X), 2 = Computer (O)
extern int ownership[6][6];

// Initialize marker positions (start at 1 for both)
extern int top_marker;  // Player controls the top marker
extern int bottom_marker;  // Computer controls the bottom marker

void clear_console();
void display_grid();
void display_number_line();
void display_game_state(const char* turn_message);
void find_cell(int product, int* row, int* col);
int check_win(int player);
int is_board_full();
int simulate_move(int marker_pos, int is_top, int player);
void computer_move(int* row, int* col);
void player_move(int* row, int* col);
void play_game();

#endif
