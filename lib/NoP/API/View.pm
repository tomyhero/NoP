package NoP::API::View;
use Ze::Class;
extends 'Ze::WAF::View';
use Ze::View;

sub _build_engine {
    my $self = shift;

    return Ze::View->new(
        engines => [
            { engine => 'Ze::View::JSON', config  => {} } 
        ]
    );

}


EOC;
