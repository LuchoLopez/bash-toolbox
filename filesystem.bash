#!/bin/bash


# @ checkFolder
# Description: Chek if folder exists (or create it)
# 1st param  : Full path to folder
# 2nd param  : [optional] if 'create' is used, then I create the folder if not exists
# Return     : 'ERR' when something was wrong, else return 'OK'
function checkFolder {
  local folder="${1}"
  local create="${2}"
  if [[ "${create}" == 'create' ]]; then
    mkdir -p "${folder}" &>/dev/null
  fi
  if [[ ! -d "${folder}" ]]; then
      echo 'ERR'
  else
      echo 'OK'
  fi
}

