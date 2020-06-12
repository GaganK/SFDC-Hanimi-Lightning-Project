({
	save : function(component, event) {

        console.log('## Save called helper in child');

        var action = component.get("c.updatePartnerQuestion");

        action.setParams({

            'partnerQuestion': component.get("v.singleRec")
        });
        
        action.setCallback(this,function(response) {

            var state = response.getState();

            console.log('## state : ',state);
            
            if (state === "SUCCESS") {
                
                component.set("v.singleRec",response.getReturnValue());
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