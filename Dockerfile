FROM continuumio/miniconda3:4.7.12
SHELL [ "/bin/bash", "-c"]
RUN conda create -n env python=3.6
RUN echo "conda activate env" > ~/.bashrc
ENV PATH /opt/conda/envs/env/bin:$PATH
RUN conda config --append channels conda-forge
RUN conda install --yes --freeze-installed \
     glances \
    && conda clean -afy 
#Install Python Packages
COPY requirements.txt /tmp/
#RUN  pip3 install --requirement /tmp/requirements.txt
RUN cat /tmp/requirements.txt | sed -e '/^\s*#.*$/d' -e '/^\s*$/d' | xargs -n 1 pip install
