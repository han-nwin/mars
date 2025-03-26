import os  # For clearing the console (optional)
import random  # For computer's random moves

# ANSI escape codes for colors
RED = "\033[31m"  # Red for Player (X)
BLUE = "\033[34m"  # Blue for Computer (O)
RESET = "\033[0m"  # Reset color

# Initialize the 6x6 grid with the products as shown in the image
GRID = [
    [1, 2, 3, 4, 5, 6],
    [7, 8, 9, 10, 12, 14],
    [15, 16, 18, 20, 21, 24],
    [25, 27, 28, 30, 32, 35],
    [36, 40, 42, 45, 48, 49],
    [54, 56, 63, 64, 72, 81],
]

# Track cell ownership: 0 = empty, 1 = Player (X), 2 = Computer (O)
ownership = [[0 for _ in range(6)] for _ in range(6)]

# Initialize marker positions (start at 1 for both)
top_marker = 1  # Player controls the top marker
bottom_marker = 1  # Computer controls the bottom marker


def clear_console():
    """Clear the console for better readability (works on most systems)."""
    os.system("cls" if os.name == "nt" else "clear")


def display_grid():
    """Display the 6x6 grid with numbers or player symbols, ensuring proper alignment."""
    for row in range(6):
        row_display = []
        for col in range(6):
            if ownership[row][col] == 1:
                row_display.append(f" {RED}X{RESET} ")  # Player's marker in red
            elif ownership[row][col] == 2:
                row_display.append(f" {BLUE}O{RESET} ")  # Computer's marker in blue
            else:
                # Ensure consistent spacing for all numbers (3 characters wide)
                num = GRID[row][col]
                if num < 10:
                    row_display.append(f" {num} ")  # Add space before single digits
                else:
                    row_display.append(f"{num} ")  # Double digits
        print("|".join(row_display))
    print()


def display_number_line():
    """Display the number line with the top and bottom markers, properly aligned."""
    # Calculate the position of the arrows
    # "Number line: " is 12 characters long, then each number is 2 characters apart (e.g., "1 ", "2 ", etc.)
    # Position of number N is: 12 (prefix) + (N-1) * 2
    top_position = 13 + (top_marker - 1) * 2
    bottom_position = 13 + (bottom_marker - 1) * 2

    # Top marker (v for Player)
    top_spaces = " " * top_position
    print(f"{top_spaces}v")

    # Number line
    print("Number line: 1 2 3 4 5 6 7 8 9")

    # Bottom marker (^ for Computer)
    bottom_spaces = " " * bottom_position
    print(f"{bottom_spaces}^")

    # Show the current product
    product = top_marker * bottom_marker
    print(f"Product: {top_marker} x {bottom_marker} = {product}")
    print()


def display_game_state(turn_message):
    """Display the full game state (turn message, grid, and number line)."""
    clear_console()
    print(turn_message)
    display_grid()
    display_number_line()


def show_message(message):
    """Display a message and wait for the user to press Enter."""
    print(message)
    input("Press Enter to continue...")


def find_cell(product):
    """Find the (row, col) of the cell with the given product. Returns (-1, -1) if not found."""
    for row in range(6):
        for col in range(6):
            if GRID[row][col] == product:
                return row, col
    return -1, -1  # Product not in grid


def check_win(player):
    """Check if the given player has four in a row (horizontally, vertically, or diagonally)."""
    # Check horizontal
    for row in range(6):
        for col in range(3):  # Only need to check starting positions 0 to 2
            if all(ownership[row][col + i] == player for i in range(4)):
                return True

    # Check vertical
    for row in range(3):  # Only need to check starting rows 0 to 2
        for col in range(6):
            if all(ownership[row + i][col] == player for i in range(4)):
                return True

    # Check diagonal (top-left to bottom-right)
    for row in range(3):
        for col in range(3):
            if all(ownership[row + i][col + i] == player for i in range(4)):
                return True

    # Check diagonal (top-right to bottom-left)
    for row in range(3):
        for col in range(3, 6):
            if all(ownership[row + i][col - i] == player for i in range(4)):
                return True

    return False


def is_board_full():
    """Check if all cells are claimed."""
    for row in range(6):
        for col in range(6):
            if ownership[row][col] == 0:
                return False
    return True


def simulate_move(marker_pos, is_top, player):
    """Simulate a move to see if it results in a win or blocks the opponent."""
    global top_marker, bottom_marker
    # Save current marker positions
    original_top = top_marker
    original_bottom = bottom_marker

    # Simulate the move
    if is_top:
        top_marker = marker_pos
    else:
        bottom_marker = marker_pos

    product = top_marker * bottom_marker
    row, col = find_cell(product)

    # Restore original positions
    top_marker = original_top
    bottom_marker = original_bottom

    # Check if the move is valid
    if row == -1 or ownership[row][col] != 0:
        return False, -1, -1

    # Simulate claiming the cell
    ownership[row][col] = player
    win = check_win(player)
    ownership[row][col] = 0  # Undo the move

    return win, row, col


def computer_move():
    """Determine the computer's move (bottom marker)."""
    global bottom_marker

    # Try to win: Check each position 1-9 for the bottom marker
    for pos in range(1, 10):
        win, row, col = simulate_move(pos, False, 2)  # Computer is player 2
        if win:
            bottom_marker = pos
            return row, col

    # Try to block the player: Check if the player can win on their next move
    for pos in range(1, 10):
        win, row, col = simulate_move(pos, True, 1)  # Simulate player's move
        if win:
            # Move the bottom marker to block
            for block_pos in range(1, 10):
                _, block_row, block_col = simulate_move(block_pos, False, 2)
                if (
                    block_row == row
                    and block_col == col
                    and ownership[block_row][block_col] == 0
                ):
                    bottom_marker = block_pos
                    return block_row, block_col

    # If no winning or blocking move, choose a random valid position
    valid_moves = []
    for pos in range(1, 10):
        _, row, col = simulate_move(pos, False, 2)
        if row != -1 and ownership[row][col] == 0:
            valid_moves.append(pos)

    if valid_moves:
        bottom_marker = random.choice(valid_moves)
        product = top_marker * bottom_marker
        row, col = find_cell(product)
        return row, col
    else:
        # No valid moves left (shouldn't happen if board isn't full)
        return -1, -1


def play_game():
    """Main game loop: Player vs Computer."""
    global top_marker, bottom_marker

    while True:
        # Player's turn (controls the top marker)
        display_game_state("Your turn (X)")

        # Prompt the player to move the top marker
        while True:
            try:
                new_pos = int(input("Move the top marker to a number (1-9): "))
                if 1 <= new_pos <= 9:
                    break
                else:
                    show_message("Invalid input, enter a number between 1 and 9.")
                    display_game_state("Your turn (X)")
            except ValueError:
                show_message("Invalid input, enter a number between 1 and 9.")
                display_game_state("Your turn (X)")

        # Update the top marker position
        top_marker = new_pos

        # Calculate the product and find the cell
        product = top_marker * bottom_marker
        row, col = find_cell(product)

        # Check if the cell exists and is available
        if row == -1:
            show_message(f"Product {product} is not in the grid, try again.")
            continue
        if ownership[row][col] != 0:
            show_message("Cell already taken, try again.")
            continue

        # Claim the cell for the player
        ownership[row][col] = 1
        show_message(f"You claim {product}!")

        # Check for a win
        if check_win(1):
            display_game_state("Your turn (X)")
            show_message("You win!")
            break

        # Check for a tie
        if is_board_full():
            display_game_state("Your turn (X)")
            show_message("It's a tie!")
            break

        # Computer's turn (controls the bottom marker)
        display_game_state("Computer's turn (O)")

        # Computer makes a move
        row, col = computer_move()
        if row == -1:
            show_message("Computer has no valid moves left!")
            break

        product = top_marker * bottom_marker
        ownership[row][col] = 2
        show_message(f"Computer claims {product}!")

        # Check for a win
        if check_win(2):
            display_game_state("Computer's turn (O)")
            show_message("Computer wins!")
            break

        # Check for a tie (redundant but safe)
        if is_board_full():
            display_game_state("Computer's turn (O)")
            show_message("It's a tie!")
            break


if __name__ == "__main__":
    print("Welcome to Multiplication Four!")
    print("Move the top marker on the number line to claim cells. Four in a row wins!")
    print("You are X (red), the computer is O (blue).")
    input("Press Enter to start the game...")
    play_game()
