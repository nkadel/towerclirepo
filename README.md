towerclirepo
==========

Wrapper for SRPM building tools for ansible-tower-cli  on RHEL.

Building towercli
===============

Ideally, install "mock" and use that to build for both RHEL 6 and RHEL

* make cfgs # Create local .cfg configs for "mock".
* * centos-stream+epel-8-x86_64.cfg
* * centos-stream+epel-9-x86_64.cfg
* * centos-stream+epel-10-x86_64.cfg
# # towerclirepo-8-x86_64.cfg
# # towerclirepo-9-x86_64.cfg
# # towerclirepo-10-x86_64.cfg

* make repos # Creates local local yum repositories in $PWD/towerclirepo
* * towerclirepo/el/8
* * towerclirepo/el/9
* * towerclirepo/el/10

* make # Make all distinct versions using "mock"

Building a compoenent, without "mock" and in the local working system,
can also be done for testing.

* make build

Installing Towercli
=================

The relevant yum repository is built locally in towerclireepo. To enable the repository, use this:

* make repo

Then install the .repo file in /etc/yum.repos.d/ as directed. This
requires root privileges, which is why it's not automated.

Towercli RPM Build Security
===========================

There is a significant security risk with enabling yum repositories
for locally built components. Generating GPF signed packages and
ensuring that the compneents are in this build location are securely
and safely built is not addressed in this test setup.

		Nico Kadel-Garcia <nkadel@gmail.com>
