package NoP::Controller::Root;
use Ze::Class;
extends 'NoP::WAF::Controller';
use NoP::ObjectDriver::DBI;
use NoP::Cache;
use NoP::Util;

sub index {
    my ($self,$c) = @_;

    if($c->req->method eq 'POST' ) {
        $self->do_add($c);
    }
}


sub do_add {
    my ($self,$c) = @_;
    my $obj = $c->model('Paste')->create( $c->req->as_fdat );
    $c->redirect(sprintf('/paste/%s/',$obj->code));
}

sub detail {
    my ($self,$c) = @_;
    $c->template('detail');
    my $obj = $c->model('Paste')->lookup( $c->args->{code} ) or return $c->not_found;
    $c->stash->{paste_obj} = $obj;
}



EOC;
