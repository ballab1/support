package logger::KafkaLogger;         
=head1 NAME
logger::KafkaLogger

=head1 DESCRIPTION 
Original file: KafkaLogger.pm
This software outputs records to a CSV file


The following methods are provided:
C<new>  C<header>   C<close>   C<logger>

=head1 COPYRIGHT
(C) 2013 - 2014 EMC

=head1 AUTHOR
Bob Ballantyne  2014/11/02

=head1 SEE ALSO


########################################################################

=head2 Methods

=over 12

=cut

use warnings;
use strict;

#  allow use of 'given' while' and 'say'
use feature ":5.18";
no if $] >= 5.018, warnings => 'experimental::smartmatch';


use Exporter;
use JSON;
use Kafka::Librd;

our $VERSION     = '1.00';
our @ISA         = qw(Exporter);
our @EXPORT_OK   = qw(close logger);

 
# Global variables
use constant {
    DEFAULT_BROKER => '10.1.3.11:9092'
};
 
=item C<new>

############################################################
constructor

my $log = unity::logger::CsvLogger->new($filename, \@columnDefs)

The constructor returns a new C<unity::common::CsvLogger> object which 
will output records to a CSV file

=cut

sub new
{
    my ( $class, $config ) = @_;

    my $self = {
        server => DEFAULT_BROKER,
        records => 0,
        debug => 0,
        client => 0,
        group => 0,
        partition => 0,
        topic => undef,
        msgflags => undef,
        compression_codec => undef,
        keys => undef
    };
    bless( $self, $class );

#Kafka::Internals::debug_level( $flags )

    die("FATAL: No topic defined!\n")  unless (defined $config->{'topic'});

    for my $option (keys %{ $config }) {
         my $value = $config->{$option};
         next unless (defined $value);
         given ($option) {
            when (['debug']) {
                $self->{$option} = 1 if $value;
            }
            when (['client', 'group', 'partition', 'server', 'topic', 'msgflags', 'compression_codec', 'key']) {
                $self->{$option} = $value;
            }
            default { die "Unknown option: $option,  value: $value" }
        }
    }

    # When debugging, show the librdkakfa version
#    print STDERR "Using rdkafka version: " . Kafka::Librd::rd_kafka_version_str if $self->{debug};

    my $params = { "client.id" => $self->{client},
                   "group.id" => $self->{group}
                  };

    my $kafka = Kafka::Librd->new(Kafka::Librd::RD_KAFKA_PRODUCER, $params);
    $self->{kafka} = $kafka;

    # Configure the server
    $kafka->brokers_add($self->{server});
    say STDERR "Added broker" if $self->{debug}; 

    my $topic = $kafka->topic($self->{topic}, {});
    $self->{kafka_topic} = $topic;
    
    return $self;
}


=item C<DESTROY>

############################################################
# Shut down the Kafka connection

=cut
sub DESTROY {
    my $self = shift;
    my $kafka = $self->{kafka};

    if (defined $kafka) {
        print STDERR "Destroying Kafka producer..." if $self->{debug};
        $kafka->destroy;
        print STDERR "Waiting for destruction..." if $self->{debug};
        Kafka::Librd::rd_kafka_wait_destroyed(5000);
        print STDERR "Destruction complete" if $self->{debug};
    }
} 

=item C<logger>

############################################################
logger

   $log->logger()

outputs a record to a CSV file

=cut

sub logger
{
    my ($self, $results) = @_;
    
    try {
        my $json = JSON->new->allow_nonref;
        my $json_text = $json->encode( $results );

        my $topic = $self->{kafka_topic};
        if ($topic->produce($self->{partition}, 0, $json_text, $self->{key})) {
            $self->{records}++;
        }
    } 
    catch {
        my $error = $_;
        if ( $error->isa( 'Kafka::Exception' ) ) {
            warn 'Error: (', $error->code, ') ',  $error->message, "\n";
            exit;
        }
        die $error;
    };

}


#########################################################################
1;
__END__

=back

=head1 EXAMPLES

Show how we use this module

=cut