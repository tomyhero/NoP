package NoP::Data::Base;
use strict;
use warnings;
use base qw(Data::ObjectDriver::BaseObject Class::Data::Inheritable);
use Data::ObjectDriver::SQL;
use Sub::Install;
use UNIVERSAL::require;
use NoP::DateTime;

__PACKAGE__->add_trigger( pre_insert => sub {
        my ( $obj, $orig ) = @_;

        my $now = NoP::DateTime->sql_now ;
        if ( $obj->has_column('created_at') && !$obj->created_at ) {
        $obj->created_at( $now );
        $orig->created_at( $now );
        }

        if ( $obj->has_column('updated_at') ) {
        $obj->updated_at( $now );
        $orig->updated_at( $now );
        }

        my $class = ref $obj;
            my $values = $class->default_values;
            for my $key (keys %{$values}) {
                unless (defined $obj->$key()) {
                    $obj->$key( $values->{$key} );
                    $orig->$key( $values->{$key} );
                }
            }
        },
);

__PACKAGE__->add_trigger( pre_update => sub {
        my ( $obj, $orig ) = @_;
        if ( $obj->has_column('updated_at') ) {
            my $now = NoP::DateTime->sql_now ;
            $obj->updated_at( $now );
            $orig->updated_at( $now );
        }
    }
);

__PACKAGE__->add_trigger( pre_search => sub {
        my ( $class, $terms, $args ) = @_;
        if ( $args && ( my $pager = delete $args->{pager} ) ) {
            $pager->total_entries($class->count( $terms ));
            $args->{limit}  = $pager->entries_per_page;
            $args->{offset} = $pager->skipped;
        }
    },
);


# always return array ref.
sub get_primary_keys {
    my $class = shift;
    my $primary_key = $class->properties->{'primary_key'};

    if( ref $primary_key ) {
        return $primary_key;
    }
    else {
        return [ $primary_key ];
    }
}

sub install_plugins {
    my $class = shift;
    my $plugins = shift;

    for my $plugin ( @$plugins ) {
        $plugin = 'NoP::Data::Plugin::' . $plugin;
        $plugin->require or die $@;
        for my $method ( @{$plugin->methods} ) {
            Sub::Install::install_sub({
                code => $method,
                from => $plugin,
                into => $class
            });
        }
    }
}


sub setup_alias {
    my $class = shift;
    my $map   = shift;

    for my $alias ( keys %$map ) {
        my $method_name  = $map->{$alias};
        Sub::Install::install_sub({
            code => sub { 
                my $self = shift;
                my $value = shift;
                if( defined $value ) {
                    $self->$method_name( $value ) ;
                }
                else {
                    $self->$method_name ;
                }
            } ,
            as   => $alias,
            into => $class
        });
    }
}

sub default_values {+{}}



sub dbi_select {
    my $self  = shift;
    my $query = shift;
    my $bind  = shift || [];
    my $dbh = $self->driver->r_handle;
    my $sth = $dbh->prepare($query) or die $dbh->errstr;
    my @rows = ();
    $sth->execute( @{$bind} );
    while(my $row = $sth->fetchrow_hashref()){
        push @rows,$row;
    }
    $sth->finish;
    return \@rows;
}
sub dbi_search {
    my ( $self,$terms,$args,$select ) = @_;
    $select ||= '*';
    $terms ||= {};
    my $stmt = Data::ObjectDriver::SQL->new;
    $stmt->add_select($select);
    $stmt->from( [ $self->driver->table_for($self) ] );
    if ( ref($terms) eq 'ARRAY' ) {
        $stmt->add_complex_where($terms);
    }
    else {
        for my $col ( keys %$terms ) {
            $stmt->add_where( $col => $terms->{$col} );
        }
    }

    ## Set statement's ORDER clause if any.
    if ($args->{sort} || $args->{direction}) {
        my @order;
        my $sort = $args->{sort} || 'id';
        unless (ref $sort) {
            $sort = [{column    => $sort,
                direction => $args->{direction}||''}];
        }

        my $dbd = $self->driver->dbd;
        foreach my $pair (@$sort) {
            my $col = $dbd->db_column_name( $self->driver->table_for($self) , $pair->{column} || 'id');
            my $dir = $pair->{direction} || '';
            push @order, {column => $col,
                desc   => ($dir eq 'descend') ? 'DESC' : 'ASC',
            }
        }

        $stmt->order(\@order);
    }
    $stmt->limit( $args->{limit} )     if $args->{limit};
    $stmt->offset( $args->{offset} )   if $args->{offset};
    $stmt->comment( $args->{comment} ) if $args->{comment};
    if (my $terms = $args->{having}) {
        for my $col (keys %$terms) {
            $stmt->add_having($col => $terms->{$col});
        }
    }

    my $dbh = $self->driver->r_handle;
    my $sth = $dbh->prepare($stmt->as_sql) or die $dbh->errstr;
    my @rows = ();
    $sth->execute( @{$stmt->{bind}});
    while(my $row = $sth->fetchrow_hashref()){
        push @rows,$row;
    }
    $sth->finish;
    return \@rows;
}

sub count {
    my ( $self, $terms ) = @_;
    $terms ||= {};
    my $stmt = Data::ObjectDriver::SQL->new;
    $stmt->add_select('COUNT(*)');
    $stmt->from( [ $self->driver->table_for($self) ] );
    if ( ref($terms) eq 'ARRAY' ) {
        $stmt->add_complex_where($terms);
    }
    else {
        for my $col ( keys %$terms ) {
            $stmt->add_where( $col => $terms->{$col} );
        }
    }
    $self->driver->select_one( $stmt->as_sql, $stmt->{bind} );
}
sub single {
    my ( $self, $terms, $options ) = @_;
    $options ||= {};
    $options->{limit} = 1;
    my $res = $self->search( $terms, $options );
    return $res->next;
}

sub as_fdat {
    my $self = shift;
    my $column_names  = shift || $self->column_names;
    my %fdat = map { $_ => $self->$_() } @{ $column_names };
    \%fdat;
}


sub find_or_create {
    my $class = shift;
    my $data = shift;
    my $keys = shift;

    my $obj ;
    if($keys) {
        my $cond = {};
        for(@$keys) {
            $cond->{$_} = $data->{$_};
        }
        $obj = $class->single($cond);
    }
    else {
        my @cond = ();
        for(@{$class->get_primary_keys}){
            push @cond , $data->{$_};
        }
        $obj = $class->lookup(\@cond);
    }

    if($obj){
        return $obj;
    }else {
        $obj = $class->new(%$data);
        $obj->save();
        return $obj;
    }
}

sub update_or_create {
    my $class = shift;
    my $data = shift;

    my $primary_key  = $class->properties('primary_key')->{primary_key};
    my $cond ;

    my $pkeys = {};
    if(ref $primary_key eq 'ARRAY'){
        $cond = [];
        for(@$primary_key){
           $pkeys->{$_} = 1;
           push @$cond , $data->{$_};
        }
    }
    else {
        $cond = $data->{$primary_key};
        $pkeys->{$primary_key} = 1;
    }

    my $obj = $class->lookup($cond);
    if($obj){
        my $is_modified = 0;
        for my $key (keys %{$data} ) {
            next if $pkeys->{$key};
            # 同じ値のときはsetしない

            # undefined compair error.
            $data->{$key} = '' unless defined $data->{$key};
            my $value = $obj->$key();
            $value = '' unless defined $obj->$key();

            next if( $obj->$key() eq $data->{$key});
            #debugf('modified_key:[ %s ] now:%s new:%s',$key,$obj->$key,$data->{$key});
            $is_modified = 1 ;
            $obj->$key($data->{$key});
        }

        # 変更が無い時は書き込み処理をしない
        unless ($is_modified){
            #debugf('SAME DATA IS SET. NOT SAVED');
            return $obj ;
        }

    }else {
        $obj = $class->new(%$data) ;
    }
    
    $obj->save;
    return $obj;
}

# lookup_multiはデータが見つからないとレコードにNULLをいれてくるのでそれを取り除く処理付きのメソッド
sub lookup_multi_filterd {
    my $self = shift;
    my $tmp = $self->lookup_multi(@_);
    my @objs = ();

    for(@$tmp){
        next unless $_;
        push @objs,$_;
    }
    return \@objs;
}

sub to_datetime {
    my($self, $column) = @_;
    my $val = $self->$column();
    return unless length $val;

    if ($val =~ /^\d{4}-\d{2}-\d{2}$/) {
        $val .= ' 00:00:00';
    }

    my $dt = NoP::DateTime->parse_mysql($val) or return;
    return $dt;
}



1;
