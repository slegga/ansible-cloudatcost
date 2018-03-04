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

3th, Run setup
    % $EDITOR bin/setup.pl
    % bin/setup.pl
    %
3th, run
    % cd ~/ansible
    % ansible-playbook -i hosts init.yml -vvv --ask-pass
    % mv private_key-xxxxx.id_rsa ~/.ssh/.
