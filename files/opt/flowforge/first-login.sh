#!/bin/bash

myip=$(hostname -I | awk '{print$1}')

modify_config()
{
    DOM=$1

    sed -i "s/example.com/$DOM/" /opt/flowforge/etc/flowforge.yml
    sed -i 's/base_url: http/base_url: https/' /opt/flowforge/etc/flowforge.yml
    sed -i 's/  public_url: ws/  public_url: wss/' /opt/flowforge/etc/flowforge.yml

    sed -i "s/example.com/$DOM/" /opt/flowforge/docker-compose.yml
    sed -i 's/# //' /opt/flowforge/docker-compose.yml

    #temp fix
    sed -i 's!initdb.d/setup-db.sh!initdb.d/01-setup-db.sh!' /opt/flowforge/docker-compose.yml
    sed -i 's!initdb.d/setup-context-db.sh!initdb.d/02-setup-context-db.sh!' /opt/flowforge/docker-compose.yml
}

cat <<EOF
********************************************************************************"

Welcome to the FlowForge Digital Ocean Droplet Wizard

Please ensure you have an A record DNS entry pointing to $myip for your domain

EOF

read -p "Please enter the domain to use for FlowForge: " DOMAIN
echo "Using $DOMAIN"
select yn in "Yes" "No"; do
    case $yn in
        Yes ) modify_config $DOMAIN; break;;
        No ) ;;
    esac
    read -p "Pease enter the domain to use for FlowForge: " DOMAIN
    echo "Using $DOMAIN"
    echo "1) Yes"
    echo "2) No"

done

cat <<EOF
********************************************************************************

Would you like to setup an SMTP Server to allow FlowForge to send email.

This will be used to handle password resets and to invite users to teams.

EOF
select email in "Yes" "No"; do

    case $email in
      Yes ) echo "Setting up email";;
      No ) break;;
    esac

    while : ; do

        read -p "Please enter the hostname of your SMTP server: " SMTPHOST
        read -p "Please enter the port for your SMTP server [587]: " SMTPPORT
        read -p "Please enter the usename for your SMTP server: " SMTPUSER
        read -s -p "Please enter the password for your SMTP server: " SMTPPASSWORD
        echo \n

        SMTPPORT=${SMTPPORT:-587}

        SMTPSECURE=false

        if [ ${SMTPPORT} -eq 485 ]; then 
            SMTPSECURE=true
        fi

        [[ ( -z $SMTPHOST  ||  -z $SMTPUSER ||  -z $SMTPPASSWORD ) ]] || break 

        echo "You must supply all values"

    done

    cat <<EOF >> /opt/flowforge/etc/flowforge.yml
email:
  enabled: true
  from: '"FlowForge" <flowforge@$DOMAIN>'
  smtp:
    host: $SMTPHOST
    port: $SMTPPORT
    secure: $SMTPSECURE
    auth:
      user: $SMTPUSER
      pass: $SMTPPASSWORD
EOF
break
done

# cd /opt/flowforge
# docker compose -p flowforge up -d

cat <<EOF

********************************************************************************

You can then finish setting up your FlowForge instance at

https://forge.$DOMAIN/setup

********************************************************************************

EOF
# cp -f /etc/skel/.bashrc /root/.bashrc