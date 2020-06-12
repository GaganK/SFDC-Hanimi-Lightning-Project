({
    redirecteduPage : function(component, event, helper) {
        var urlEvent = $A.get("e.force:navigateToURL");
        urlEvent.setParams({
            "url": "/my-preference"
        });
        
        urlEvent.fire();
    },
    redirectCDLMentor : function(component, event, helper) {
        var urlEvent = $A.get("e.force:navigateToURL");
        urlEvent.setParams({
            "url": "/cdlmentors"
        });
        
        urlEvent.fire();
    },
    doInit: function(component, event, helper) {
        var myAction = component.get("c.fetchSlackUrlDetail"); 
        myAction.setCallback(this, function(response) { 
          if(response.getState() === "SUCCESS") { 
            component.set("v.loggedinUserSlackUrl", response.getReturnValue()); 
        }}); 
        $A.enqueueAction(myAction); 
    },
    redirectCDLpi: function(component, event, helper) {
        var urlEvent = $A.get("e.force:navigateToURL");
        urlEvent.setParams({
            "url": "/my-preference"
        });
        urlEvent.fire();
       $A.get('e.force:refreshView').fire(); 
    },
    redirectCDLSession: function(component, event, helper) {
        var urlEvent = $A.get("e.force:navigateToURL");
        urlEvent.setParams({
            "url": "/my-sessions"
        });
        
        urlEvent.fire();
    },
    redirectSchedule: function(component, event, helper) {
        var tab = "partner";
        var urlEvent = $A.get("e.force:navigateToURL");
        urlEvent.setParams({
            "url": "/my-sessions?tab="+ tab,
           /* componentAttributes: {
                "selectedTab" : "partner"
            }*/
        });
        urlEvent.fire();
    },
    redirectfa:function(component, event, helper) {
        var urlEvent = $A.get("e.force:navigateToURL");
        urlEvent.setParams({
            "url": "/mentor-profiles"
        });
        
        urlEvent.fire();
    },
    redirectPage : function(component, event, helper) {
        var urlEvent = $A.get("e.force:navigateToURL");
        urlEvent.setParams({
            "url": "/machine-learning-conference-"
        });
        
        urlEvent.fire();
    },
    redirectFn : function(component, event, helper) {
        var urlEvent = $A.get("e.force:navigateToURL");
        urlEvent.setParams({
            "url": "/mentor-family-newsletter"
        })
        urlEvent.fire();
    }, 
    redirectcdlPartner: function(component, event, helper) {
        var urlEvent = $A.get("e.force:navigateToURL");
        urlEvent.setParams({
            "url": "/cdl-partners"
        });
       
        urlEvent.fire();
    },
})