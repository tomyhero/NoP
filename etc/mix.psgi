use strict;
use warnings;
use FindBin::libs;
use Plack::App::URLMap;
use Plack::Util ;

use NoP::Home;
my $home = NoP::Home->get;

my $pc = Plack::Util::load_psgi( $home->file('etc/pc.psgi'));
my $api = Plack::Util::load_psgi( $home->file('etc/api.psgi'));

my $urlmap = Plack::App::URLMap->new;
$urlmap->map("/" => $pc);
$urlmap->map("/api" => $api);

$urlmap->to_app;
