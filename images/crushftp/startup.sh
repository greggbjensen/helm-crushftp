#!/usr/bin/env bash
CRUSH_FTP_BASE_DIR="/var/opt/CrushFTP10"
FTP_CONFIG_BASE_DIR="/mnt/config"

# Create persisted volume directories and symbolically link to correct CrushFTP path.
if [[ ! -f ${FTP_CONFIG_BASE_DIR}/config_initialized.txt ]] ; then
    echo "Creating symbolic links for FTP config..."

    if [[ ! -f ${FTP_CONFIG_BASE_DIR} ]] ; then
        mkdir -p ${FTP_CONFIG_BASE_DIR}
    fi

    cd ${FTP_CONFIG_BASE_DIR} && mkdir backup logs settings SavedReports users syncsDB statsDB
    ln -s ${FTP_CONFIG_BASE_DIR}/backup ${CRUSH_FTP_BASE_DIR}/backup
    ln -s ${FTP_CONFIG_BASE_DIR}/logs ${CRUSH_FTP_BASE_DIR}/logs
    ln -s ${FTP_CONFIG_BASE_DIR}/settings ${CRUSH_FTP_BASE_DIR}/settings
    ln -s ${FTP_CONFIG_BASE_DIR}/SavedReports ${CRUSH_FTP_BASE_DIR}/SavedReports
    ln -s ${FTP_CONFIG_BASE_DIR}/users ${CRUSH_FTP_BASE_DIR}/users
    ln -s ${FTP_CONFIG_BASE_DIR}/syncsDB ${CRUSH_FTP_BASE_DIR}/syncsDB
    ln -s ${FTP_CONFIG_BASE_DIR}/statsDB ${CRUSH_FTP_BASE_DIR}/statsDB
    touch ${FTP_CONFIG_BASE_DIR}/config_initialized.txt

    echo "Because this was an intial setup, you will want to restart the pod once fully ready for best performance."
fi

if [ -z ${CRUSH_ADMIN_USER} ]; then
    CRUSH_ADMIN_USER=crushadmin
fi

if [ -z ${CRUSH_ADMIN_PASSWORD} ] && [ -f ${CRUSH_FTP_BASE_DIR}/admin_user_set.txt ]; then
    CRUSH_ADMIN_PASSWORD="NOT DISPLAYED!"
elif [ -z ${CRUSH_ADMIN_PASSWORD} ] && [ ! -f ${CRUSH_FTP_BASE_DIR}/admin_user_set.txt ]; then
    CRUSH_ADMIN_PASSWORD=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 16 | head -n 1)
fi

if [ -z ${CRUSH_ADMIN_PROTOCOL} ]; then
    CRUSH_ADMIN_PROTOCOL=http
fi

if [ -z ${CRUSH_ADMIN_PORT} ]; then
    CRUSH_ADMIN_PORT=8080
fi

if [[ ! -f ${CRUSH_FTP_BASE_DIR}/admin_user_set.txt ]] ; then
    echo "Creating default admin..."
    cd ${CRUSH_FTP_BASE_DIR} && java -jar ${CRUSH_FTP_BASE_DIR}/CrushFTP.jar -a "${CRUSH_ADMIN_USER}" "${CRUSH_ADMIN_PASSWORD}"
    touch ${CRUSH_FTP_BASE_DIR}/admin_user_set.txt
fi

${CRUSH_FTP_BASE_DIR}/crushftp_init.sh start

until [ -f ${CRUSH_FTP_BASE_DIR}/settings/prefs.XML ]
do
     sleep 1
done

echo "########################################"
echo "# URL:		${CRUSH_ADMIN_PROTOCOL}://127.0.0.1:${CRUSH_ADMIN_PORT}"
echo "# User:		${CRUSH_ADMIN_USER}"
echo "# Password:	${CRUSH_ADMIN_PASSWORD}"
echo "########################################"

while true; do sleep 86400; done