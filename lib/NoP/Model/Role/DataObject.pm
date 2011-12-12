package NoP::Model::Role::DataObject;
use Ze::Role;
use Mouse::Util;

has 'data_class' => (
    is => 'rw',
    lazy_build => 1
);

sub _build_data_class {
    my $self = shift;
    my $class = ref $self;
    my @a = split('::',$class);
    my $name = $a[-1];
    my $pkg =  'NoP::Data::' . $name;
    Mouse::Util::load_class($pkg); #XXX
    return $pkg;
}

sub create {
    my $self = shift;
    my $args = shift || {};
    my $profile_name = shift;
    my $v = $self->assert_with($args);
    my $obj = $self->data_class->new( %$v ) ;
    $obj->save();
    return $obj;
}

sub lookup {
    my $self = shift;
    return $self->data_class->lookup( @_ );
}

1;
