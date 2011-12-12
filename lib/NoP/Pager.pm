package NoP::Pager;

use strict;
use warnings;
use base qw(Data::Page);
use Data::Page::Navigation;
use URI::QueryParam ;

sub build_uri {
    my $self = shift;
    my $p    = shift;
    my $uri  = $self->uri->clone();
    $uri->query_param_append( p => $p );
    return $uri;
}

sub pages_in_navigation {
    my $self = shift;
    my @arr = $self->SUPER::pages_in_navigation(shift);
    return \@arr;
}

sub uri {
    my $self = shift;
    my $uri = shift;
    if( $uri ) {
        my $u = $uri->clone();    
        $u->query_param_delete('p');
        $self->{__uri} = $u;
    }
    else {
        $self->{__uri};    
    }
}

1;
