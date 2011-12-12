package NoP::Validator;
use warnings;
use strict;
use utf8;
use FormValidator::LazyWay;
use YAML::Syck();
use Data::Section::Simple;
use NoP::Validator::Result;

sub create_config {
    my $reader = Data::Section::Simple->new(__PACKAGE__);
    my $yaml = $reader->get_data_section('validate.yaml');
    my $data = YAML::Syck::Load( $yaml);
    return $data;
}

sub instance {
    my $class = shift;
    no strict 'refs';
    my $instance = \${ "$class\::_instance" };
    defined $$instance ? $$instance : ($$instance = $class->_new);
}

sub _new {
    my $class = shift;
    my $self = bless {}, $class;
    return $self->create_validator();
}

sub create_validator {
    my $self = shift;
    my $config = $self->create_config();
    FormValidator::LazyWay->new( config => $config ,result_class => 'NoP::Validator::Result' );
}

1;

=head1 NAME

NoP::Validator - Validatorクラス

=head1 SYNOPSIS

my $validator = NoP::Validator->instance();

=head1 DESCRIPTION

L<FormValidator::LazyWay>のオブジェクトををシングルトン化し取得することができます。

=cut

__DATA__
@@ validate.yaml
--- 
lang: ja
rules: 
  - Number
  - String
  - Net
  - Email
setting: 
    regex_map :
      '_id$': 
        rule: 
          - Number#uint
    strict:
      url: 
        rule:
            - Net#url_loose
      member_name:
        rule:
            - String#length:
                max : 55
                min : 1
      p: 
        rule: 
          - Number#uint
