({
    initRecords: function(component, event, helper) {
       helper.getStreamPotential(component, event);
     helper.doInitHelper(component, helper);
    },
     getApplicationRecords : function(component, event, helper){
        helper.doInitHelper(component, helper);
        component.set("v.isModalOpen", false);
         //$A.get('e.force:refreshView').fire(); 
    },openModel: function(component, event, helper) {
        // Set isModalOpen attribute to true
        component.set("v.isModalOpen", true);
     },
    
     closeModel: function(component, event, helper) {
        // Set isModalOpen attribute to false  
        component.set("v.isModalOpen", false);
     },
    Save: function(component, event, helper) {
      // Check required fields(Name) first in helper method which is return true/false
       // if (helper.requiredValidation(component, event)){
              // call the updateApplication apex method for update inline edit fields update 
               var action = component.get("c.updateApplication");
                  action.setParams({
                    'app': component.get("v.ApplicationList")
                  });
            action.setCallback(this, function(response) {
                var state = response.getState();
                if (state === "SUCCESS") {
                    var storeResponse = response.getReturnValue();
                    // set ApplicationList list with return value from server.
                    component.set("v.ApplicationList", storeResponse);
                    // Hide the save and cancel buttons by setting the 'showSaveCancelBtn' false 
                    component.set("v.showSaveCancelBtn",false);
                   // alert('Updated...');
                    $A.get('e.force:refreshView').fire(); 
                }
            });
            $A.enqueueAction(action);
        //} 
    },
    
    cancel : function(component,event,helper){
       // on cancel refresh the view (This event is handled by the one.app container. It’s supported in Lightning Experience, the Salesforce app, and Lightning communities. ) 
        $A.get('e.force:refreshView').fire(); 
    } 
    
})