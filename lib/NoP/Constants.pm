package NoP::Constants;
use strict;
use warnings;
use parent qw(Exporter);
our @EXPORT_OK = ();
our %EXPORT_TAGS = (
    common => [qw(FAIL SUCCESS)],
);

our $DATA = {};
__PACKAGE__->build_export_ok();
__PACKAGE__->make_hash_ref();

use constant FAIL => 0;
use constant SUCCESS => 0;

sub build_export_ok {
    for my $tag  (keys %EXPORT_TAGS ){
        for my $key (@{$EXPORT_TAGS{$tag}}){
            push @EXPORT_OK,$key;
        }
    }
}

sub make_hash_ref {
    no strict 'refs';
    for my $key(@EXPORT_OK) {
        $DATA->{$key} = $key->();
    }
    1;
}

sub as_hashref {
    return $DATA;
}

1;
