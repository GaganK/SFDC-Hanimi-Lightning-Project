({
    // Function to fetch data from server called in initial loading of page
    getAdmittedVentures : function(component, event, helper) {
        
        //get record id from request parameter
        var paramId;
        var sPageURL = decodeURIComponent(window.location.search.substring(1));
        var sURLVariables = sPageURL.split('&');
        
        
        for (var i = 0; i < sURLVariables.length; i++) {
            var sParameterName = sURLVariables[i].split('=');
            
            if (sParameterName[0] ==="ventureId") {
                paramId = sParameterName[1] === undefined ? "" : sParameterName[1];
            }
        }  

        // Assign server method to action variable
        var action = component.get("c.getCompanyDetails");
        // Getting the account id from page
        
        // Setting parameters for server method
        action.setParams({
            recordId: paramId
        });
        // Callback function to get the response
        action.setCallback(this, function(response) {
            // Getting the response state
            var state = response.getState();
            // Check if response state is success
            if(state === 'SUCCESS') {
                // Getting the list of contacts from response and storing in js variable
                var wrapperList = response.getReturnValue();
                
                var wrappers=new Array();
                
                for (var idx=0; idx<wrapperList.length; idx++) {
                    var compWebsite;
                    if(wrapperList[idx].isSuccess) {
                       if (!wrapperList[idx].companyWebsite.startsWith('http') && !wrapperList[idx].companyWebsite.startsWith('https')) {
                        compWebsite = 'https://' + wrapperList[idx].companyWebsite;
                    	} 
                    }
                    
                    var wrapper = wrapperList[idx];
                    wrapper.companyWebsite = compWebsite;
                    wrappers.push(wrapper);
                }
                
                //Set component attributes
                component.set("v.isTechVal1",wrappers[0].isTechVal1);
                component.set("v.isTechVal2",wrappers[0].isTechVal2);
                component.set("v.isIndVal1",wrappers[0].isIndVal1);
                component.set("v.isIndVal2",wrappers[0].isIndVal2);
                component.set("v.isSiteVal",wrappers[0].isSiteVal);
                component.set("v.isStreamVal",wrappers[0].isStreamVal);
                component.set("v.updateFlag",wrappers[0].updateFlag);
                component.set("v.overviewFlag",wrappers[0].overviewFlag);
                component.set("v.pitchDeckFlag",wrappers[0].pitchDeckFlag);
                component.set("v.updateURL",wrappers[0].externalURL+'/sfc/servlet.shepherd/document/download/'+wrappers[0].updateContentId+'?operationContext=S1');
                component.set("v.overviewURL",wrappers[0].externalURL+'/sfc/servlet.shepherd/document/download/'+wrappers[0].overviewContentId+'?operationContext=S1');
                component.set("v.pitchDeckURL",wrappers[0].externalURL+'/sfc/servlet.shepherd/document/download/'+wrappers[0].pitchDeckContentId+'?operationContext=S1');
                
                // Set the list attribute in component with the value returned by function
                component.set("v.isSuccess",wrappers[0].isSuccess);
                component.set("v.wrapperList",wrappers);
            }
            else {
                // Show an alert if the state is incomplete or error
                alert('Error in getting data');
            }
        });
        // Adding the action variable to the global action queue
        $A.enqueueAction(action);
    },
    showToast : function(component, event, helper) {
        // Show toast if the content file is not found
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "title": "",
            "message": "File not found."
        });
        toastEvent.fire(); 
    }
})