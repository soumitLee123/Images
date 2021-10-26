FROM nvidia/cuda:10.2-devel-ubuntu18.04

RUN apt-get update && apt-get install -y libglib2.0-0 && apt-get clean

RUN apt-get install -y wget htop byobu git gcc g++ vim libsm6 libxext6 libxrender-dev lsb-core

RUN set -xe \
    && apt-get update -y \
    && apt-get install -y python3-pip

RUN pip3 install --upgrade pip

RUN cd /root && wget https://repo.anaconda.com/archive/Anaconda3-2020.07-Linux-x86_64.sh

RUN cd /root && bash Anaconda3-2020.07-Linux-x86_64.sh -b -p ./anaconda3

#works for CPU only
RUN bash -c "source /root/anaconda3/etc/profile.d/conda.sh && conda install pytorch torchvision torchaudio cpuonly -c pytorch"

#for cuda 10.2, torch version 1.7 > use:
#RUN bash -c "source /root/anaconda3/etc/profile.d/conda.sh && conda install -y pytorch==1.7.0 torchvision cudatoolkit=11.0 -c pytorch"

RUN bash -c "/root/anaconda3/bin/conda init bash"

WORKDIR /root
RUN mkdir code
WORKDIR code

RUN git clone https://github.com/facebookresearch/detectron2.git
RUN bash -c "source /root/anaconda3/etc/profile.d/conda.sh && conda activate base && cd detectron2 && python setup.py build develop"

RUN bash -c "source /root/anaconda3/etc/profile.d/conda.sh && conda activate base"

COPY requirements.txt ./requirements.txt
RUN bash -c "source /root/anaconda3/etc/profile.d/conda.sh && conda activate base && pip install -r requirements.txt"

RUN rm /root/Anaconda3-2020.07-Linux-x86_64.sh
