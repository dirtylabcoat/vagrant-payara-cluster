VAGRANTFILE_API_VERSION = "2"
BOX_IMAGE = "fso/xenial64"
Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
    (1..3).each do |i|
        config.vm.define "payara-box#{i}" do |box|
            box.vm.box = BOX_IMAGE
            box.vm.hostname = "payara-box#{i}"
            box.vm.provider :virtualbox do |vb|
                vb.name = "payara-box#{i}"
                vb.customize ["modifyvm", :id, "--memory", "1024"]
            end

            box.vm.network :forwarded_port, guest: 4848, host: 5000 + i
            box.vm.network :forwarded_port, guest: 8080, host: 8000 + i
            box.vm.provision "shell", path: "provision.sh"
        end
    end
end
