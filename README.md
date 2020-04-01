# Quake III Server in Docker optimized for Unraid
This container will download and install Quake III Server (You have to copy your .pk3 files from your game directory to your server).

PK3 Files: After the container started the first time you have to copy your pak*.pk3 files from your Quake III Arena directory into your server directory: .../.q3a/baseq3/ (i strongly recommend you to place all your pak*.pk3 files into it) after that simply restart the container and it would start the server.

Configuring the server: Your server.cfg and maprotationfile.cfg is located into your server directory and .../.q3a/baseq/ (after you successfully started the Quake III Server once).


## Env params
| Name | Value | Example |
| --- | --- | --- |
| SERVER_DIR | Folder for gamefile | /serverdata/serverfiles |
| GAME_PARAMS | Enter your preferred game version | +set sv_punkbuster 0 +set fs_game osp +set com_hunkMegs 32 |
| Q3_PORT | The Quake III Server base port (you have to expose this and the following 3 port from this port on) | 27960 |
| Q3_MAP | The prefered startup map | q3dm0 |
| DL_URL_PR | The Download URL to the Pointrelease 1.32b | https://ftp.gwdg.de/pub/misc/ftp.idsoftware.c... |
| DL_URL_PATCH | The Download URL for the server patch 1.32c | https://ftp.gwdg.de/pub/misc/ftp.idsoftware.c... |
| UID | User Identifier | 99 |
| GID | Group Identifier | 100 |
| UMASK | User file permission mask for newly created files | 000 |
| DATA_PERM | Data permissions for main storage folder | 770 |

## Run example
```
docker run --name Quake3Server -d \
	-p 27960:27960/udp -p 27961:27961/udp -p 27962:27962/udp -p 27963:27963/udp \
	--env 'GAME_PARAMS=+set sv_punkbuster 0 +set fs_game osp +set com_hunkMegs 32' \
	--env 'Q3_PORT=27960' \
	--env 'Q3_MAP=q3dm0' \
	--env 'DL_URL_PR=https://ftp.gwdg.de/pub/misc/ftp.idsoftware.com/idstuff/quake3/linux/linuxq3apoint-1.32b-3.x86.run' \
	--env 'DL_URL_PATCH=https://ftp.gwdg.de/pub/misc/ftp.idsoftware.com/idstuff/quake3/quake3-1.32c.zip' \
	--env 'UID=99' \
	--env 'GID=100' \
	--env 'UMASK=000' \
	--env 'DATA_PERM=770' \
	--volume /mnt/user/appdata/quake3:/quake3 \
	ich777/quake3
```

This Docker was mainly edited for better use with Unraid, if you don't use Unraid you should definitely try it!

#### Support Thread: https://forums.unraid.net/topic/79530-support-ich777-gameserver-dockers/
