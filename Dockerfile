FROM ubuntu:latest

RUN apt update -y; apt install -y clang clang-tools cmake curl gcc git ninja-build python3 python3-pip

#### Install shaderc
WORKDIR /root
RUN git clone https://github.com/google/shaderc
WORKDIR /root/shaderc
RUN git describe > /root/shaderc-version.txt
RUN ./utils/git-sync-deps
WORKDIR /root/shaderc/build
# See https://github.com/google/shaderc/issues/1306 for SKIP_TESTS
RUN cmake -GNinja \
    -DCMAKE_BUILD_TYPE=Release \
    -DCMAKE_INSTALL_PREFIX=/usr/local \
    -DSPIRV_SKIP_TESTS=ON \
    -DSHADERC_SKIP_TESTS=ON \
    ..
RUN ninja install

WORKDIR /root
RUN rm -rf /root/shaderc

#### Install SPIRC-Cross
WORKDIR /root
RUN git clone https://github.com/KhronosGroup/SPIRV-Cross
#RUN DSPIRV_CROSS_CLI=ON; cd SPIRV-Cross; mkdir build; cd build; cmake ..; make; make install
WORKDIR /root/SPIRV-Cross
RUN git describe --tags > /root/SPIRV-Cross-version.txt
WORKDIR /root/SPIRV-Cross/build
RUN cmake -GNinja \
    -DSPIRV_CROSS_CLI=ON \
    ..
RUN ninja install

WORKDIR /root
RUN rm -rf /root/SPIRV-Cross
