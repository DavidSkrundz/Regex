#!/bin/sh
# Count the number of lines in the Swift project

# cd to the directory where this file is located
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd "$DIR"

# move the cursor to the top of the terminal
tput reset

# define some colors
Yellow='\033[1;33m'
Red='\033[1;31m'
Blue='\033[1;34m'
Reset='\033[0m'


printf "================================================================================\n"
printf "                                      ${Yellow}Meta${Reset}                                      \n"
printf "================================================================================\n"

find . \( -ipath ./*.swift -o -ipath ./Tests/*.swift \) -exec wc -l '{}' \+


printf "\n"
printf "================================================================================\n"
printf "                                     ${Red}Swift${Reset}                                      \n"
printf "================================================================================\n"

find . \( -ipath "./Sources/*.swift" \) -exec wc -l '{}' \+


printf "\n"
printf "================================================================================\n"
printf "                                     ${Blue}Tests${Reset}                                      \n"
printf "================================================================================\n"

find . \( -ipath "./Tests/*/*.swift" \) -exec wc -l '{}' \+


printf "\n" 
read -n1 -r -p "Press any key to continue..." key