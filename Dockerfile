FROM jrottenberg/ffmpeg

RUN apt-get update && \
    apt-get install -y build-essential cmake checkinstall software-properties-common procps


RUN apt-get install -y python-dev python-pip python3-dev python3-pip git

RUN pip2 install -U pip numpy
RUN pip3 install -U pip numpy

RUN pip install numpy scipy matplotlib scikit-image scikit-learn ipython

RUN pip install walrus ffmpy

RUN git clone https://github.com/opencv/opencv.git && \
    cd opencv && \
    git checkout 4.0.1 && \
    cd ..

RUN git clone https://github.com/opencv/opencv_contrib.git && \
    cd opencv_contrib && \
    git checkout 4.0.1 && \
    cd ..

RUN apt-get install -y libjpeg8-dev libjasper-dev libpng12-dev libtiff5-dev libavcodec-dev libavformat-dev libswscale-dev libdc1394-22-dev libxine2-dev libv4l-dev libgstreamer0.10-dev libgstreamer-plugins-base0.10-dev qt5-default libgtk2.0-dev libtbb-dev libatlas-base-dev libfaac-dev libmp3lame-dev libtheora-dev libvorbis-dev libxvidcore-dev libopencore-amrnb-dev libopencore-amrwb-dev x264 v4l-utils

RUN cd opencv && \
    mkdir build && \
    cd build && \
    cmake -D CMAKE_BUILD_TYPE=RELEASE \
      -D CMAKE_INSTALL_PREFIX=/usr/local \
      -D INSTALL_C_EXAMPLES=ON \
      -D INSTALL_PYTHON_EXAMPLES=ON \
      -D WITH_TBB=ON \
      -D WITH_V4L=ON \
      -D WITH_QT=ON \
      -D WITH_OPENGL=ON \
      -D WITH_FFMPEG=ON \
      -D OPENCV_EXTRA_MODULES_PATH=../../opencv_contrib/modules \
      -D BUILD_EXAMPLES=ON .. && \
    make -j4 && \
    make install && \
    sh -c 'echo "/usr/local/lib" >> /etc/ld.so.conf.d/opencv.conf' && \
    ldconfig

#nproc

RUN cp ./lib/python3/cv2.cpython-35m-x86_64-linux-gnu.so /usr/local/lib/python3.5/dist-packages/ && \
    cd /usr/local/lib/python3.5/dist-packages/ && \
    ln -s cv2.cpython-35m-x86_64-linux-gnu.so cv2.so

RUN cp ./lib/python3/cv2.cpython-35m-x86_64-linux-gnu.so /usr/local/lib/python2.7/dist-packages/ && \
    cd /usr/local/lib/python2.7/dist-packages/ && \
    ln -s cv2.cpython-35m-x86_64-linux-gnu.so cv2.so

ENTRYPOINT  ["bash"]
