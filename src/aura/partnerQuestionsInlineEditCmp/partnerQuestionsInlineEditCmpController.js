({
    
    doInit: function(component, event, helper) { 

 		component.set("v.singleRec.Account_Name__c", component.get("v.accountId"));
    }, 

    inlineEditCommentsOnVenture : function(component,event,helper){   

        component.set("v.commentsonventure", true);       
    },  

    closecommentsonVentureBox : function (component, event, helper) {

        component.set("v.commentsonventure", false); 
        helper.save(component,event);
    },

	inlineEditIsVenture : function(component,event,helper){   

        component.set("v.isVentureEditMode", true);      
    },

    closeIsVentureBox : function (component, event, helper) {

        component.set("v.isVentureEditMode", false); 
        helper.save(component,event);
    },

	inlineEditComments : function(component,event,helper){   

        component.set("v.commentsEditMode", true);      
    },
    
    closeCommentsBox : function (component, event, helper) {

        component.set("v.commentsEditMode", false); 
        helper.save(component,event);
    },

	inlineEditwouldyouwantmoreinfo : function(component,event,helper){   

        component.set("v.wouldyouwantmoreinfo", true);      
    },
   
    closewouldyouwantmoreinfo : function (component, event, helper) {

        component.set("v.wouldyouwantmoreinfo", false);
        helper.save(component,event);
    }
})