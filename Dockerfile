FROM nvidia/cuda:9.0-cudnn7-devel-ubuntu16.04

ARG DEBIAN_FRONTEND=noninteractive

# https://gitlab.com/nvidia/container-images/cuda/-/issues/158
RUN apt-key del "7fa2af80" \
&& export this_distro="$(cat /etc/os-release | grep '^ID=' | awk -F'=' '{print $2}')" \
&& export this_version="$(cat /etc/os-release | grep '^VERSION_ID=' | awk -F'=' '{print $2}' | sed 's/[^0-9]*//g')" \
&& apt-key adv --fetch-keys "http://developer.download.nvidia.com/compute/cuda/repos/${this_distro}${this_version}/x86_64/3bf863cc.pub" \
&& apt-key adv --fetch-keys "http://developer.download.nvidia.com/compute/machine-learning/repos/${this_distro}${this_version}/x86_64/7fa2af80.pub"


RUN apt update && apt upgrade -y
# RUN apt install -y python3 python3-dev python3-pip
# https://stackoverflow.com/questions/55313610/importerror-libgl-so-1-cannot-open-shared-object-file-no-such-file-or-directo
RUN apt-get install ffmpeg libsm6 libxext6  -y
# https://stackoverflow.com/questions/12806122/missing-python-bz2-module
RUN apt-get install -y libbz2-dev
# https://stackoverflow.com/questions/57743230/userwarning-could-not-import-the-lzma-module-your-installed-python-is-incomple
RUN apt-get install -y liblzma-dev

# https://stackoverflow.com/questions/45954528/pip-is-configured-with-locations-that-require-tls-ssl-however-the-ssl-module-in
RUN apt-get install -y build-essential
RUN apt install -y libssl-dev libncurses5-dev libsqlite3-dev libreadline-dev libtk8.6 libgdm-dev libdb4o-cil-dev libpcap-dev
RUN apt install -y git wget unzip
RUN apt-get install -y zlib1g-dev
WORKDIR /opt
RUN wget https://www.python.org/ftp/python/3.6.9/Python-3.6.9.tgz
RUN tar -xvf Python-3.6.9.tgz
WORKDIR /opt/Python-3.6.9
RUN ./configure
RUN make 
RUN make install
WORKDIR /


RUN pip3 install grpcio==1.16.1
RUN pip3 install numpy==1.16.1
RUN pip3 install h5py==2.10.0
RUN pip3 install protobuf==3.6.1
RUN pip3 install tensorflow-gpu==1.11.0
RUN pip3 install cython==0.29.24
RUN pip3 install open3d-python==0.3.0
RUN pip3 install pandas==0.25.2
RUN pip3 install scipy==1.4.1
RUN pip3 install scikit-learn==0.21.3
RUN pip3 install pyyaml==5.1.1


RUN apt install -y git 
RUN git clone https://github.com/QingyongHu/RandLA-Net.git
WORKDIR /RandLA-Net/utils/nearest_neighbors
RUN python3 setup.py install --home="."
# RUN python3 setup.py install
WORKDIR /RandLA-Net/utils/cpp_wrappers
RUN sh compile_wrappers.sh
WORKDIR /



RUN pip3 install cloudpickle==0.4.2


RUN pip3 list
