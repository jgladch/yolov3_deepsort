FROM nvcr.io/nvidia/pytorch:20.03-py3

# Create working directory
RUN mkdir -p /usr/src/app
WORKDIR /usr/src/app

# Copy contents
COPY . /usr/src/app

# RUN pip uninstall -y opencv-python
# RUN apt-get update
# RUN apt-get install -y libgtk2.0-dev pkg-config libglib2.0-0 libsm6 libxext6 libxrender1

RUN conda env create -f conda-cpu.yml

# Make RUN commands use the new environment:
# SHELL ["conda", "run", "-n", "tracker-cpu", "/bin/bash", "-c"]

# Activate the environment, and make sure it's activated:
# RUN echo "conda init bash" > ~/.bashrc
# RUN echo "source /opt/conda/etc/profile.d/conda.sh" > ~/.bashrc
# RUN echo "conda activate tracker-cpu" > ~/.bashrc
