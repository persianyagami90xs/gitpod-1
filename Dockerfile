FROM continuumio/miniconda3:4.6.14
RUN conda config --append channels conda-forge

RUN conda create -n arcticw python=3.6
RUN echo "conda activate arcticw" > ~/.bashrc
ENV PATH /opt/conda/envs/env/bin:$PATH
RUN . ~/.bashrc

#Install conda packages
RUN conda install --yes --freeze-installed -c conda-forge glances
RUN conda install --yes --freeze-installed -c conda-forge gdal
RUN conda install --yes --freeze-installed -c conda-forge xeus-cling
RUN conda install --yes --freeze-installed -c conda-forge xeus-python
RUN conda install --yes --freeze-installed -c conda-forge xtl
RUN conda install --yes --freeze-installed -c conda-forge openblas
RUN conda install --yes --freeze-installed -c conda-forge util-linux
RUN conda install --yes --freeze-installed -c conda-forge libtiff
RUN conda install --yes --freeze-installed -c conda-forge libgdal
RUN conda install --yes --freeze-installed -c conda-forge jupyterlab
RUN conda install --yes --freeze-installed -c conda-forge beakerx
RUN conda install --yes --freeze-installed -c conda-forge python-graphviz
RUN conda install --yes --freeze-installed -c conda-forge tensorflow
RUN conda install --yes --freeze-installed -c conda-forge keras
RUN conda install --yes --freeze-installed -c pytorch pytorch
RUN conda install --yes --freeze-installed -c conda-forge dask
RUN conda install --yes --freeze-installed -c conda-forge dash
RUN conda install --yes --freeze-installed -c conda-forge dash-table
RUN conda install --yes --freeze-installed -c conda-forge rx
RUN conda install --yes --freeze-installed -c conda-forge dash-core-components
RUN conda install --yes --freeze-installed -c anaconda pyodbc
RUN conda install --yes --freeze-installed -c conda-forge cassandra-driver
RUN conda clean -afy 
