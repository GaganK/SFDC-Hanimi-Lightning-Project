({
	doInit : function(component, event, helper) {
		var myAction = component.get("c.getpublicAccess"); 
          var conId = component.get("v.contentDocumentId");
      
         myAction.setParams({  conDocumentId : conId});
        myAction.setCallback(this, function(response) {
           
          if(response.getState() === "SUCCESS") { 
            component.set("v.iframeUrl", response.getReturnValue()); 
            //alert(response.getReturnValue());    
        }}); 
       
        $A.enqueueAction(myAction); 
	}
})