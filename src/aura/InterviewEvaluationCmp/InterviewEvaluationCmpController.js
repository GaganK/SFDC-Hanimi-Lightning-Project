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
        var sObjectList = component.get("v.listOfAllApplications");
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
    },
    selectedRow: function(component, event, helper) {
        //component.set('v.showSpinner', true);
      var selectedItem = event.currentTarget;
          var recId = selectedItem.dataset.record;
        component.set("v.selectedEvaluationId",recId);
         helper.getContacts(component, helper);
        
    }, handleLoad: function(cmp, event, helper) {
        cmp.set('v.showSpinner', false);
        
    },

    handleSubmit: function(cmp, event, helper) {
         event.preventDefault(); 
        var fields = event.getParam('fields');
         fields.CDL_Evaluator__c = cmp.get("v.loggedinUserId");
        fields.Application__c =  cmp.get("v.selectedEvaluationId");
        cmp.find('myRecordForm').submit(fields);
        cmp.set('v.disabled', true);
        cmp.set('v.showSpinner', true);
    },

    handleError: function(cmp, event, helper) {
        // errors are handled by lightning:inputField and lightning:nessages
        // so this just hides the spinnet
        cmp.set('v.showSpinner', false);
        
    },
    handleSuccess: function(cmp, event, helper) {
        cmp.set('v.showSpinner', false);
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "title": "Success!",
            "message": "The record has been updated successfully."
        });
        toastEvent.fire();
       cmp.find('fieldId').forEach(function(f) {
            f.reset();
        });
    }
})