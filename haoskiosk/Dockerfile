################################################################################
# Add-on: HAOS Kiosk Display - Chromium Edition
# File: Dockerfile
# Version: 2.0.0-chromium
# Based on: puterboy/HAOS-kiosk v1.3.0
# Modified by: TCS - Chromium fork for native 4K HiDPI support
# Date: April 2026
################################################################################

ARG BUILD_FROM
FROM $BUILD_FROM

ARG BUILD_VERSION
ENV ADDON_VERSION=${BUILD_VERSION}

#===============================================================================
##### Install X, Chromium Browser and all necessary dependencies
RUN apk update && apk add --no-cache \
## Xserver and graphics
     xorg-server \
     xf86-video-modesetting \
     mesa-dri-gallium \
     mesa-egl \
     mesa-gles \
     libdrm \
### X utils
     xdotool \
     xinput \
     xrandr \
     xset \
     libxkbcommon \
     setxkbmap \
### Input, udev
     xf86-input-libinput \
     libinput \
     udev \
     libinput-udev \
     libevdev \
     evtest \
### Window, mouse, keyboard management
     openbox \
     onboard \
     unclutter-xfixes \
     ttf-dejavu \
### Linux utils
     bash \
     util-linux \
     patch \
     scrot \
### Full Timezone info
     icu-data-full \
### Python libraries
    py3-pip \
    py3-xlib \
### Sound
     pulseaudio-utils \
### VNC (for debugging)
      x11vnc \
### Chromium Browser (replaces Luakit for full 4K HiDPI support)
     chromium \
     font-noto \
     font-noto-emoji \
     ttf-freefont \
   && rm -rf /var/cache/apk/*

#===============================================================================

##### Set the display variable
ENV DISPLAY=:0
ENV CHROME_BIN=/usr/bin/chromium-browser
ENV CHROME_PATH=/usr/lib/chromium/

##### Copy over config files
COPY xorg.conf.default /etc/X11/
COPY translations/*.yaml /translations/

##### Copy startup and login handler
COPY run.sh /
RUN chmod a+x /run.sh

COPY chromium_login.sh /
RUN chmod a+x /chromium_login.sh

COPY mouse_touch_inputs.py gesture_commands.json /
COPY rest_server.py /
RUN pip install --no-cache-dir --break-system-packages aiohttp

##### Create Chromium data directory
RUN mkdir -p /data/chromium

CMD ["/run.sh"]
