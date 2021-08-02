FROM ubuntu:16.04
LABEL author="artur.manukyan@umassmed.edu" description="Docker image containing all requirements for scanpy analysis image"

# env
ENV PATH="/miniconda3/bin:${PATH}"
ARG PATH="/miniconda3/bin:${PATH}"

# update
RUN apt-get -y update 
RUN apt-get install -y wget && rm -rf /var/lib/apt/lists/*

# install git
RUN apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys E1DD270288B4E6030699E45FA1715D88E1DF1F24
RUN su -c "echo 'deb http://ppa.launchpad.net/git-core/ppa/ubuntu trusty main' > /etc/apt/sources.list.d/git.list"
RUN apt-get -y update
RUN apt-get install -y git

# set conda
RUN wget \
    https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh \
    && mkdir /.conda \
    && bash Miniconda3-latest-Linux-x86_64.sh -b -p /miniconda3 \
    && rm -f Miniconda3-latest-Linux-x86_64.sh 
COPY environment.yml /
RUN conda env create -f /environment.yml && conda clean -a

# conda install r-base
# RUN conda install r-base 
# RUN conda install r-essentials
# RUN conda install r-base-env

# configure and install R
RUN apt-get -y update 
RUN apt-get -y install software-properties-common
RUN add-apt-repository 'deb https://cloud.r-project.org/bin/linux/ubuntu xenial-cran40/'
RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-keys E298A3A825C0D65DFD57CBB651716619E084DAB9
RUN apt-get -y install apt-transport-https
RUN apt-get -y update
RUN apt-get -y install r-base r-base-dev
RUN apt-get -y install libcurl4-openssl-dev libssl-dev libxml2-dev 
RUN apt-get -y install pandoc
RUN apt-get -y install texlive-base texlive-latex-base texlive-fonts-recommended
RUN apt-get -y install libfontconfig1-dev libcairo2-dev

# Install scanpy and leidenalg
RUN pip3 install scanpy==1.8.1
RUN pip3 install leidenalg # download Leiden Algorithm
RUN pip3 install --use-feature=2020-resolver git+https://github.com/theislab/scib.git

# Download Additional batch correction algorithm modules
RUN pip3 install bbknn # download BBKNN
RUN pip3 install mnnpy # download MNN
RUN pip3 install desc # download DESC 
