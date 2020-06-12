({
    speakerList : function(component, event, helper) {
        var action = component.get("c.getFetchSpeakerMap");   
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {                
                var custs = [];
                var conts = response.getReturnValue();
                component.set("v.NewSpeakersList",response.getReturnValue());
            } 
        });           
        $A.enqueueAction(action);
    }
})