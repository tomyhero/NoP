use Test::More;
use t::Util;
use lib 't/lib';
use Test::NoP::Data;

cleanup_database();

use_ok('NoP::Data::Member');
columns_ok('NoP::Data::Member');

subtest 'alias' => sub {
    my $member_obj = NoP::Data::Member->new(
        member_id   => 1,
        member_name => 'hoge',
    );
    is($member_obj->id, 1);
    is($member_obj->name, 'hoge');
};



done_testing();
