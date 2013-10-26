# --
# Kernel/Language/de_SafeBrowsing.pm - translation file
# Copyright (C) 2013 Marc Nilius, http://www.marcnilius.de/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Language::de_SafeBrowsing;

use strict;
use warnings;

sub Data {
    my $Self = shift;

    # Outputfilter
    $Self->{Translation}->{'Checking article links for security risks...'} = 'Artikellinks werden auf Sicherheitsrisiken überprüft...';

    # Template: SafeBrowsing4OTRS
    $Self->{Translation}->{'No ArticleID given!'} = 'Keine ArticleID angegeben!';
    $Self->{Translation}->{'According to the'} = 'Basierend auf den Informationen der';
    $Self->{Translation}->{'Google Safe Browsing database'} = 'Google Safe Browsing Datenbank';
    $Self->{Translation}->{', all links and URLs in this article are safe.'} = ' sind alle Links und URLs in diesem Artikel sicher.';
    $Self->{Translation}->{', at least one of the links and URLs in this article is potentially unsafe. Please see the following list for details.'} =
        ' ist mindestens einer der Links oder URLs in diesem Artikel potentiell unsicher. Bitte prüfen Sie die folgende Liste für weitere Details.';
    $Self->{Translation}->{'Advisory provided by Google'} = 'Informationen zur Vefügung gestellt durch Google';
    $Self->{Translation}->{'Malware Warning'} = 'Malware-Warnung';
    $Self->{Translation}->{'Visiting these web sites may harm your computer. These pages appear to contain malicious code that could be downloaded to your computer without your consent. You can learn more about harmful web content including viruses and other malicious code and how to protect your computer at'} =
        'Das Besuchen dieser Websites kann ihrem Computer Schaden zufügen. Diese Seiten scheinen Schadcode zu enthalten, der sich ohne ihr Zutun auf ihren Computer lädt. Lernen Sie mehr über gefährliche Web-Inhalte wie Viren oder anderer Schadcode und wie sie ihren Computer davor schützen können unter';
    $Self->{Translation}->{'Phishing Warning'} = 'Phishing-Warnung';
    $Self->{Translation}->{'Suspected phishing pages. These pages may be a forgery or imitation of another website, designed to trick users into sharing personal or financial information. Entering any personal information on these pages may result in identity theft or other abuse. You can find out more about phishing from'} =
        'Vermutliche Phishing-Websites. Diese Seiten könnten eine Fälschung oder Imitation einer anderen Website sein, die darauf angelegt ist, die Besucher der Seite dazu zu bringen, persönliche oder finanzielle Informationen anzugeben. Die Eingabe solcher Informationen auf diesen Seiten könnte in einem Identitätsklau oder anderem Mißbrauch enden. Mehr Informationen zu Phishing erhalten sie von';
    $Self->{Translation}->{'Error connecting to the Google Safe Browsing database. Possibly your API key is invalid. Please contact your OTRS Administrator.'} =
        'Fehler beim Verbinden zur Google Safe Browsing Datenbank. Vermutlich ist ihr API-Schlüssel ungültig. Bitte kontaktieren sie ihren OTRS-Administrator.';

    # SysConfig
    $Self->{Translation}->{'Activates Safe Browsing feature.'} = 'Safe Browsing-Funktion aktivieren';
    $Self->{Translation}->{'Always show message'} = 'Hinweis immer anzeigen';
    $Self->{Translation}->{'Check all articles'} = 'Alle Artikel prüfen';
    $Self->{Translation}->{'Check only incoming / external messages'} = 'Nur externe / eingehende Nachrichten prüfen';
    $Self->{Translation}->{'Fade out message after some seconds'} = 'Hinweis nach wenigen Sekunden ausblenden';
    $Self->{Translation}->{'Frontend module registration for SafeBrowsing4OTRS.'} = 'Frontend-Modul-Registrierung für SafeBrowsing4OTRS';
    $Self->{Translation}->{'If the module does not find any potentially unsafe links and URLs, fade out the info message after some seconds.'} =
        'Wenn das Modul keine potentiell unsichere Links oder URLs findet, dann soll der Hinweis darauf nach wenigen Sekunden ausgeblendet werden.';
    $Self->{Translation}->{'Inactive'} = 'Inaktiv';
    $Self->{Translation}->{'Only check incoming messages for potentially unsafe links and URLs.'} =
        'Nur eingehende Nachrichten auf potentiell unsichere Links und URLs prüfen';
    $Self->{Translation}->{'Output filter to add SafeBrowsing to the TicketZoom.'} = 'Output-Filter, um SafeBrowsing zum TicketZoom hinzuzufügen.';
    $Self->{Translation}->{'The Google Safe Browsing API key. You can get your API key here: https://developers.google.com/safe-browsing/key_signup.'} =
        'Der API-Schlüssel für Google Safe Browsing. Sie erhalten ihren Schlüssel hier: https://developers.google.com/safe-browsing/key_signup.';
    $Self->{Translation}->{'The number of milliseconds to wait until the message will be faded out (1000 milliseconds = 1 second).'} =
        'Die Anzahl an Millisekunden die gewartet wird, bevor der Hinweis ausgeblendet wird (1000 Millisekunden = 1 Sekunde).';

    #
    # OBSOLETE ENTRIES FOR REFERENCE, DO NOT TRANSLATE!
    #

}

1;
