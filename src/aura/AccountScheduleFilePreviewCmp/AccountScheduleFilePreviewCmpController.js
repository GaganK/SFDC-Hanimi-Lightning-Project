({
    myint : function(component, event, helper) {
        var url_string =  window.location.href;
        var url = new URL(url_string);
        var selectedTab = url.searchParams.get("tab");
        if(selectedTab == 'partner'){
            component.set("v.selectTab", "partner"); 
        }
        
        component.set("v.previewAttachment",true);
        var action = component.get("c.fetchContentDocument");
        //action.setParams({"accountId":component.get("v.recordId")});
        action.setCallback(this,function(response){
            var state = response.getState();
            var result = response.getReturnValue();
            
            if(!$A.util.isEmpty(result)){
                component.set("v.attachmentId",response.getReturnValue());
                 
            }            
            else{
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
    openPreview : function(component,event,helper){
        component.set("v.previewAttachment",false);
        component.set("v.previewAttachment",true);
    }
    
})