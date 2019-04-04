FROM ubuntu:latest

ARG SSH_PASSWORD
ENV SSH_PASSWORD=$SSH_PASSWORD

ARG SSH_ROOT_PASSWORD
ENV SSH_ROOT_PASSWORD=$SSH_ROOT_PASSWORD

COPY docker-entrypoint.sh /docker-entrypoint.sh

# Set correct environment variables.
ENV HOME /root
ENV DEBIAN_FRONTEND noninteractive
ENV INITRD No
ENV NOTVISIBLE "in users profile"

RUN apt-get update \
    && apt-get install -y   openssh-server \
                            nano \
                            vim-nox \
                            mariadb-client \
                            rsync \
                            curl \
    && apt-get -y autoremove && apt-get clean && apt-get autoclean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* \
    && mkdir /var/run/sshd \
    && sed -i 's/PermitRootLogin prohibit-password/"PermitRootLogin yes"/' /etc/ssh/sshd_config \
    && echo 'PermitRootLogin yes' >> /etc/ssh/sshd_config \
    && sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd \
    && echo "export VISIBLE=now" >> /etc/profile \
    && usermod --shell /bin/bash www-data \
    && usermod -m -d /home/www-data www-data \
    && chmod +x /docker-entrypoint.sh
    
EXPOSE 22

ENTRYPOINT ["/docker-entrypoint.sh"]
