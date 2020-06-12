({
   // fetch picklist values dynamic from apex controller 
    fetchPickListVal: function(component, fieldName, picklistOptsAttributeName) {
        var action = component.get("c.getselectOptions");
        action.setParams({
            "objObject": component.get("v.objInfoForPicklistValues"),
            "fld": fieldName
        });
        var opts = [];
        action.setCallback(this, function(response) {
            if (response.getState() == "SUCCESS") {
                var allValues = response.getReturnValue();
 
                if (allValues != undefined && allValues.length > 0) {
                    opts.push({
                        //class: "optionClass",
                        label: "--- None ---",
                        value: ""
                    });
                }
                for (var i = 0; i < allValues.length; i++) {
                    opts.push({
                        //class: "optionClass",
                        label: allValues[i],
                        value: allValues[i]
                    });
                }
                component.set("v." + picklistOptsAttributeName, opts);
            }
        });
        $A.enqueueAction(action);
    },
    updaterecords: function(component, event, helper) {
         var cmpEvent = component.getEvent("UpdatedRecs");
         cmpEvent.setParams({
         "selectedApp" : component.get("v.singleRec")});
        cmpEvent.fire();
    },
    getApplicationURL: function(component, event) {
        var action = component.get("c.getApplicationURL");
         var appId = component.get("v.singleRec.Id");
         action.setParams({  applicationid : appId});
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var result = response.getReturnValue();
                  component.set("v.contentVersionObj", result);
                //component.set('v.showSpinner', false);
            }
        });
        $A.enqueueAction(action);
    },
})