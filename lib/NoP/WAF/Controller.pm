package NoP::WAF::Controller;
use Ze::Class;
use Try::Tiny;
extends 'Ze::WAF::Controller';

sub EXCECUTE {
    my( $self, $c, $action ) = @_;

    try {
        $self->$action( $c );
    }
    catch {
        if( ref $_ && ref $_ eq 'NoP::Validator::Error') {

            if($c->view_type && $c->view_type eq 'JSON') {
                $c->set_json_error($_);
            }
            else {
                $c->stash->{fdat} = $_->valid;
                $c->stash->{error_obj} = $_;
            }
        }
        else {
            die $_; 
        }
    };

    return 1;
}


EOC;
