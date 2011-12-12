package NoP::FileGenerator::sample;
use strict;
use warnings;
use base qw/NoP::FileGenerator::Base/;

sub run {
    my ($self, $opts) = @_;
    $self->echo();
}

sub echo {
    my $self = shift;
    my $args = shift;

    $self->generate(['pc'],{
        name => "sample/echo",
        vars => { 
            name => 'sample',
        },
    });
    return 1;
}


1;
__END__

