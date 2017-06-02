############################################################
# Dockerfile to build 4Cin container image
# Based on ubuntu:16.04
############################################################

# Set the base image to official ubuntu
FROM ubuntu:16.04

# File Author / Maintainer
MAINTAINER Ibai Irastorza-Azcarate <https://github.com/batxes>

################## BEGIN INSTALLATION ######################
RUN apt-get -yqq update 
RUN apt-get upgrade -y
RUN apt-get autoremove -y

# Install dependencies
RUN apt-get install -y gcc
RUN apt-get install -y build-essential
RUN apt-get install -y zlib1g-dev
RUN apt-get install -y wget
RUN apt-get install -y cmake
RUN apt-get install -y python-dev
RUN apt-get install -y libboost-all-dev
RUN apt-get install -y libcgal-dev
RUN apt-get install -y python-matplotlib
RUN apt-get install -y python-scipy
RUN apt-get install -y python-numpy
RUN apt-get install -y vim
RUN apt-get install -y git
RUN apt-get install -y libpcre3-dev
RUN apt-get install -y python-pip
RUN apt-get install -y libhdf5-dev
        #libboost1.49-all-dev 
        #x11-apps
RUN pip install pysam
RUN apt-get clean
#ENV DISPLAY :0



# Installing programs as source

#install Swig (we need this version)
RUN wget http://prdownloads.sourceforge.net/swig/swig-3.0.12.tar.gz -O /opt/swig-3.0.12.tar.gz
RUN tar xzvf /opt/swig-3.0.12.tar.gz -C /opt/
RUN cd /opt/swig-3.0.12 && ./configure && make && make install
#RUN ln -s swig-3.0.12 swig

#install IMP
RUN wget https://integrativemodeling.org/2.5.0/download/imp-2.5.0.tar.gz -O /opt/imp-2.5.0.tar.gz 
RUN tar xzvf /opt/imp-2.5.0.tar.gz -C /opt/
RUN mkdir /opt/IMP
RUN cmake -H/opt/imp-2.5.0 -B/opt/IMP/ -DCMAKE_BUILD_TYPE=Release -DIMP_MAX_CHECKS=NONE -DIMP_MAX_LOG=SILENT -DSWIG_EXECUTABLE=/opt/swig-3.0.12/swig
RUN make -j4 -C /opt/IMP/
RUN make install -C /opt/IMP/
ENV LD_LIBRARY_PATH="/opt/IMP/lib:/opt/IMP/src/dependency/RMF/:${LD_LIBRARY_PATH}" 
ENV PYTHONPATH="/opt/IMP/lib:/opt/IMP/src/dependency/RMF/:{$PYTHONPATH}" 

# install chimera. it is a bin so we need to install this from a terminal in docker.
ADD chimera-1.11.2-linux_x86_64.bin /opt/chimera-1.11.2-linux_x86_64.bin 
RUN chmod +x /opt/chimera-1.11.2-linux_x86_64.bin
#Install chimera manually. 
#RUN /opt/chimera-1.11.2-linux_x86_64.bin
#set link in /usr/bin
#RUN ln -s /opt/UCSF/Chimera/chimera chimera /usr/bin/chimera
