package NoP::Authorizer::Base;
use Ze::Class;

has c => ( is => 'rw', required => 1 );

sub authorize  { die 'ABSTRACT METHOD' } 
sub logout_url { die 'ABSTRACT METHOD' }


EOC;
