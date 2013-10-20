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
    TargetNS.SafeBrowsingXHR = undefined;

    function CheckLinksOfActiveArticle() {
        var ArticleID = $('#ArticleTable tr.Active input:hidden.ArticleID').val(),
            Data = {};

        if (!ArticleID) {
            return;
        }

        Data = {
            Action: 'SafeBrowsing4OTRS',
            ArticleID: ArticleID
        };

        if (TargetNS.SafeBrowsingXHR) {
            TargetNS.SafeBrowsingXHR.abort();
            TargetNS.SafeBrowsingXHR = undefined;
        }

        TargetNS.SafeBrowsingXHR = Core.AJAX.FunctionCall(Core.Config.Get('Baselink'), Data, function (Response) {
            $('.SafeBrowsing.Checking').addClass('Hidden');
            $('.SafeBrowsing.Ok, .SafeBrowsing.Error, .SafeBrowsing.Warning').remove();
            $('.SafeBrowsing.Checking').after(Response);
        }, 'html');
    }

    /**
     * @function
     * @return nothing
     *      This function initializes the module functionality
     */
    TargetNS.Init = function () {
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
