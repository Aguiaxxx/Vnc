# Docker container image with "headless" VNC

This Docker image is installed with the following components:

* Desktop environment [**Xfce4**](http://www.xfce.org)
* VNC-Server (default VNC port `5901`)
* [**noVNC**](https://github.com/novnc/noVNC) - HTML5 VNC client (default http port `6901`)
* Browsers:
  * Chromium

## Build

```
docker build --rm -f "Dockerfile.ubuntu.xfce.vnc" -t onepanel/vnc:latest .
```

## Usage

- Print out help page:

      docker run onepanel/vnc:latest --help

- Run command with mapping to local port `5901` (vnc protocol) and `6901` (vnc web access):

      docker run -d -p 5901:5901 -p 6901:6901 onepanel/vnc:latest
  
- Change the default user and group within a container to your own with adding `--user $(id -u):$(id -g)`:

      docker run -d -p 5901:5901 -p 6901:6901 --user $(id -u):$(id -g) onepanel/vnc:latest

- If you want to get into the container use interactive mode `-it` and `bash`
      
      docker run -it -p 5901:5901 -p 6901:6901 onepanel/vnc:latest bash

# Connect & Control

If the container is started like mentioned above, connect via one of these options:

- connect via __VNC viewer `localhost:5901`__, default password: `vncpassword`
- connect via __noVNC HTML5 full client__: [`http://localhost:6901/vnc.html`](http://localhost:6901/vnc.html), default password: `vncpassword` 
- connect via __noVNC HTML5 lite client__: [`http://localhost:6901/?password=vncpassword`](http://localhost:6901/?password=vncpassword) 


## Hints

### 1. Extend a Image with your own software

Example:

```bash
## Custom Dockerfile
FROM onepanel/vnc:latest
ENV REFRESHED_AT 2020-06-01

## Install a gedit
RUN yum install -y gedit \
    && yum clean all
```

### 2. Change User of running container

You can change the user id as follows: 

#### 2.1. Using root (user id `0`)
Add the `--user` flag to your docker run command:

    docker run -it --user 0 -p 6911:6901 onepanel/vnc:latest

#### 2.2. Using user and group id of host system
Add the `--user` flag to your docker run command:

    docker run -it -p 6911:6901 --user $(id -u):$(id -g) onepanel/vnc:latest

### 3. Override VNC environment variables
The following VNC environment variables can be overwritten at the `docker run` phase to customize your desktop environment inside the container:

- `VNC_COL_DEPTH`, default: `24`
- `VNC_RESOLUTION`, default: `1280x1024`
- `VNC_PW`, default: `my-pw`
- `VNC_PASSWORDLESS`, default: `<not set>`

#### 3.1. Example: Override the VNC password
Simply overwrite the value of the environment variable `VNC_PW`. For example in
the docker run command:

    docker run -it -p 5901:5901 -p 6901:6901 -e VNC_PW=my-pw onepanel/vnc:latest

#### 3.2. Example: Override the VNC resolution
Simply overwrite the value of the environment variable `VNC_RESOLUTION`. For example in
the docker run command:

    docker run -it -p 5901:5901 -p 6901:6901 -e VNC_RESOLUTION=800x600 onepanel/vnc:latest

#### 3.3. Example: Start passwordless
Set `VNC_PASSWORDLESS` to `true` to disable the VNC password.
It is highly recommended that you put some kind of authorization mechanism
before this. For example in the docker run command:

    docker run -it -p 5901:5901 -p 6901:6901 -e VNC_PASSWORDLESS=true onepanel/vnc:latest

### 4. View only VNC
It's possible to prevent unwanted control via VNC. Therefore you can set the environment variable `VNC_VIEW_ONLY=true`. If set, the startup script will create a random password for the control connection and use the value of `VNC_PW` for view only connection over the VNC connection.

     docker run -it -p 5901:5901 -p 6901:6901 -e VNC_VIEW_ONLY=true onepanel/vnc:latest

### 5. Known Issues

#### 5.1. Chromium crashes with high VNC_RESOLUTION
If you open some graphic/work intensive websites in the Docker container (especially with high resolutions, e.g. `1920x1080`) Chromium can crash without any specific reason. The problem is that size of `/dev/shm` too small in the container. You can define this size on startup via the  `--shm-size` option:

    docker run --shm-size=256m -it -p 6901:6901 -e VNC_RESOLUTION=1920x1080 onepanel/vnc:latest chromium-browser http://map.norsecorp.com/

## How to release
See **[how-to-release.md](./how-to-release.md)**

## Changelog
The current changelog is provided here: **[changelog.md](./changelog.md)**

## Acknowledgments
This repository is a fork of https://github.com/ConSol/docker-headless-vnc-container