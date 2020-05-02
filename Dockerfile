FROM nvcr.io/nvidia/pytorch:20.03-py3

# Create working directory
RUN mkdir -p /usr/src/app
WORKDIR /usr/src/app

# Copy contents
COPY . /usr/src/app

RUN conda env create -f conda-cpu.yml

# Make RUN commands use the new environment:
# SHELL ["conda", "run", "-n", "tracker-cpu", "/bin/bash", "-c"]
