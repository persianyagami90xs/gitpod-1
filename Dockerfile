FROM continuumio/miniconda3:4.6.14
RUN conda config --append channels conda-forge
RUN conda install --yes --freeze-installed \
    nomkl \
    jupyterlab \
    beakerx \
    tensorflow \
    pyodbc \
    glances \
    dash \
    dash-table \
    pytorch \
    util-linux \
    openblas \
    xeus-cling \ 
    xeus-python \
    rx \
    cassandra-driver \
    keras \
    gdal \
    dask \
    numpy \
    pandas \
    tini \
    && conda clean -afy 
