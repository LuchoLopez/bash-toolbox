#!/bin/bash

# @ checkSocket
# Description: Test connection to socket (ip:port) using netcat or nc command
# 1st param  : IP address
# 2nd param  : Port number
# 3rd param  : [optional] Connection timeoute in seconds. Default value 5s
# Return     : 'ERR' when something was wrong, else return 'OK'
function checkSocket {
  local ipaddress=${1}
  local port=${2}
  local timeout=${3}
  local nc_cmd=''
  if [ $(which nc) ]; then
    nc_cmd=nc
  elif [ $(which netcat) ]; then
    nc_cmd=netcat
  fi
  if [ -n "${nc_cmd}" ]; then
    if [ -z "${timeout}" ]; then
      timeout=5
    fi
    ${nc_cmd} -w ${timeout} ${ipaddress} ${port} <<< 'quit;' &>/dev/null
    if [ $? -ne 0 ]; then
      echo 'ERR'
    else
      echo 'OK'
    fi
  else
    echo 'ERR'
  fi
}

# @ admRoute
# Description: Add or delete routes (using route command) TODO: Add ip command support
# 1st param  : operation 'add' or 'del'
# 2nd param  : network address (ex: 192.168.1.0)
# 3rd param  : network mask (ex: 255.255.255.0)
# 4th param  : gateway to be used for this route
# 5th param  : interface name to be used for this route
# Return     : 'ERR' when something was wrong, else return 'OK'
function admRoute {
  local operation=${1}
  local network=${2}
  local netmask=${3}
  local gateway=${4}
  local iface=${5}
  if [[ "${operation}" != 'add' && "${operation}" != 'del' ]]; then
      echo 'ERR'
  else
      route ${operation} -net "${network}" netmask ${netmask} gw ${gateway} dev ${iface} &> /dev/null
      if [ $? -ne 0 ]; then
          echo 'ERR'
      else
          echo 'OK'
      fi
  fi
}
