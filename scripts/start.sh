#!/bin/bash
echo "---Checking if UID: ${UID} matches user---"
usermod -u ${UID} ${USER}
echo "---Checking if GID: ${GID} matches user---"
usermod -g ${GID} ${USER}
echo "---Setting umask to ${UMASK}---"
umask ${UMASK}

echo "---Checking for optional scripts---"
if [ -f /opt/scripts/user.sh ]; then
	echo "---Found optional script, executing---"
    chmod +x /opt/scripts/user.sh
    /opt/scripts/user.sh
else
	echo "---No optional script found, continuing---"
fi

echo "---Checking if Quake3 is installed---"
if [ ! -f ${DATA_DIR}/q3ded ]; then
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
    chown -R ${UID}:${GID} ${DATA_DIR}
    chmod -R ${DATA_PERM} ${DATA_DIR}
fi

echo "---Starting...---"
chown -R ${UID}:${GID} /opt/scripts
su ${USER} -c "/opt/scripts/start-server.sh"