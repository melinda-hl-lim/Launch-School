## Tic Tac Toe Problem Description

### Decomposing the problem

First we need to describe the problem, at least at a high level. Here's Melinda's attempt at describing Tic Tac Toe:

Tic Tac Toe is a 2 player game. Each player has a symbol: x or o. They take turns populating a 3 x 3 grid (9 squares total) with their mark. The objective to win is to have three of your marks in a straight line: a row, a column, or along the diagonal. If no one accomplishes the straight line, it's a tie.

So the next step is to outline the sequence of the gameplay.
Here's Launch School's sequence:

1. Display the initial empty 3x3 board.
2. Ask the user to mark a square.
3. Computer marks a square.
4. Display the updated board state.
5. If winner, display winner.
6. If board is full, display tie.
7. If neither winner nor board is full, go to #2
8. Play again?
9. If yes, go to #1
10. Good bye!

Now Melinda will attempt to break down the whole process into reusable methods:

game_loop()

round_loop()

display_board(marker_array)

place_marker(player, position)

winner?(marker_array)

prompt(message)

marker_array:
[[0,1,2],[3,4,5],[6,7,8]]
