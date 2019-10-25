FROM continuumio/miniconda3:4.6.14
RUN conda config --append channels conda-forge
RUN conda install --yes --freeze-installed \
    jupyterlab \
    beakerx \
    tensorflow \
    pyodbc \
    glances \
    dash \
    dash-table \
    util-linux \
    openblas \
    xeus-cling \ 
    rx \
    cassandra-driver \
    keras \
    dask \
    numpy \
    pandas \
    tini \
    && conda clean -afy 
