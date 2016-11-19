#!/bin/bash


# @ writelog
# Description: Append a message to a logfile
# 1st param  : Text to append to the logfile. Default value /tmp/bash-toolbox.log
# 2nd param  : Log file path. Default value /tmp/bash-toolbox.log
function writelog {
  local text="${1}"
  local logfile="${2}"
  if [ -n "${text}" ]; then
    if [ -z "${logfile}" ]; then
      logfile='/tmp/bash-toolbox.log'
    fi
    echo "$(date '+%Y-%m-%d %H:%M:%S') - ${2}" >> "${1}"
  fi
}

# @ showinscreen
# Description: Prints a colored message to screen
# 1st param  : Text to print
# 2nd param  : [optional] Message level (ERR,WRN,INF,OK)
function showinscreen {
  local red='\033[1;31m'
  local green='\033[0;32m'
  local yellow='\033[1;33m'
  local blue='\033[1;34m'
  local default='\033[0m'
  local color="${default}"
  local msgText="${1}"
  local msgType="${2}"
  if [ -z "${msgType}" ]; then
    color="${default}"
  elif [ "${msgType}" = "ERR" ]; then
    color="${red}"
  elif [ "${msgType}" = "WRN" ]; then
    color="${yellow}"
  elif [ "${msgType}" = "INF" ]; then
    color="${blue}"
  elif [ "${msgType}" = "OK" ]; then
    color="${green}"
  fi
  echo -e "${color}${msgText}${default}"
}

# @ printListItem
# Description: Prints a 'list item' character
# 1st param  : List item level (indentation in the list)
function printListItem {
  local indent='  '
  local lv1='o'
  local lv2='>'
  local lv3='*'
  local lv4='-'
  local lv5='.'
  local line=''
  local char=''
  {  
    local let itemlevel="${1}" 
  } || local let itemlevel=1 
  for level in $(seq 1 ${itemlevel}); do
    if [ ${level} -eq 1 ]; then
      char="${lv1}"
    elif [ ${level} -eq 2 ]; then
      char="${lv2}"
    elif [ ${level} -eq 3 ]; then
      char="${lv3}"
    elif [ ${level} -eq 4 ]; then
      char="${lv4}"
    elif [ ${level} -gt 4 ]; then
      char="${lv5}"
    fi
    line="${line}${indent}"
  done
  echo -n "${line}${char} "
}
