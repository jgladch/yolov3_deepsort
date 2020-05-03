FROM ubuntu:16.04

# stackoverflow issue: https://stackoverflow.com/questions/49433383/conda-build-of-official-anacondarecipes-opencv-feedstock-fails-looking-for-libpn
# conda-recipe opencv repo: https://github.com/AnacondaRecipes/opencv-feedstock 
LABEL description="Image for building Opencv" \
  version="0.1"

RUN touch .tmp

# Required dependencies for gcc compiling, opencv, tbb, lib-png.
RUN export DEBIAN_FRONTEND=noninteractive
RUN apt-get update -qq && \
  apt-get install -y --no-install-recommends \
  wget bzip2 ca-certificates libglib2.0-0 libxext6 libsm6 libxrender1 \
  git mercurial \
  build-essential libtbb2 libtbb-dev libgl1-mesa-glx sudo \
  cmake libgtk2.0-dev pkg-config libavcodec-dev libavformat-dev \
  libswscale-dev python-dev python-numpy \
  libjpeg-dev libpng-dev libtiff-dev libjasper-dev libdc1394-22-dev \
  curl grep sed dpkg && \
  TINI_VERSION=`curl https://github.com/krallin/tini/releases/latest | grep -o "/v.*\"" | sed 's:^..\(.*\).$:\1:'` && \
  curl -L "https://github.com/krallin/tini/releases/download/v${TINI_VERSION}/tini_${TINI_VERSION}.deb" > tini.deb && \
  dpkg -i tini.deb && \
  rm tini.deb && \
  apt-get clean && \
  rm -Rf /var/lib/apt/lists/* /tmp/* /var/tmp/* /usr/local/share/man/*

RUN echo 'export PATH=/opt/conda/bin:$PATH' > /etc/profile.d/conda.sh && \
  wget --quiet https://repo.continuum.io/miniconda/Miniconda2-4.3.27-Linux-x86_64.sh -O ~/miniconda.sh && \
  /bin/bash ~/miniconda.sh -b -p /opt/conda && \
  rm ~/miniconda.sh

ENV PATH /opt/conda/bin:$PATH

# Create working directory
RUN mkdir -p /usr/src/app
WORKDIR /usr/src/app

# Copy contents
COPY . /usr/src/app

RUN conda update conda
RUN conda env create -f conda-docker.yml
RUN conda config --add channels conda-forge

#Give permissions to conda folder for everyone
RUN chmod 777  /opt/conda/lib/python2.7/site-packages/

ENTRYPOINT [ "/usr/bin/tini", "--" ]
CMD [ "/bin/bash" ]
