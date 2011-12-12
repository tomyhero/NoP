package NoP::ObjectDriver::Cache;
use warnings;
use strict;
use NoP::Cache;
use NoP::ObjectDriver::DBI;
use Data::ObjectDriver::Driver::Cache::Memcached;

sub driver {
    Data::ObjectDriver::Driver::Cache::Memcached->new(
        cache => NoP::Cache->instance(),
        fallback =>  NoP::ObjectDriver::DBI->driver,
    );
}

1;

