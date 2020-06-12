({
    /*call apex controller method "fetchAttachments" to get salesforce file records*/
    doInit : function(component, event, helper) {
        var action = component.get("c.fetchAttachments");
        action.setCallback(this, function(response) {
            var state = response.getState();
            var urlString = window.location.href;
             var baseURL = urlString.substring(0, urlString.indexOf("/s"));
             component.set("v.cbaseURL", baseURL);
            if (state === "SUCCESS") {
                component.set('v.lstAttachments', response.getReturnValue());
            }
            else if (state === "INCOMPLETE") {
            }
                else if (state === "ERROR") {
                    var errors = response.getError();
                    if (errors) {
                        if (errors[0] && errors[0].message) {
                            console.log("Error message: " + 
                                        errors[0].message);
                        }
                    } else {
                        console.log("Unknown error");
                    }
                }
        });
        $A.enqueueAction(action);  
    }
    
})