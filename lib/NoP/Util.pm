package NoP::Util;
use strict;
use warnings;
use JSON::XS();
use Encode();
use parent qw(Exporter);

our @EXPORT = qw(to_json from_json);

sub from_json {
    my $json = shift; 
     $json = Encode::encode('utf8',$json);
     return JSON::XS::decode_json( $json );
}

sub to_json {
    my $data = shift; 
     Encode::decode('utf8',JSON::XS::encode_json( $data ) );
}


1;
