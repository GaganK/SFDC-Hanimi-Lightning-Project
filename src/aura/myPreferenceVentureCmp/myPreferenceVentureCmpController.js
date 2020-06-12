({
    doInit: function(component, event, helper) {

        helper.doInitHelper(component, event);
         helper.getSiteList(component, event);
         helper.getStreamList(component, event);
         helper.getRankingList(component, event);
    },
    OpenFile :function(component,event,helper){  
     var rec_id = event.currentTarget.id;  
     $A.get('e.lightning:openFiles').fire({  
       recordIds: [rec_id] 
     });  
   },
    openModel: function(component, event, helper) {
        
        // Set isModalOpen attribute to true
         var whichOne = event.getSource().getLocalId();
        component.set("v.clickedButtonId", whichOne);

        component.set("v.isModalOpen", true);
     },
    openContactModel: function(component, event, helper) {
         var ctarget = event.currentTarget;
        var selConId = ctarget.dataset.value;
        console.log(selConId);
       
         var action = component.get("c.fetchConInfowrapper");
        action.setParams({"conId":selConId});
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS"){
                 var oRes = response.getReturnValue();
                if(oRes.length > 0){
                     //alert('oRes'+oRes[0].conDocId);
                    component.set('v.conDetail', oRes);
                    console.log(oRes);
                      component.set("v.isConModalOpen", true);
                }              
            }
            else{
                alert('Error...');
            }
        });
        $A.enqueueAction(action);
     },
     closeModel: function(component, event, helper) {
        // Set isModalOpen attribute to false  
        component.set("v.isdocModalOpen", false);
          component.set("v.isModalOpen", false);
          component.set("v.isConModalOpen", false);
     },
     
    cancel : function(component,event,helper){
       // on cancel refresh the view (This event is handled by the one.app container. It’s supported in Lightning Experience, the Salesforce app, and Lightning communities. ) 
        $A.get('e.force:refreshView').fire(); 
    },
    showHideFilter : function(component, event, helper) {   
        
        component.set("v.filterEnabled", true);
        var el = component.find('searchPanel');
        $A.util.toggleClass(el,'hideFilterPanel');
    },
   onSearch : function(component, event, helper) {   
        
        window.clearTimeout(helper.searchTimer);

        helper.searchTimer = window.setTimeout(
            function(){
                console.log('## Search called');
                new Promise($A.getCallback(function(resolve, reject) {
                    component.set("v.isSearching", true);
                    helper.doInitHelper(component, helper);
                }));
            }
            , 500);
    },
     getVentureRecords : function(component, event, helper){
        helper.doInitHelper(component, helper);
         helper.getSiteList(component, event);
         helper.getStreamList(component, event);
          helper.getRankingList(component, event);
        component.set("v.isModalOpen", false);
         //$A.get('e.force:refreshView').fire(); 
    },
    resetView : function(component, event, helper) {
        $A.get('e.force:refreshView').fire();
    }


})