use Test::More;
use t::Util;

cleanup_database;

use_ok('NoP::Model::Member');

my $model = NoP::Model::Member->new();

subtest 'create' => sub {
    my $member_obj = $model->create({ member_name => 'teranishi' });
    isa_ok($member_obj,'NoP::Data::Member');
    is($member_obj->name,'teranishi');
};

done_testing();
