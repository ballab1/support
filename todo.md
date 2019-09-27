TODO
```

implement Docker.findImage  (should check local and remote. Need flag to indicate to pull remote)
change nagiosgraph to pnp4nagios
move to python:3.7

get working
    fix project updates
    zenphoto
    kafkamgr
    microservices from kafka to DBMS
    supervisord monitor
    docker-utilities: registory curation
    finish nginx front end

docker-utilities
    pushImage needs to be able to rename to latest if needed
    minor issue:
	$ docker-utilities report -o x.txt -f text
	docker-utilities: invalid option -- 'f'
	report remote images in ubuntu-s2:5000/  : text

	No content specified
	Caught: groovy.json.JsonException: Unable to determine the current character, it is not a string, number, array, or object

	The current character read is '}' with an int value of 125
	Unable to determine the current character, it is not a string, number, array, or object
	line number 1
	index number 8
	{"data":}
	........^
	groovy.json.JsonException: Unable to determine the current character, it is not a string, number, array, or object

	The current character read is '}' with an int value of 125
	Unable to determine the current character, it is not a string, number, array, or object
	line number 1
	index number 8
	{"data":}
	........^
		at org.apache.groovy.json.internal.JsonParserCharArray.decodeValueInternal(JsonParserCharArray.java:206)
		at org.apache.groovy.json.internal.JsonParserCharArray.decodeJsonObject(JsonParserCharArray.java:132)
		at org.apache.groovy.json.internal.JsonParserCharArray.decodeValueInternal(JsonParserCharArray.java:186)
		at org.apache.groovy.json.internal.JsonParserCharArray.decodeValue(JsonParserCharArray.java:157)


deploy
    --container_tag needed. 
    retag existing images if (needed and ! inuse)
    when CONTAINER_TAG is a 'git tag' (for something ?):
    	set default CONTAINER_TAG to tag
    	push images with tag=CONTAINER_TAG
    	set tag on current repo (if not exists)

jenkins
    k8s jobs
    clean workspace directory
    CleanDockerRegistry.jenkinsfile
	$ df
	df: /media/WDMyCloud: Stale file handle
	returns exit code 1


build.sh + deploy
    recognize parent on different branch

deploy:
    update of ${CONFIG_DIR}/docker-compose.yml should only update 'image:'
    recognize ">>>>> issue while executing 06.nagios <<<<<" 
    add docker-compose checking to deploy

    cyc@hopcyc-ballab1-1-00 ~/GIT/devops_container_environment (dev/ballab1/mres3291)
    $ ./deploy --clean
    ***ERROR at /home/cyc/GIT/devops_container_environment/libs/deploy.bashlib:95. 'grep -cs "$network"' exited with status 1
    >>>    Current directory /home/cyc/GIT/devops_container_environment
    Stack trace:
    >>>    01: /home/cyc/GIT/devops_container_environment/libs/deploy.bashlib:95 trap.catch_error  <<<
    >>>    02: /home/cyc/GIT/devops_container_environment/libs/deploy.bashlib:331 deploy.clean  <<<
    >>>    03: ./deploy:78 deploy.main  <<<
    $rm -rf /home/cyc/GIT/devops_container_environment/workspace.devops_container_environment
    $deploy.restart 2>&1 | tee restart.log
    INFO: updating /home/cyc/GIT/devops_container_environment/workspace.devops_container_environment/docker-compose.yml
    populating secrets

    the following also reported because of interference with CFG_USER_SECRETS=~/.inf
    ***ERROR: Password file: '.secrets/grafana_admin.pwd' not found. Used by startup of service: grafana
    ***ERROR: Password file: '.secrets/mysql_root.pwd' not found. Used by startup of service: mysql
    ***ERROR: Password file: '.secrets/mysql.pwd' not found. Used by startup of service: nagios
    >> GENERATING SSL CERT


add https://hub.docker.com/r/pihole/pihole to production
        fix hosts on nginx
change 'versions' to subtree for production

jenkins
    improve logging from 'Clean Docker Registry': show badge when reclaim shows > 0
    improve 'Check for Linux updates' to more clearly show list of updated packages
registry report
    - include packed sizes
usLib to save to mySQL
fix small pics on zen
error in uid_gid.validateUser when passed 2222:2222
change docker-registry-fe to delimit pagination using '?' rather than '/'

build_container:
    build dependencies
        - handled by Gradle: change build.sh to work inside each sub-repo. iter on OS in each repo (rather than repo for each OS) 

nginx index.html
nagios:
    nagios:  nohup: can't execute 'nagios.finishStartup': No such file
    add drive checking to nagios
    2 sources of truth:  mysql & NagiosCOnfig.tgz :: need to select one or other
    does not correctly spawn nagios.finishStartup.
        - /run/nagios.lock does not exists (should contain PID of primary nagios for supervisord)
        - var/rw/nagios.cmd has incorrect permissions (resrticts what nconf can do)
        docker-entrypoint.sh
            my.defaultInit
                crf.prepareEnvironment
                    ( command "$tmp_script" ) && status=$? || status=$?
                        cd "$WORKDIR"
                        source "$file"
                or sudo -E
                        crf.prepareEnvironment
                        ( command "$tmp_script" ) && status=$? || status=$?
                               cd "$WORKDIR"
                            source "$file"
    checkout https://github.com/harisekhon/nagios-plugins


get stuff working:
   reverse proxy for cesi
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
    complete unit tests

CBF:
    check if download file already exists (to allow use of Git-LFS)
    Track created users for runtime changes
    migrate to python
    use CBF_VERSION better
        - should never unset
        - should check if specified version same as installed version (no point in wget)

builds
    quality ladder:  dev -> staging -> master
        - deploy should set 'latest' (not build). (use registry API to get and work with available images)
        - dev:  where we make changes
        - staging: PRs from dev + CI builds
        - master: production
    fix promotions: quality ladder:  dev -> staging -> master
            - keep dev at 1 build
            - deploy should update 'latest' tag
    docker-registry
        - change to https
        - configure to use redis
             https://github.com/docker-library/redis/blob/e95c0cf4ffd9a52aa48d05b93fe3b42069c05032/5.0-rc/32bit/Dockerfile
    Separate build, package and deploy/run actions
        Fix up docker dependency script

enhancements:
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
        registryReport (summary):
                add amount of space used
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
2019-09-07
docker-utilities 
    multiple updates
    recognize filer on tags for 'docker-utilities images '*:*'
jenkins
    kafka logging from pipelines


2019-07-31
jenkins
    UpdateRepoDirs.jenkinsfile
	2 executors on master caused deadlock
	does not sync
		bobb@ubuntu-s4 ~/GIT/support/bin (dev)
		$ gl
		* 5e68f67 - (9 minutes ago) fixes to utilities - Ballantyne, Bob (origin/master, origin/HEAD, master)
		| * 2bf7d84 - (2 days ago) fixes to utilities - Ballantyne, Bob (HEAD -> dev, origin/dev)
		|/
		* b6d4941 - (6 days ago) fixes to utilities - Ballantyne, Bob
		* 37cd250 - (3 weeks ago) add submodule - Ballantyne, Bob
		* d79c65f - (3 weeks ago) first commit - Ballantyne, Bob


2019-07-13
    change cbf/bashlib to 
      - subtree for cbf
      - submodule for support
      - subtree for production
            git clone https://github.com/ballab1/container_build_framework
            cd container_build_framework/
#            git remote add -t master -f --no-tags bashlib ../bashlib
            git remote add -t master -f --no-tags bashlib https://github.com/ballab1/bashlib
            git fetch bashlib
            git rm -rf cbf/bashlib
            git commit -m 'remove bashlibs prior to adding subtree'
            git subtree add --squash --prefix=cbf/bashlib bashlib master
            git push
            git br -d dev
            git push origin -d dev
            git checkout -b dev
            git push origin -u dev
            git checkout master
or/
            git fetch bashlib
            git subtree merge --squash --prefix=cbf/bashlib bashlib master
            git push


2019-07-07
    provide 'updateDownload'
            - download file
            - calc sha256
            - upload file to artifactory
            - update action_folders/04.downloads/
    docker-search
     - include sizes
     - layers: include count
     - dependants: include count
       docker-dependents: show labels for images
    docker-registry
    : registry
    : deleteImage: when deleting a repo, 202 is shown, but none of images or tags shown
        - handle more tags to fingerprint lookup (ex: latest, master, staging)
        - move old named content to new repos
        - permit deleteion of content based on
                tag  (as in all tags which match ... in a repo)
                do not use 'master' but instead 'yyyymmdd-$(git-describe)' and update docker-compose
        scan and reduce all entries to max
        scan and remove fingerprints 'from' n-x repos unless tags > 1
        remove specific tag (needs testing)
        add more docker registry management
            - delete tag from multiple repos
            - squash repo when new version created
            - other repo reports (what needs squashing, tags in use/where, image sizes and space reuse)
            - deploy for 'git describe' container; finish deploy workflow
            - handle more tags to fingerprint lookup (ex: latest, master, staging)
            - move old named content to new repos
            - permit deletion of content based on
                    tag  (as in all tags which match ... in a repo)
                    do not use 'master' but instead 'yyyymmdd-$(git-describe)' and update docker-compose
    nagios:
        fcgiwrap: REMOTE_USER not found  - when initial page loads  (occurs because no user has logged int)
        nagios logs to supervisord.log
enhancements:
    setup elasticsearch


2019-06-16
        use confluent container in place of kafka (deprecate kafka)
        fix 'Space Recovered: -268 kb'
        nagiosgraph issues
        nagiosgraph does not display

2019-06-15
registryReport (summary):
        add time
        add amount of space used

2019-06-09
nginx:  05.applications/01.NGINX.installer
        create /usr/lib/nginx/modules.debug and /usr/lib/nginx/modules.non-debug
        create links for /usr/lib/nginx/modules, /etc/nginx/modules and /usr/sbin/nginx
        permit runtime config based on [ $NGINX_DEBUG -eq 1 ], also add "error_log /var/log/nginx_error.log debug;"  to nginx.conf


2019-05-26
change 'versions' to submodule for support
docker-dependants: change to annon associative arrays
add registry analysis to report
setup rsync for registry
nagios:
        DBI connect('database=nconf;host=mysql','bobb',...) failed: Can't connect to MySQL server on 'mysql' (115) at /usr/local/nagios/share/nconf/bin/lib/NConf/DB.pm line 103.
        Compilation failed in require at /usr/local/nagios/share/nconf/bin/generate_config.pl line 51.
        BEGIN failed--compilation aborted at /usr/local/nagios/share/nconf/bin/generate_config.pl line 51.
        ***ERROR at environment:9. '"${NCONF_HOME}/bin/generate_config.pl"' exited with status 115
        Stack trace:
        >>>    02: /usr/local/crf/startup/05.nagios:35 nagios.redeployConfig  <<<



add parent sha to labels
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
Phpmyadmin configuration
    resolve login issue where page is left blank
    fix phpmyAdmin issues (missing config)
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

bin/git-keep: add help
```
