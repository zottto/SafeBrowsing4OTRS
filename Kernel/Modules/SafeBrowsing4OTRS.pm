# --
# Kernel/Modules/SafeBrowsing4OTRS.pm - SafeBrowsing4OTRS module
# Copyright (C) 2014 Marc Nilius, http://www.marcnilius.de/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Modules::SafeBrowsing4OTRS;

use strict;
use warnings;

our @ObjectDependencies = (
    'Kernel::System::SafeBrowsing',
);

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {%Param};
    bless( $Self, $Type );

    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;
    my $Content = '';

    # get params
    my $ArticleID
        = $Kernel::OM->Get('Kernel::System::Web::Request')->GetParam( Param => 'ArticleID' );

    my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');
    if ( !$ArticleID ) {
        $LayoutObject->Block(
            Name => 'ErrorNoArticle',
        );

        $Content = $LayoutObject->Output(
            TemplateFile => 'SafeBrowsing4OTRS',
        );

        return $LayoutObject->Attachment(
            ContentType => 'text/html',
            Charset     => $LayoutObject->{UserCharset},
            Content     => $Content,
            Type        => 'inline',
            NoCache     => 1,
        );
    }

    my %Article = $Kernel::OM->Get('Kernel::System::Ticket')->ArticleGet(
        ArticleID     => $ArticleID,
        DynamicFields => 0,
    );

    my $Text = $Article{Body};

    my %URLs;
    while (
        $Text
        =~ /((http(?:s)?\:\/\/[a-zA-Z0-9\-]+(?:\.[a-zA-Z0-9\-]+)*\.[a-zA-Z]{2,6}(?:\/?|(?:\/[\w\-]+)*)(?:\/?|\/\w+\.[a-zA-Z]{2,4}(?:\?[\w]+\=[\w\-]+)?)?(?:\&[\w]+\=[\w\-]+)*))/g
        )
    {
        $URLs{$1} = 1;
    }

    my @URLList = keys %URLs;
    my $Result;

    if ( scalar @URLList > 0 ) {
        $Result = $Kernel::OM->Get('Kernel::System::SafeBrowsing')->CheckUrl(
            URL => \@URLList,
        );
    }

    if ( scalar @URLList == 0 || $Result && $Result->{'Status'} eq 'Ok' ) {
        $LayoutObject->Block(
            Name => 'LinksSafe',
        );
    }

    elsif ( $Result->{'Status'} eq 'Warning' ) {
        $LayoutObject->Block(
            Name => 'LinksWarning',
        );

        my $Phishing = 0;
        my $Malware  = 0;

        for ( sort keys $Result->{URL} ) {
            if ( $Result->{URL}->{$_} eq 'malware' ) {
                $Malware++;
            }

            if ( $Result->{URL}->{$_} eq 'phishing' ) {
                $Phishing++;
            }

            $LayoutObject->Block(
                Name => 'LinksWarningURL',
                Data => {
                    URL     => $_,
                    Warning => $Result->{URL}->{$_},
                },
            );
        }

        if ($Malware) {
            $LayoutObject->Block(
                Name => 'LinksWarningMalware',
            );
        }

        if ($Phishing) {
            $LayoutObject->Block(
                Name => 'LinksWarningPhishing',
            );
        }
    }

    else {
        $LayoutObject->Block(
            Name => 'ErrorAPI',
        );
    }

    $Content = $LayoutObject->Output(
        TemplateFile => 'SafeBrowsing4OTRS',
    );

    return $LayoutObject->Attachment(
        ContentType => 'text/html',
        Charset     => $LayoutObject->{UserCharset},
        Content     => $Content,
        Type        => 'inline',
        NoCache     => 1,
    );
}

1;
