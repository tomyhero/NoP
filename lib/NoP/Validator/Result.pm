package NoP::Validator::Result;
use strict;
use warnings;
use parent qw(FormValidator::LazyWay::Result);

sub error_fields {
    my $self = shift;
    my @f = ();

    if(ref $self->missing ){ 
        for(@{$self->missing}){
            push @f,$_;
        }
    }

    if(ref $self->invalid ){ 
        for my $key (keys %{$self->invalid} ){
            push @f,$key;
        }
    }
    return \@f;
}


1;
