use Test::More;
use_ok('t::Util');
use NoP::Config;
use Test::TCP;
use NoP::Util;

subtest 'memcahced' => sub {
    my $cache_config =  NoP::Config->instance()->get('cache');
    my ($original_port) =  $cache_config->{servers}[0] =~ /(\d+)$/;
    like($cache_config->{servers}[0] ,qr/^127\.0\.0\.1:\d+$/, 'memcached conifg serversの差し替え');
    my ($port) =  $cache_config->{servers}[0] =~ /(\d+)$/;
    sleep 1; # memcached があがるのをを待つ感じ
    is(Test::TCP::_check_port($port),1, 'memcachedたぶんあがってる');
};


done_testing();
