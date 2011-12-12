package NoP::Model::Member;
use Ze::Class;
extends 'NoP::Model::Base';
with 'NoP::Model::Role::DataObject';

sub profiles {
    return +{ 
        create => {
            required => [qw/member_name/],
        },
    };
}


EOC;
