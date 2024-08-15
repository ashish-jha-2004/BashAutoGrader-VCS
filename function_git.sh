#!/usr/bin/env bash

# Author :- Ashish Kumar

# Function to generate a random 16-digit number
generate_random_16_digit_number() {
    # Generate 16 random digits and concatenate them
    number=""
    for i in {1..16}; do
        digit=$(( RANDOM % 10 ))
        number="${number}${digit}"
    done
    echo "$number"
}

function init {
    # Create a directory specified by the second argument
    path="$1"
    cur_d=$(pwd)
    if [ ! -d "$path" ]; then
        mkdir -p "$path"
    fi
    # Store the path in a flag file
    echo "$path" > .flag
    # Initialize commit count to 1
    echo "1" > .cnt
    # Store the current directory
    current_d=$(pwd)
    # Change directory to the specified path
    cd $path
    # Create a .git_log file to store commit information
    touch .git_log
    # Change back to the original directory
    cd $current_d
}

# Function to commit changes
function commit {
    # Copy the path from the hidden file from .flag
    pa=$(cat .flag)
    # Copy the path of the present working directory
    cuwd=$(pwd)
    # Get the current commit count
    cnt=$(cat .cnt)
    # Change directory to the repository path
    cd "$pa"
    # Generate a random 16-digit number and append it to .git_log
    generate_random_16_digit_number >> .git_log
    # Append the commit message to .git_log
    echo "$1" >> .git_log
    # Create a directory for the commit
    mkdir "commit_${cnt}"
    # Change back to the original directory
    cd "$cuwd"
    # Copy all files from the current directory to the commit directory
    cp -r ./*.csv "${pa}/commit_${cnt}"
    # Increment the commit count
    ((cnt = cnt + 1))
    # Update the commit count in .cnt
    echo "$cnt" > .cnt
}


function checkout {
    # Print the current directory
    echo $(pwd)
    # Get the path from the flag file
    pat=$(cat .flag)
    # Check if the commit specified by the second argument exists
    # checking how much commit exist with the same no.
    ct=$(grep -E "$1" "${pat}/.git_log" | wc -l)
    # if ct == 0 then no any such commit exists
    if [ $ct -eq 0 ]; then
        echo "no such commits exist"
        exit 1
    fi
    # if the count is greater then 1 then conflict occurs
    if [ $ct -gt 1 ]; then
        echo "conflict occurred"
        exit 1
    # otherwise do the usual stuff
    else 

        # Store the current working directory
        cw=$(pwd)
        # Change directory to the repository path
        cd $pat
        # Get the line number of the commit in the .git_log file
        line_no=$(awk -v pattern="$1" '$0 ~ pattern { print NR }' .git_log)
        # Calculate the commit number based on whether the line number is even or odd
        number=$line_no
        cd $cw
        if [ $((number % 2)) -eq 0 ]; then
            ((number = number/2))
            rm *.csv
            cd "${pat}/commit_${number}/"
            cp -r * "$cw"
            cd "$cw"
        else
            ((number = (number+1)/2))
            rm *.csv
            cd "${pat}/commit_${number}/"
            cp -r * "$cw"
            cd "$cw"
        fi
    fi
}

#################################################################################################################################################

#customisation

function log {
    pathr=$(cat .flag)                        # Read the path from the .flag file
    curd=$(pwd)                               # Store the current directory
    cd "$pathr"                               # Change directory to the path from .flag
    k=1                                       # Initialize commit counter
    num=2                                     # Initialize line number counter (starting from 2)
    cat .git_log > temp.txt                   # Copy contents of .git_log to temp.txt
    while read -r line; do                    # Read each line of temp.txt
        if [ $((num % 2)) -eq 0 ];then        # Check if the line number is even
            echo "=============================================================================================="
            echo "commit ${k}"                # Print commit number
            ((k = k + 1))                     # Increment commit counter
        fi
        ((num += 1))                          # Increment line number
        echo "$line"                          # Print the current line
    done < temp.txt                           # End of loop reading temp.txt
    echo "=============================================================================================="
    rm temp.txt                               # Remove the temporary file
    cd "$curd"                                # Change back to the original directory
}