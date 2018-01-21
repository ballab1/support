package ArgHandler;         
=head1 NAME
ArgHandler

=head1 DESCRIPTION 
Original file: ArgHandler.pm
This software parses the command line,, and sets up all of the default values expected by the app


The following methods are provided:
C<usage>   C<verify>  C<getLoggerInfo> C<getParams>

=head1 COPYRIGHT
(C) 2013 - 2014 EMC

=head1 AUTHOR
Bob Ballantyne  2015/11/02

=head1 SEE ALSO

########################################################################

=head2 Methods

=over 12

=cut

use strict;
use warnings;
use Exporter;
our $VERSION     = 1.00;
our @ISA         = qw(Exporter);
our @EXPORT_OK   = qw(getLoggerInfo verify usage);
                 
use File::Basename qw(dirname);
use File::Spec qw(catfile);
use Getopt::Long qw(GetOptions);
use utilities::hashes qw(copyHash);


=item C<new>

############################################################
constructor

my $args = ArgHandler->new()

The constructor returns a new C<ArgHandler> object which 
parses the commandline args, and ensures that all the required defaults
are set.

=cut

sub new
{
  my ( $class, $configData ) = @_;

  my $self = {};
  bless( $self, $class );

  $self->{cfg} = $configData;
  
  my @opts = ( 'infile=s' );
  foreach my $cfg ( @{ $configData->{OUTPUT} } ) {
      push @opts, "$cfg->{topic}=s";
  }
  push @opts, 'id=i';
  &Getopt::Long::config('require_order');
  unless (Getopt::Long::GetOptions($self, @opts, 'help' => sub { $self->usage() })) {
      $self->usage();
  };

 # setup default values
  
  $self->verify('infile');
  foreach my $cfg ( @{ $configData->{OUTPUT} } ) {
      $self->verify($cfg->{topic});
  }
  return $self;
}

=item C<getLoggerInfo>

############################################################
getLoggerInfo

return the column defs for a given topic

=cut

sub getLoggerInfo
{
    my ($self, $topic) = @_;
    
    foreach my $cfg ( @{ $self->{cfg}->{OUTPUT} } ) {
      next unless ($cfg->{topic} eq $topic);
      
      # remove params used for HELP (usage)
      my $info = copyHash($cfg);
      delete $info->{comment} if (exists $info->{comment});
      return $info;
    }
    return undef;
}


=item C<getParams>

############################################################
getParams

return the column defs for a given topic

=cut

sub getParams
{
    my ($self) = @_;
    my $params = {};
    foreach my $cfg ( @{ $self->{cfg}->{OUTPUT} } ) {
        my $topic = $cfg->{topic};
        $params->{$topic} = logger::KafkaLogger->new($self->getLoggerInfo($topic));
    }

    return $params;
}

=item C<usage>

############################################################
usage

provide help

=cut

sub usage()
{
    my $self = shift;
    my $cfg = $self->{cfg};
    
    print "USAGE: $0 [options]\n";
    print "          topic                   Kafka topic";
    foreach my $cfg ( @{ $cfg->{OUTPUT} } ) {
        print "          $cfg->{comment}\n";
    }
    print "          -help                                       {this info}\n";
    exit -2;
}


=item C<verify>

############################################################
verify

setup the default value for a spcific value

=cut

sub verify
{
    my ($self, $topic) = @_;
    
    foreach my $cfg ( @{ $self->{cfg}->{OUTPUT} } ) {
      if ($cfg->{topic} eq $topic) {
          $self->{$topic} = $cfg->{extension};
          last;
      }
    }
    return $self->{$topic};
}

#########################################################################
1;
__END__

=back

=head1 EXAMPLES

Show how we use this module

=cut