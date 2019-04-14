TODO
```

add docker-compose checking to deploy
error in uid_gid.validateUser when passed 2222:2222



build dependencies
nginx index.html
nagios:
	DBI connect('database=nconf;host=mysql','bobb',...) failed: Can't connect to MySQL server on 'mysql' (115) at /usr/local/nagios/share/nconf/bin/lib/NConf/DB.pm line 103.
	Compilation failed in require at /usr/local/nagios/share/nconf/bin/generate_config.pl line 51.
	BEGIN failed--compilation aborted at /usr/local/nagios/share/nconf/bin/generate_config.pl line 51.
	***ERROR at environment:9. '"${NCONF_HOME}/bin/generate_config.pl"' exited with status 115
	Stack trace:
	>>>    02: /usr/local/crf/startup/05.nagios:35 nagios.redeployConfig  <<<



get stuff working:
   reverse proxy for cesi
   nagiosgraph issues

   Jenkins
     (on nginx):
        need to examine/tune Garbage collection
        	https://www.slideshare.net/TidharKleinOrbach/why-does-my-jenkins-freeze-sometimes-and-what-can-i-do-about-it
        	http://engineering.taboola.com/5-simple-tips-boosting-jenkins-performance/
        	https://www.cloudbees.com/blog/joining-big-leagues-tuning-jenkins-gc-responsiveness-and-stability
        	https://jenkins.io/blog/2016/11/21/gc-tuning/
        	analyze GC logs with tools such as http://gceasy.io/
        2018/01/01 16:29:15 [error] 6#6: *9 connect() failed (111: Connection refused) while connecting to upstream, client: 10.1.3.24, server: default, request: "POST /jenkins/ajaxBuildQueue HTTP/1.1", upstream: "http://172.18.0.5:8080/jenkins/ajaxBuildQueue", host: "10.1.3.6", referrer: "https://10.1.3.6/jenkins/"
        2018/01/01 16:29:15 [error] 6#6: *10 connect() failed (111: Connection refused) while connecting to upstream, client: 10.1.3.24, server: default, request: "POST /jenkins/ajaxExecutors HTTP/1.1", upstream: "http://172.18.0.5:8080/jenkins/ajaxExecutors", host: "10.1.3.6", referrer: "https://10.1.3.6/jenkins/" 
    nagios:
        fcgiwrap: REMOTE_USER not found  - when initial page loads
        nagios logs to supervisord.log
    complete unit tests

CBF:
    use CBF_VERSION better
        - should never unset
        - should check if specified version same as installed version (no point in wget)

builds
    quality ladder:  dev -> staging -> master
        - deploy should set 'latest' (not build). (use registry API to get and work with available images)
    docker-registry
        - handle more tags to fingerprint lookup (ex: latest, master, staging)
        - move old named content to new repos
        - permit deleteion of content based on
        	tag  (as in all tags which match ... in a repo)
        	do not use 'master' but instead 'yyyymmdd-$(git-describe)' and update docker-compose
        - configure to use redis
             https://github.com/docker-library/redis/blob/e95c0cf4ffd9a52aa48d05b93fe3b42069c05032/5.0-rc/32bit/Dockerfile
    Separate build, package and deploy/run actions
        Fix up docker dependency script

enhancements:
    setup elasticsearch
    container kafka logging with https://hub.docker.com/r/mickyg/kafka-logdriver/
    containers
        base jenkins and webdav on supervisord image
        tie DBMS backups into startup by copying SQL files to "ubuntu-s:\home\bobb\prod\mysql\vols\loader\dumps" 
        improve logging   (make use of /dev/fd/1 or /dev/fd/2)
        need generic uS for "kafka topic -> DBMS table"
        file checksums -> kafka topic
    kafka to MySQL
        https://docs.confluent.io/current/connect/connect-jdbc/docs/sink_connector.html
        write sync jobs (using sha256hash)
        hash generation should be perl container job/script to push to kafka topic
        photos
        backups
        jenkins:  
        build.sh: auto configure from JENKINS_GITHUB settings
    webdav
        currently provides read/write access : no restrictions
        improve page layout (make similar to:  https://apache.org/dist/zookeeper/)
    nagios
        reconfigue nagios
        configuration: load DBMS from config files
    PHP
        Nagios/nconf with php7
        create/use base containers for 'nginx+php5+fpm'/'nginx+php7+fpm': use port for PHP
        provide build options
            Add getcomposer (for debugging PHP) to php5
            Add getcomposer (for debugging PHP) to php7
        move PHP to port 9000 so we can move it out of nginx
    nginx
        improve extensibility
            change usage from conf.d to sites_enabled
            add thread to check sites_enabled (shared vol) & restart nginx on any change
                check age of files & delete if old
                proxied servers create files in sites_enabled & touch on frequent basis
        funnel access of other servers through nginx
    backups
        find & remove dup files across 10.1.3.1/10.1.3.5
        sync across network USB drives  (10.1.3.1 & 10.1.3.5)
        barebones hubot:  see https://slackapi.github.io/hubot-slack/
            need more coffeescript & add script versions
        recipes: 
            add side menu for categories filtering
            backup needs more intelligence + moved to jenkinsfile
    registry
        scan and reduce all entries to max
        scan and remove fingerprints 'from' n-x repos unless tags > 1
        remove specific tag (needs testing)
        docker-dependents: show labels for images
    jenkins
        implement jenkins jobs as containers
        make fancy report for 'Jenkins Uptime Pipeline' and export data to kafka
        review list of plugins and dependents to ensure all loaded plugins are explicity defined


future development  
    create container which has a firewall
    create a GIT-LFS->raw_fs server for testing
```

Done
=============================================================
```
occasional error at registry.bashlib:175
	    for digest in "${!digests[@]}"; do
		tags=( ${digests[$digest]} )
		createTime="$(registry.createTime "$name" "${tags[0]}" | tr -d '"')"
		[ "$createTime" != '                      ' ] || createTime='null'
		[ "${times[$createTime]:-}" ] || times[$createTime]="$digest"
	    done
deploy docker-compose.yml for prod
Kafka broker/zookeeper issues
Grafana update
mysql update
ubuntu-s1 production and build
SMB write access
completion of CD install
configure Jenkins with official builds & deploys

docker-registry
- setup private docker registry
- improve error handling
- curate content on the fly
security
- mapping layer for ENV variables.  use docker-compose.yml
- base set going into docker-compose.yml : individual set for each container
- need layered containers
  remove passwords from container environment variables
    zen, nagios, phpadmin, grafana, webdav, hubot, jenkins, mysql
  use git crypt
  permit removal of any environment variable prior to running service
  remove bashlib functions prior to running service

build
- consolidate setupProduction and restartProd

CI/CD
    add ENV for HOST_IP
    every container should update config with HOST_IP
        script to reconfigure demo (change IP addresses in correct places)
phpadmin:
    resolve login issue where page is left blank
Phpmyadmin configuration
Jenkins:   Permission denied: /var/run/docker.sock
           permission denied on /usr/local/crf/CRF.properties are runtime
           rename all pipelines to *.jenkinsfile
consolidate nginx_alt into nginx_base
Move bashlib to action_folder
Consolidate build & runtime folder structure
Nagios reverse proxy
Allow any action to have an osId extension to support conditional actions
setup nodervisor  (supervisor views with nodejs)
    supervisord-monitor configuration
split 'production' into two: "broker,zookeeper,hubot,mysql", "other"
git-crypt: encode/decode files (aka GIT-LFS encoding) which are protected so they can go into GIT

issues pushing/pulling to registry
     sometimes ':latest' not defined, sometimes 'fingerprint' not defined		
     projects should have definition of /version:tags
         so we can have
        	jenkins/2.121.2:latest
        	jenkins/2.121.3:latest
        	jenkins:latest
     need a way to 'just push'

ubuntu-s1 zookeeper/broker

Smonitor/nodervisor
Hubot update
Zenphoto update
consolidate nginx_alt into nginx_base
Add getcomposer (for PHP) to php5
Add getcomposer (for PHP) to php7
- need layered containers
- https://stackoverflow.com/questions/5725296/difference-between-sh-and-bash
    kafkamgr reverse proxy
    nginx/php5 layers need more work
    zen:
        The plain HTTP request was sent to HTTPS port
            http://10.1.3.6:443/zp-core/setup/index.php?autorun=gallery
                        zp-core/htaccess references:  RewriteBase /zenphoto 
                        zp-core/setup/index.php:  if ($connection && !isset($_zp_options))  [ but file should be index.php.xxx ]
        Always starts up in 'setup / update' mode
    Jenkins errors (on nginx):
                need dockerentry.sh to set owner of files in .ssh
Jenkins jobs
        scan registry and delete folders with no sub-folders in
            /var/lib/docker-registry/docker/registry/v2/repositories/<name>/_manifests/tags/

LABELS in images
    - git remote get-url origin
    - git describe --tags --abbrev=40 --dirty

CBF
    delete cache files
    parse Dockerfile for 'sudo' requirement  (USER + VOLUME): warn on 'USER' rather than 'USER_UID'
    base_container does not recognize changes in CBF
    fingerprint calculation should not be dependent on "$CONTAINER_TAG"
    base_container does not have a dependency on CBF
```
