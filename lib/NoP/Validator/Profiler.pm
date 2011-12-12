package NoP::Validator::Profiler;

use strict;
use warnings;
use Text::SimpleTable;
use Ze::Util;
use Term::ANSIColor;;
use Data::Dumper;

sub import {
    my $class = shift;
    my $args = shift;
    if($args){
        $SIG{__DIE__} = \&message;
    }
}

sub message {
    my $error = shift;

    if (ref $error eq "NoP::Validator::Error"){
        my $column_width = Ze::Util::term_width() - 30;
        my $t1 =Text::SimpleTable->new([20,'VALIDATE ERROR'],[$column_width,'VALUE']);
        $t1->row('custom_invalid' , Dumper ($error->{custom_invalid}));
        $t1->row('missing' , Dumper ($error->{missing}));
        $t1->row('invalid' , Dumper ($error->{invalid}));
        $t1->row('error_keys' , Dumper ($error->{error_keys}));
        $t1->row('valid' , Dumper ($error->{valid}));

        print color 'yellow';
        print $t1->draw;
        print color 'reset';

    }
};

1;
