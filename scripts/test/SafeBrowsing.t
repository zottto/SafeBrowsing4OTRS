# --
# SafeBrowsing.t - SafeBrowsingObject tests
# Copyright (C) 2013 Marc Nilius, http://www.marcnilius.de/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --
use strict;
use warnings;
use utf8;

use vars (qw($Self));

our @ObjectDependencies = (
    'Kernel::System::SafeBrowsing',
);

my $SafeBrowsingObject = $Kernel::OM->Get('Kernel::System::SafeBrowsing');

# Test 1 - Single URL, no risk
my $Result = $SafeBrowsingObject->CheckUrl(
    URL => 'http://www.marcnilius.de',
);

$Self->Is(
    $Result->{Status},
    'Ok',
    'Check single URL, no security risk',
);

# Test 2 - Single URL, risky
$Result = $SafeBrowsingObject->CheckUrl(
    URL => 'http://ianfette.org/',
);

$Self->Is(
    $Result->{Status},
    'Warning',
    'Check single URL, security risk',
);

$Self->Is(
    $Result->{URL}->{'http://ianfette.org/'},
    'malware',
    'Check single URL, security risk',
);

# Test 3 - Multiple URLs, all ok
my @URLs = ( 'http://www.marcnilius.de', 'http://www.seofacts.info' );
$Result = $SafeBrowsingObject->CheckUrl(
    URL => \@URLs,
);

$Self->Is(
    $Result->{Status},
    'Ok',
    'Check multiple URLs, no security risk',
);

# Test 4 - Multiple URLs, at least one is risky
@URLs = ( 'http://www.marcnilius.de', 'http://www.seofacts.info', 'http://ianfette.org/' );
$Result = $SafeBrowsingObject->CheckUrl(
    URL => \@URLs,
);

$Self->Is(
    $Result->{Status},
    'Warning',
    'Check multiple URLs, at least one risky',
);

$Self->Is(
    $Result->{URL}->{'http://ianfette.org/'},
    'malware',
    'Check multiple URLs, at least one risky',
);

1;
