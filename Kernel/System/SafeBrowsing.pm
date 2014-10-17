# --
# Kernel/System/SafeBrowsing.pm - Provides the basic functions for SafeBrowsing4OTRS
# Copyright (C) 2013 Marc Nilius, http://www.marcnilius.de/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::System::SafeBrowsing;

use strict;
use warnings;

use LWP::UserAgent;

our @ObjectDependencies = (
    'Kernel::Config',
    'Kernel::System::Log',
);

=head1 NAME

Kernel::System::SafeBrowsing - basic functions for SafeBrowsing4OTRS

=head1 SYNOPSIS

Provides the basic functions for SafeBrowsing4OTRS

=head1 PUBLIC INTERFACE

=over 4

=cut

=item new()

create an object

    use Kernel::System::ObjectManager;
    local $Kernel::OM = Kernel::System::ObjectManager->new();
    my $SafeBrowsingObject = $Kernel::OM->Get('Kernel::System::SafeBrowsing');

=cut

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $Type );

    return $Self;
}

=item CheckUrl()

check one or more URLs with Google Safe Browsing


=cut

sub CheckUrl {
    my ( $Self, %Param ) = @_;

    # get API key from SysConfig
    my $ConfigObject = $Kernel::OM->Get('Kernel::Config');
    my $APIKey       = $ConfigObject->Get('SafeBrowsing::APIKey');

    # if SafeBrowsing is not active, stop execution
    if ( !$ConfigObject->Get('SafeBrowsing::Active') ) {
        $Kernel::OM->Get('Kernel::System::Log')
            ->Log( Priority => 'error', Message => 'SafeBrowsing not active!' );
        return;
    }

    # if no API key is given, stop execution
    if ( length($APIKey) == 0 ) {
        $Kernel::OM->Get('Kernel::System::Log')
            ->Log( Priority => 'error', Message => 'No SafeBrowsing API key!' );
        return;
    }

    # if no URL is given, stop execution
    if ( !$Param{URL} ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log( Priority => 'error', Message => 'Need URL!' );
        return;
    }

    # Define API-URL and Request object
    my $APIUrl
        = "https://sb-ssl.google.com/safebrowsing/api/lookup?client=SafeBrowsing4OTRS&apikey="
        . $APIKey
        . "&appver=1.5.2&pver=3.0";
    my $Request = HTTP::Request->new( POST => $APIUrl );

    # build post data
    my $URLCount = 0;
    my $URLList  = '';

    if ( ref $Param{URL} eq 'ARRAY' ) {
        $URLCount = scalar @{ $Param{URL} };
        $URLList = join( "\n", @{ $Param{URL} } );
    }
    else {
        $URLCount = 1;
        $URLList  = $Param{URL}
    }

    $Request->content( $URLCount . "\n" . $URLList );

    # send POST request and save response
    my $UserAgentObject = LWP::UserAgent->new();
    my $Response        = $UserAgentObject->request($Request);

    # error while checking (Bad Request, API key not valid, service unavailable)
    if ( $Response->code() == 400 || $Response->code() == 401 || $Response->code() == 503 ) {
        return { Status => 'Error' };
    }

    # all URLs are ok
    if ( $Response->code() == 204 ) {
        return { Status => 'Ok' };
    }

    # at least one URL must have a potential security risk
    my @Result = split( /\n/, $Response->decoded_content() );
    my %ResultHash;

    # map request response to the URLs we sent to the API
    if ( ref $Param{URL} eq 'ARRAY' ) {
        @ResultHash{ @{ $Param{URL} } } = @Result;
    }
    else {
        $ResultHash{ $Param{URL} } = $Result[0];
    }

    # get all risky URLs and there "type" (malware or phishing)
    my %Risky;
    for ( sort keys %ResultHash ) {
        if ( $ResultHash{$_} eq 'malware' || $ResultHash{$_} eq 'phishing' ) {
            $Risky{$_} = $ResultHash{$_};
        }
    }

    return {
        Status => 'Warning',
        URL    => \%Risky,
    };
}

1;

=back

=head1 TERMS AND CONDITIONS

This software comes with ABSOLUTELY NO WARRANTY. For details, see
the enclosed file COPYING for license information (AGPL). If you
did not receive this file, see L<http://www.gnu.org/licenses/agpl.txt>.

=cut
