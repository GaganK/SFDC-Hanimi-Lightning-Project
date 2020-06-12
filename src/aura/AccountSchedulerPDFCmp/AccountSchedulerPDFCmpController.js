({
    doInit : function(component, event, helper) {
        var action = component.get("c.fetchContentDocument");
        //action.setParams({"accountId":component.get("v.recordId")});
        action.setCallback(this,function(response){
            var state = response.getState();
            var result = response.getReturnValue();
            if(!$A.util.isEmpty(result)){
                component.set("v.attachmentId",result);
                helper.closeQuickAction(component,event,helper);
            }            
            else{
                helper.closeQuickAction(component,event,helper);
                component.set("v.openModal",false);
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Info!",
                    "message": "There is no file added.",
                    "type":"info"
                });
                toastEvent.fire();
            }
        });
        $A.enqueueAction(action);
       
    },
    closeModel : function(component,event,helper){
        component.set("v.openModal",false);
    }
    
})