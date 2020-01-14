HVORDAN OPPDATERE SIKKERHET
===========================
# UPDATED 17 February 2019
# Redirect all HTTP traffic to HTTPS
# https://gist.github.com/9a39bb636a820fb97eec2ed85e473d38.git

cdg ansible-cloudatcost

cd roles/nginx

wget https://gist.github.com/9a39bb636a820fb97eec2ed85e473d38.git 

cat ~/git/9a39bb636a820fb97eec2ed85e473d38/nginx.conf |perl -ne 'print $_ if $_!~/{|root|}|return|default_type|listen|domain.com|^\# [^S]/' >files/includes/security.conf

VANLIG KJØRING
==============
ansible-playbook -i hosts -K -t nginx update.yml