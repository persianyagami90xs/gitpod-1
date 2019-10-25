FROM continuumio/miniconda3:4.6.14	

# load in the environment.yml file
ADD ./environment.yml /

# create the environmnt
RUN conda update -n base conda -y && conda env update
