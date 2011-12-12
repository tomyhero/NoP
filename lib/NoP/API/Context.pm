package NoP::API::Context;
use Ze::Class;
extends 'NoP::WAF::Context';

__PACKAGE__->load_plugins( 'Ze::WAF::Plugin::Encode','Ze::WAF::Plugin::JSON', 'Ze::WAF::Plugin::AntiCSRF');


sub not_found {
    my $c = shift;
    $c->view_type('JSON');
    $c->res->status( 404 );
    $c->res->body('{"error":1}');
    $c->res->content_type( 'text/html;charset=utf-8' );
    $c->finished(1);
}

EOC;
