package NoP::WAF::Context;
use Ze::Class;
extends 'Ze::WAF::Context';
use NoP::Session;
use Module::Pluggable::Object;

has 'member_obj' => ( is => 'rw' );

sub create_session {
    my $c = shift;
    NoP::Session->create( $c->req,$c->res);
}

my $MODELS ;
BEGIN {
    # PRE LOAD API
    $MODELS = {}; 
    my $finder = Module::Pluggable::Object->new(
        search_path => ['NoP::Model'],
        except => qr/^(NoP::Model::Base$|NoP::Model::Role::)/, 
        'require' => 1,
    );
    my @classes = $finder->plugins;

    for my $class (@classes) {
        (my $moniker = $class) =~ s/^NoP::Model:://;
        $MODELS->{$moniker} = $class;
    }
}

sub model {
    my $c =  shift;
    my $moniker= shift;
    my $args   = shift || {};
    return $MODELS->{$moniker}->new( $args );
}

sub not_found {
    my $c = shift;
    $c->res->status( 404 );
    $c->template('404');
    $c->res->content_type( 'text/html;charset=utf-8' );
    $c->RENDER();
    $c->finished(1);
}



EOC;
