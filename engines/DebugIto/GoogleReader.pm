package Numpaar::Engine::DebugIto::GoogleReader;
use base qw(Numpaar::Engine::DebugIto::Firefox);

use strict;
use warnings;

## show-newitems と show-allitemsのトグルもやりたいが、GreaseMonkeyを使ってもできそうにない。。


sub new {
    my ($class) = @_;
    return $class->setupBasic('^Navigator\.Firefox Google リーダー .*- Mozilla Firefox$');
}

sub handlerExtended_up {
    my ($self, $want_help) = @_;
    return "Item up" if defined($want_help);
    $self->getConnection()->comKeyString("k");
    return 0;
}

sub handlerExtended_down {
    my ($self, $want_help) = @_;
    return "Item down" if defined($want_help);
    $self->getConnection()->comKeyString('j');
    return 0;
}

sub handlerExtended_center {
    my ($self, $want_help) = @_;
    return "Item open/close" if defined($want_help);
    $self->getConnection()->comKeyString('o');
    return 0;
}

sub handlerExtended_page_up {
    my ($self, $want_help) = @_;
    return "Page up" if defined($want_help);
    $self->getConnection()->comKeyString('shift+space');
    return 0;
}

sub handlerExtended_page_down {
    my ($self, $want_help) = @_;
    return "Page down" if defined($want_help);
    $self->getConnection()->comKeyString('space');
    return 0;
}

sub handlerExtended_right {
    my ($self, $want_help) = @_;
    return "View original" if defined($want_help);
    $self->getConnection()->comKeyString('v');
    return 0;
}

sub handlerExtended_end {
    my ($self, $want_help) = @_;
    return "Star" if defined($want_help);
    $self->getConnection()->comKeyString('s');
    return 0;
}

sub handlerExtended_insert {
    my ($self, $want_help) = @_;
    return "Mark all as read" if defined($want_help);
    $self->getConnection()->comKeyString('shift+a');
    return 0;
}

sub handlerExtended_left {
    my ($self, $want_help) = @_;
    return "Go to navication" if defined($want_help);
    $self->setState('ReaderNavi');
    return 0;
}

sub handlerReaderNavi_up {
    my ($self, $want_help) = @_;
    return "Navication up" if defined($want_help);
    $self->getConnection()->comKeyString('shift+p');
    return 0;
}

sub handlerReaderNavi_down {
    my ($self, $want_help) = @_;
    return "Navication down" if defined($want_help);
    $self->getConnection()->comKeyString('shift+n');
    return 0;
}

sub handlerReaderNavi_right {
    my ($self, $want_help) = @_;
    return "Open subscription" if defined($want_help);
    $self->getConnection()->comKeyString('shift+o');
    $self->setState('Extended');
    return 0;
}

sub handlerReaderNavi_home {
    my ($self, $want_help) = @_;
    return "All items" if defined($want_help);
    $self->getConnection()->comKeyType('ga');
    return 0;
}

sub handlerReaderNavi_left {
    my ($self, $want_help) = @_;
    return "Starred items" if defined($want_help);
    $self->getConnection()->comKeyType('gs');
    return 0;
}

sub handlerReaderNavi_center {
    my ($self, $want_help) = @_;
    return "Expand/collapse" if defined($want_help);
    $self->getConnection()->comKeyString('shift+x');
    return 0;
}

sub handlerReaderNavi_page_up {
    my ($self, $want_help) = @_;
    return "Refresh" if defined($want_help);
    $self->getConnection()->comKeyString('r');
    return 0;
}

1;





