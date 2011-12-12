package NoP::DateTime;
use strict;
use warnings;
use base qw( DateTime );
use DateTime::TimeZone;
use DateTime::Format::Strptime;

our $DEFAULT_TIMEZONE = DateTime::TimeZone->new( name => 'local' );

sub new {
    my ( $class, %opts ) = @_;
    $opts{ time_zone } ||= $DEFAULT_TIMEZONE;
    return $class->SUPER::new( %opts );
}

sub now {
    my ( $class, %opts ) = @_;
    $opts{ time_zone } ||= $DEFAULT_TIMEZONE;
    return $class->SUPER::now( %opts );
}

sub from_epoch {
    my $class = shift;
    my %p = @_ == 1 ? (epoch => $_[0]) : @_;
    $p{ time_zone } ||= $DEFAULT_TIMEZONE;
    return $class->SUPER::from_epoch( %p );
}

sub parse {
    my ( $class, $format, $date ) = @_;
    $format ||= 'MySQL';

    my $module;
    if ( ref $format ) {
        $module = $format;
    }
    else {
        $module = "DateTime::Format::$format";
        eval "require $module";
        die $@ if $@;
    }

    my $dt = $module->parse_datetime( $date ) or return;
    # If parsed datetime is floating, don't set timezone here.
    # It should be "fixed" in caller plugins
    $dt->set_time_zone( $DEFAULT_TIMEZONE || 'local' )
        unless $dt->time_zone->is_floating;

    return bless $dt, $class;
}

sub strptime {
    my($class, $pattern, $date) = @_;
    my $format = DateTime::Format::Strptime->new(
        pattern   => $pattern,
        time_zone => $DEFAULT_TIMEZONE || 'local',
    );
    $class->parse($format, $date);
}

sub set_time_zone {
    my $self = shift;
    eval { $self->SUPER::set_time_zone( @_ ) };
    if ( $@ ) {
        $self->SUPER::set_time_zone( 'UTC' );
    }
    return $self;
}

sub sql_now {
    my($class, %options) = @_;
    my $self = $class->now( %options );
    $self->strftime( '%Y-%m-%d %H:%M:%S' );
}

sub yesterday {
    my $class = shift;
    my $now = $class->now();
    return $now->subtract( days => 1 );
}

1;
