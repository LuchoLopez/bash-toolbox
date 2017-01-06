#!/bin/bash

# Use user home as workdir
WORKDIR="${HOME}"
TIMEOUT='10'

# @ runSSHcmd
# Description: Run a command in remote host using SSH
# 1st param  : The user@host to use with SSH
# 2nd param  : Password to login user@host
# 3rd param  : The command to execute at remote host
# Return     : If something was wrong 'ERR' else return remote command output
function runSSHcmd {
	local userhost=${1}
	local pass=${2}
	local cmd=${3}
	if [ -z "${userhost}" ]; then
		echo 'ERR'
	elif [ -z "${pass}" ]; then
		echo 'ERR'
	elif [ -z "${cmd}" ]; then
		echo 'ERR'
	else
        createASKPASS 'pass' "${pass}" &>/dev/null
	    setsid ssh -oStrictHostKeyChecking=no -oLogLevel=error -oUserKnownHostsFile=/dev/null -oConnectTimeout=${TIMEOUT} ${userhost} "${cmd}" 2>/dev/null
        [[ $? -ne 0 ]] &&  echo 'ERR'
        createASKPASS 'clean' &>/dev/null
    fi
}

# @ scpImproved
# Description: Copy files using SCP without asking for password
# 1st param  : The password to do login
# 2nd param  : The source full path. user@host:/source/file or local file
# 3rd param  : The destination full path. user@host:/source/file or local file
# Return     : If something was wrong 'ERR' else return 'OK'
function scpImproved {
	local pass=${1}
	local src=${2}
	local dst=${3}

	if [ -z "${pass}" ]; then
		echo 'ERR'
	elif [ -z "${dst}" ]; then
		echo 'ERR'
	elif [ -z "${dst}" ]; then
		echo 'ERR'
	else
		createASKPASS 'pass' "${pass}" &>/dev/null
		setsid scp -oStrictHostKeyChecking=no -oLogLevel=error -oUserKnownHostsFile=/dev/null -oConnectTimeout=${TIMEOUT} ${src} ${dst} &>/dev/null
		[[ $? -eq 0 ]] && echo 'OK' || echo 'ERR'
		createASKPASS 'clean' &>/dev/null
	fi
}


# @ copySSHid
# Description: Copy a key file into remote host without asking for password
# 1st param  : The full path to key file (ssh public key file)
# 2nd param  : user@host to copy the public key file
# 3rd param  : The password to do login
# Return     : If something was wrong 'ERR' else return 'OK'
# NOTES: This function use egrep to "determine" if keyfile is a PUBLIC KEY (security reasons)
function copySSHid {
	local keyfile=${1}
	local userhost=${2}
	local pass=${3}

	if [ -z "${userhost}" ]; then
		echo 'ERR'
	elif [ -z "${keyfile}" ]; then
		echo 'ERR'
	elif [ -z "${pass}" ]; then
		echo 'ERR'
	else
        
		if [ ! -f ${keyfile} ]; then
			echo 'ERR'
		elif [ ! $(egrep -zo ' [^ ]+@.*' "${keyfile}" ) ]; then
			# If we are here, I think keyfile is PRIVATE KEY and not PUBLIC
			# 'cause public key file ends with text like this: ' user@hostname'
			echo 'ERR'
		else
			createASKPASS 'pass' "${pass}" &>/dev/null
			setsid ssh-copy-id -i ${keyfile} -oStrictHostKeyChecking=no -oLogLevel=error -oUserKnownHostsFile=/dev/null -oConnectTimeout=${TIMEOUT} ${userhost} &>/dev/null
			[[ $? -eq 0 ]] && echo 'OK' || echo 'ERR'
			createASKPASS 'clean' &>/dev/null
		fi
	fi
}


# @ createASKPASS <only internal use>
# Description: Create a script to print SSH password instead asking you
# 1st param  : if 'clean' is used I will delete all my trash
# 1st param  : if 'pass' is used I will use 2nd parama as password
#   * 2nd param  : the password to be used to login at remote hosts
function createASKPASS {
    local ask_pass_script="${WORKDIR}/.askpass.$$"
    local operation="${1}"
    local password="${2}"
    export DISPLAY=:0
    export SSH_ASKPASS=${ask_pass_script}
    if [ -z "${operation}" ]; then
    	echo 'ERR'
    elif [ "${operation}" = 'clean' ]; then
        rm "${ask_pass_script}" &> /dev/null
        unset SSH_ASKPASS &> /dev/null
    else
    	if [ "${operation}" = 'pass' ]; then
    		if [ -z "${password}" ]; then
    			echo 'ERR'
    		fi
    	fi
        cat > ${ask_pass_script} << EOF
#!/bin/sh
echo "${password}"
EOF
        chmod 755 ${ask_pass_script}
    fi
}
