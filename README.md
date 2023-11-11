# Sandbox Selenium (python)

A sandbox to develop python projects based on [Selenium](https://www.selenium.dev/).  

This project uses a docker image that includes all required resources such as:  

- [Python 3.12](https://www.python.org/)
- [Selenium for Python](https://pypi.org/project/selenium/)
- [Webdriver Manager for Python](https://pypi.org/project/webdriver-manager/)
- [Google Chrome](https://www.google.com/intl/it_it/chrome/)

You can test environment with the following commands:  

1. Docker build and login (from linux shell):

    ```bash
    make build login # Build docker image and Login docker container
    ```

2. Run test.py script (from docker container)

    ```bash
    ./test.py # Run test.py script (open google chrome browser)
    exit # Exit from docker container
    ```

**NOTE**  
The project include the .devcontainer folder to automate the docker build and develop within vscode.

## Appendix

### Build the docker image

The docker image can be manually built as follow:  

```bash
# make build
docker build -t ricfio/python-selenium:3.12 .
```

The project docker image was built as a customization from:  
`mcr.microsoft.com/vscode/devcontainers/python:0-3.12-bullseye`

### Run a temporary docker container opening Google Chrome inside

```bash
# make run
docker run -it --rm --net host -e DISPLAY=unix$(DISPLAY) ricfio/python-selenium:3.12 google-chrome-stable --no-sandbox
```

### Install Python packages

This project uses some python packages that can be installed with pip:  

```bash
pip install selenium
pip install webdriver-manager
```

### Install Google Chrome

The Google Chrome browser was installed in the docker image (linux debian based) as follow:  

```bash
cd ~
sudo apt update
wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
sudo dpkg -i google-chrome-stable_current_amd64.deb || true && sudo apt -y --fix-broken install
sudo apt clean
google-chrome-stable --version
```

### Install VcXsrv Windows X Server

You can run Google Chrome also inside a docker container (debian based) on Windows 10 using [VcXsrv Windows X Server](https://sourceforge.net/projects/vcxsrv/).

1. Install the X-Server 'VcXsrv Windows X Server' (on Windows 10)
2. Run 'XLaunch for Windows' (on Windows 10)
3. Run Google Chrome from the docker container

Further details to install VcXsrv:  

- [Install an X-Server to display UI from the linux subsystem (WSL2)](https://docs.cypress.io/guides/getting-started/installing-cypress#Windows-Subsystem-for-Linux)

### Run Google Chrome in docker using the X-Server running on docker host

```bash
google-chrome-stable --no-sandbox --display=host.docker.internal:0.0 --disable-dev-shm-usage
```
