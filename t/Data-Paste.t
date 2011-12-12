use Test::More;
use t::Util;
use lib 't/lib';
use Test::NoP::Data;

cleanup_database();

use_ok('NoP::Data::Paste');
columns_ok('NoP::Data::Paste');

done_testing();
