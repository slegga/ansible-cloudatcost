# Provisioning CloudAtCost by Ansible

1st, add cloudatcost's fingerprint to known_hosts

    % ssh -l root xxx.xxx.xxx.xxx 

2nd, install sshpass for login with password

    % curl -O -L http://downloads.sourceforge.net/project/sshpass/sshpass/1.06/sshpass-1.06.tar.gz
    % tar -zxvf sshpass-1.06.tar.gz
    % cd sshpass-1.06
    % ./configure
    % make 
    % sudo make install

3rd, test ansible connection

    % ansible -i hosts xxx.xxx.xxx.xxx -m ping -c ssh -vvv --ask-pass

4th, run

    % ansible-playbook -i hosts init.yml -vvv --extra-vars ansible_ssh_pass=PASSWORD


## reference

- [実践！Ansibleベストプラクティス（前編）](http://knowledge.sakura.ad.jp/tech/3084/)
- [AnsibleでVPS初期設定](http://blog.ieknir.com/blog/beginning-conoha-vps-with-ansible/)
