FROM ubuntu:16.04
MAINTAINER lovecon78@hanmail.net

# apt-get ������Ʈ 
RUN apt-get update

# SSH, VIM ��ġ
RUN apt-get install -y openssh-server && apt-get -y install vim

# Open JDK 8 ��ġ
RUN apt-get -y install openjdk-8-jdk
RUN mkdir /var/run/sshd

#root �н����� ����
RUN echo 'root:tlfh66' | chpasswd
RUN sed -i 's/PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config

# SSH login fix. Otherwise user is kicked off after login
RUN sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd

ENV NOTVISIBLE "in users profile"
RUN echo "export VISIBLE=now" >> /etc/profile

#��Ĺ ȣ��Ʈ�κ��� ����
ADD apache-tomcat-7.0.92 /usr/local/apache-tomcat-7.0.92
ADD tomcat.txt /etc/init.d/tomcat

#��Ĺ ���� ���
RUN sed -i -e 's/\r//g' /etc/init.d/tomcat
RUN chmod 755 /etc/init.d/tomcat
RUN update-rc.d tomcat defaults

# ��Ĺ �α� Alias ����
RUN echo "alias tlog='tail -f /usr/local/apache-tomcat-7.0.92/logs/catalina.out'" >> ~/.bashrc
RUN /bin/bash -c "source ~/.bashrc"

# ��Ĺ �ɺ��� ��ũ ����
RUN ln -s /usr/local/apache-tomcat-7.0.92/ /tomcat

# ���� ��ũ��Ʈ ����
COPY startup.txt /usr/local/startup.sh
RUN sed -i -e 's/\r//g' /usr/local/startup.sh
RUN chmod 755 /usr/local/startup.sh

EXPOSE 22
EXPOSE 80
EXPOSE 8009

CMD ["/usr/local/startup.sh"]