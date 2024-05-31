cd /home

sudo chmod 777 /tmp/id_rsa
sudo mv /tmp/id_rsa ~/.ssh/id_rsa
sudo chmod 600 ~/.ssh/id_rsa

ssh-keyscan github.com >> ~/.ssh/known_hosts

sudo chmod 777 /home
sudo yes yes | git clone git@github.com:Stabien/esgi-challenge-s4
ls

wait

cd esgi-challenge-s4/back
sudo cp /tmp/.env.local ./.env.local
sudo docker compose up -d
