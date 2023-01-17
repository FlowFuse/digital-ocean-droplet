# FlowForge Droplet

## Description

FlowForge's intuitive UI lets you manage your Node-RED instances all in one place.

Spin up instances of Node-RED in seconds, monitor project health and tear down or suspend projects as required.

### Before you deploy your FlowForge Droplet

#### Get a Domain

Use this [DNS quickstart](https://docs.digitalocean.com/products/networking/dns/quickstart/) guide to get your DNS setup on DigitalOcean. You’ll first need to purchase and register your domain through a third party, such as Name.com, GoDaddy, etc…

- Why do you need a domain name?

    The domain will be used to generate the host names for each FlowForge project you deploy

## Getting started after deploying

On your first SSH Login to your droplet or when you connect to the Droplet console you will be greeted by a wizard that will guide you through setting up the domain name and starting your FlowForge instance.

Before entering your hostname you will need to add an A record for your domain.

Once the wildcard A record has been created you can enter it into the wizard. The wizard will then update the configuration files and start the FlowForge Application. The final configuration is done via the web interface on the hostname that will be in final message from the wizard.

Details of how to complete configuration can be found [here](https://flowforge.com/docs/install/first-run/#--docker-or-kubernetes)