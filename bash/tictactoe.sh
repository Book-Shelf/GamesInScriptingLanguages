#!/bin/bash
declare -A board

# initialize board
for ((i=0;i<3;i++))
do
    for ((j=0;j<3;j++))
    do
        board[${i},${j}]=0
    done
done

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

# check_if_game_over() {

# }

circle_move=true

while [ true ]
do  
    print_board

    read -p "Enter position row column: " row col

    if ! check_input_format ${row} ${col} || ! is_position_available ${row} ${col} ; then
        continue
    fi

    if ${circle_move} ; then
        board[${row},${col}]=2
        circle_move=false
    else
        board[${row},${col}]=1
        circle_move=true
    fi

    

    echo "bitch"
done
