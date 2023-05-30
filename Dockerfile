FROM ubuntu:latest

ENV LANG=en_US.UTF-8

RUN apt-get update && \
      apt-get -y install sudo

RUN sudo apt-get update 

RUN sudo apt-get install -y hostname expect net-tools iputils-ping wget vim iproute2 unrar less tar gzip uuid-runtime tcsh libaio1 && rm -r /var/lib/apt/lists/*

# uuidd is needed by nw abap
RUN mkdir /run/uuidd && chown uuidd /var/run/uuidd && /usr/sbin/uuidd

# Copy expect script + the extracted SAP NW ABAP files to the container
COPY install.exp /tmp/sapdownloads/
COPY sapdownloads /tmp/sapdownloads/

WORKDIR /tmp/sapdownloads

RUN chmod +x install.sh install.exp

# Important ports to be exposed (TCP):
# HTTP
EXPOSE 8000
# HTTPS
EXPOSE 44300
# ABAP in Eclipse
EXPOSE 3300
# SAP GUI
EXPOSE 3200
# SAP Cloud Connector
# EXPOSE 8443

# Unfortunatelly, we cannot run the automated installation directly here!
# Solution: run original install.sh or the automated install.exp after the image has been created
# RUN ./install.exp

