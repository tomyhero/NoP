package NoP::Session;
use strict;
use warnings;
use HTTP::Session;
use HTTP::Session::State::Cookie;
use NoP::Cache::Session;
use NoP::Config;



BEGIN {
    no warnings;
    use HTTP::Session::Store::Memcached;
    *HTTP::Session::Store::Memcached::new = sub {
        my $class = shift;
        my %args = ref($_[0]) ? %{$_[0]} : @_;
        # check required parameters
        for (qw/memd/) {
            Carp::croak "missing parameter $_" unless $args{$_};
        }

    # XXX : skiped..
    #
    #    unless (ref $args{memd} && index(ref($args{memd}), 'Memcached') >= 0) {
    #        Carp::croak "memd requires instance of Cache::Memcached::Fast or Cache::Memcached";
    #    }

        bless {%args}, $class;
    };
}


sub create {
    my $class = shift;
    my $req = shift;
    my $res = shift;
    my $cookie_config =  NoP::Config->instance()->get('cookie_session');

    my $session = HTTP::Session->new(
        store => HTTP::Session::Store::Memcached->new( memd =>  NoP::Cache::Session->instance ),
        state => HTTP::Session::State::Cookie->new( name => $cookie_config->{namespace} ),
        request => $req,
    );


    # http headerをセットしてる程度なのでとりあえずここでもおk
    $session->response_filter($res);
    return $session;
}

1;
