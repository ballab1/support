TODO
```

Jenkins:   Permission denied: /var/run/docker.sock
Kafka broker/zookeeper issues
Grafana update
Nagios/nconf with php7
Phpmyadmin configuration
Hubot update
Zenphoto update
mysql update
Smonitor
SMB write access

Track created users for runtime changes
Separate build, package and deploy/run actions
Fix up docker dependency script 
consolidate nginx_alt into nginx_base
Add getcomposer (for PHP) to php5
Add getcomposer (for PHP) to php7


security
- mapping layer for ENV variables.  use docker-compose.yml
- base set going into docker-compose.yml : individual set for each container
- need layered containers
- https://stackoverflow.com/questions/5725296/difference-between-sh-and-bash

containers
    kafkamgr reverse proxy
    ubuntu-s1 zookeeper/broker
    mysql 10.0
    need generic uS for "kafka topic -> DBMS table"
    file checksums -> kafka topic

configuration
    nagios: load DBMS from config files
    script to reconfigure demo (change IP addresses in correct places)
    nginx/php5 layers need more work
    supervisord-monitor
    
CBF
    parse Dockerfile for 'sudo' requirement  (USER + VOLUME): warn on 'USER' rather than 'USER_UID'
    


get stuff working:
    zen:
        The plain HTTP request was sent to HTTPS port
            http://10.1.3.6:443/zp-core/setup/index.php?autorun=gallery
                        zp-core/htaccess references:  RewriteBase /zenphoto 
                        zp-core/setup/index.php:  if ($connection && !isset($_zp_options))  [ but file should be index.php.xxx ]
        Always starts up in 'setup / update' mode
    Jenkins errors (on nginx):
                need dockerentry.sh to set owner of files in .ssh
                2018/01/01 16:29:15 [error] 6#6: *9 connect() failed (111: Connection refused) while connecting to upstream, client: 10.1.3.24, server: default, request: "POST /jenkins/ajaxBuildQueue HTTP/1.1", upstream: "http://172.18.0.5:8080/jenkins/ajaxBuildQueue", host: "10.1.3.6", referrer: "https://10.1.3.6/jenkins/"
        2018/01/01 16:29:15 [error] 6#6: *10 connect() failed (111: Connection refused) while connecting to upstream, client: 10.1.3.24, server: default, request: "POST /jenkins/ajaxExecutors HTTP/1.1", upstream: "http://172.18.0.5:8080/jenkins/ajaxExecutors", host: "10.1.3.6", referrer: "https://10.1.3.6/jenkins/" 
    nagios:
        fcgiwrap: REMOTE_USER not found  - when initial page loads
        nagios logs to supervisord.log
    phpadmin:
        resolve login issue where page is left blank

        
enhancements:
    kafka to MySQL
        https://docs.confluent.io/current/connect/connect-jdbc/docs/sink_connector.html
        write sync jobs (using sha256hash)
        hash generation should be perl container job/script to push to kafka topic
        photos
        backups
        jenkins:  
        build.sh: auto configure from JENKINS_GITHUB settings
    webdav:
        currently provies read/write access : no restrictions
        improve page layout (make similar to:  https://apache.org/dist/zookeeper/)
    backups:
        find & remove dup files
        sync across network USB drives  (10.1.3.1 & 10.1.3.5)
        barebones hubot:  see https://slackapi.github.io/hubot-slack/
        need more coffeescript & add script versions
        recipes: 
            add side menu for categories filtering
            backup needs more intelegence + moved to jenkinsfile
        remove passwords from container enironment variables
            zen, nagios, phpadmin, grafana, webdav, hubot, jenkins, mysql
    implement jenkins jobs as containers
    tie DBMS backups into startup by copying SQL files to "ubuntu-s:\home\bobb\prod\mysql\vols\loader\dumps" 
    setup nodervisor  (supervisor views with nodejs)
    make fancy report for 'Jenkins Uptime Pipeline' and export data to kafka
    create/use base containers for 'nginx+php5+fpm'/'nginx+php7+fpm'
    reconfigue nagios
    funnel access of other servers through nginx
    setup elasticsearch


future development  
        LABELS in images
        - git remote get-url origin
        - git describe --tags --abbrev=40 --dirty
    create container which has a firewall
    encode/decode files (aka GIT-LFS encoding) which are protected so they can go into GIT
    create a GIT-LFS->raw_fs server for testing
```


Done
=============================================================
Move bashlib to action_folder
Consolidate build & runtime folder structure
Nagios reverse proxy
Allow any action to have an osId extension to support conditional actions
