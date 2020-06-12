({
    onClickHome: function(component, event, helper) {
        if(component.get("v.showSaveCancelBtn")){
            if (confirm('Changes you made may not be saved.')) {
                return false;
            } else {
                return false;
            }
        }
        else{
            var urlEvent = $A.get("e.force:navigateToURL");
            urlEvent.setParams({
                "url": "/mentorportal/s/"
            });
            
            urlEvent.fire();
        }
        
    },
    MenuItemOne: function(component, event, helper) {
        if(component.get("v.showSaveCancelBtn")){
            if (confirm('Changes you made may not be saved.')) {
                return false;
            } else {
                return false;
            }
        }
        else{
            var urlEvent = $A.get("e.force:navigateToURL");
            urlEvent.setParams({
                "url": "/mentorportal/s/cdlmentors"
            });
            
            urlEvent.fire();
        }
        
    },
    MenuItemTwo: function(component, event, helper) {
        if(component.get("v.showSaveCancelBtn")){
            if (confirm('Changes you made may not be saved.')) {
                return false;
            } else {
                return false;
            }
        }
        else{
            var urlEvent = $A.get("e.force:navigateToURL");
            urlEvent.setParams({
                "url": "/mentorportal/s/mentor-family-newsletter"
            });
            
            urlEvent.fire();
        }
        
    },
    MenuItemThree: function(component, event, helper) {
        if(component.get("v.showSaveCancelBtn")){
            if (confirm('Changes you made may not be saved.')) {
                return false;
            } else {
                return false;
            }
        }
        else{
            var urlEvent = $A.get("e.force:navigateToURL");
            urlEvent.setParams({
                "url": "/mentorportal/s/my-preference"
            });
            
            urlEvent.fire();
        }
        
    },
    handleApplicationEvent: function(component,event,helper){
        debugger;
        var message = event.getParam("showSaveCancelBtn");
        console.log(message);
        // set the handler attributes based on event data
        component.set("v.showSaveCancelBtn", message);
    }
    
})