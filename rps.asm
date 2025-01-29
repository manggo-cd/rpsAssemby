.data
    user_prompt: .asciiz "Enter R (Rock), P (Paper), S (Scissors): "
    ai_choice_text: .asciiz "AI chose: "
    win_msg: .asciiz "You Win!\n"
    lose_msg: .asciiz "You Lose!\n"
    tie_msg: .asciiz "It's a Tie!\n"
    rock_txt: .asciiz "Rock\n"
    paper_txt: .asciiz "Paper\n"
    scissors_txt: .asciiz "Scissors\n"
    user_input: .space 2  # Buffer for user input

.text
.globl main
main:
    # Print user prompt
    li $v0, 4
    la $a0, user_prompt
    syscall

    # Read user input
    li $v0, 8
    la $a0, user_input
    li $a1, 2
    syscall

    # Generate AI choice (0 = Rock, 1 = Paper, 2 = Scissors)
    li $v0, 42
    li $a0, 0
    li $a1, 3
    syscall
    move $t0, $a0  # Store AI move in $t0

    # Print AI choice text
    li $v0, 4
    la $a0, ai_choice_text
    syscall

    # Print AI's move
    beq $t0, 0, print_rock
    beq $t0, 1, print_paper
    beq $t0, 2, print_scissors

print_rock:
    li $v0, 4
    la $a0, rock_txt
    syscall
    j determine_winner

print_paper:
    li $v0, 4
    la $a0, paper_txt
    syscall
    j determine_winner

print_scissors:
    li $v0, 4
    la $a0, scissors_txt
    syscall
    j determine_winner

determine_winner:
    # Load user input
    la $t1, user_input
    lb $t2, 0($t1)

    # Check if user chose Rock ('R' = 82)
    li $t3, 82
    beq $t2, $t3, user_rock

    # Check if user chose Paper ('P' = 80)
    li $t3, 80
    beq $t2, $t3, user_paper

    # Check if user chose Scissors ('S' = 83)
    li $t3, 83
    beq $t2, $t3, user_scissors

    # Invalid input, restart
    j main

user_rock:
    beq $t0, 0, print_tie      # AI Rock
    beq $t0, 1, print_lose     # AI Paper
    beq $t0, 2, print_win      # AI Scissors

user_paper:
    beq $t0, 0, print_win      # AI Rock
    beq $t0, 1, print_tie      # AI Paper
    beq $t0, 2, print_lose     # AI Scissors

user_scissors:
    beq $t0, 0, print_lose     # AI Rock
    beq $t0, 1, print_win      # AI Paper
    beq $t0, 2, print_tie      # AI Scissors

print_win:
    li $v0, 4
    la $a0, win_msg
    syscall
    j main

print_lose:
    li $v0, 4
    la $a0, lose_msg
    syscall
    j main

print_tie:
    li $v0, 4
    la $a0, tie_msg
    syscall
    j main
