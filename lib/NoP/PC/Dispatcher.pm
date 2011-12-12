package NoP::PC::Dispatcher;
use Ze::Class;
extends 'Ze::WAF::Dispatcher::Router';

sub _build_config_file {
    my $self = shift;
    $self->home->file('etc/router-pc.pl');
}

EOC;
