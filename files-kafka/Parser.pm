package Parser;         
=head1 NAME
Parser

=head1 DESCRIPTION 

=head1 AUTHOR
Bob Ballantyne  2014/11/02

=head1 SEE ALSO

########################################################################

=head2 Methods

=over 12

=cut

use strict;
use warnings;
use Exporter 'import';
our $VERSION     = 1.00;

our @ISA         = qw(Exporter);
our @EXPORT_OK   = qw(processFile); 


use POSIX qw(strftime);
use IO::Dir;
use Crypt::Digest::SHA256 qw(sha256_file_hex);
use File::stat qw(:FIELDS);
use Cwd qw(abs_path);

use utilities::hashes qw(copyHash);
use utilities::string qw(trim);
use utilities::formattime qw(getTime);


#-- GLOBALS -------------------------------------------------------
use constant {
    DEFAULT_LOG => 'kafkaLogger',
    FILES_RESULTS => 'fileHashes',
    SCAN_RESULTS => 'scanResults'
};    

#['client', 'group', 'partition', 'server', 'topic', 'msgflags', 'compression_codec', 'keys']
use constant {
   SCANSDEF => { 'topic' => SCAN_RESULTS,
                 'comment' => '-' . SCAN_RESULTS . q#          Kafka topic name#,
                 'debug' => undef,
                 'group' => 0,
                 'client' => 0,
                 'partition' => 0,
                 'msgflags' => 0,
                 'compression_codec' => 0,
                 'key' => 0
                 },
   FILESDEF => { 'topic' => FILES_RESULTS,
                 'comment' => '-' . FILES_RESULTS . q#         Kafka topic name#,
                 'debug' => 0,
                 'group' => 0,
                 'client' => 0,
                 'partition' => 0,
                 'msgflags' => 0,
                 'compression_codec' => 0,
                 'key' => 0
               }
};


use constant {
    CONFIG_DATA => { INPUT_LOG => DEFAULT_LOG . '.txt',
                     OUTPUT => [ FILESDEF, SCANSDEF ]
                    }
};

sub processFile($$)
{
    my ($input, $parser) = @_;
    
    # get the current time #
    my $now = time;    
    
    my $parsedCount = $parser->parse($input);

    my $warningsCount = $parser->reportWarnings();
    
    # print summary of what was done #
    print "\n\nParsed ".$parsedCount.' records read';
    print '.    '.$warningsCount.' warnings detected '  if ($warningsCount > 0);

    # Calculate total runtime (current time minus start time) #
    $now = time - $now;
    # Print runtime #
    printf("\nTotal running time: %02d:%02d:%02d\n\n", int($now / 3600), int(($now % 3600) / 60), int($now % 60));
    
    return 1;
}

=item C<new>

############################################################
constructor

my $logEntry = Parser->new()

The constructor returns a new C<unity::rpmsShare::rpmsShare> object which encapsulate
the all required parsing for logEntry records from wssetup/wsupdate

=cut

sub new
{
    my ( $class, $params ) = @_;

    my $self = {};
    bless( $self, $class );

    # setup default values
    $self->{id} = 0 unless (exists $self->{id});
    $self->{start_tm} = time();
    $self->{tm} = getTime($self->{start_tm});
    $self->{dirs} = 0;
    $self->{links} = 0;
    $self->{emptyfiles} = 0;
    $self->{regfiles} = 0;
    $self->{total} = 0;
    $self->{size} = 0;
    copyHash($params, $self);
#    $self->{WARNINGS} = {};

    return $self;
}

=item C<close>

############################################################
close method

$logger->close()

closes all the CsvLoggers used by the defined instance of the LogParser

=cut

sub close()
{
    my ($self) = @_;

    my $results = {};
    $results->{id} = $self->{id}; 
    $results->{tm} = $self->{tm}; 
    $results->{dirs} = $self->{dirs};
    $results->{links} = $self->{links};
    $results->{emptyfiles} = $self->{emptyfiles};
    $results->{regfiles} = $self->{regfiles};
    $results->{total} = $self->{regfiles} + $self->{emptyfiles} +  $self->{links};
    $results->{duration} = time() - $self->{start_tm};
    $results->{size} = $self->{size};
    $self->{SCAN_RESULTS()}->logger($results);
    
    for my $cfg ( @{ CONFIG_DATA()->{OUTPUT} }) {
        my $key = $cfg->{topic};
        $self->{$key}->close();
    }

    print "\nTotal of $results->{dirs} folders scanned";
    print "\n         $results->{links} links detected";
    print "\n         $results->{emptyfiles} empty files detected";
    print "\n         $results->{regfiles} regular files detected";
    print "\n         detected total of $results->{total} files/folders/links";
    print "\n         size of all files: $results->{size}";
    print "\n         duration of scan: $results->{duration} (secs)";
}

=item C<parse>

############################################################
parse method

$logger->parse($strLineToParse)

parses the given line

=cut

sub parse($)
{
    my ($self, $shareDir) = @_;

    return 0  if (! defined $shareDir || length($shareDir) <= 1);

    chomp($shareDir);
    $shareDir = trim($shareDir);
    $self->{size} += $self->checkDir($shareDir.'/');
    
    return 1;
}

=item C<reportWarnings>

############################################################
report parser warnings  (part of public interface)

$logger->reportWarnings()

reports any NON-FATAL parser issues

=cut

sub reportWarnings()
{
    my ($self) = @_;
    return 0;
}


#########################################################################
#
#########################################################################
sub isValid($)
{
    my ($self, $tm) = @_;
    return ((! defined $self->{LAST_ENTRY}) or ($self->{LAST_ENTRY} lt $tm));
}

=item C<hashToJsonQuery>

############################################################
checkDir

create a JSON query based on the structure of a hash

=cut

sub checkDir($)
{
    my ($self, $path) = @_;
    my $dirSize = 0;

    $self->{dirs}++;
    my %dir;
    tie %dir, 'IO::Dir', $path;
    foreach (keys %dir)
    {
        next if ( $_ eq '.' || $_ eq '..' );

        my $shareDir = $path . $_;
        my $size =  $self->checkDir($shareDir . '/')  if ( -d $shareDir  and not -l $shareDir );
        my $results = $self->logEntry($path, $_, $dir{$_}, $size);
        $dirSize += $results->{size};
    }
    untie %dir;

    return $dirSize;
}

sub logEntry($$$)
{
    my ($self, $path, $name, $st, $size) = @_;
    my $results = {};

    $results->{tm} = $self->{tm};
    $results->{name} = $name; 
    $results->{path} = substr($path,0,-1); 
    $results->{size} = 0; 
    if (defined $st)
    {
        $results->{inode} = $st->ino; 
        if ( ($st->mode & 020000) != 0 )
        {
            $results->{type} = 'symbolic link';
            my $link = readlink($path.$name); 
            $link = $path.$link  unless ( $link =~ /^\// );
            $results->{target} = abs_path($link);
            $self->{links}++;
        }
        elsif ( ($st->mode & 040000) != 0 )
        {
            $results->{type} = 'directory'; 
            $results->{size} = $size; 
        }
        elsif ( $st->size > 0 )
        {
            $results->{type} = 'regular file' ; 
            $results->{size} = $st->size;
            $results->{sha} = sha256_file_hex($path.$name);
            $self->{emptyfiles}++;
        }
        else
        {
            $results->{type} = 'regular empty file'; 
            $self->{regfiles}++;
        }
        $results->{permission} = ($st->mode & 0777); 
        $results->{owner} = getpwuid($st->uid);
        $results->{group} = getgrgid($st->gid);
        $results->{lastmodified} = getTime($st->mtime);
    }
    $self->{FILES_RESULTS()}->logger($results);
    
    return $results;
}

#########################################################################
1;
__END__

=back

=head1 EXAMPLES

Show how we use this module

=cut