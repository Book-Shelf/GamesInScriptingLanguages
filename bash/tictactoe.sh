#!/bin/bash
declare -A board
circle_move=true
game_over=1
move_remaining=9

initialize_board() {
    for ((i=0;i<3;i++))
    do
        for ((j=0;j<3;j++))
        do
            board[${i},${j}]=0
        done
    done
}

print_board() {
    for row in {0..2}
    do
        for col in {0..2}
        do
            sign=""

            if [[ ${board[${row},${col}]} == 1 ]]; then
                sign="x"
            elif [[ ${board[${row},${col}]} == 2 ]]; then
                sign="o"
            else
                printf " "
            fi

            printf "%s" ${sign}

            if [[ ${col} != 2 ]]; then
                printf "|"
            fi

        done

        if [[ ${row} != 2 ]]; then
            printf "\n_____\n"
        fi
    done
    
    printf "\n"
}

is_position_available() {

    if [[ ${board[${1},${2}]} != 0 ]]; then
        echo "Position is already taken"
        return 1
    fi

    return 0
}

check_input_format() {
    if [[ (${1} != 0 && ${1} != 1 && ${1} != 2) || (${2} != 0 && ${2} != 1 && ${2} != 2) ]]; then
        echo "Wrong input format"
        return 1
    fi

    return 0
}

check_if_game_over() {
    player=""

    if [[ $1 == 1 ]]; then
        player="Cross"
    else
        player="Nought"
    fi

    for i in {0..2}
    do
        if [[ (${board[${i},0]} == $1 && ${board[${i},1]} == $1 && ${board[${i},2]} == $1) || (${board[0,${i}]} == $1 && ${board[1,${i}]} == $1 && ${board[2,${i}]} == $1) ]]; then
            game_over=0
            printf "Congratulations!\n%s player won!\n\n" ${player}
            print_board
        fi
    done

    if [[ (${board[0,0]} == $1 && ${board[1,1]} == $1 && ${board[2,2]} == $1) || (${board[2,0]} == $1 && ${board[1,1]} == $1 && ${board[0,2]} == $1) ]]; then
        game_over=0
        printf "Congratulations!\n%s player won!\n\n" ${player}
        print_board
    fi

    if [[ ${move_remaining} == 0 && ${game_over} != 0 ]]; then
        printf "GAME OVER\nIt is a tie!\n"
        game_over=0
        print_board
    fi
}

initialize_board

while [ ${game_over} -eq 1 ]
do  
    print_board

    read -p "Enter position row column: " row col

    if ! check_input_format ${row} ${col} || ! is_position_available ${row} ${col} ; then
        continue
    fi

    move_remaining=$((move_remaining - 1))

    if ${circle_move} ; then
        board[${row},${col}]=2
        circle_move=false
        check_if_game_over 2
    else
        board[${row},${col}]=1
        circle_move=true
        check_if_game_over 1
    fi

done
