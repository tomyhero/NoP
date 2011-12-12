package NoP::Controller::Root;
use Ze::Class;
extends 'NoP::WAF::Controller';
use NoP::ObjectDriver::DBI;
use NoP::Cache;

sub index {
    my ($self,$c) = @_;

    eval {
        my $dbh = NoP::ObjectDriver::DBI->driver->rw_handle;
        $c->stash->{ok_db} = $dbh->ping;
    };
    if($@){
        $c->stash->{ok_db} = 0;
    }


    my $cache =  NoP::Cache->instance();

    my $time = time;
    $cache->set($time,'ok');
    $c->stash->{ok_cache} = $cache->get($time);

}

EOC;
