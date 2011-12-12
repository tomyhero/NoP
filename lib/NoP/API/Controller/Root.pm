package NoP::API::Controller::Root;
use Ze::Class;
extends 'NoP::API::Controller::Base';

use NoP::Authorizer::Member;

sub me {
    my ($self,$c) = @_;
    my $authorizer = NoP::Authorizer::Member->new( c => $c ); 
    my $member_obj  = $authorizer->authorize();

    my $item = {};
    my $is_login = 0;
    if($member_obj){
        for(qw/member_id member_name/){
            $item->{$_} = $member_obj->$_;
        }
        $is_login = 1;
    }

    $c->set_json_stash({ item => $item , is_login => $is_login });

}

EOC;
