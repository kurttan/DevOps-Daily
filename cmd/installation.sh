#!/bin/bash -e
##-------------------------------------------------------------------
## File : installation.sh
## Description :
## --
## Created : <2013-12-29>
## Updated: Time-stamp: <2014-03-26 22:19:59>
##-------------------------------------------------------------------
. utility.sh
function install_package ()
{
    log "install packages"
    # install epel repo
    # cd /tmp
    # wget http://mirror-fpt-telecom.fpt.net/fedora/epel/6/i386/epel-release-6-8.noarch.rpm
    # rpm -ivh epel-release-6-8.noarch.rpm

    yum_install git
    yum_install rabbitmq-server
    yum_install python
    yum_install python-devel
    yum_install python-pip

    pip_install pymongo
    pip_install flask
    pip_install jinja2

    # install mongo
    # cat >/etc/yum.repos.d/10gen.repo<<EOF
    # [10gen]
    # name=10gen Repository
    # baseurl=http://downloads-distro.mongodb.org/repo/redhat/os/x86_64
    # gpgcheck=0
    # EOF
    
    # sudo yum install -y mongo-10gen mongo-10gen-server
    # sudo service mongod start
    # sudo chkconfig mongod on 
}

function update_profile ()
{
    cfg_file="/etc/profile"
    log "update $cfg_file to configure global environments"
    update_cfg $cfg_file "PORT_GATEWAY" "8810"
    update_cfg $cfg_file "PROP_HOME" "$(dirname `pwd`)"
}

ensure_is_root
update_profile
install_package

(cd $PROP_HOME/code/gateway && make install)

## File : installation.sh ends