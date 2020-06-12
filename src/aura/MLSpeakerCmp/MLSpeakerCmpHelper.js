({
    doInitHelper : function(component,event, helper){ 
        var action = component.get("c.fetchMLspeakerwrapper");
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS"){
                var oRes = response.getReturnValue();
                if(oRes.length > 0){
                     //alert('oRes'+oRes[0].conDocId);
                    component.set('v.listOfAllContacts', oRes);
                }
            }
            else{
                alert('Error...');
            }
        });
        $A.enqueueAction(action);  
    }
})