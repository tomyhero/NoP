package NoP::PC::View;
use Ze::Class;
extends 'Ze::WAF::View';
use NoP::Home;
use Ze::View;

sub _build_engine {
    my $self = shift;
    my $path = [ NoP::Home->get()->subdir('view-pc'), NoP::Home->get()->subdir('view-include/pc') ];

    return Ze::View->new(
        engines => [
            { engine => 'Ze::View::Xslate' , config => { path => $path , module => ['Text::Xslate::Bridge::Star' ] } }, 
            { engine => 'Ze::View::JSON', config  => {} } 
        ]
    );

}


EOC;
