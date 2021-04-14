apt update
apt install -y software-properties-common apt-transport-https wget
wget -q https://packages.microsoft.com/keys/microsoft.asc -O- | sudo apt-key add -
add-apt-repository "deb [arch=amd64] https://packages.microsoft.com/repos/vscode stable main"

apt install -y code

# Root user needs to specify a directory to operate in, this is it.
mkdir /headless/vscode

# Install extensions
code --install-extension ms-python.python --user-data-dir /headless/vscode