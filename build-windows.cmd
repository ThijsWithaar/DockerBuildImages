set DBUILDOPTS=--pull --no-cache --squash
set DBUILDOPTS=--pull -m 16GB
set DOCKER_USER=thijswithaar

"C:\Program Files\docker\docker\DockerCLI.exe" -SwitchWindowsEngine
@rem docker login -u %DOCKER_USER% -p ${{ secrets.DOCKER_PASSWORD }}
docker build %DBUILDOPTS% -f Dockerfile.windows_2022 -t %DOCKER_USER%/windows:2022 .
docker image push %DOCKER_USER%/windows:2022

@rem docker build %DBUILDOPTS% -f Dockerfile.windows -t %DOCKER_USER%/windows:2019 .
@rem docker image push %DOCKER_USER%/windows:2019
