({
	 inlineEditRefferal : function(component,event,helper){   
        component.set("v.refferalEditMode", true);  
        setTimeout(function(){ 
            component.find("refName").focus();
        }, 100);
    },onValueChange : function(component,event,helper){ 
          if(event.getSource().get("v.value") != undefined &&  event.getSource().get("v.value")!= ''){ 
            component.set("v.showSaveCancelBtn",true);
            var appObj = component.get("v.singleRec");
            var updatingappObj = component.get("v.updatedApplications");
            updatingappObj.push(appObj);
            component.set("v.updatedApplications", updatingappObj); 
        }
    },closeInlineEditIcon : function (component, event, helper) {
        component.set("v.refferalEditMode", false);  
          if(event.getSource().get("v.value") != undefined &&  event.getSource().get("v.value")!= ''){ 
            component.set("v.showErrorClass",true);
        }else{
            component.set("v.showErrorClass",false);
        }
    }
    
})