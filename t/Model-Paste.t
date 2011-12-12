use Test::More;
use t::Util;

cleanup_database;

use_ok('NoP::Model::Paste');

my $model = NoP::Model::Paste->new();


subtest 'create' => sub {
    my $obj= $model->create({ body => 'body' });
    ok($obj->code);
    is($obj->body,'body');

};

done_testing();
