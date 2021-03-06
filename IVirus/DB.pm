package IVirus::DB;

use IVirus::Config;
use IVirus::Schema;
use DBI;
use Moose;

has config     => (
    is         => 'rw',
    isa        => 'IVirus::Config',
    lazy_build => 1,
);

has dbd => (
    is         => 'rw',
    isa        => 'Str',
    default    =>  'mysql',
    predicate  => 'has_dbd',
);

has dbh => (
    is         => 'rw',
    isa        => 'DBI::db',
    lazy_build => 1,
);

has dsn => (
    is         => 'rw',
    isa        => 'Str',
    lazy_build => 1,
);

has db_options => (
    is         => 'rw',
    isa        => 'HashRef',
    default    => sub { { RaiseError => 1 } },
);

has host => (
    is         => 'rw',
    isa        => 'Str',
    default    => 'localhost',
);

has name => (
    is         => 'rw',
    isa        => 'Str',
    default    => 'ivirus',
    predicate  => 'has_name',
);

has password   => (
    is         => 'rw',
    isa        => 'Str',
    lazy_build => 1,
);

has schema => (
    is         => 'ro',
    isa        => 'DBIx::Class::Schema',
    lazy_build => 1,
);

has user => (
    is         => 'rw',
    isa        => 'Str',
    default    => 'ivirus',
    predicate  => 'has_user',
);

# ----------------------------------------------------------------
sub BUILD {
    my $self    = shift;
    my $config  = $self->config;
    my $db_conf = $config->get('db');

    if (!$self->has_user && defined $db_conf->{'user'}) {
        $self->user($db_conf->{'user'});
    }

    if (!$self->has_password && defined $db_conf->{'password'}) {
        $self->password($db_conf->{'password'});
    }

    if (!$self->has_name && defined $db_conf->{'name'}) {
        $self->name($db_conf->{'name'});
    }

    if ( !$self->has_dsn ) {
        my $host = $self->host;
        my $name = $self->name;

        $self->dsn(
            sprintf( "dbi:%s:%s",
                $self->dbd,
                $host ? "database=$name;host=$host" : $name
            )
        );
    }
}

# ----------------------------------------------------------------
sub _build_config {
    return IVirus::Config->new;
}

# ----------------------------------------------------------------
sub _build_dbh {
    my $self = shift;
    my $dbh;

    eval {
        $dbh = DBI->connect(
            $self->dsn, 
            $self->user, 
            $self->password, 
            $self->db_options
        );
    };

    if ( my $err = $@ ) {
        die "Error: $err";
    }
    else {
        return $dbh;
    }
}

# ----------------------------------------------------------------
sub _build_schema {
    my $self = shift;

    return IVirus::Schema->connect( sub { $self->dbh } );
}

1;
