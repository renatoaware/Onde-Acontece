package Onde::Acontece;
use Moose;
use namespace::autoclean;

use Catalyst::Runtime 5.80;

# Set flags and add plugins for the application.
#
# Note that ORDERING IS IMPORTANT here as plugins are initialized in order,
# therefore you almost certainly want to keep ConfigLoader at the head of the
# list if you're using it.
#
#         -Debug: activates the debug mode for very useful log messages
#   ConfigLoader: will load the configuration from a Config::General file in the
#                 application's home directory
# Static::Simple: will serve static files from the application's root
#                 directory

use Catalyst qw/
  -Debug
  ConfigLoader
  Static::Simple
  /;

extends 'Catalyst';
use Sys::Hostname;

our $VERSION = '0.01';

# Configure the application.
#
# Note that settings in onde_acontece.conf (or other external
# configuration file that you set up manually) take precedence
# over this when using ConfigLoader. Thus configuration
# details given here can function as a default configuration,
# with an external configuration file acting as an override for
# local deployment.

my $user = $ENV{USER};
my $host = Sys::Hostname::hostname();

__PACKAGE__->config(
  name                   => 'Onde::Acontece',
  'Plugin::ConfigLoader' => {
    config_local_suffix => "${user}",
    file                => __PACKAGE__->path_to('conf')
  },

  # Disable deprecated behavior needed by old applications
  disable_component_resolution_regex_fallback => 1,
  default_view                                => 'TT',
  'View::TT'                                  => {
    INCLUDE_PATH =>
      [ map { __PACKAGE__->path_to(@$_) }[qw(root src)], [qw(root lib)] ]
  },
  'View::Topico' => {
    INCLUDE_PATH =>
      [ map { __PACKAGE__->path_to(@$_) }[qw(root src)], [qw(root lib)] ]
  },
);

# Start the application
__PACKAGE__->setup();

=head1 NAME

Onde::Acontece - Catalyst based application

=head1 SYNOPSIS

    script/onde_acontece_server.pl

=head1 DESCRIPTION

[enter your description here]

=head1 SEE ALSO

L<Onde::Acontece::Controller::Root>, L<Catalyst>

=head1 AUTHOR

Thiago Rondon

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

1;
