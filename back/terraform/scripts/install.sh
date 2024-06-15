sudo apt-get update -y

#Install Git
sudo apt-get install git -y

# Add Docker's official GPG key:
sudo apt-get install ca-certificates curl -y
sudo install -m 0755 -d /etc/apt/keyrings -y
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc

# Add the repository to Apt sources:
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

sudo apt-get update -y
sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin -y

cd /home

sudo chmod 777 /tmp/id_rsa
sudo mv /tmp/id_rsa ~/.ssh/id_rsa
sudo chmod 600 ~/.ssh/id_rsa

ssh-keyscan github.com >> ~/.ssh/known_hosts

sudo chmod 777 /home
sudo yes yes | git clone --branch feat/add-cd git@github.com:Stabien/esgi-challenge-s4

cd esgi-challenge-s4/back
sudo cp /tmp/.env.local ./.env.local