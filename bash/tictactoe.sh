#!/bin/bash
declare -A board
circle_move=true
game_over=1
move_remaining=9
dir_path=$(dirname "$0")
SAVE_FILE_NAME="save.txt"

print_welcome_message() {
    clear
    printf "\tWelcome to TicTacToe game!\n\n"
    printf "Your goal is to put three crosses or noughts in verticle, horizontal or diagonal line\n"
    printf "In your turn you will be prompted to give position where to put a nought or cross.\n"
    printf "Position is represented by two numbers, separated by space, in range 0 to 2,\n"
    printf "where 0 0 is left top corner and 2 2 is right bottom one.\n\n"
    printf "To save the game and leave type \"s\" instead of position.\n\n"
    printf "\tTo load saved game press l\n"
    printf "\tTo start the game press enter\n\n"
}

initialize_board() {
    for ((i=0;i<3;i++))
    do
        for ((j=0;j<3;j++))
        do
            board[${i},${j}]=0
        done
    done
}

save_game() {
    file_path="$dir_path/$SAVE_FILE_NAME"
    echo "Saving the game..."
    if [ ! -f "$file_path" ]; then
        touch "$file_path"
    fi

    printf "" > $file_path


    for ((i=0;i<3;i++))
    do
        for ((j=0;j<3;j++))
        do
            echo $i $j ${board[${i},${j}]} >> $file_path
        done
    done

    echo $circle_move >> $file_path
    echo $move_remaining >> $file_path

    sleep 1
    echo "Saved the game"
    sleep 1
    echo "Leaving the game"
    game_over=0
}

load_game() {
    file_path="$dir_path/$SAVE_FILE_NAME"

    printf "\nLoading saved game...\n\n"

    if [ ! -f "$file_path" ]; then
        echo "There is no saved game to be found."
        sleep 1
        clear
        printf "Starting the new game"
        return 1
    fi

    line_count=11

    while read line
    do
        if (( $line_count > 2 )); then
            row=${line[0]:0:1}
            col=${line[0]:2:1}
            val=${line[0]:4:1}
            board[${row},${col}]=$val
        elif (( $line_count == 2 )); then
            circle_move=$line
        else
            move_remaining=$line
        fi

        line_count=$((line_count - 1))

    done < $file_path

    sleep 1
    printf "\nSaved game Loaded\n"
    printf "Starting the game\n\n"

    return 0
}

print_board() {
    printf "\n"
    for row in {0..2}
    do
        printf "\t"
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
            printf "\n\t_____\n"
        fi
    done
    
    printf "\n\n"
}

is_position_available() {

    if [[ ${board[${1},${2}]} != 0 ]]; then
        echo "Position is already taken"
        return 1
    fi

    return 0
}

check_input_format() {

    if [[ ${1} == "s" ]]; then
        save_game
        return 1
    fi

    if [[ (${1} != 0 && ${1} != 1 && ${1} != 2) || (${2} != 0 && ${2} != 1 && ${2} != 2) ]]; then
        echo "Wrong input format"
        return 1
    fi

    return 0
}

make_move() {

    move_remaining=$((move_remaining - 1))

    if ${circle_move} ; then
        board[${1},${2}]=2
        circle_move=false
        check_if_game_over 2
    else
        board[${1},${2}]=1
        circle_move=true
        check_if_game_over 1
    fi
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

start_game() {
    while true;
    do 
        read -n 1 -s key

        if [ "$key" = "l" ]; then
            clear
            load_game
            sleep 1
            break
        fi

        if [ "$key" = "" ]; then
            break
        fi
    done

    main_game
}

main_game() {
    while [ ${game_over} -eq 1 ]
    do  
        print_board

        if ${circle_move} ; then
            printf "Nought turn.\n"
        else 
            printf "Cross turn.\n"
        fi

        read -p "Enter position (row column): " row col

        if ! check_input_format ${row} ${col} || ! is_position_available ${row} ${col} ; then
            continue
        fi

        make_move ${row} ${col}

    done
}

initialize_board
print_welcome_message
start_game
