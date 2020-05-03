FROM nvcr.io/nvidia/pytorch:20.03-py3

# Create working directory
RUN mkdir -p /usr/src/app
WORKDIR /usr/src/app

# Copy contents
COPY . /usr/src/app

# RUN pip uninstall -y opencv-python
# RUN apt-get update
# RUN apt-get install -y libgtk2.0-dev pkg-config libglib2.0-0 libsm6 libxext6 libxrender1

# RUN conda update conda
RUN conda env create -f conda-docker.yml

RUN pip install numpy

SHELL ["conda", "run", "-n", "tracker-docker", "/bin/bash", "-c"]

RUN pip install numpy
RUN cd ~/ &&\
  git clone https://github.com/Itseez/opencv.git &&\
  git clone https://github.com/Itseez/opencv_contrib.git &&\
  cd opencv && mkdir build && cd build && cmake  -DWITH_QT=ON -DWITH_OPENGL=ON -DFORCE_VTK=ON -DWITH_TBB=ON -DWITH_GDAL=ON -DWITH_XINE=ON -DBUILD_EXAMPLES=ON .. && \
  make -j4 && make install && ldconfig && rm -rf ~/opencv*  # Remove the opencv folders to reduce image size

# Set the appropriate link
RUN ln /dev/null /dev/raw1394

# Make RUN commands use the new environment:
# SHELL ["conda", "run", "-n", "tracker-cpu", "/bin/bash", "-c"]

# Activate the environment, and make sure it's activated:
# RUN echo "conda init bash" > ~/.bashrc
# RUN echo "source /opt/conda/etc/profile.d/conda.sh" > ~/.bashrc
# RUN echo "conda activate tracker-cpu" > ~/.bashrc
