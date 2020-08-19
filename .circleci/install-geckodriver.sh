curl -L -o "/tmp/geckodriver.tar.gz" "https://github.com/mozilla/geckodriver/releases/download/v$GECKODRIVER_VERSION/geckodriver-v$GECKODRIVER_VERSION-linux64.tar.gz"
tar -xvzf /tmp/geckodriver.tar.gz -C /tmp/
sudo mv "/tmp/geckodriver" "/opt/geckodriver"
chmod +x /opt/geckodriver
sudo ln -sf "/opt/geckodriver" "/usr/local/bin/geckodriver"