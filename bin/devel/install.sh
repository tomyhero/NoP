#!/bin/sh

install_ext() {
    if [ -e ~/work/$2 ]
    then
        cd ~/work/$2
        git pull
        cpanm --mirror ftp://ftp.kddilabs.jp/CPAN/ .
    else
        git clone $1 ~/work/$2
        cd ~/work/$2
        cpanm --mirror ftp://ftp.kddilabs.jp/CPAN/ .
    fi
}

cpanm --mirror ftp://ftp.kddilabs.jp/CPAN/ Module::Install
cpanm --mirror ftp://ftp.kddilabs.jp/CPAN/ Module::Install::Repository

install_ext git://github.com/tomyhero/p5-App-Home.git p5-App-Home
install_ext git://github.com/tomyhero/Ze.git Ze
install_ext git://github.com/tomyhero/p5-Aplon.git p5-Aplon
install_ext git://github.com/kazeburo/Cache-Memcached-IronPlate.git Cache-Memcached-IronPlate
install_ext git://github.com/onishi/perl5-devel-kytprof.git Devel-KYTProf



cpanm --mirror ftp://ftp.kddilabs.jp/CPAN/ --installdeps .
