#!/bin/sh

KEY_TYPE='rsa'
KEY_DIR="${HOME}/.ssh"
KEY_NAME="${KEY_DIR}/id_rsa"
TIME=`date +"%Y%m%d%H%M%S"`

# 鍵を作成する
[ -d $KEY_DIR ] || mkdir $KEY_DIR && chmod 700 $KEY_DIR
[ -d $KEY_DIR ] && \
	echo "please input Mail Address" && read MailAdress && echo -e '\n' && \
	echo "please input password" && read PASSWD && echo -e '\n' && \
	ssh-keygen -t ${KEY_TYPE} -f ${KEY_NAME}`[ -s $MailAdress ] || echo ".${MailAdress}"`.${TIME} -C ''${MailAdress} -P ''${PASSWD}

exit 0
