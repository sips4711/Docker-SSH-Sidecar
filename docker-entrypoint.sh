#!/bin/sh
# generate host keys if not present
ssh-keygen -A

echo "www-data:${SSH_PASSWORD}" | chpasswd
echo "root:${SSH_ROOT_PASSWORD}" | chpasswd

# do not detach (-D), log to stderr (-e), passthrough other arguments
exec /usr/sbin/sshd -D -e "$@"