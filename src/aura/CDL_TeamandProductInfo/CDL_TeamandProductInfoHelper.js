({
    getdata : function(component, event, helper) {
    
        var paramId;
        var sPageURL = decodeURIComponent(window.location.search.substring(1));
        var sURLVariables = sPageURL.split('&');
        
        for (var i = 0; i < sURLVariables.length; i++) {

            var sParameterName = sURLVariables[i].split('=');
            
            if (sParameterName[0] ==="ventureId") {

                paramId = sParameterName[1] === undefined ? "" : sParameterName[1];
            }
        }  
        var action = component.get("c.getCompanyDetails");
		
        action.setParams({

            recordId: paramId
        });

        action.setCallback(this, function(response) {
            
            var state = response.getState();
            
            if(state === 'SUCCESS') {
                
                let data = response.getReturnValue();

                console.log('## data : ',data);

                for(let wrapper of data) {

                    console.log('## wrapper : ',wrapper);
                	component.set("v.ventureData",wrapper);
                }
            }
            else {
                
                alert('Error in getting data');
            }
        });
        
        $A.enqueueAction(action);
    },
})