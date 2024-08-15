#!/usr/bin/env bash

# Author :- Ashish Kumar (23B1028)

###########################################################################################################################################################################

###############
# Auto Grader #
###############

# Source the function_auto_grader.sh file to include its functions
source function_auto_grader.sh

# Combine function for main.csv
if [ "$1" == "combine" ]; then
    if [ -e main.csv ]; then
        # Check if the main.csv file contains the required header
        if grep -q "^Roll_Number,Name.*,Total$" main.csv; then
            # Call combine function
            combine
            # Call total function
            total
        else 
            # Call combine function only
            combine
        fi
    else 
        # Call combine function only
        combine
    fi
fi

# Upload function for main.csv
if [ "$1" == "upload" ]; then
    # Call upload function with the second argument as the file to upload
    upload "$2"
fi

# Total function for main.csv
if [ "$1" == "total" ]; then
    # Call total function
    total
fi

# Update function for main.csv
if [ "$1" == "update" ]; then
    # Call update function
    update
fi

# Stats function for main.csv
if [ "$1" == "stats" ]; then
    stats
fi

if [ "$1" == "plot" ]; then
    python3 ./plotting.py
fi

if [ "$1" == "rank" ]; then
    # Get the header and find the index of the Total column
    header=$(head -n 1 main.csv)

    # Rearrange the header to desired order
    new_header=$(echo $header | awk -F, '{print $2","$1","$NF}')

    # Print the new header
    echo $new_header > rank.csv

    # Sort by total marks
    awk -F, 'NR==1 {next} {print $2","$1","$NF}' main.csv | sort -nr -t, -k3 | cut -d, -f1-3 >> rank.csv
    awk -F, 'NR==1 {print $0 ",Rank"; next} {print $0 "," ++rank}' rank.csv > temp.csv
    rm rank.csv
    mv temp.csv rank.csv
fi

############################################################################################################################################################

##########################
# Version Control System #
##########################

# Source the function_git.sh file to include its functions
source function_git.sh

# Check if the command is git_init
if [ "$1" == "git_init" ]; then
    init "$2"
fi

# Check if the command is git_commit
if [ "$1" == "git_commit" ] && [ "$2" == "-m" ]; then
    # Check if git is initialized
    if [ ! -f .flag ]; then
        echo "git is not initialized"
        exit 1
    else 
        # Call the commit function with the commit message
        commit "$3"
        # Get the current commit count
        cnt=$(cat .cnt)
        # Check if there are at least 2 commits
        if [ $cnt -gt 2 ]; then
            # Get the path from the flag file
            pa=$(cat .flag)
            # Decrement the commit count
            ((cnt = cnt - 1))
            # Get the paths for the last two commits
            directory_path2="${pa}/commit_${cnt}"
            ((cnt = cnt - 1))
            directory_path1="${pa}/commit_${cnt}"
            # Check if the directories exist
            if [ ! -d "$directory_path2" ] || [ ! -d "$directory_path1" ]; then
                echo "Directories not found"
                exit 1
            fi
            # Iterate over files in directory_path2
            for file1 in "$directory_path2"/*.csv; do
                if [ -f "$file1" ] && [ "${file1##*/}" != ".*" ]; then
                    # Check if the file exists in directory_path1
                    file2="$directory_path1/${file1##*/}"
                    if [ -e "$file2" ] && [ "${file2##*/}" != ".*" ]; then
                        # Compare the files
                        cmp -s "$file1" "$file2"
                        if [ $? -ne 0 ]; then
                            echo "${file1##*/} : Modified"
                        fi
                    fi
                fi
            done
        fi
    fi
fi

# Check if the command is git_checkout
if [ "$1" == "git_checkout" ]; then
    checkout "$2"
fi

if [ "$1" == "git_log" ]; then                # Check if the first argument is "git_log"
    log
fi                                           # End of if statement
