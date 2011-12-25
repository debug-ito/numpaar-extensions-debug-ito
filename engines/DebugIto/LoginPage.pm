package Numpaar::Engine::DebugIto::LoginPage;
use base 'Numpaar::Engine::DebugIto::Firefox';
use Numpaar::Config qw(configElement);

use strict;
use warnings;

sub new {
    my ($class, $user_name, $secret_filepath) = @_;
    my $self = $class->setupBasic('^Navigator\.Firefox \[LOGIN\]');
    $self->{account_name} = $user_name;
    $self->{secret_file} = $secret_filepath;
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
    $connection->comKeyType($self->{account_name});
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
    my $secret_loader = sprintf('%s "%s"', &configElement('extern_program', 'secret_loader'), $self->{secret_file});
    my $secret = `$secret_loader`;
    chomp $secret;
    if($secret eq '') {
        print STDERR "ERROR: LoginPage: secret loader error.\n";
        $self->setState(0);
        return 0;
    }
    $connection->comKeyType($secret);
    $connection->comKeyString("Return");
    $self->setState(0);
    return 0;
}


1;

