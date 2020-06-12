({
    doInit : function(component, event, helper) {

        component.set("v.loggedinUserId", $A.get("$SObjectType.CurrentUser.Id"));
        helper.doInitHelper(component, event);
    },

    navigateToWebsite : function(component, event, helper) {

        var selectedItem = event.currentTarget;
        var websiteURL = selectedItem.dataset.record;

        if (websiteURL === '' || websiteURL === null || websiteURL === undefined) {

            return;
        }

        if (!websiteURL.startsWith('http') || !websiteURL.startsWith('https')) {

            websiteURL = 'https://' + websiteURL;
        }

        var urlEvent = $A.get("e.force:navigateToURL");
        urlEvent.setParams({
            "url": websiteURL
        });
        urlEvent.fire();
    },

    showSpinner: function(component, event, helper) {

        component.set("v.isProcessing", true);
    },

    hideSpinner: function(component, event, helper) {

        component.set("v.isProcessing", false);
    }
})