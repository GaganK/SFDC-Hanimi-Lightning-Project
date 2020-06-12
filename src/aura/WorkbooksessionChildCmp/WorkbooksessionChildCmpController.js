({
    
    doInit: function(component, event, helper) { 
 		component.set("v.singleRec.Account_Name__c", component.get("v.accountId"));
        var acctName = component.get("v.singleRec.Account_Name__c");
          //alert(component.get("v.singleRec.Account_Name__c"));
    }, 
    inlineEditCommentsOnVenture : function(component,event,helper){   
        component.set("v.commentsonventure", true);       
    },  
    closecommentsonVentureBox : function (component, event, helper) {
        component.set("v.commentsonventure", false); 
        component.set("v.showSaveCancelBtn",true);
    },
	inlineEditIsVenture : function(component,event,helper){   
        component.set("v.isVentureEditMode", true);      
    },
    closeIsVentureBox : function (component, event, helper) {
        component.set("v.isVentureEditMode", false); 
          component.set("v.showSaveCancelBtn",true);
    }
	,
	inlineEditComments : function(component,event,helper){   
        component.set("v.commentsEditMode", true);      
    },
    
    closeCommentsBox : function (component, event, helper) {
        component.set("v.commentsEditMode", false); 
          component.set("v.showSaveCancelBtn",true);
    }
	,
	inlineEditwouldyouwantmoreinfo : function(component,event,helper){   
        component.set("v.wouldyouwantmoreinfo", true);      
    },
   
    closewouldyouwantmoreinfo : function (component, event, helper) {
        component.set("v.wouldyouwantmoreinfo", false);
          component.set("v.showSaveCancelBtn",true);
    }
	,
	inlineEditwhatinfowouldyoulike : function(component,event,helper){   
        component.set("v.whatinfowouldyoulike", true);      
    },
   
    closewhatinfowouldyoulikeBox : function (component, event, helper) {
        component.set("v.whatinfowouldyoulike", false);
          component.set("v.showSaveCancelBtn",true);
    }
	,
	inlineEditwanttoconnect : function(component,event,helper){   
        component.set("v.wanttoconnect", true);      
    },
    
    closewanttoconnect : function (component, event, helper) {
        component.set("v.wanttoconnect", false); 
          component.set("v.showSaveCancelBtn",true);
    },
	inlineEditwhyfounders : function(component,event,helper){   
        component.set("v.whyfounders", true);      
    },
    
    closewhyfoundersBox : function (component, event, helper) {
        component.set("v.whyfounders", false); 
          component.set("v.showSaveCancelBtn",true);
    },
	inlineEditAdditionalComments : function(component,event,helper){   
        component.set("v.AdditionalCommentsEditMode", true);      
    },
    
    closeaddtionalBox : function (component, event, helper) {
        component.set("v.AdditionalCommentsEditMode", false); 
          component.set("v.showSaveCancelBtn",true);
    }
})