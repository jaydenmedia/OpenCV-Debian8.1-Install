#!/bin/bash
#### Description: Install OpenCV 3.1 on Debian Jessie 8.1
#### Written by: Josh Smith  on August 8, 2016
#### Note: Prior to running, ensure that the target disk has enough storage capacity!

#### Thanks go to:
#### https://quirkymonk.wordpress.com/2015/08/10/how-to-install-opencv-3-0-for-python-3-4-in-debian-jessie/
#### http://funvision.blogspot.ie/2016/02/install-opencv-with-ffmpeg-debian.html

#### License:
#    This program is free software: you can redistribute it and/or modify
#    it under the terms of the GNU General Public License as published by
#    the Free Software Foundation, either version 3 of the License, or
#    (at your option) any later version.

#    This program is distributed in the hope that it will be useful,
#    but WITHOUT ANY WARRANTY; without even the implied warranty of
#    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#    GNU General Public License for more details.

#    You should have received a copy of the GNU General Public License
#    along with this program.  If not, see <http://www.gnu.org/licenses/>.


# Keep Debian up-to-date
echo ***UPDATING/UPGRADING APT***
sudo apt-get update
sudo apt-get upgrade
sudo apt-get dist-upgrade
sudo apt-get autoremove


# Install depencencies
echo ***INSTALLING BUILD TOOLS***
sudo apt-get install build-essential make cmake pkg-config nasm 

echo ***INSTALLING VERSIONING***
sudo apt-get install git

echo ***INSTALLING OPENCV AND FFMPEG DEPENDENCIES***
sudo apt-get install libgtk2.0-dev python-dev python-numpy libgstreamer0.10-0-dbg libgstreamer0.10-0 libgstreamer0.10-dev libgstreamer-plugins-base0.10-dev libunicap2 libunicap2-dev libdc1394-22-dev libdc1394-22 libdc1394-utils libv4l-0 libv4l-dev libavcodec-dev libavformat-dev libswscale-dev libdc1394-22-dev libdc1394-utils libjpeg-dev libpng-dev libtiff-dev libjasper-dev libtiff5 libtiff5-dev libopenexr-dev libjasper-dev libpng12-dev libatlas-base-dev gfortran python3.4-dev python3-numpy python3-scipy python3-matplotlib ipython3 python3-pandas ipython3-notebook python3-tk libtbb-dev libeigen3-dev yasm libfaac-dev libopencore-amrnb-dev libopencore-amrwb-dev libtheora-dev libvorbis-dev libxvidcore-dev libx264-dev libqt4-dev libqt4-opengl-dev sphinx-common texlive-latex-extra libxine2-dev libxext-dev libxfixes-dev zlib1g-dev

echo ***INSTALLING OPENCV TEXT RECOGNITION DEPENDENCIES***
sudo apt-get install tesseract-ocr tesseract-ocr-eng libtesseract-dev libleptonica-dev

echo ***INSTALLING MISCELLANEOUS OPENCV DEPENDENCIES***
sudo apt-get build-dep opencv

echo ***INSTALLING DOWNLOADER AND ZIP UNPACKER***
sudo apt-get install unzip wget


echo ***PROCEEDING WITH INSTALLATION***
# Create a new folder and name it as ‘build’.
mkdir ~/OpenCV
mkdir ~/OpenCV/build

cd ~/OpenCV

echo ***DOWNLOADING FFMPEG***
sudo wget -O ffmpeg-2.8.tar.bz2 "https://www.ffmpeg.org/releases/ffmpeg-2.8.tar.bz2"
sudo tar -xvf ffmpeg-2.8.tar.bz2
sudo rm -Rf ffmpeg-2.8.tar.bz2

cd /ffmpeg-2.8 

./configure --enable-nonfree --enable-gpl --enable-libx264 --enable-x11grab --enable-zlib

echo ***MAKE FFMPEG***
# Make FFMpeg. Use -j<NUMBER OF PROCESS THREADS>
make -j2
sudo make install
sudo ldconfig -v

echo ***DOWNLOADING OPENCV 3.1***
# Download OpenCV 3.1 and OpenCV-open-contrib
wget -O 3.1.0.zip https://github.com/Itseez/opencv/archive/3.1.0.zip
wget -O master.zip https://github.com/opencv/opencv_extra/archive/master.zip
# Unzip
unzip opencv-3.1.0.zip
unzip opencv_contrib-master.zip
# Cleanup
rm -Rf opencv-3.1.0.zip
rm -Rf opencv_contrib-master.zip

cd ~/OpenCV/build/

sudo cp /usr/include/x86_64-linux-gnu/python3.4m/pyconfig.h /usr/include/python3.4m/


echo ***COMPILING OPENCV***
# Compile OpenCV
# This cmake command includes Python and C.  Changes required for Java installation
cmake -D CMAKE_BUILD_TYPE=RELEASE -D CMAKE_INSTALL_PREFIX=/usr/local -D INSTALL_C_EXAMPLES=OFF -D INSTALL_PYTHON_EXAMPLES=ON -D OPENCV_EXTRA_MODULES_PATH=./opencv_contrib-master/modules -D BUILD_DOCS=ON -D BUILD_EXAMPLES=ON -D WITH_TBB=ON -D WITH_QT=ON -D WITH_OPENGL=ON -DWITH_VTK=ON -D PYTHON_EXECUTABLE=/usr/bin/python3 -D PYTHON_LIBRARY=/usr/lib/x86_64-linux-gnu/libpython3.4m.so.1.0 -D PYTHON_INCLUDE_DIR=/usr/include/python3.4m -D PYTHON_INCLUDE_DIR2=/usr/include/x86_64-linux-gnu/python3.4m -D PYTHON_NUMPY_INCLUDE_DIRS=/usr/lib/python3/dist-packages/numpy/core/include -D PLANTUML_JAR=./plantuml.jar -D BUILD_opencv_java=ON ..


echo ***MAKE OPENCV***
# Make OpenCV. Use -j<NUMBER OF PROCESS THREADS>
make -j4


echo ***CREATING DOCUMENTATION***
cd ~/OpenCV/build/doc/
make -j7 html_docs


echo ***INSTALLING OPENCV***
sudo make install
sudo ldconfig -v

echo ***INSTALLATION COMPLETE***

# When installation process is finished enter the following commands to test if installation is successful

#$ python3 (enter python shell)
#>> import cv2
#>> print (cv2.__version__)


