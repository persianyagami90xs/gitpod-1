# install dependencies
#Should match Config.py
echo Initializing...

#conda update -n base -c defaults conda -y
conda create --name arcticw python=3.6 &&
echo "conda activate arcticw" > ~/.bashrc &&
export PATH=/opt/conda/envs/env/bin:$PATH &&
source ~/.bashrc

#Install conda packages
conda install -y -c conda-forge glances
conda install -y -c conda-forge gdal
conda install -y -c conda-forge xeus-cling
conda install -y -c conda-forge xeus-python
conda install -y -c conda-forge xtl
conda install -y -c conda-forge openblas
conda install -y -c conda-forge util-linux
conda install -y -c conda-forge libtiff
conda install -y -c conda-forge libgdal
conda install -y -c conda-forge jupyterlab
conda install -y -c conda-forge beakerx
conda install -y -c conda-forge python-graphviz
conda install -y -c conda-forge tensorflow
conda install -y -c conda-forge keras
conda install -y -c pytorch pytorch
conda install -y -c conda-forge dask
conda install -y -c conda-forge dash
conda install -y -c conda-forge dash-table
conda install -y -c conda-forge rx
conda install -y -c conda-forge dash-core-components
conda install -y -c anaconda pyodbc
conda install -y -c conda-forge cassandra-driver


#Install pip packages
pips install -r /workspace/notebooks/requirements.txt

#Install R
Rscript -e 'install.packages("drat", repos="https://cran.rstudio.com")'
Rscript -e 'install.packages("IRkernel", repos="https://cran.rstudio.com")'
Rscript -e 'IRkernel::installspec()'

# Get github repos
git clone https://github.com/mtvu/write.git
git clone https://github.com/mtvu/infra.git
git clone https://github.com/mtvu/notebooks.git
git clone https://github.com/mtvu/config

#Notes
#To run jupyter lab : jupyter lab --ip=0.0.0.0 --allow-root
#rstudio-server start
echo Done...
