package NoP::ObjectDriver::DBI;
use strict;
use warnings;
use base qw(NoP::ObjectDriver::Replication);
use Ze;
use DBI;
use List::Util;
use NoP::Config;

sub _get_dbh_master {
    if( $Ze::GLOBAL->{dbh} &&  $Ze::GLOBAL->{dbh}{master} && $Ze::GLOBAL->{dbh}{master}->ping){
        return $Ze::GLOBAL->{dbh}{master};
    }
    else {
        my $config = NoP::Config->instance()->get('database')->{master};
        my $dbh = DBI->connect( $config->{dsn},$config->{username},$config->{password} ,
                           {
                               RaiseError => 1,
                               PrintError => 1,
                               AutoCommit => 1,
                               mysql_enable_utf8 => 1,
                               mysql_connect_timeout=>4,
                           }) or die $DBI::errstr;

        $Ze::GLOBAL->{dbh}{master} = $dbh;
        return $dbh;
    }
}

sub _get_dbh_slave {
    my $config = NoP::Config->instance()->get('database')->{slaves};
    my @slaves = List::Util::shuffle @{$config};
    for my $slave (@slaves) {
        if( $Ze::GLOBAL->{dbh} &&  $Ze::GLOBAL->{dbh}{slave} && $Ze::GLOBAL->{dbh}{slave}->ping){
            return  $Ze::GLOBAL->{dbh}{slave}; 
        }
        else {
            my $dbh = eval { DBI->connect($slave->{dsn},$slave->{username},$slave->{password},
                                      {
                                          RaiseError => 1,
                                          PrintError => 1,
                                          AutoCommit => 1,
                                          mysql_enable_utf8 => 1,
                                          mysql_connect_timeout=>4,
                                          on_connect_do => [
#                                              "SET NAMES 'utf8'",
                                              "SET CHARACTER SET 'utf8'"
                                          ],
                                      }) or die $DBI::errstr;
                     };
            if ($@ || !$dbh) {
                warn $@;
                next;
            }
            $Ze::GLOBAL->{dbh}{slave} = $dbh;
            return $dbh;
        }
    }
    warn "fail connect all slaves. try connect to master";
    return _get_dbh_master();
}

sub driver {
    my $class = shift;
    $class->new(
        get_dbh => \&_get_dbh_master,
        get_dbh_slave => \&_get_dbh_slave,
    );
}

1;

