use Test::More;
use t::Util;

test_pc(sub {
        my $cb  = shift;
        my $res = $cb->(GET "/");

        is($res->code,200);
});


done_testing();
