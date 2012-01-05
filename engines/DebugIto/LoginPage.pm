package Numpaar::Engine::DebugIto::LoginPage;
use base 'Numpaar::Engine::DebugIto::Firefox';
use Numpaar::Config qw(configElement configCheck);

use strict;
use warnings;

sub new {
    my ($class, $user_name, $secret_filepath) = @_;
    &configCheck('extern_program', 'zenity', 'gpg');
    my $self = $class->setupBasic('^Navigator\.Firefox \[LOGIN\]');
    $self->heap->{account_name} = $user_name;
    $self->heap->{secret_file} = $secret_filepath;
    return $self;
}

sub handlerExtended_up {
    my ($self, $want_help) = @_;
    my $connection = $self->getConnection();
    return 'LOGIN' if defined($want_help);
    $self->handlerExtended_center();
    $self->handlerExtended_right();
    $self->handlerExtended_down();
    return 0;
}

sub handlerExtended_center {
    my ($self, $want_help) = @_;
    my $connection = $self->getConnection();
    return 'User name' if defined($want_help);
    $connection->comKeyType($self->heap->{account_name});
    return 0;
}

sub handlerExtended_right {
    my ($self, $want_help) = @_;
    my $connection = $self->getConnection();
    return 'Tab' if defined($want_help);
    $connection->comKeyString("Tab");
}

sub handlerExtended_down {
    my ($self, $want_help) = @_;
    my $connection = $self->getConnection();
    return 'Password' if defined($want_help);
    if(! -f $self->heap->{secret_file}) {
        printf STDERR ("ERROR: LoginPage: cannot find %s\n", $self->heap->{secret_file});
        $self->setState(0);
        return 1;
    }
    my $zen_command = sprintf('%s --entry --title "Password required" --text "Enter password" --hide-text', &configElement('extern_program', 'zenity'));
    my $password = `$zen_command`;
    chomp $password;
    if($password eq '') {
        printf STDERR "ERROR: LoginPage: no password is given.\n";
        $self->setState(0);
        return 1;
    }
    my $gpg_command = sprintf('%s --passphrase "%s" -d "%s"', &configElement('extern_program', 'gpg'), $password, $self->heap->{secret_file});
    my $secret = `$gpg_command`;
    chomp $secret;
    if($secret eq '') {
        print STDERR "ERROR: LoginPage: gpg error.\n";
        $self->setState(0);
        return 0;
    }
    $connection->comKeyType($secret);
    $connection->comKeyString("Return");
    $self->setState(0);
    return 0;
}


1;

