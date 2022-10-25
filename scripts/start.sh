#!/bin/bash
echo "---Ensuring UID: ${UID} matches user---"
usermod -u ${UID} ${USER}
echo "---Ensuring GID: ${GID} matches user---"
groupmod -g ${GID} ${USER} > /dev/null 2>&1 ||:
usermod -g ${GID} ${USER}
echo "---Setting umask to ${UMASK}---"
umask ${UMASK}

echo "---Checking for optional scripts---"
cp -f /opt/custom/user.sh /opt/scripts/start-user.sh > /dev/null 2>&1 ||:
cp -f /opt/scripts/user.sh /opt/scripts/start-user.sh > /dev/null 2>&1 ||:

if [ -f /opt/scripts/start-user.sh ]; then
    echo "---Found optional script, executing---"
    chmod -f +x /opt/scripts/start-user.sh ||:
    /opt/scripts/start-user.sh || echo "---Optional Script has thrown an Error---"
else
    echo "---No optional script found, continuing---"
fi

echo "---Checking if Quake3 is installed---"
if [ ! -f ${DATA_DIR}/q3ded ]; then
	echo "---Quake 3 not found, downloading...---"
	cd ${DATA_DIR}
	if wget -q -nc --show-progress --progress=bar:force:noscroll -O ${DATA_DIR}/quake.run "${DL_URL_PR}" ; then
    	echo "---Successfully downloaded Quake3---"
	else
    	echo "---Can't download Quake3 please check your download URL, putting server into sleep mode---"
        sleep infinity
	fi
	if wget -q -nc --show-progress --progress=bar:force:noscroll -O ${DATA_DIR}/quake.zip "${DL_URL_PATCH}" ; then
    	echo "---Successfully downloaded Quake3 Patch---"
	else
    	echo "---Can't download Quake3 Patch please check your download URL, putting server into sleep mode---"
        sleep infinity
	fi
    chmod +x ${DATA_DIR}/quake.run
    ${DATA_DIR}/quake.run --target ${DATA_DIR}/quake3/install > /dev/null
    unzip ${DATA_DIR}/quake.zip
    rm quake.run
    rm quake.zip
    mkdir -p /tmp/quake3
    mv ${DATA_DIR}/quake3/install/bin/Linux/x86/* /tmp/quake3/
    mv ${DATA_DIR}/Quake*/linux/* /tmp/quake3/
    rm -R ${DATA_DIR}/*
    mv /tmp/quake3/* ${DATA_DIR}/
    rm -R /tmp/quake3
    mkdir -p ${DATA_DIR}/.q3a/baseq3
else
	echo "---Quake 3 found, continuing...---"
fi

echo "---Taking ownership of data...---"
chown -R root:${GID} /opt/scripts
chmod -R 750 /opt/scripts
chown -R ${UID}:${GID} ${DATA_DIR}
chmod -R ${DATA_PERM} ${DATA_DIR}

echo "---Starting...---"
term_handler() {
	kill -SIGTERM "$killpid"
	wait "$killpid" -f 2>/dev/null
	exit 143;
}

trap 'kill ${!}; term_handler' SIGTERM
su ${USER} -c "/opt/scripts/start-server.sh" &
killpid="$!"
while true
do
	wait $killpid
	exit 0;
done