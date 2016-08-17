#!/bin/sh

KEY_TYPE='rsa'
KEY_LENGTH='4096'
KEY_DIR="${HOME}/.ssh"
KEY_NAME="${KEY_DIR}/id_rsa"
TIME=`date +"%Y%m%d%H%M%S"`

# 鍵を作成する
[ -d $KEY_DIR ] || mkdir $KEY_DIR && chmod 700 $KEY_DIR
[ -d $KEY_DIR ] && \
	echo "please input Mail Address" && read MailAdress && echo '\n' && \
	echo "please input password" && read PASSWD && echo '\n' && \
	ssh-keygen -t ${KEY_TYPE} -b ${KEY_LENGTH} -C ''${MailAdress} -P ''${PASSWD} \
        -f ${KEY_NAME}`[ -s $MailAdress ] || echo ".${MailAdress}"`.${TIME}

exit 0
