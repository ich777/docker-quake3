FROM ich777/debian-baseimage

LABEL org.opencontainers.image.authors="admin@minenet.at"
LABEL org.opencontainers.image.source="https://github.com/ich777/docker-quake3"

RUN dpkg --add-architecture i386 && \
	apt-get update && \
	apt-get -y install --no-install-recommends screen unzip lib32z1 && \
	rm -rf /var/lib/apt/lists/*

ENV DATA_DIR="/quake3"
ENV GAME_PARAMS="+set sv_punkbuster 0 +set fs_game osp +set com_hunkMegs 32"
ENV Q3_PORT=27960
ENV Q3_MAP="q3dm0"
ENV DL_URL_PR="https://ftp.gwdg.de/pub/misc/ftp.idsoftware.com/idstuff/quake3/linux/linuxq3apoint-1.32b-3.x86.run"
ENV DL_URL_PATCH="https://ftp.gwdg.de/pub/misc/ftp.idsoftware.com/idstuff/quake3/quake3-1.32c.zip"
ENV UMASK=000
ENV UID=99
ENV GID=100
ENV DATA_PERM=770
ENV USER="quake3"

RUN mkdir $DATA_DIR && \
	useradd -d $DATA_DIR -s /bin/bash $USER && \
	chown -R $USER $DATA_DIR && \
	ulimit -n 2048

ADD /scripts/ /opt/scripts/
RUN chmod -R 777 /opt/scripts/

#Server Start
ENTRYPOINT ["/opt/scripts/start.sh"]