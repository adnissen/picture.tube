source .env

# install image magick
apt install imagemagick

# install unzip
apt install unzip

# install aws-cli
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install

# install caddy
cd /usr/local/bin
curl "https://caddyserver.com/api/download?os=linux&arch=amd64" -o "caddy"
chmod 777 caddy
cd ~

# configure the image processing cron job
chmod 777 process.sh

# configure the static side building job
chmod 777 generate_site.sh

# setup the web server