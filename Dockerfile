
# Using linuxserver.io baseimage
FROM lsiobase/guacgui


# Build environment
ENV FREAC_ARCH=x86_64 \
    FREAC_VER=1.1-rc2 \
    FREAC_HOME=/app/freac
    

# Install a missing fre:ac dependency (clean-up needed, as only single library needed from this bundle?)
RUN apt-get update && apt-get -y install libgtk-3-0 && \
# Add Japanese language support (github issue #1)
    apt-get install -y fonts-takao fonts-takao-mincho


# Install fre:ac
RUN curl -SLO https://github.com/enzo1982/freac/releases/download/v${FREAC_VER}/freac-${FREAC_VER}-linux-${FREAC_ARCH}.AppImage && \
    chmod a+x freac-${FREAC_VER}-linux-${FREAC_ARCH}.AppImage && \
    ./freac-${FREAC_VER}-linux-${FREAC_ARCH}.AppImage --appimage-extract && \
    rm -rf freac-${FREAC_VER}-linux-${FREAC_ARCH}.AppImage && \
    mkdir -p ${FREAC_HOME} && \
    mv squashfs-root/* ${FREAC_HOME} && \
    rm -rf squashfs-root


# Ports and volumes
# Expose both ports to get 'DISPLAY' to work for remote desktop
EXPOSE 3389 8080
# Configuration and cache
VOLUME /root
# Media directory
VOLUME /storage


# Environment for fre:ac
ENV PATH ${FREAC_HOME}:$PATH
ENV LD_LIBRARY_PATH ${FREAC_HOME}:$LD_LIBRARY_PATH
ENV DISPLAY :1

CMD freac
