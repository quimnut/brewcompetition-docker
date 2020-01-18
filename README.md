# brewcompetition-docker
Docker compose for [https://github.com/geoffhumphrey/brewcompetitiononlineentry/](https://github.com/geoffhumphrey/brewcompetitiononlineentry/) using traefik for SSL automation.

As of 2.1.18 [brewcompetitiononlineentry](https://github.com/geoffhumphrey/brewcompetitiononlineentry/) supports SMTP email. 

This docker stack will deploy a baseline_ database on apache2 using the ADMIN_ credentials for the admin user.

It is a work in progress and any contributions are welcome.

This project aims to help home brew clubs quickly deploy a competition website.

## Requirements
A docker environment ($5/m VPS, home NAS).

A (sub)domain name to use (possibly free).

A SMTP email account for sending email (possibly free, or mailgun).

## Usage
- Ensure docker and git are installed.
- Clone the configuration with git `git clone https://github.com/quimnut/brewcompetition-docker.git`
- `chmod 600 ./appdata/acme.json`
- Edit all of the environment variables in docker-compose.yml ensuring you do not miss the the 2 traefik labels containing the DNS hostname of your web site 
- Edit traefik.yml and update the email for your LetsEncrypt SSL cert.
- Make sure your DNS works and your firewall is confiugred to allow ports 80 and 443.
- `docker-compose up -d`

The ADMIN credentials are only applied when the database is first created.

The SMTP settings are applied when started.

Wait a minute or 2 for the SSL cert to be installed if you see SSL errors. 

Check the logs via docker, or in the appdata folder.

## Known Issues
Does not support non-typical ports (80 and 443 only).
