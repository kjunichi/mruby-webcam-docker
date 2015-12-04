FROM ubuntu:15.10
MAINTAINER Junichi Kajiwara<junichi.kajiwara@gmail.com>
RUN apt-get update

# 絶対ダイアログは出さない
ENV DEBIAN_FRONTEND noninteractive

RUN apt-get install -y mingw-w64 git mingw-w64-tools cmake cmake-curses-gui \
 vim apt-file wget rake bison

RUN mkdir /root/src && cd /root/src && git clone https://github.com/Itseez/opencv && cd opencv && mkdir build \
   && wget https://gist.githubusercontent.com/kjunichi/270013dd19d7e8bf39ff/raw/cfa11b178dc529244f01082864bcc424c886b2bf/mytool_i686-w64-mingw32.cmake \
   && wget https://gist.githubusercontent.com/kjunichi/a16a8482ae247ea6cf8b/raw/b7d92f21c2d2723315b7bc18dd6e8f8fb752f406/OpenCVCompilerOptions.cmake.patch && patch -p1 < OpenCVCompilerOptions.cmake.patch 
RUN cd /root/src/opencv/build && cmake -DCMAKE_TOOLCHAIN_FILE=../mytool_i686-w64-mingw32.cmake -DWITH_IPP=OFF -DBUILD_SHARED_LIBS=OFF  .. \
   && make -j4 && make install && cp -r install/include/* /usr/i686-w64-mingw32/include/ \
&& cp -r install/lib/* /usr/i686-w64-mingw32/lib/ && cp 3rdparty/lib/* /usr/i686-w64-mingw32/lib
RUN cd /root/src/opencv && rm -rf build && mkdir build \
  &&  wget https://gist.githubusercontent.com/kjunichi/0eff83446468eaf666ed/raw/e929af6ad24fce99b74e30d13e5c1903309d9aa9/mytool_x86_64-w64-mingw32.cmake \
  && cd build && cmake -DCMAKE_TOOLCHAIN_FILE=../mytool_x86_64-w64-mingw32.cmake  -DWITH_IPP=OFF -DBUILD_SHARED_LIBS=OFF  .. \
  && make -j4 && make install && cp -r install/include/* /usr/x86_64-w64-mingw32/include/ \
  && cp -r install/lib/* /usr/x86_64-w64-mingw32/lib/ && cp 3rdparty/lib/* /usr/x86_64-w64-mingw32/lib
RUN cd /root/src/opencv/build && make clean
RUN cd /root/src && git clone https://github.com/mruby/mruby
RUN cd /root/src/mruby && mv build_config.rb build_config.rb.orig && wget  https://gist.githubusercontent.com/kjunichi/9bca245d6ab9a1a0a9ec/raw/65c23c1401bb86f6be022842d7d2a97950cf7241/build_config.rb && rake
 
# 絶対ダイアログは出さないを戻しとく
ENV DEBIAN_FRONTEND dialog

# Set environment variables.
ENV HOME /root
# Define working directory.
WORKDIR /root

# Define default command.
CMD ["bash"]
