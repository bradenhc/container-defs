FROM ubuntu:22.04

# Grab the dependencies we need in order to install and build the tools inside our container image.
# We'll also through in some basic utilities that make the development experience better.
RUN apt update \ 
    && apt install -y \
        build-essential \
        curl \
        git \
        unzip \
        python3 \
        python3-pip \
    && apt clean \
    && rm -rf /var/lib/apt/lists/*

# Setup some links
RUN ln -s /usr/bin/python3 /usr/local/bin/python

# Install CMake
RUN cd /opt \
    # Define what we need
    && baseurl="https://github.com/Kitware/CMake/releases/download" \
    && version="3.26.3" \
    && release="cmake-$version-linux-x86_64" \
    && archive="$release.tar.gz" \
    && checksum="cmake-$version-SHA-256.txt" \
    # Download
    && curl -sSLO "$baseurl/v$version/$archive" \
    # Verify
    && keyserver="hkps://keyserver.ubuntu.com" \
    && keyid="C6C265324BBEBDC350B513D02D2CEF1034921684" \
    && gpg --keyserver $keyserver --recv-keys $keyid \
    && curl -sSLO "$baseurl/v$version/$checksum" \
    && curl -sSLO "$baseurl/v$version/$checksum.asc" \
    && sha256sum -c --ignore-missing $checksum \
    && gpg --verify $checksum.asc \
    # Unpack
    && tar -xzf $archive \
    && mv $release cmake \
    # Cleanup
    && rm -rf $archive \
    && rm -rf $checksum \
    && rm -rf $checksum.asc
ENV PATH="${PATH}:/opt/cmake/bin"

# Install LLVM
RUN cd /opt \
    # Define what we need
    && branch="llvmorg-16.0.1" \
    # Download and Verify
    && git clone -b $branch "https://github.com/llvm/llvm-project.git" \
    # Build
    && mkdir llvm-project/build \
    && cd llvm-project/build \
    && cmake ../llvm -DCMAKE_BUILD_TYPE=Release \
        -DCMAKE_INSTALL_PREFIX=/opt/llvm \
        -DLLVM_ENABLE_PROJECTS="clang;clang-tools-extra" \
        -DLLVM_TARGETS_TO_BUILD=X86 \
    && make -j3 \
    # Install
    && make install \
    # Cleanup 
    && cd ../.. \
    && rm -rf llvm-project
ENV PATH="${PATH}:/opt/llvm/bin"

# Install Ninja
RUN mkdir -p /opt/ninja/bin \
    && cd /opt/ninja/bin \
    # Define what we need
    && baseurl="https://github.com/ninja-build/ninja/releases/download" \
    && version="v1.11.1" \
    && file="ninja-linux.zip" \
    # Download
    && curl -sSLO "$baseurl/$version/$file" \
    # Unpack / Install
    && unzip $file \
    # Cleanup
    && rm $file
ENV PATH="${PATH}:/opt/ninja/bin" 

# Install Conan
RUN python -m pip install conan==2.0.4

# Setup a non-root user for us to use for development
RUN adduser cppdev && groupadd devs && usermod -aG devs cppdev
USER cppdev:devs

# Establish our user home directory as the entrypoint directory. This is also the recommended
# mount point for a volume when using this container for development.
WORKDIR /home/cppdev
COPY .bashrc .bashrc
COPY --chown=cppdev:devs default /home/cppdev/.conan2/profiles/default
