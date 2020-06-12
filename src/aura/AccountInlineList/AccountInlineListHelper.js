({
    doInitHelper: function(component, event) {

        var action = component.get("c.getVentures");
        
        action.setCallback(this,function(response) {

            var state = response.getState();
            
            if (state === "SUCCESS") {
                
                var lstSiteToStreamWrapper = response.getReturnValue();

                console.log('## lstSiteToStreamWrapper : ',lstSiteToStreamWrapper);

                if(lstSiteToStreamWrapper.length > 0) {

                    component.set('v.lstSiteToStreamWrapper',lstSiteToStreamWrapper);
                } else {

                    component.set("v.hasNoRecords", true);
                }
            } else if(state === "ERROR") {

                var errors = response.getError();
                if (errors) {

                    if (errors[0] && errors[0].message) {

                        console.log("Error message: ",errors[0].message);
                    }
                } else {

                    console.log("Unknown error");
                }
            }
        });
        
        $A.enqueueAction(action);
    }
})