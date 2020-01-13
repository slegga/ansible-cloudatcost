HVORDAN OPPDATERE SIKKER
========================
# UPDATED 17 February 2019
# Redirect all HTTP traffic to HTTPS
# https://gist.github.com/9a39bb636a820fb97eec2ed85e473d38.git

cdg ansible-cloudatcost

cd roles/nginx/stageing

wget https://gist.github.com/9a39bb636a820fb97eec2ed85e473d38.git 

cat roles/nginx/files/nginx.conf |perl -ne 'print $_ if $_!~/{|root|}|default_type|listen|domain.com|^\# [^S]/' >../files/includes/security.conf
