({
   
    redirectPage : function(component, event, helper) {
        var urlEvent = $A.get("e.force:navigateToURL");
        urlEvent.setParams({
            "url": "/cdl-module-1"
        });
        
        urlEvent.fire();
    },
    module2 :function(component, event, helper) {
        var urlEvent = $A.get("e.force:navigateToURL");
        urlEvent.setParams({
            "url": "/cdl-module-2"
        });
        
        urlEvent.fire();
    },
    module3 :function(component, event, helper) {
        var urlEvent = $A.get("e.force:navigateToURL");
        urlEvent.setParams({
            "url": "/cdl-module-3"
        });
        
        urlEvent.fire();
    },
    module4 :function(component, event, helper) {
        var urlEvent = $A.get("e.force:navigateToURL");
        urlEvent.setParams({
            "url": "/cdl-module-4"
        });
        
        urlEvent.fire();
    },
    module5 :function(component, event, helper) {
        var urlEvent = $A.get("e.force:navigateToURL");
        urlEvent.setParams({
            "url": "/cdl-module-5"
        });
        
        urlEvent.fire();
    },
})