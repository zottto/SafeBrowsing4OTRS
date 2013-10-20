# --
# Kernel/Modules/SafeBrowsing4OTRS.pm - SafeBrowsing4OTRS module
# Copyright (C) 2013 Marc Nilius, http://www.marcnilius.de/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Modules::SafeBrowsing4OTRS;

use strict;
use warnings;

use Kernel::System::SafeBrowsing;

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {%Param};
    bless( $Self, $Type );

    # check needed objects
    for my $Needed (
        qw(ParamObject DBObject TicketObject LayoutObject LogObject QueueObject ConfigObject UserObject SessionObject)
        )
    {
        if ( !$Self->{$Needed} ) {
            $Self->{LayoutObject}->FatalError( Message => "Got no $Needed!" );
        }
    }

    $Self->{SafeBrowsingObject} = Kernel::System::SafeBrowsing->new(%Param);

    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;
    my $Content = '';

    # get params
    my $ArticleID = $Self->{ParamObject}->GetParam( Param => 'ArticleID' );

    if ( !$ArticleID ) {
        $Self->{LayoutObject}->Block(
            Name => 'ErrorNoArticle',
        );

        $Content = $Self->{LayoutObject}->Output(
            TemplateFile => 'SafeBrowsing4OTRS',
        );

        return $Self->{LayoutObject}->Attachment(
            ContentType => 'text/html',
            Charset     => $Self->{LayoutObject}->{UserCharset},
            Content     => $Content,
            Type        => 'inline',
            NoCache     => 1,
        );
    }

    my %Article = $Self->{TicketObject}->ArticleGet(
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
        $Result = $Self->{SafeBrowsingObject}->CheckUrl(
            URL => \@URLList,
        );
    }

    if ( scalar @URLList == 0 || $Result && $Result->{'Status'} eq 'Ok' ) {
        $Self->{LayoutObject}->Block(
            Name => 'LinksSafe',
        );
    }

    elsif ( $Result->{'Status'} eq 'Warning' ) {
        $Self->{LayoutObject}->Block(
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

            $Self->{LayoutObject}->Block(
                Name => 'LinksWarningURL',
                Data => {
                    URL     => $_,
                    Warning => $Result->{URL}->{$_},
                },
            );
        }

        if ($Malware) {
            $Self->{LayoutObject}->Block(
                Name => 'LinksWarningMalware',
            );
        }

        if ($Phishing) {
            $Self->{LayoutObject}->Block(
                Name => 'LinksWarningPhishing',
            );
        }
    }

    else {
        $Self->{LayoutObject}->Block(
            Name => 'ErrorAPI',
        );
    }

    $Content = $Self->{LayoutObject}->Output(
        TemplateFile => 'SafeBrowsing4OTRS',
    );

    return $Self->{LayoutObject}->Attachment(
        ContentType => 'text/html',
        Charset     => $Self->{LayoutObject}->{UserCharset},
        Content     => $Content,
        Type        => 'inline',
        NoCache     => 1,
    );
}

1;
