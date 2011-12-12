package Test::NoP::Data;
use strict;
use warnings;
use parent qw/Exporter/;
use Test::More();
use NoP::ObjectDriver::DBI;
our @EXPORT = qw(columns_ok);


sub columns_ok {
    my $pkg =  shift or die 'please set data class name';

    my $dbh = NoP::ObjectDriver::DBI->driver->rw_handle;

    my %columns = map {$_ => 1 } @{$pkg->column_names};

    my $database_name = get_database_name($dbh);
    my $table_name = $pkg->datasource();


    my $sql = "select COLUMN_NAME from information_schema.columns c where c.table_schema = ? and c.table_name = ?";


    my $data = $dbh->selectall_arrayref($sql,{},$database_name,$table_name);

    my $mysql_columns = {};
    for(@$data){
        $mysql_columns->{$_->[0]} = 1; 
    }

    Test::More::is_deeply(\%columns,$mysql_columns,sprintf("%s's columns does not much with database and source code",$table_name));

}

sub get_database_name {
    my $dbh = shift;
    return $dbh->private_data->{database};
}

1;
