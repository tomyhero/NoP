use inc::Module::Install;
name 'NoP';
all_from 'lib/NoP.pm';

requires (
    'Ze' => '0.02',
    'Ukigumo::Client' => 0,
    'Plack::Middleware::ReverseProxy' => 0,
    'Aplon' => 0,
    'FormValidator::LazyWay' => 0,
    'YAML::Syck' => 0,
    'Data::Section::Simple' => 0,
    'DBI' => 0,
    'DBD::mysql' => 0,
    'Data::ObjectDriver' => 0,
    'List::Util'=>0,
    'Class::Singleton' => 0,
    'Cache::Memcached::IronPlate' => 0,
    'Cache::Memcached::Fast' => 0,
    'Devel::KYTProf'  => 0,
    'List::MoreUtils' => 0,
    'Data::Page' => 0,
    'Data::Page::Navigation' => 0,
    'URI::QueryParam' => 0,
    'Text::SimpleTable' => 0,
    'HTTP::Parser::XS' => 0,
    'FindBin::libs' => 0,
    'HTTP::Session' => 0,
    'Data::GUID::URLSafe' => 0,
);


test_requires(
    'Test::LoadAllModules' => 0,
    'Test::TCP' => 0,
    'Proc::Guard' => 0,
    'Test::Output' => 0,
);


tests_recursive;

build_requires 'Test::More';
auto_include;
WriteAll;
