package Numpaar::Engine::DebugIto::GoogleAccount;
use base 'Numpaar::Engine::DebugIto::Firefox';
use Numpaar::Config qw(configElement);

sub new {
    my ($class, $user_name, $secret_filepath) = @_;
    my $self = $class->setupBasic('^Navigator\.Firefox \[GOOGLE ACCOUNT\]');
    $self->{'google_account_name'} = $user_name;
    $self->{'google_account_secret_file'} = $secret_filepath;
    return $self;
}

sub handlerExtended_up {
    my ($self, $connection, $want_help) = @_;
    return 'LOGIN' if defined($want_help);
    my $secret_loader = sprintf('%s "%s"', &configElement('extern_program', 'secret_loader'), $self->{google_account_secret_file});
    print STDERR ">>> $secret_loader\n";
    my $secret = `$secret_loader`;
    chomp $secret;
    if($secret eq '') {
        print STDERR "ERROR: GoogleAccount: secret loader error.\n";
        $self->setState(0, $connection);
        return 0;
    }
    $connection->comKeyType($self->{google_account_name});
    $connection->comKeyString("Tab");
    $connection->comKeyType($secret);
    $connection->comKeyString("Return");
    $self->setState(0, $connection);
    return 0;
}

1;

