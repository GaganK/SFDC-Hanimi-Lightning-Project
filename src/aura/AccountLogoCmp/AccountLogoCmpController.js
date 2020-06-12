({
	doInit : function(component, event, helper) {
	 var action = component.get("c.accountImageURL");	
      action.setCallback(this, function(response)
           {
              var state = response.getState();
               //alert(state);
               if (state === "SUCCESS")
               {
                 component.set("v.acctObj",response.getReturnValue());
               }
            });
    $A.enqueueAction(action);
	}
})