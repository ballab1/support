TODO
```

docker-utilities
	in docker.clean, add
		scan volumes
		check /var/lib/docker/containers are same as running, and remove


docker-search.py
        need to handle docker volumes

	Executing container kafka-eagle
	Container Name:  kafka-eagle
		    ID:  c71547e3b4a21474355e81222de248578d9294ba3268c2fa66c69d3940fa602b
		 Image:  sha256:3c68324bd3331a4625b41bf56fd87263e5f3d4ce86a2d916b9f3b5b10faee896
	      Image ID:  sha256:3c68324bd3331a4625b41bf56fd87263e5f3d4ce86a2d916b9f3b5b10faee896
		Status:  running: Up 3 hours
	       Network:  devops-container-net
	    IP Address:  172.23.0.9/16


	Image details for
		 Image:  sha256:3c68324bd3331a4625b41bf56fd87263e5f3d4ce86a2d916b9f3b5b10faee896
	object of type 'NoneType' has no len()
	Traceback (most recent call last):
	  File "/home/cyc/bin/docker-search.py", line 851, in main
	    images.show()
	  File "/home/cyc/bin/docker-search.py", line 506, in show
	    Display.imageInfo(image, image.id)
	  File "/home/cyc/bin/docker-search.py", line 203, in imageInfo
	    Display.basicImageInfo(image, refid)
	  File "/home/cyc/bin/docker-search.py", line 151, in basicImageInfo
	    if len(image.repo_tags) > 1:
	TypeError: object of type 'NoneType' has no len()




cbf
    remove all function exports. move to where/when needed

nagios
    checkout https://github.com/harisekhon/nagios-plugins
    curate 'archives/nagios-*.log' and 'config/NagiosConfig.tgz.*' and 'config/NagiosConfig.ERROR.tgz.*'
                - ./nagios/archives:/var/nagios/archives
                - ./nagios/config:/var/www/nconf/output  
    nconf/include/ajax/exec_generate_config.php contains 'tar -r' to refresh NagiosConfig.tgz with startic files : Alpine does not support 'tar -r'

jenkins
     add kafka loging of Linux updates
    k8s jobs
    (on nginx):
         need to examine/tune Garbage collection
                 https://www.slideshare.net/TidharKleinOrbach/why-does-my-jenkins-freeze-sometimes-and-what-can-i-do-about-it
                 http://engineering.taboola.com/5-simple-tips-boosting-jenkins-performance/
                 https://www.cloudbees.com/blog/joining-big-leagues-tuning-jenkins-gc-responsiveness-and-stability
                 https://jenkins.io/blog/2016/11/21/gc-tuning/
                 analyze GC logs with tools such as http://gceasy.io/
         2018/01/01 16:29:15 [error] 6#6: *9 connect() failed (111: Connection refused) while connecting to upstream, client: 10.1.3.24, server: default, request: "POST /jenkins/ajaxBuildQueue HTTP/1.1", upstream: "http://172.18.0.5:8080/jenkins/ajaxBuildQueue", host: "10.1.3.6", referrer: "https://10.1.3.6/jenkins/"
         2018/01/01 16:29:15 [error] 6#6: *10 connect() failed (111: Connection refused) while connecting to upstream, client: 10.1.3.24, server: default, request: "POST /jenkins/ajaxExecutors HTTP/1.1", upstream: "http://172.18.0.5:8080/jenkins/ajaxExecutors", host: "10.1.3.6", referrer: "https://10.1.3.6/jenkins/" 
     It appears that your reverse proxy set up is broken.
     complete unit tests


usLib to save to mySQL
change docker-registry-fe to delimit pagination using '?' rather than '/'

build_container:
    build dependencies
        - handled by Gradle: change build.sh to work inside each sub-repo. iter on OS in each repo (rather than repo for each OS) 
    change '/usr/local/bin' to subtree


    k8s :
        dns
      	    codedns : restarts, resolve ubuntu.home
    	ingress
    	authentication
    	    rbac
    	jenkins
    openvpn
    	“MAN-IN-THE-MIDDLE” ATTACK IF CLIENTS DO NOT VERIFY THE CERTIFICATE OF THE SERVER THEY ARE CONNECTING TO.  https://openvpn.net/community-resources/how-to/#mitm
    	
+
    kafka (and remove debug from logs)
      pipeline to refresh (stop/start zookeepers in order, then brokers)
      kafkacat
      kafkatool
      need better config tool
      kafka to mysql uService
    gradle build
    convert container build to gradle
    resync configs across all ubuntu (docker-compose, apt(packages), docker(daemon.json), fstab(synology)
    nagios pnp4nagios & php7
       https://github.com/Bonsaif/new-nconf
    migrate mysql to miriadb
    multi-pr
    ELK monitoring
      nginx_status
      on other systems
    jasc

    graphql
    jasc
    docker-registry-frontend : change 'user:repo' paradigm to 'folder:subfolder:subfolder:..' paradigm
    determine why we do not have kafka metrics
    build using kaniko  (https://www.thenativeweb.io/blog/2018-08-14-11-32-kubernetes-building-docker-images-within-a-cluster/ 
                         https://console.cloud.google.com/gcr/images/kaniko-project/GLOBAL/executor?pli=1&gcrImageListsize=30)
            or 
#    microservices from kafka to DBMS
#      (us-lib)
    k8s
    reverse proxy for cesi & photoprism & & registry-fe & wdmycloud et al.
    scan fileshare (NFS issues :  negotiated dialect[SMB3_11] against server[10.1.3.5])
      - 
    cloud-init: ssh keys
      - need further broad investigation
    MAAS
    DNS  (pihole or dnsmasq or Synology)
    hubot
#    CBF: mod 99.logs.sh for webdav/deploy startup & update bashlibs
    photoprism.bashlib (to provide scriptable interface to setup photoprism)
    implement extensible traps in BASH


CBF:
    Track created users for runtime changes
    migrate to python
    use CBF_VERSION better
        - should never unset
        - should check if specified version same as installed version (no point in wget)
    error in uid_gid.validateUser when passed 2222:2222


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
        registryReport (summary):
                add amount of space used  (use ` ssh ubuntu-s2 df /dev/sdb1 | tail -1 | awk '{print $5 " used, " $3/1024/1024 " GB  available"}'`)
    PHP
        create/use base containers for 'nginx+php5+fpm'/'nginx+php7+fpm': use port for PHP
        provide build options
            Add getcomposer (for debugging PHP) to php5
            Add getcomposer (for debugging PHP) to php7
        move PHP to port 9000 so we can move it out of nginx
    nginx
        funnel access of other servers through nginx
        improve extensibility
            change usage from conf.d to sites_enabled
            use docker events to detect changes
                restart nginx on any change
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
        implement jasc


future development  
    create container which has a firewall
    create a GIT-LFS->raw_fs server for testing
```

Done
=============================================================
```
5/13/21
deploy
	save to & restore from a tarfile


4/13/2021
CBF:
    check if download file already exists (to allow use of Git-LFS)
jenkins
    improve logging from 'Clean Docker Registry': show badge when reclaim shows > 0
PHP
    Nagios/nconf with php7
    

12/17/2020
    add elk monitoring on other systems
    jenkins
	parseUptime:
		regex:  ^\s*(\S{8})\s+up\s+([^u]+),\s+(\d+){0,1}(?:\susers{0,1},\s+){0,1}load\s+average:\s(\S+),\s+(\S+),\s+(\S+)
		only matches:	19:27:11 up  8:20,  0 users,  load average: 0.00, 0.01, 0.00
				02:50:06 up 7 days, 18:37,  0 users,  load average: 0.52, 0.72, 0.76
				02:50:08 up  0 days, 0:0:0,   load average: 0.55, 0.30, 0.26
		does not match:	19:27:10 up  0 days, 0:0:0,  0.29, 0.34
			  (from master after a reboot)
		problem is with 'realUptime' script


10/23/2020
    improve 'Check for Linux updates' to more clearly show list of updated packages
    jenkins:
	- compare zip files on ubuntu and check for diff. If there is a diff, rename  with date, and delete oldest when there are more than 10 (use for ecipies and configs)
	- backup NagiosConfig
    ELK monitoring
      nginx_status
    add elk monitoring on other systems
    nagios
        add drive checking to nagios


10/16/2020
    nagios pnp4nagios & php7
       https://github.com/Bonsaif/new-nconf
        nagios startup & nagiosgraph polling


9/24/2020
    redo certificates
    deploy
        line 904 failes with '$${data.host}:$${data.port}'
        create deploy function for

    fix checkForLinuxUpdates.sh
    	dpkg --get-selections | grep -e 'linux.*-4'
    kafkacat


9/11/2020
        grafana
        nginx is in debug mode
        all docker-compose refer to 10.1.3.1
        kafka issues
        jenkins startup
	ubuntu-s3 : ubuntu-5 : ubuntu-6
            sudo hostnamectl set-hostname s3.ubuntu.home
	pip missing
	    curl https://bootstrap.pypa.io/get-pip.py -o get-pip.py
	    python get-pip.py
	pyyaml==5.3.1  missing
	    python -c "import yaml; print(yaml.__version__)"
              curl https://bootstrap.pypa.io/get-pip.py -o get-pip.py;  python get-pip.py; rm get-pip.py;pip install pyyaml==5.3.1;python -c "import yaml; print(yaml.__version__)"
        change bobb from bobb:bobb to bobb:users


8/8/2020
    graph of %disk space on each server
    nagios
    jira-event-client
    gradle coverage
    unit-tests for bash and Jenkins
    python script to fix nas filenames to unicode
    analyze calc checksums - remove dups
    migration to alpine:3.12.0


3/21/2020
    nagios
        change nagiosgraph to pnp4nagios
        2 sources of truth:  mysql & NagiosCOnfig.tgz :: need to select one or other
        configuration: load DBMS from config files
    nagios:  nohup: can't execute 'nagios.finishStartup': No such file
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


2/3/2020
    multi-pr
    elk-stack
      nginx_status
      on other systems
    jasc
    k8s
    	authentication
    	codedns : restarts, resolve ubuntu.home
    	ingress
    	rbac
    	jenkins
    nagios startup & nagiosgraph polling
    other from 12/19/19


2/8/2020
    confluent
	changes to fix clustering issues
    webdav
        currently provides read/write access : no restrictions


1/1/2020
    cesi (supervisord monitor)
    add https://hub.docker.com/r/pihole/pihole to production
        fix hosts on nginx


12/19/19
    multi-pr
    elk-stack
      nginx_status


11/29/2019
nginx
    improve extensibility
jenkins
    clean workspace directory
    	implement in pipline post{}
deploy
    change to deploy.yml
zen
    get admin working

11/9/2019
builds
    recognize parent on different branch
	    prompt to pull dependant images and retag
    add user/settings credential support

11/2/2019
deploy
    add user/settings credential support
    regression: CONTAINER_TAG always honored, may have other side effects
    bugtrace:
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
    update of ${CONFIG_DIR}/docker-compose.yml should only update 'image:'
docker-utilities
    registory curation
    add user/settings credential support
    need more help info in context help
    bugtrace:
	$ docker-utilities deleteTag 'devops/.*:dev-ballab1-f4072' -u svc_cyclonebuild -c $__SETTINGS_FILE
	delete specific tag from afeoscyc-mw.cec.lab.emc.com/ : devops/.*:dev-ballab1-f4072
	retrieving digests for devops/.*
	***ERROR: failure to complete registry request
	    command:       curl --insecure --request GET --silent https://afeoscyc-mw.cec.lab.emc.com/artifactory/api/docker/cyclone-dockerv2-local/v2/devops/.*/tags/list
	    error code:    "NAME_UNKNOWN"
	    error message: "Repository name not known to registry."
	    error details: {
	  "name": "devops/.*"
	}
	    http_code:     404 Not Found
	    Failed to get https://afeoscyc-mw.cec.lab.emc.com/artifactory/api/docker/cyclone-dockerv2-local/v2/devops/.*/tags/list

	***ERROR: repository: devops/.* - does not exist


2019-10-04
finish nginx front end
docker-utilities
    deletetag --allrepos fails when a tag does not exist in a nrepo
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


2019-10-02
nginx index.html
nagios
    change nagiosgraph to pnp4nagios
    reconfigue nagios:
    	remove lock on startup (backgound process)
	restart process after NCONF deploys new config

2019-09-07
docker-utilities 
    multiple updates
    recognize filer on tags for 'docker-utilities images '*:*'
jenkins
    kafka logging from pipelines
deploy
    --container_tag needed. 
fix small pics on zen


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
            git subtree merge --squash --prefix=cbf/bashlib bashlib/master
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
