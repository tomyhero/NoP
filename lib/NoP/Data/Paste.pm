package NoP::Data::Paste;
use strict;
use warnings;
use base qw(NoP::Data::Base);
use NoP::ObjectDriver::Cache;

__PACKAGE__->install_properties({
    columns => [qw(code body created_at)],
    datasource => 'paste',
    primary_key => 'code',
    driver => NoP::ObjectDriver::Cache->driver,
});


1;
