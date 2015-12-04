FROM ubuntu:15.10
MAINTAINER Junichi Kajiwara<junichi.kajiwara@gmail.com>
RUN apt-get update

# 絶対ダイアログは出さない
ENV DEBIAN_FRONTEND noninteractive

RUN apt-get install -y mingw-w64 git mingw-w64-tools cmake cmake-curses-gui \
 vim apt-file wget rake bison

COPY opencv_i686-w64-mingw32.cmake /root/src/
COPY opencv_x86_64-w64-mingw32.cmake /root/src/
COPY OpenCVCompilerOptions.cmake.patch /root/src/
COPY build_config.rb /root/src/

RUN cd /root/src && git clone https://github.com/Itseez/opencv && cd opencv && mkdir build \
  && patch -p1 < /root/src/OpenCVCompilerOptions.cmake.patch && cd build \
  && cmake -DCMAKE_TOOLCHAIN_FILE=/root/src/opencv_i686-w64-mingw32.cmake -DWITH_IPP=OFF -DBUILD_SHARED_LIBS=OFF  .. \
  && make -j4 && make install && cp -r install/include/* /usr/i686-w64-mingw32/include/ \
  && cp -r install/lib/* /usr/i686-w64-mingw32/lib/ && cp 3rdparty/lib/* /usr/i686-w64-mingw32/lib
RUN cd /root/src/opencv && rm -rf build && mkdir build \
  && cd build && cmake -DCMAKE_TOOLCHAIN_FILE=/root/src/opencv_x86_64-w64-mingw32.cmake  -DWITH_IPP=OFF -DBUILD_SHARED_LIBS=OFF  .. \
  && make -j4 && make install && cp -r install/include/* /usr/x86_64-w64-mingw32/include/ \
  && cp -r install/lib/* /usr/x86_64-w64-mingw32/lib/ && cp 3rdparty/lib/* /usr/x86_64-w64-mingw32/lib \
  && cd .. && rm -rf build
RUN cd /root/src && git clone https://github.com/mruby/mruby \
  && cd /root/src/mruby && mv build_config.rb build_config.rb.orig && cp /root/src/build_config.rb . && rake

# 絶対ダイアログは出さないを戻しとく
ENV DEBIAN_FRONTEND dialog

# Set environment variables.
ENV HOME /root
# Define working directory.
WORKDIR /root

# Define default command.
CMD ["bash"]
