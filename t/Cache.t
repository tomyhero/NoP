use Test::More;
use t::Util;

use NoP::Cache;
my $cache = NoP::Cache->instance();

$cache->set('a','b');

is($cache->get('a'),'b');;


done_testing();
