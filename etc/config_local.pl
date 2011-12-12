+{
    cache => {
        servers => [ '127.0.0.1:11211' ],
    },
    cache_session => {
        servers => [ '127.0.0.1:11211' ],
    },
    database => {
        master => {
            dsn => "dbi:mysql:nop_local",
            username => "dev_master",
            password => "secretme",
        },
        slaves => [
            {
                dsn => "dbi:mysql:nop_local",
                username => "dev_slave",
                password => "secretme",
            }
        ],
    },
};
