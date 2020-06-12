({
    doInit: function(component, event, helper) {
        helper.doInitHelper(component, event);
         helper.getSiteList(component, event);
         helper.getStreamList(component, event);
        window.addEventListener('beforeunload', function (e) {
          e.returnValue = 'Changes you made may not be saved!!!';
            
        });

    },
     OpenFile :function(component,event,helper){  
     var rec_id = event.currentTarget.id;  
     $A.get('e.lightning:openFiles').fire({ 
       recordIds: [rec_id] 
     });  
   },
    handleDiscard: function(component, event, helper) {
        var unsavedData = component.find('unsavedData');
        unsavedData.setUnsavedChanges(false);
      },
     handleDataChange: function(component, event, helper) {
        var unsavedData = component.find('unsavedData');
        unsavedData.setUnsavedChanges(true, {label: 'myMatchVentureCmp?'});
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
         component.set("v.showFullBio", false); 
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
        if (confirm('Changes you made may not be saved.')) {
        
        } else {
            $A.get('e.force:refreshView').fire();
        }
        
    },
    handleVentureRanking: function(component, event, helper){
        component.set("v.showSaveCancelBtn", false);
        var selectCmp = event.getSource().get("v.value");
        console.log(selectCmp);
        var selvenId = event.getSource().get("v.accesskey");
        console.log('****auraId*****'+selvenId);
        var selVentures = component.get("v.selectedVenturesList");
        var existingRankingList = component.get("v.existingRankingList");
         var errormessage = 'This Ranking was already selected , Please select another Rank \n';
        var uniqueRankingVal=component.get("v.existingRankingList");
        var selVenVal = selvenId+'&&'+selectCmp;
		
       
            console.log('********Check********'+uniqueRankingVal.includes(selectCmp));
     
           if(uniqueRankingVal.includes(selectCmp) == true){           
            // helper.showToast(component, event,errormessage,'Error');
                /* var rankValues = component.get("v.RankingList");
                var plValues =[];
               for (var i = 0; i < rankValues.length; i++) {
                   if(uniqueRankingVal.includes(rankValues[i].value) == true){
                        plValues.push({
                            label: rankValues[i].label,
                            value: rankValues[i].value,
                            disabled : true,
                            selected : true
                        });
						console.log('********CheckTrue********'+rankValues[i].label);
                   }else{
                        plValues.push({
                            label: rankValues[i].label,
                            value: rankValues[i].value,
                            disabled : false,
                            selected : false
                        });
			console.log('********CheckFalse********'+rankValues[i].label);						
                   }
                                     
               }
               component.set("v.RankingList", plValues);*/
           }else{
               selVentures.push(selVenVal);
               uniqueRankingVal.push(selectCmp);
               component.set("v.showSaveCancelBtn", true); 
           }      
        component.set("v.existingRankingList", uniqueRankingVal);
        component.set("v.selectedVenturesList", selVentures);


    },
    Save: function(component, event, helper){
         var existingRankingList = component.get("v.existingRankingList");
        console.log(existingRankingList.length);

        if(existingRankingList.length>20){
            helper.showToast(component, event,'You can choose only 20','error');
        }else{
            helper.SaveAdmit(component, event,helper);
        }
    },
     showFullBioAction : function(component, event, helper) {
        
        component.set("v.showFullBio", true); 
    },
    
    showShortBioAction : function(component, event, helper) {
        
        component.set("v.showFullBio", false); 
    }


})