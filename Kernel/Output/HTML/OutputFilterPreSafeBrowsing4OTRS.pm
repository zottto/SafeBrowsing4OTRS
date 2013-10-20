# --
# Kernel/Output/HTML/OutputFilterPreSafeBrowsing4OTRS.pm
# Copyright (C) 2013 Marc Nilius, http://www.marcnilius.de/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Output::HTML::OutputFilterPreSafeBrowsing4OTRS;

use strict;
use warnings;

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {%Param};
    bless( $Self, $Type );

    # check needed objects
    for my $Needed (qw(ConfigObject LogObject TimeObject MainObject EncodeObject)) {
        if ( !$Self->{$Needed} ) {
            $Self->{LayoutObject}->FatalError( Message => "Got no $Needed!" );
        }
    }

    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;

    # get template name
    my $TemplateName = $Param{TemplateFile};

    return 1 if !$TemplateName;

    # get output filter pre configs
    my $OutputFilterPreConfigs = $Self->{ConfigObject}->Get('Frontend::Output::FilterElementPre');

    return if !$OutputFilterPreConfigs;
    return if ref $OutputFilterPreConfigs ne 'HASH';

    # extract output filter config
    my $OutputFilterConfig = $OutputFilterPreConfigs->{OutputFilterPreSafeBrowsing4OTRS};

    return if !$OutputFilterConfig;
    return if ref $OutputFilterConfig ne 'HASH';

    # get valid modules
    my $ValidTemplates = $OutputFilterConfig->{Templates};

    return if !$ValidTemplates;
    return if ref $ValidTemplates ne 'HASH';

    # apply only if template is valid in config
    return 1 if !$ValidTemplates->{$TemplateName};

    if ( $Self->{ConfigObject}->Get('SafeBrowsing::Active') ) {
        my $SafeBrowsing = <<"EOF";
<div class="SafeBrowsing Checking">
    Checking article links for security risks...
</div>
<!-- dtl:js_on_document_complete -->
<script type="text/javascript">//<![CDATA[
    SafeBrowsing4OTRS.Init();
//]]></script>
<!-- dtl:js_on_document_complete -->
EOF

        ${ $Param{Data} }
            =~ s{(<div \s* class="ArticleMailContent">)}{$1$SafeBrowsing}xms;
    }

    return 1;
}

1;
