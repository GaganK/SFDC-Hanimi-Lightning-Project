({
    redirectPage : function(component, event, helper) {
        var urlEvent = $A.get("e.force:navigateToURL");
        urlEvent.setParams({
            "url": "/m-l-conference"
        });
        
        urlEvent.fire();
    },
    
       redirectFn : function(component, event, helper) {
        var urlEvent = $A.get("e.force:navigateToURL");
        urlEvent.setParams({
            "url": "/familynewsletter"
        })
        urlEvent.fire();
         },  
          redirectfa:function(component, event, helper) {
        var urlEvent = $A.get("e.force:navigateToURL");
        urlEvent.setParams({
            "url": "/fa-bios"
        });
        
        urlEvent.fire();
          },
    
})