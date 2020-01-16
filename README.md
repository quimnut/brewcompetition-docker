# brewcompetition-docker
```
Edit all environment variables in docker-compse.yml and the 2 labels with the DNS of your web site -> Host(`your.brew.comp.web.site.beer`)
Edit traefik.yml and put in an email for the LE SSL cert.
Make sure DNS works and your FW is confiugred to allow 80 and 443.
The ADMIN email anbd pass is only applied when the database is first created.

Ensure ./appdata/acme.json is chmod 0600

Wait a minute or 2 for the SSL cert to be installed.

```
