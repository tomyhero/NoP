package NoP::Model::Base;
use Ze::Class;
extends 'Aplon';
use NoP::Validator;
use NoP::Pager;

with 'Aplon::Validator::FormValidator::LazyWay';
has '+error_class' => ( default => 'NoP::Validator::Error' );

has 'pager' => (  is => 'rw' );



sub FL_instance {
    NoP::Validator->instance();
}

sub create_pager {
    my $self = shift;
    my $p    = shift;
    my $entries_per_page = shift || 10;
    my $pager = NoP::Pager->new();
    $pager->entries_per_page( $entries_per_page );
    $pager->current_page($p);
}


EOC;
