FROM        ubuntu:14.04
RUN         apt-get update && apt-get install -y redis-server openssh-server
RUN         mkdir /var/run/sshd
RUN         sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd
RUN         useradd -ms /bin/bash testuser
RUN         echo 'testuser:lajwlifhwe239h2kjhl' | chpasswd
RUN         mkdir /home/testuser/.ssh
ENV         NOTVISIBLE "in users profile"
RUN         echo "export VISIBLE=now" >> /etc/profile
EXPOSE      6379
EXPOSE      22
ADD         ./start.sh /start.sh
RUN         chmod 775 /start.sh
CMD         ["/bin/bash", "/start.sh"]
