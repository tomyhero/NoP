package NoP::Data::Plugin::AttributesDump;

use strict;
use warnings;
use base qw(NoP::Data::Plugin::Base);
use NoP::Util qw(from_json to_json);

__PACKAGE__->methods([qw/attributes set_attributes/]);

sub attributes {
    my $self = shift;
    return length $self->attributes_dump ? from_json($self->attributes_dump) : {};
}

sub set_attributes {
    my $self = shift;
    my $data = shift;
    $self->attributes_dump( to_json( $data ) );
}

1;
