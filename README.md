# brewcompetition-docker
Docker compose for [https://github.com/geoffhumphrey/brewcompetitiononlineentry/](https://github.com/geoffhumphrey/brewcompetitiononlineentry/) using traefik for SSL automation.

As of 2.1.18 [brewcompetitiononlineentry](https://github.com/geoffhumphrey/brewcompetitiononlineentry/) supports SMTP email.

This docker stack will deploy a baseline_ database on apache2 using the ADMIN_ credentials for the admin user.

It is a work in progress and any contributions are welcome.

This project aims to help home brew clubs quickly deploy a competition website.

## Requirements
A docker environment ($5/m VPS, home NAS, aws/oci/gcs/m$ cloud free tier).

A (sub)domain name to use (possibly free also).

A SMTP email account for sending email (possibly free like mailgun).

## Usage
- Ensure docker, docker-compose and git are installed.
- Clone the configuration with git `git clone https://github.com/quimnut/brewcompetition-docker.git`
- `chmod 600 ./appdata/acme.json`
- Edit all of the environment variables in docker-compose.yml ensuring you do not miss the the 2 traefik labels containing the DNS hostname of your web site 
- Edit traefik.yml and update the email for your LetsEncrypt SSL cert.
- Make sure your DNS works and your firewall is configured to allow ports 80 and 443.
- `docker-compose build`
- `docker-compose up -d`
- The first time you run this, if you are a new install appdata/app/ will be populated where the persistent data will be stored
- Now you can stop the container and edit custom.sh, I do this to overwrite the clubs list, as the php code is inside the container image and not persistent.
- to load a database export with any prefix, remove the appdata/app/database directory and copy the dump to appdata/app/loadme.sql, and start the container.

The ADMIN credentials are only applied when a baseline database is used to create a new install.

The SMTP settings are applied every start.

Wait a minute or 2 for the SSL cert to be installed if you see SSL errors. 

Check the logs via docker, or in the appdata folder.

## Known Issues
Does not support non-typical ports (80 and 443 only).
