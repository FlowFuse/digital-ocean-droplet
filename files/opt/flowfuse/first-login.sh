#!/bin/bash

# myip=$(hostname -I | awk '{print$1}')
myip=$(curl -s ipinfo.io/ip)

modify_config()
{
    DOM=$1

    cp /opt/flowfuse/.env.example /opt/flowfuse/.env
    sed -i "s/^DOMAIN=.*/DOMAIN=$DOM/" /opt/flowfuse/.env
    sed -i "s/^TLS_ENABLED=.*/TLS_ENABLED=true/" /opt/flowfuse/.env
    echo CREATE_ADMIN=true >> /opt/flowfuse/.env

}

cat <<EOF
********************************************************************************

Welcome to the FlowFuse Digital Ocean Droplet Wizard

Please ensure you have an A record DNS entry pointing to $myip for your domain

EOF

read -p "Please enter the domain to use for FlowFuse: " DOMAIN
echo "Using $DOMAIN"
select yn in "Yes" "No"; do
    case $yn in
        Yes ) modify_config $DOMAIN; break;;
        No ) ;;
    esac
    read -p "Pease enter the domain to use for FlowFuse: " DOMAIN
    echo "Using $DOMAIN"
    echo "1) Yes"
    echo "2) No"

done

cat <<EOF
********************************************************************************

Would you like to setup an SMTP Server to allow FlowFuse to send email?

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

        if [ ${SMTPPORT} -eq 465 ]; then 
            SMTPSECURE=true
        fi

        [[ ( -z $SMTPHOST  ||  -z $SMTPUSER ||  -z $SMTPPASSWORD ) ]] || break 

        echo "You must supply all values"

    done

    sed -i "s/^EMAIL_ENABLED=.*/ENAMIL_ENABLED=true/" /opt/flowfuse/.env
    sed -i "s/^EMAIL_HOST=.*/EMAIL_HOST=$SMTPHOST/" /opt/flowfuse/.env
    sed -i "s/^EMAIL_PORT=.*/EMAIL_PORT=$SMTPPORT/" /opt/flowfuse/.env
    sed -i "s/^EMAIL_USER=.*/EMAIL_USER=$SMTPUSER/" /opt/flowfuse/.env
    sed -i "s/^EMAIL_PASSWORD=.*/EMAIL_PASSWORD=$SMTPPASSWORD/" /opt/flowfuse/.env
    sed -i "s/^EMAIL_SECURE=.*/EMAIL_SECURE=$SMTPSECURE/" /opt/flowfuse/.env

break
done

cd /opt/flowfuse
docker compose --profile autotls up -d --quiet-pull

cat <<EOF
********************************************************************************

Waiting 30 seconds for startup

********************************************************************************
EOF

sleep 30
curl -s -L --insecure "https://forge.$DOMAIN/setup"
sleep 2

adminPass=$(docker logs flowfuse-forge-1 2>&1 | awk '/\[SETUP\] password/ { print $0}' | jq -r .msg | awk '{ print $3 }')

cat <<EOF

********************************************************************************

You can then finish setting up your FlowFuse instance at

https://forge.$DOMAIN/setup

Username: ff-admin
Password: $adminPass

You will be asked to change the password on login.

If you get a certificate error on first access, please wait a minute for 
LetsEncrypt to complete provisioning and reload the page.

********************************************************************************

EOF
cp -f /etc/skel/.bashrc /root/.bashrc
