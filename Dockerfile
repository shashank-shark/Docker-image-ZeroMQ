FROM    ubuntu:16.04
# MAINTAINER Shashank J "https://github.com/shashank-shark"

# RUN apt-get update

# RUN apt-get install -y openssh-server
# RUN mkdir /var/run/sshd

# RUN echo 'root:root' |chpasswd

# RUN sed -ri 's/^#?PermitRootLogin\s+.*/PermitRootLogin yes/' /etc/ssh/sshd_config
# RUN sed -ri 's/UsePAM yes/#UsePAM yes/g' /etc/ssh/sshd_config

# RUN mkdir /root/.ssh

# RUN apt-get clean && \
#     rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# EXPOSE 22

# CMD    ["/usr/sbin/sshd", "-D"]

######## WILL BE UPDATED SOON
######## FOR NOW YOU CAN PULL THE IMAGE FROM THE CLOUD
#------------ $ docker pull shashankshark/zeromq-dev