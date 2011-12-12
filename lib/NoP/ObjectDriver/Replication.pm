package NoP::ObjectDriver::Replication;
use strict;
use warnings;

use base qw( Data::ObjectDriver::Driver::DBI );
__PACKAGE__->mk_accessors(qw(dbh_slave get_dbh_slave));

sub init {
    my $driver = shift;
    my %param = @_;
    if (my $get_dbh_slave = delete $param{get_dbh_slave}) {
        $driver->get_dbh_slave($get_dbh_slave);
    }
    $driver->SUPER::init(%param);
    return $driver;
}

sub r_handle {
    my $driver = shift;
    my $db = shift || 'main';

    $driver->dbh_slave(undef) if $driver->dbh_slave and !$driver->dbh_slave->ping;
    my $dbh_slave = $driver->dbh_slave;
    unless ($dbh_slave) {
        if (my $getter = $driver->get_dbh_slave) {
            $dbh_slave = $getter->();
            return $dbh_slave if $dbh_slave;
        }
    }
    $driver->rw_handle($db);
}


1;
