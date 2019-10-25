FROM continuumio/miniconda3:4.6.14	
RUN conda create -n env python=3.6
RUN echo "source activate env" > ~/.bashrc
ENV PATH /opt/conda/envs/env/bin:$PATH
RUN /bin/bash -c "conda activate arcticw"
#Install Python Packages
COPY requirements.txt /tmp/
#RUN  pip3 install --requirement /tmp/requirements.txt
RUN cat /tmp/requirements.txt | sed -e '/^\s*#.*$/d' -e '/^\s*$/d' | xargs -n 1 pip3 install
