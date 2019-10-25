FROM continuumio/miniconda3:4.6.14	
RUN conda create -n arcticw python=3.6	
RUN echo "conda activate arcticw" > ~/.bashrc	
ENV PATH /opt/conda/envs/env/bin:$PATH	
RUN conda env list
RUN conda activate arcticw
RUN conda config --append channels conda-forge
RUN conda install -y  --freeze-installed -c conda-forge glances
RUN conda install -y  --freeze-installed -c conda-forge jupyterlab
RUN conda install -y  --freeze-installed -c conda-forge beakerx
