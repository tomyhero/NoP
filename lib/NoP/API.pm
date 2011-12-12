package NoP::API;
use Ze::Class;
extends 'Ze::WAF';
use NoP::Config;

if( NoP::Config->instance->get('debug') ) {
    with 'Ze::WAF::Profiler';
};

EOC;
