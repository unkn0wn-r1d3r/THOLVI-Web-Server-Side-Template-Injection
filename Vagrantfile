Vagrant.configure("2") do |config|
    config.vm.box = "ubuntu/focal64"
    config.vm.network "forwarded_port", guest: 5000, host: 5000  # Flask port
  
    config.vm.provision "shell", inline: <<-SHELL
      apt-get update
      apt-get install -y python3-flask
      python3 -m pip install gunicorn
      cp /vagrant/vuln_app.py /home/vagrant/
      chmod +x /vagrant/setup.sh
      /vagrant/setup.sh
      nohup python3 /home/vagrant/vuln_app.py &
    SHELL
  end