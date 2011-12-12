# DB スキーマに変更があったら、テスト用のデータベースをまるっと作り替える
# mysqldump --opt -d -uroot nop_$ENV} | mysql -uroot nop_test_${ENV}

# として、データベースを作成。スキーマ定義がちがくてうごかないときも同様。
package t::lib::App::Prove::Plugin::SchemaUpdater;
use strict;
use warnings;
use Test::More;
#use nop::Home;

sub run { system(@_)==0 or die "Cannot run: @_\n-- $!\n"; }

sub get_nop_env {
    return $ENV{NOP_ENV}; 
}

sub create_database {
    my ($target, $nop_env) = @_;
    diag("CREATE DATABASE ${target}_test_${nop_env}");
    run("mysqladmin -uroot create ${target}_test_${nop_env}");
}
sub drop_database {
    my ($target, $nop_env) = @_;
    diag("DROP DATABASE ${target}_test_${nop_env}");
    run("mysqladmin --force -uroot drop ${target}_test_${nop_env}");
}
sub copy_database {
    my ($target, $nop_env) = @_;
    diag("COPY DATABASE ${target}_${nop_env} to ${target}_test_${nop_env}");
    run("mysqldump --opt -d -uroot ${target}_${nop_env} | mysql -uroot ${target}_test_${nop_env}");
}
sub has_database {
    my ($target, $nop_env) = @_;
    return (`echo 'show databases' | mysql -u root|grep ${target}_test_${nop_env} |wc -l` =~ /1/);
}
sub filter_dumpdata {
    my $data = join "", @_;
    $data =~ s{^/\*.*\*/;$}{}gm;
    $data =~ s{^--.*$}{}gm;
    $data =~ s{^\n$}{}gm;
    $data =~ s{ AUTO_INCREMENT=\d+}{}g;
    $data;
}
sub changed_database {
    my ($target, $nop_env) = @_;
    my $orig = filter_dumpdata(`mysqldump --opt -d -uroot ${target}_${nop_env}`);
    my $test = filter_dumpdata(`mysqldump --opt -d -uroot ${target}_test_${nop_env}`);
    return ($orig ne $test);
}


sub load {
    my $nop_env = get_nop_env or die 'NOP_ENV is not set';
    for my $target (qw/ nop /) {
        if (has_database($target, $nop_env)) {
            if (changed_database($target, $nop_env)) {
                drop_database($target, $nop_env);
                create_database($target, $nop_env);
                copy_database($target, $nop_env);
            } else {
                diag("NO CHANGE DATABASE ${target}_test_${nop_env}");
            }
        } else {
            create_database($target, $nop_env);
            copy_database($target, $nop_env);
        }
    }
}

1;
