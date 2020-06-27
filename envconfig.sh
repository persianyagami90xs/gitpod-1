# install dependencies
#Should match Config.py
echo Initializing...

# #conda update -n base -c defaults conda -y
# conda create --name arcticw python=3.6 &&
# echo "conda activate arcticw" > ~/.bashrc &&
# export PATH=/opt/conda/envs/env/bin:$PATH &&
# source ~/.bashrc


#conda update -n base -c defaults conda -y
mkdir -p /workspace/conda
mkdir -p /workspace/data
conda create --prefix /workspace/conda/arcw python=3.6 &&
echo "conda activate /workspace/conda/arcw" > ~/.bashrc &&
export PATH=/workspace/conda/arcw/bin:$PATH &&
source ~/.bashrc
export SHELL=/bin/bash

/opt/conda/bin/conda init bash
chmod 777 /workspace/data/appcfg/rclone.conf
export RCLONE_CONFIG=/workspace/data/appcfg/rclone.conf
export PATH=/workspace/data/app:$PATH


# Get github repos
cd /workspace
git clone https://github.com/mtvu/write.git
git clone https://github.com/mtvu/infra.git
git clone https://github.com/mtvu/notebooks.git
git clone https://github.com/mtvu/config
ln -fs /workspace /workspace/gitpod

wget --quiet https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O ~/miniconda.sh && \
/bin/bash ~/miniconda.sh -b -p /workspace/conda && \
rm ~/miniconda.sh && \
ln -s /workspace/conda/etc/profile.d/conda.sh /etc/profile.d/conda.sh && \
echo "export PATH=/workspace/conda/bin:$PATH" >> ~/.bashrc && \
echo "/workspace/conda/etc/profile.d/conda.sh" >> ~/.bashrc && \
echo "SHELL=/bin/bash" >> ~/.bashrc && \
echo "conda init bash" >> ~/.bashrc && \
echo "conda activate base" >> ~/.bashrc

#Install utils
cd /home/gitpod &&
wget https://github.com/gdrive-org/gdrive/releases/download/2.1.0/gdrive-linux-x64 &&
mv gdrive-linux-x64 gd &&
chmod 777 gd &&
echo "alias gd=/home/gitpod/gd" >> ~/.bashrc &&
echo "alias ll="ls -lart" >> ~/.bashrc

#Install archivebox

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
pip install -r /workspace/gitpod/notebooks/requirements.txt
#cat /tmp/requirements.txt | sed -e '/^\s*#.*$/d' -e '/^\s*$/d' | xargs -n 1 pip install

#Install R
Rscript -e 'install.packages("drat", repos="https://cran.rstudio.com")'
Rscript -e 'install.packages("IRkernel", repos="https://cran.rstudio.com")'
Rscript -e 'IRkernel::installspec()'


#Notes
#To run jupyter lab : jupyter lab --ip=0.0.0.0 --allow-root

#/usr/lib/rstudio-server/bin/rstudio-server start
#rstudio-server start
echo Done...

#Create soft link
ln -fs /workspace/notebooks /workspace/gitpod/notebooks


#Install rclone
curl -O https://downloads.rclone.org/rclone-current-linux-amd64.zip
unzip rclone-current-linux-amd64.zip
cd rclone-*-linux-amd64

sudo cp rclone /usr/bin/
sudo chown root:root /usr/bin/rclone
sudo chmod 755 /usr/bin/rclone

vi /home/gitpod/.config/rclone/rclone.conf
./rclone sync -P 1drive-a16706:mirror gdrive-musesoft:landing