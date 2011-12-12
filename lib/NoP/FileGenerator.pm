package NoP::FileGenerator;
use strict;
use warnings;
use parent 'Ze::FileGenerator';

sub _module_pluggable_options {
    return (
        except => ['NoP::FileGenerator::Base'],
    );
};


1;
