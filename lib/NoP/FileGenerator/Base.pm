package NoP::FileGenerator::Base;
use warnings;
use strict;
use NoP::FileGenerator -command;
use parent 'Ze::FileGenerator::Base';
use Ze::View;
use NoP::Home;

my $home = NoP::Home->get();

__PACKAGE__->in_path( $home->subdir("view-component/base") );
__PACKAGE__->out_path( $home->subdir("view-include/component") );


sub create_view {

    my $path = [ NoP::Home->get()->subdir('view-component') , NoP::Home->get()->subdir('view-include') ];

    return Ze::View->new(
        engines => [
            { engine => 'Ze::View::Xslate' , config => { path => $path , module => ['Text::Xslate::Bridge::Star' ] } }, 
            { engine => 'Ze::View::JSON', config  => {} } 
        ]
    );

}

sub execute {
    my ($self, $opt, $args) = @_;
    $self->setup();
    $self->run( $opt , $args );
}
1;
