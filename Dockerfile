FROM continuumio/miniconda3:4.6.14
COPY environment.yml /tmp/
RUN conda env create -f /tmp/environment.yml
ENV PATH /opt/conda/envs/env/bin:$PATH
RUN conda env list
RUN conda activate arcticw


