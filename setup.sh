source .env

# install image magick
apt install imagemagick

# install unzip
apt install unzip

# install aws-cli
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install

echo "Make sure the full and thumbnail directories are readable by the public!"

# configure the image processing cron job
chmod 777 process.sh

# configure the static side building job
chmod 777 generate_site.sh
chmod 777 generate_page.sh