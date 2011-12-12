use Test::More;
use t::Util;

use NoP::Cache::Session;
my $session = NoP::Cache::Session->instance();

$session->set('a','b');

is($session->get('a'),'b');;


done_testing();
