#
# Makefile - build wrapper for towercli on CentPOS 7
#
#	git clone RHEL 7 SRPM building tools from
#	https://github.com/nkadel/[package] into designated
#	TOWERCLIPKGS below
#
#	Set up local 

# Rely on local nginx service poingint to file://$(PWD)/towerclirepo
#REPOBASE = http://localhost
REPOBASE = file://$(PWD)

# Buildable with only EPEL
EPELPKGS+=python-click-srpm
# Installation requires click
EPELPKGS+=ansible-tower-cli-srpm

#TOWERCLIPKGS+=python-mock-srpm

REPOS+=towerclirepo/el/10
REPOS+=towerclirepo/el/9
REPOS+=towerclirepo/el/9

REPODIRS := $(patsubst %,%/x86_64/repodata,$(REPOS)) $(patsubst %,%/SRPMS/repodata,$(REPOS))

# No local dependencies at build time
CFGS+=towerclirepo-8-x86_64.cfg
CFGS+=towerclirepo-9-x86_64.cfg
CFGS+=towerclirepo-10-x86_64.cfg

# Link from /etc/mock
MOCKCFGS+=centos-stream+epel-8-x86_64.cfg
MOCKCFGS+=centos-stream+epel-9-x86_64.cfg
MOCKCFGS+=centos-stream+epel-10-x86_64.cfg

all:: install
install:: $(CFGS) $(MOCKCFGS)
install:: $(REPODIRS)
install:: $(EPELPKGS)
install:: $(TOWERCLIPKGS)

build install clean getsrc build:: FORCE
	@for name in $(EPELPKGS) $(TOWERCLIPKGS); do \
	     (cd $$name; $(MAKE) $(MFLAGS) $@); \
	done  

# It is sometimes useful to build up all the more independent EPEL packages first
epel:: $(EPELPKGS)

# Dependencies for order sensitivity
#python-towercli-srpm::
#
#python-botocore-srpm:: python-jmespath-srpm
#
#python-linecache2-srpm:: python-fixtures-srpm
#python-linecache2-srpm:: python-unittest2-srpm

# Actually build in directories
$(EPELPKGS):: FORCE
	(cd $@; $(MAKE) $(MLAGS) install)

$(TOWERCLIPKGS):: FORCE
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

towerclirepo-8-x86_64.cfg: /etc/mock/centos-stream+epel-8-x86_64.cfg
	@echo Generating $@ from $?
	@echo "include('$?')" > $@
	@echo "config_opts['root'] = 'towerclirepo-{{ releasever }}-{{ target_arch }}'" | tee -a $@
	@echo "config_opts['dnf.conf'] += \"\"\"" | tee -a $@
	@echo '[towerclirepo]' | tee -a $@
	@echo 'name=towerclirepo' | tee -a $@
	@echo 'enabled=1' | tee -a $@
	@echo 'baseurl=$(REPOBASE)/towerclirepo/el/8/x86_64/' | tee -a $@
	@echo 'failovermethod=priority' | tee -a $@
	@echo 'skip_if_unavailable=False' | tee -a $@
	@echo 'metadata_expire=1' | tee -a $@
	@echo 'gpgcheck=0' | tee -a $@
	@echo '#cost=2000' | tee -a $@
	@echo '"""' | tee -a $@

towerclirepo-9-x86_64.cfg: /etc/mock/centos-stream+epel-9-x86_64.cfg
	@echo Generating $@ from $?
	@echo "include('$?')" > $@
	@echo "config_opts['root'] = 'towerclirepo-{{ releasever }}-{{ target_arch }}'" | tee -a $@
	@echo "config_opts['dnf.conf'] += \"\"\"" | tee -a $@
	@echo '[towerclirepo]' | tee -a $@
	@echo 'name=towerclirepo' | tee -a $@
	@echo 'enabled=1' | tee -a $@
	@echo 'baseurl=$(REPOBASE)/towerclirepo/el/9/x86_64/' | tee -a $@
	@echo 'failovermethod=priority' | tee -a $@
	@echo 'skip_if_unavailable=False' | tee -a $@
	@echo 'metadata_expire=1' | tee -a $@
	@echo 'gpgcheck=0' | tee -a $@
	@echo '#cost=2000' | tee -a $@
	@echo '"""' | tee -a $@

towerclirepo-10-x86_64.cfg: /etc/mock/centos-stream+epel-10-x86_64.cfg
	@echo Generating $@ from $?
	@echo "include('$?')" > $@
	@echo "config_opts['root'] = 'towerclirepo-{{ releasever }}-{{ target_arch }}'" | tee -a $@
	@echo "config_opts['dnf.conf'] += \"\"\"" | tee -a $@
	@echo '[towerclirepo]' | tee -a $@
	@echo 'name=towerclirepo' | tee -a $@
	@echo 'enabled=1' | tee -a $@
	@echo 'baseurl=$(REPOBASE)/towerclirepo/el/10/x86_64/' | tee -a $@
	@echo 'failovermethod=priority' | tee -a $@
	@echo 'skip_if_unavailable=False' | tee -a $@
	@echo 'metadata_expire=1' | tee -a $@
	@echo 'gpgcheck=0' | tee -a $@
	@echo '#cost=2000' | tee -a $@
	@echo '"""' | tee -a $@

repo: towerclirepo.repo
towerclirepo.repo:: Makefile towerclirepo.repo.in
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

towerclirepo.repo:: FORCE
	cmp -s /etc/yum.repos.d/$@ $@       

nginx:: nginx/default.d/towerclirepo.conf

nginx/default.d/towerclirepo.conf:: FORCE nginx/default.d/towerclirepo.conf.in
	cat $@.in | \
		sed "s|@REPOBASEDIR@;|$(PWD)/;|g" | tee $@;

nginx/default.d/towerclirepo.conf:: FORCE
	cmp -s $@ /etc/$@ || \
	    diff -u $@ /etc/$@

clean::
	find . -name \*~ -exec rm -f {} \;
	rm -f *.cfg
	rm -f *.out
	rm -f nginx/default.d/*.conf
	@for name in $(TOWERCLIPKGS); do \
	    $(MAKE) -C $$name clean; \
	done

distclean:
	rm -rf $(REPOS)

maintainer-clean:
	rm -rf $(TOWERCLIPKGS)

FORCE::
