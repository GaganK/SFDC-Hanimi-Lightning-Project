({
    doInit: function(component, event, helper) {
        var myAction = component.get("c.fetchUserId"); 
        myAction.setCallback(this, function(response) { 
          if(response.getState() === "SUCCESS") { 
            component.set("v.loggedinUserId", response.getReturnValue()); 
        }}); 
        $A.enqueueAction(myAction); 
        helper.doInitHelper(component, event);
    },
    /* javaScript function for pagination */
    navigation: function(component, event, helper) {
        var sObjectList = component.get("v.listOfAllAccounts");
        var end = component.get("v.endPage");
        var start = component.get("v.startPage");
        var pageSize = component.get("v.pageSize");
        var whichBtn = event.getSource().get("v.name");
        // check if whichBtn value is 'next' then call 'next' helper method
        if (whichBtn == 'next') {
            component.set("v.currentPage", component.get("v.currentPage") + 1);
            helper.next(component, event, sObjectList, end, start, pageSize);
        }
        // check if whichBtn value is 'previous' then call 'previous' helper method
        else if (whichBtn == 'previous') {
            component.set("v.currentPage", component.get("v.currentPage") - 1);
            helper.previous(component, event, sObjectList, end, start, pageSize);
        }
    }
})