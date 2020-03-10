#!/bin/bash
if [ ! -d ${DATA_DIR}/.q3a/baseq3 ]; then
	mkdir -p ${DATA_DIR}/.q3a/baseq3
fi

echo "---Checking if .pk3 files are present---"
if [ ! -f ${DATA_DIR}/.q3a/baseq3/pak0.pk3 ]; then
	echo "-----------------------------------------------------------"
	echo "---No pak file found in your .../.q3a/baseq3/ folder...----"
    echo "----Please paste all your pak*.pk3 files from your game----"
    echo "------directory into your .../.q3a/baseq3/ folder and -----"
    echo "---restart the container, putting server into sleep mode---"
    echo "-----------------------------------------------------------"
    sleep infinity
else
	echo "---pak0.pk3 found, continuing---"
fi

echo "---Prepare Server---"
echo "---Checking if 'server.cfg' is present---"
if [ ! -f ${DATA_DIR}/.q3a/baseq3/server.cfg ]; then
	echo "--- No 'server.cfg' found, downloading---"
    cd ${DATA_DIR}/.q3a/baseq3
	if wget -q -nc --show-progress --progress=bar:force:noscroll https://raw.githubusercontent.com/ich777/docker-quake3/master/config/server.cfg ; then
		echo "---Successfully downloaded 'server.cfg'---"
	else
		echo "---Can't download 'server.cfg', putting server into sleep mode...---"
        sleep infinity
	fi
else
	echo "---'server.cfg' found, continuing---"
fi

echo "---Server ready---"
chmod -R ${DATA_PERM} ${DATA_DIR}

echo "---Starting server---"
cd ${DATA_DIR}
${DATA_DIR}/q3ded +set fs_basepath ${DATA_DIR} +set net_ip 0.0.0.0 +set dedicated 1 +map ${Q3_MAP} +set net_port ${Q3_PORT} +exec server.cfg