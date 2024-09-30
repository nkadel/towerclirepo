#
# Makefile - build wrapper for awxkit on CentPOS 7
#
#	git clone RHEL 7 SRPM building tools from
#	https://github.com/nkadel/[package] into designated
#	AWXKITPKGS below
#
#	Set up local 

# Rely on local nginx service poingint to file://$(PWD)/awxkitrepo
#REPOBASE = http://localhost
REPOBASE = file://$(PWD)

# Buildable with only EPEL
EPELPKGS+=python-jq-srpm
EPELPKGS+=python-websocket-client-srpm

AWXKITPKGS+=awxkit-srpm

REPOS+=awxkitrepo/el/10
REPOS+=awxkitrepo/el/9
REPOS+=awxkitrepo/el/8

REPODIRS := $(patsubst %,%/x86_64/repodata,$(REPOS)) $(patsubst %,%/SRPMS/repodata,$(REPOS))

# No local dependencies at build time
CFGS+=awxkitrepo-8-x86_64.cfg
CFGS+=awxkitrepo-9-x86_64.cfg
CFGS+=awxkitrepo-10-x86_64.cfg

# Link from /etc/mock
MOCKCFGS+=centos-stream+epel-8-x86_64.cfg
MOCKCFGS+=centos-stream+epel-9-x86_64.cfg
MOCKCFGS+=centos-stream+epel-10-x86_64.cfg

all:: install
install:: $(CFGS) $(MOCKCFGS)
install:: $(REPODIRS)
install:: $(EPELPKGS)
install:: $(AWXCKITPKGS)

build install clean getsrc build:: FORCE
	@for name in $(EPELPKGS) $(AWXKITPKGS); do \
	     (cd $$name; $(MAKE) $(MFLAGS) $@); \
	done  

# It is sometimes useful to build up all the more independent EPEL packages first
epel:: $(EPELPKGS)

# Actually build in directories
$(EPELPKGS):: FORCE
	(cd $@; $(MAKE) $(MLAGS) install)

$(AWXKITPKGS):: FORCE
	(cd $@; $(MAKE) $(MLAGS) install)

repos: $(REPOS) $(REPODIRS)
$(REPOS):
	install -d -m 755 $@

.PHONY: $(REPODIRS)
$(REPODIRS): $(REPOS)
	@install -d -m 755 `dirname $@`
	/usr/bin/createrepo_c `dirname $@`

.PHONY: cfg cfgs
cfg cfgs:: $(CFGS) $(MOCKCFGS)

$(MOCKCFGS)::
	@echo Generating $@ from /etc/mock/$@
	@echo "include('/etc/mock/$@')" | tee $@

awxkitrepo-8-x86_64.cfg: /etc/mock/centos-stream+epel-8-x86_64.cfg
	@echo Generating $@ from $?
	@echo "include('$?')" > $@
	@echo "config_opts['root'] = 'awxkitrepo-{{ releasever }}-{{ target_arch }}'" | tee -a $@
	@echo "config_opts['dnf.conf'] += \"\"\"" | tee -a $@
	@echo '[awxkitrepo]' | tee -a $@
	@echo 'name=awxkitrepo' | tee -a $@
	@echo 'enabled=1' | tee -a $@
	@echo 'baseurl=$(REPOBASE)/awxkitrepo/el/8/x86_64/' | tee -a $@
	@echo 'failovermethod=priority' | tee -a $@
	@echo 'skip_if_unavailable=False' | tee -a $@
	@echo 'metadata_expire=1' | tee -a $@
	@echo 'gpgcheck=0' | tee -a $@
	@echo '#cost=2000' | tee -a $@
	@echo '"""' | tee -a $@

awxkitrepo-9-x86_64.cfg: /etc/mock/centos-stream+epel-9-x86_64.cfg
	@echo Generating $@ from $?
	@echo "include('$?')" > $@
	@echo "config_opts['root'] = 'awxkitrepo-{{ releasever }}-{{ target_arch }}'" | tee -a $@
	@echo "config_opts['dnf.conf'] += \"\"\"" | tee -a $@
	@echo '[awxkitrepo]' | tee -a $@
	@echo 'name=awxkitrepo' | tee -a $@
	@echo 'enabled=1' | tee -a $@
	@echo 'baseurl=$(REPOBASE)/awxkitrepo/el/9/x86_64/' | tee -a $@
	@echo 'failovermethod=priority' | tee -a $@
	@echo 'skip_if_unavailable=False' | tee -a $@
	@echo 'metadata_expire=1' | tee -a $@
	@echo 'gpgcheck=0' | tee -a $@
	@echo '#cost=2000' | tee -a $@
	@echo '"""' | tee -a $@

awxkitrepo-10-x86_64.cfg: /etc/mock/centos-stream+epel-10-x86_64.cfg
	@echo Generating $@ from $?
	@echo "include('$?')" > $@
	@echo "config_opts['root'] = 'awxkitrepo-{{ releasever }}-{{ target_arch }}'" | tee -a $@
	@echo "config_opts['dnf.conf'] += \"\"\"" | tee -a $@
	@echo '[awxkitrepo]' | tee -a $@
	@echo 'name=awxkitrepo' | tee -a $@
	@echo 'enabled=1' | tee -a $@
	@echo 'baseurl=$(REPOBASE)/awxkitrepo/el/10/x86_64/' | tee -a $@
	@echo 'failovermethod=priority' | tee -a $@
	@echo 'skip_if_unavailable=False' | tee -a $@
	@echo 'metadata_expire=1' | tee -a $@
	@echo 'gpgcheck=0' | tee -a $@
	@echo '#cost=2000' | tee -a $@
	@echo '"""' | tee -a $@

repo: awxkitrepo.repo
awxkitrepo.repo:: Makefile awxkitrepo.repo.in
	if [ -s /etc/fedora-release ]; then \
		cat $@.in | \
			sed "s|@REPOBASEDIR@/|$(PWD)/|g" | \
			sed "s|/@RELEASEDIR@/|/fedora/|g" > $@; \
	elif [ -s /etc/redhat-release ]; then \
		cat $@.in | \
			sed "s|@REPOBASEDIR@/|$(PWD)/|g" | \
			sed "s|/@RELEASEDIR@/|/el/|g" > $@; \
	else \
		echo Error: unknown release, check /etc/*-release; \
		exit 1; \
	fi

awxkitrepo.repo:: FORCE
	cmp -s /etc/yum.repos.d/$@ $@       

nginx:: nginx/default.d/awxkitrepo.conf

nginx/default.d/awxkitrepo.conf:: FORCE nginx/default.d/awxkitrepo.conf.in
	cat $@.in | \
		sed "s|@REPOBASEDIR@;|$(PWD)/;|g" | tee $@;

nginx/default.d/awxkitrepo.conf:: FORCE
	cmp -s $@ /etc/$@ || \
	    diff -u $@ /etc/$@

clean::
	find . -name \*~ -exec rm -f {} \;
	rm -f *.cfg
	rm -f *.out
	rm -f nginx/default.d/*.conf
	@for name in $(AWXKITPKGS); do \
	    $(MAKE) -C $$name clean; \
	done

distclean:
	rm -rf $(REPOS)

maintainer-clean:
	rm -rf $(AWXKITPKGS)

FORCE::
