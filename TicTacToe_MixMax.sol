pragma solidity ^0.7.0;

// Tic Tac Toe game board:
//
//  0 | 1 | 2
// -----------
//  3 | 4 | 5
// -----------
//  6 | 7 | 8

// Board state is represented as a single integer, with each digit representing
// the state of that position on the board. 0 = empty, 1 = player 1 (X), 2 = player 2 (O).

// Minmax search depth
const uint8 DEPTH = 5;

contract TicTacToe {
    // The current player (1 or 2)
    uint8 public player;

    // The current state of the board
    uint public board;

    // The game has ended (true) or is still in progress (false)
    bool public gameOver;

    // The winner of the game (0 = draw, 1 = player 1, 2 = player 2)
    uint8 public winner;

    // The smart contract's address is player 1 (X)
    constructor() public {
        player = 1;
        board = 0;
        gameOver = false;
        winner = 0;
    }

    // Makes a move on the board.
    // Only callable if the game is not over and it is the current player's turn.
    function makeMove(uint8 position) public {
        require(!gameOver, "The game is already over.");
        require(player == 1, "It is not your turn.");
        require(position >= 0 && position <= 8, "Invalid position.");
        require((board / 10 ** position) % 10 == 0, "Position is already occupied.");

        board = board + (player * 10 ** position);
        checkGameOver();

        if (!gameOver) {
            // It's the computer's turn, so make its move
            uint8 computerMove = minmax(board, DEPTH, 2).index;
            board = board + (2 * 10 ** computerMove);
            checkGameOver();
        }
    }

    // Checks if the game is over and sets the gameOver and winner variables accordingly.
    function checkGameOver() private {
        // Check rows
        for (uint8 i = 0; i < 3; i++) {
            if (getBoardPosition(i) != 0 && getBoardPosition(i) == getBoardPosition(i+3) && getBoardPosition(i) == getBoardPosition(i+6)) {
                gameOver = true;
                winner = getBoardPosition(i);
                return;
            }
        }

        // Check columns
        for (uint8 i = 0; i < 3; i++) {
            if (getBoardPosition(i*3) != 0 && getBoardPosition(i*3) == getBoardPosition(i*3+1) && getBoardPosition(i*3) == getBoardPosition(i*3+2)) {
                gameOver = true;
                winner = getBoardPosition(i*3);
                return;
            }
        }

        // Check diagonals
        if (getBoardPosition(0) != 0 && getBoardPosition(0) == getBoardPosition(4) && getBoardPosition(0)
        // Retrieves the value at a specific position on the board.
function getBoardPosition(uint8 position) private view returns (uint8) {
    return uint8((board / 10 ** position) % 10);
}

// Returns the minimax value of the current board state at a given search depth.
// minmax(board, depth, player) -> best move for player at current board state
function minmax(uint board, uint8 depth, uint8 player) private view returns (uint8 value, uint8 index) {
    if (depth == 0 || gameOver) {
        return (evaluateBoard(board), 0);
    }

    if (player == 1) {
        uint8 maxValue = 0;
        uint8 maxIndex = 0;
        for (uint8 i = 0; i < 9; i++) {
            if (getBoardPosition(i) == 0) {
                uint newBoard = board + (player * 10 ** i);
                uint8 value = minmax(newBoard, depth - 1, 2).value;
                if (value > maxValue) {
                    maxValue = value;
                    maxIndex = i;
                }
            }
        }
        return (maxValue, maxIndex);
    } else {
        uint8 minValue = 10;
        uint8 minIndex = 0;
        for (uint8 i = 0; i < 9; i++) {
            if (getBoardPosition(i) == 0) {
                uint newBoard = board + (player * 10 ** i);
                uint8 value = minmax(newBoard, depth - 1, 1).value;
                if (value < minValue) {
                    minValue = value;
                    minIndex = i;
                }
            }
        }
        return (minValue, minIndex);
    }
}

// Returns the value of the current board state for the given player.
// A higher value means a more favorable board state for the player.
function evaluateBoard(uint board) private view returns (uint8) {
    // Check rows
    for (uint8 i = 0; i < 3; i++) {
        if (getBoardPosition(i) != 0 && getBoardPosition(i) == getBoardPosition(i+3) && getBoardPosition(i) == getBoardPosition(i+6)) {
            if (getBoardPosition(i) == 1) {
                return 10;
            } else {
                return 0;
            }
        }
    }

    // Check columns
    for (uint8 i = 0; i < 3; i++) {
        if (getBoardPosition(i*3) != 0 && getBoardPosition(i*3) == getBoardPosition(i*3+1) && getBoardPosition(i*3) == getBoardPosition(i*3+2)) {
            if (getBoardPosition(i*3) == 1) {
                return 10;
            } else {
                return 0;
            }
        }
    }

    // Check diagonals
    if (getBoardPosition(0) != 0 && getBoardPosition(0) == getBoardPosition(4) && getBoardPosition(0) == getBoardPosition(8)) {
        if (getBoardPosition(0) == 1) {
            return 10;
} else {
        if (getBoardPosition(2) != 0 && getBoardPosition(2) == getBoardPosition(4) && getBoardPosition(2) == getBoardPosition(6)) {
            if (getBoardPosition(2) == 1) {
                return 10;
            } else {
                return 0;
            }
        }
    }

    // No winner yet, so return a value based on how many moves are left
    uint8 movesLeft = 0;
    for (uint8 i = 0; i < 9; i++) {
        if (getBoardPosition(i) == 0) {
            movesLeft++;
        }
    }
    return movesLeft;
}
