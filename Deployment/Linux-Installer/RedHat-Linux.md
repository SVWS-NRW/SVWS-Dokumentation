# Installation auf Rocky-Linux 9 oder RedHat 9

## Installation openjdk

```
dnf install java-17-openjdk java-17-openjdk-devel
java --version
```

## Installation Zip und Wget

```
dnf -y install unzip
dnf -y install wget
```

## Download der SVWS-Server Pakete
wget https://github.com/SVWS-NRW/SVWS-Server/releases/download/v0.7.8/linux-installer-0.7.8.tar.gz