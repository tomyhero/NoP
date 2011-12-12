package NoP::Authorizer::Member;
use Ze::Class;
extends 'NoP::Authorizer::Base';
use NoP::Session;
use NoP::Model::Member;

sub logout {
    my $self = shift;
    my $session = NoP::Session->create($self->c->req,$self->c->res);
    $session->remove('member_id');
    $session->finalize();
}
sub authorize {
    my $self = shift;
    my $session = NoP::Session->create($self->c->req,$self->c->res);

    if( my $member_id = $session->get('member_id') ){
        return NoP::Model::Member->new->lookup($member_id);
    }
    return;
}

EOC;

