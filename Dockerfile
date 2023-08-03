FROM ubuntu:latest

RUN apt update -y; apt install -y clang clang-tools cmake curl gcc git ninja-build python3 python3-pip

#### Record a snapshot
RUN find / > /root/scan-0.txt

#### Install shaderc
WORKDIR /root
RUN git clone https://github.com/google/shaderc
WORKDIR /root/shaderc
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

#### Record a snapshot
RUN find / > /root/scan-1.txt

# RUN curl -O https://storage.googleapis.com/shaderc/artifacts/prod/graphics_shader_compiler/shaderc/linux/continuous_clang_release/429/20230720-061506/install.tgz; tar -xzf install.tgz
# RUN cp -r install/bin /usr/local/; cp -r install/lib /usr/local/; cp -r install/include /usr/local/
# RUN rm -rf install.tgz install

#### Install SPIRC-Cross
WORKDIR /root
RUN git clone https://github.com/KhronosGroup/SPIRV-Cross.git
#RUN DSPIRV_CROSS_CLI=ON; cd SPIRV-Cross; mkdir build; cd build; cmake ..; make; make install
WORKDIR /root/SPIRV-Cross/build
RUN cmake -GNinja \
    -DSPIRV_CROSS_CLI=ON \
    ..
RUN ninja install

WORKDIR /root
RUN rm -rf /root/SPIRV-Cross

#### Record a snapshot
RUN find / > /root/scan-2.txt
