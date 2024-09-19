FROM ubuntu:22.04

# Temporarily set non-interactive mode for apt-get installs
ENV DEBIAN_FRONTEND=noninteractive

# Install dependencies
RUN apt-get update && apt-get install -y \
    software-properties-common \
    cmake python3-pip nasm curl git gcc libx11-dev libgl1-mesa-dev libxt-dev build-essential

RUN gcc --version

RUN pip3 install Pillow

# Set up environment variables for paths
ENV PATH="/usr/local/cmake/bin:$PATH"

# Set working directory and clone OpenUSD repository
WORKDIR /OpenUSD
RUN curl -L https://github.com/PixarAnimationStudios/OpenUSD/archive/refs/tags/v24.08.tar.gz -o openusd.tar.gz && \
    tar -xzf openusd.tar.gz --strip-components=1 && \
    rm openusd.tar.gz
RUN python3 build_scripts/build_usd.py /usr/local/USD --no-python



WORKDIR /usd_from_gltf
RUN git clone https://github.com/jeffzhkw/usd_from_gltf.git . && \
python3 tools/ufginstall/ufginstall.py /usr/local/UFG /usr/local/USD --testdat

# Default command
CMD ["/bin/bash"]