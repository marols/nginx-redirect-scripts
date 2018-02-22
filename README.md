# URL redirect scripts

This repo contains a set of scripts for generating `rewrite` statements for use in Nginx.

The end goal is to redirect all of the old websites [old-url.fi](old-url.fi) to [new-url.com](new-url.com) instead.

## Process
Here are the steps you need for getting everything up and running

### Prepping the source data
1. Create a `.csv` file. It should have the name of the domain it relates to, e.g. `www.old-url.fi.csv`.
2. Open the `.csv` file in your favourite editor and
    1. Change from CRLF to LF
    2. Change encoding to UTF8
    3. Make sure there is a new line at the end of the file

### Generating redirects
1. Clone this repo
2. Copy the file you created in **Prepping the source data** above into `sources/`.
3. Open the Terminal and cd to the root folder of the repo.
4. Run
```
> ./generate-redirects.sh
```
5. This outputs one `.txt` file for each `.csv` in the `sources/` folder. This file contains all the redirects you need. **ATTENTION!** If your URLs have any query string parameters or other non-standard format you will probably have to create that redirect manually.

### Creating a new config
1. Copy an already existing .conf file from the folder `nginx-confs/`
2. Change `server_name` to the domain you are working with. That would be the same as the name for the `.csv` but without the file ending, e.g. `www.old-url.fi`.
3. Change the `access_log` and `error_log` names in the same way as with `server_name` above.
3. Open the `.txt` file with your redirects, copy all of them. Then open your newly created `.conf` file and replace all current `location` lines under the comment `# Redirects` with the ones you just copied.

### Copy config to server
1. Open a Terminal and login to the server using SSH:
```
> ssh username@server-name -p 2200
```
2. Open another terminal window and run the following command to copy the config to the server: (assuming your config file is named `www.old-url.fi.conf`)
```
> scp -P 2200 nginx-confs/www.old-url.fi.conf username@server-name:~
```
3. From the Terminal where you logged in to the server run the following command to copy the `.conf` to the nginx follder and then reload Nginx:
```
> sudo cp ~/www.old-url.fi.conf /etc/nginx/sites-available/ && sudo service nginx reload
```

### Running the tests
1. Open a Terminal and cd to the root directory of this repo.
2. Run the following command to execute the test
```
> ./test-redirects.sh
```
3. Await the result, this might take several minutes.

