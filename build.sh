#!/bin/bash

set -e

apt update
apt install -y curl sqlite3

arch=$(dpkg --print-architecture)
case $arch in
	amd64) arch="x64" ;;
	arm|armf|armhf) arch="arm" ;;
	arm64) arch="arm64" ;;
	*) echo "Unsupported architecture: $arch" && exit 1 ;;
esac

wget --content-disposition "http://readarr.servarr.com/v1/update/develop/updatefile?os=linux&runtime=netcore&arch=$arch" -O ./Readarr.tar.gz
tar -xvzf ./Readarr.tar.gz -C ./

mkdir -p ./build/
mv ./Readarr ./build/Readarr/
mkdir -p ~/.readarr-data

cat <<'EOF' > ./build/run.sh
#!/bin/bash

DATA_DIR=$(readlink -f "$HOME/.readarr-data")
exec "./Readarr/Readarr" -nobrowser -data="$DATA_DIR"
EOF

chmod +x ./build/run.sh
rm ./Readarr.tar.gz

echo "Build complete. Run './build/run.sh' to start Readarr."
