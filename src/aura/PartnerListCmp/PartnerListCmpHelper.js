({
    // Function to fetch data from server called in initial loading of page
    fetchContacts : function(component, event, helper) {
        // Assign server method to action variable
        var action = component.get("c.fetchSpeakerDetail");
        // Callback function to get the response
        action.setCallback(this, function(response) {
            // Getting the response state
            var state = response.getState();
            // Check if response state is success
            if(state === 'SUCCESS') {
                // Getting the list of contacts from response and storing in js variable
                var contactList = response.getReturnValue();
                // Set the list attribute in component with the value returned by function
                component.set("v.contactList",contactList);
            }
            else {
                // Show an alert if the state is incomplete or error
                alert('Error in getting data');
            }
        });
        // Adding the action variable to the global action queue
        $A.enqueueAction(action);
    } ,
    doInitHelper : function(component,event, helper){ 
        var action = component.get("c.fetchPartnersDetail");
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
    },
    speakerList : function(component, event, helper) {
  		var action = component.get("c.getFetchPartnersMap");   
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {                
                var custs = [];
                var conts = response.getReturnValue();
                for(var key in conts){
                    custs.push({value:conts[key], key:key}); //Here we are creating the list to show on UI.
                }
                component.set("v.SpeakersList",custs); 
            } 
  	});           
        $A.enqueueAction(action);
	}
})