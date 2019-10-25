FROM jupyter/scipy-notebook
ENTRYPOINT [ “/bin/bash”, “-c” ]
RUN conda create -n arcw python=3.6
RUN echo "conda activate arcw" > ~/.bashrc
ENV PATH /opt/conda/envs/env/bin:$PATH
RUN conda config --append channels conda-forge
RUN conda install --yes --freeze-installed \
     glances \
    && conda clean -afy 
#Install Python Packages
COPY requirements.txt /tmp/
#RUN  pip3 install --requirement /tmp/requirements.txt
RUN cat /tmp/requirements.txt | sed -e '/^\s*#.*$/d' -e '/^\s*$/d' | xargs -n 1 pip install

CMD ["/init"]
