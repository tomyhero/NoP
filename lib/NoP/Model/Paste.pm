package NoP::Model::Paste;
use Ze::Class;
extends 'NoP::Model::Base';
with 'NoP::Model::Role::DataObject';
use NoP::Util;

sub profiles {
    return +{
        create => {
            required => [qw/body/],
        },
    };
}

sub create {
    my ($self,$args) = @_;
    my $v = $self->assert_with($args);

    my $obj = $self->data_class->new( 
        body => $v->{body},
        code => NoP::Util::generate_id,
    );

    $obj->save;

    return $obj;

}

1;
