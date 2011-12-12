use strict;
use FindBin::libs;

use Plack::Builder;
use NoP::PC;
use NoP::Home;
use NoP::Validator;
use NoP::Config;


NoP::Validator->instance(); # compile
my $home = NoP::Home->get;

my $webapp = NoP::PC->new;

my $app = $webapp->to_app;

my $config = NoP::Config->instance();
my $middlewares = $config->get('middleware') || {};

if($middlewares){
    $middlewares = $middlewares->{pc} || [];
}


builder {
    enable 'Plack::Middleware::Static',
        path => sub { s!^/static/!! }, 
        root => $home->file('htdocs')
    ;

    enable_if { $_[0]->{REMOTE_ADDR} eq '127.0.0.1' } 
    "Plack::Middleware::ReverseProxy";

    for(@$middlewares){
        if($_->{opts}){
            enable $_->{name},%{$_->{opts}};
        }
        else {
            enable $_->{name};
        }
    }

    $app;
};

