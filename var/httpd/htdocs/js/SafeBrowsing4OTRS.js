// --
// SafeBrowsing4OTRS.js - provides the functions for the SafeBrowsing4OTRS module
// Copyright (C) 2013 Marc Nilius, http://www.marcnilius.de/
// --
// This software comes with ABSOLUTELY NO WARRANTY. For details, see
// the enclosed file COPYING for license information (AGPL). If you
// did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
// --

"use strict";

/**
 * @namespace
 * @exports TargetNS as SafeBrowsing4OTRS
 * @description
 *      This namespace contains all functions for the SafeBrowsing4OTRS module.
 */
var SafeBrowsing4OTRS = (function (TargetNS) {
    var Config;

    TargetNS.SafeBrowsingXHR = undefined;

    function CheckLinksOfActiveArticle() {
        var ArticleID = $('#ArticleTable tr.Active input:hidden.ArticleID').val(),
            $ArticleDirection = $('#ArticleTable tr.Active td.Direction span.Direction'),
            Data = {};

        if (!ArticleID) {
            return;
        }

        // If only external articles should be checked and the active article has not
        // the direction of Incoming, than do not check this article
        if (parseInt(Config.OnlyExternal, 10) > 0 && !$ArticleDirection.hasClass('Incoming')) {
            return;
        }

        Data = {
            Action: 'SafeBrowsing4OTRS',
            ArticleID: ArticleID
        };

        // If the user switches to another article while this check is still running,
        // stop the old ajax request and start the  one for the new article
        if (TargetNS.SafeBrowsingXHR) {
            TargetNS.SafeBrowsingXHR.abort();
            TargetNS.SafeBrowsingXHR = undefined;
        }

        $('.SafeBrowsing.Checking').show();

        TargetNS.SafeBrowsingXHR = Core.AJAX.FunctionCall(Core.Config.Get('Baselink'), Data, function (Response) {
            // although we stop the old ajax request (see above), in some race conditions
            // this callback function is still executed for the old ajax request
            // we check, if the ArticleId is still the same and do not update the
            // info box, if the ArticleID has changed
            var LatestArticleID = $('#ArticleTable tr.Active input:hidden.ArticleID').val();

            if (ArticleID !== LatestArticleID) {
                return;
            }

            $('.SafeBrowsing.Checking').addClass('Hidden').hide();
            $('.SafeBrowsing.Ok, .SafeBrowsing.Error, .SafeBrowsing.Warning').remove();
            $('.SafeBrowsing.Checking').after(Response);

            // If FadeOut is configured, initialize it
            if (parseInt(Config.FadeOut, 10) > 0) {
                window.setTimeout(function () {
                    $('.SafeBrowsing.Ok').fadeOut();
                }, parseInt(Config.FadeOutTime, 10) || 2000);
            }
        }, 'html');
    }

    /**
     * @function
     * @return nothing
     *      This function initializes the module functionality
     */
    TargetNS.Init = function (ConfigParams) {
        Config = ConfigParams;

        // check active article
        CheckLinksOfActiveArticle();

        // subscribe to event to also check links of a later selected article
        // this callback is called for every ContentUpdate call in AgentTicketZoom
        // which can be more than only the ArticleUpdates
        // only if the response contains the string "ArticleMailContent" we call the check function
        Core.App.Subscribe('Event.AJAX.ContentUpdate.Callback', function (Response) {
            if (Response.match(/ArticleMailContent/)) {
                // avoid side-effects and wait some milliseconds
                window.setTimeout(function () {
                    CheckLinksOfActiveArticle();
                }, 200);
            }
        });
    };

    return TargetNS;
}(SafeBrowsing4OTRS || {}));
