set DBUILDOPTS=""
set NAMESPACE="thijswithaar"

"C:\Program Files\docker\docker\DockerCLI.exe" -SwitchLinuxEngine

docker build %DBUILDOPTS% -f Dockerfile.debian_sid -t %NAMESPACE%/debian:sid .
docker push %NAMESPACE%/debian:sid

docker build %DBUILDOPTS% -f Dockerfile.fedora_rawhide -t %NAMESPACE%/fedora:rawhide .
docker push %NAMESPACE%/fedora:rawhide

docker build %DBUILDOPTS% -f Dockerfile.ubuntu -t %NAMESPACE%/ubuntu:devel .
docker push %NAMESPACE%/ubuntu:devel

docker build %DBUILDOPTS% -f Dockerfile.arch -t %NAMESPACE%/arch:latest .
docker push %NAMESPACE%/arch:latest

docker build %DBUILDOPTS% -f Dockerfile.suse -t %NAMESPACE%/suse:tumbleweed .
docker push %NAMESPACE%/suse:tumbleweed
