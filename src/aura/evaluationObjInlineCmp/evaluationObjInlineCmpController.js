({
	doInit: function(component, event, helper) {
        helper.fetchrecommendedIntInput(component, event,helper);
     	helper.fetchstreamRecommend(component, event, helper);
        helper.fetchtechStream(component, event, helper);
        helper.fetchrefOtherSite(component, event,helper);
        helper.fetchflag(component, event, helper);
        var evaObj = component.get("v.evaluationRec");
        var spScore = parseInt(component.get("v.evaluationRec.Superstar_Potential__c"));
        if(isNaN(spScore)){
            spScore = 0;
        }
        var brScore = parseInt(component.get("v.evaluationRec.Business_Review__c"));
         if(isNaN(brScore)){
            brScore = 0;
        }
        var trScore = parseInt(component.get("v.evaluationRec.Tech_Review__c"));
           if(isNaN(trScore)){
            trScore = 0;
        }
         var totalScore = spScore+brScore+trScore;
            component.set("v.totalScore",totalScore);
        var selectedColumnsInfoArray = component.get("v.selectedColumnsInfo");
        if(evaObj!= undefined){
            if(evaObj.Flag__c=="Other"){
                selectedColumnsInfoArray.otherFlag = false;
            }else{
               selectedColumnsInfoArray.otherFlag = true; 
            }
            component.set("v.selectedColumnsInfo",selectedColumnsInfoArray);
        }
     
    }, 
    inlineEditClick : function(component,event,helper){
         var clickVar = event.getSource().getLocalId();
         if(clickVar=="ranking"){
               component.set("v.rankingEditMode", true); 
            }else if(clickVar=="recommendedInt"){
               component.set("v.recommendedIntEditMode", true);  
            }else if(clickVar=="streamRecommend"){
               component.set("v.streamRecommendEditMode", true);
            }else if(clickVar=="comments"){
               component.set("v.commentsEditMode", true);
            }else if(clickVar=="flag"){
              component.set("v.flagEditMode", true);
            }else if(clickVar=="otherflag"){
              component.set("v.otherflagEditMode", true);
            }else if(clickVar=="generalComments"){
              component.set("v.generalCommentsEditMode", true); 
            }else if(clickVar=="techStream"){
               component.set("v.techStreamEditMode", true);
            }else if(clickVar=="refOtherSite"){
              component.set("v.refOtherSiteEditMode", true);
            }else if(clickVar=="reasonforRecommend"){
               component.set("v.reasonforRecommendEditMode", true);
            }else if(clickVar=="superstarpotential"){
               component.set("v.superstarPotentialEditMode", true);
            }else if(clickVar=="superstarPotentialComments"){
               component.set("v.superstarPotentialCommentsEditMode", true);
            }else if(clickVar=="techReview"){
               component.set("v.techReviewEditMode", true);
            }else if(clickVar=="techReviewComments"){
               component.set("v.techReviewCommentsEditMode", true);
            }else if(clickVar=="businessReview"){
               component.set("v.businessReviewEditMode", true);
            }else if(clickVar=="businessReviewComments"){
               component.set("v.businessReviewCommentsMode", true);
            }
       /* setTimeout(function(){
            if(clickVar=="ranking"){
           component.find("rankingInput").focus();
              var rankingArray = component.find("rankingInput");
                console.log('***************rankingLength*************'+rankingArray);
               for(var i=0;i< rankingArray.length;i++){
                   	console.log('find');
                   	component.find("rankingInput")[i].focus();
               }
            }else if(clickVar=="recommendedInt"){
               component.find("RecommendedIntInput").focus(); 
            }else if(clickVar=="streamRecommend"){
               component.find("streamRecommendInput").focus(); 
            }else if(clickVar=="comments"){
               component.find("commentsInput").focus(); 
            }else if(clickVar=="flag"){
               component.find("flagInput").focus(); 
            }else if(clickVar=="otherflag"){
               component.find("otherflagInput").focus(); 
            }else if(clickVar=="generalComments"){
               component.find("generalCommentsInput").focus(); 
            }else if(clickVar=="techStream"){
               component.find("techStreamInput").focus(); 
            }else if(clickVar=="refOtherSite"){
               component.find("refOtherSiteInput").focus(); 
            }else if(clickVar=="reasonforRecommend"){
               component.find("reasonforRecommendInput").focus(); 
            }
            
        }, 100);*/
    },
   handleSave: function(component, event, helper) {
         helper.SaveData(component, event,helper);
    },
    
    handleDiscard: function(component, event, helper) {
        var unsavedData = component.find('unsavedData');
        unsavedData.setUnsavedChanges(false);
    },
    onValueChange : function(component,event,helper){
          if(event.getSource().get("v.value") != undefined &&  event.getSource().get("v.value")!= ''){ 
              var unsavedData = component.find('unsavedData');
              unsavedData.setUnsavedChanges(true, {label: 'You have unsaved changes, did you want to save before navigating away from the page?'});
              component.set("v.showSaveCancelBtn",true);
            var evaObj = component.get("v.evaluationRec");
             if(evaObj!= undefined){
          var spScore = parseInt(component.get("v.evaluationRec.Superstar_Potential__c"));
        if(isNaN(spScore)){
            spScore = 0;
        }
        var brScore = parseInt(component.get("v.evaluationRec.Business_Review__c"));
         if(isNaN(brScore)){
            brScore = 0;
        }
        var trScore = parseInt(component.get("v.evaluationRec.Tech_Review__c"));
           if(isNaN(trScore)){
            trScore = 0;
        }
         var totalScore = spScore+brScore+trScore;
            component.set("v.totalScore",totalScore);
                 var updatedEvalObj = component.get("v.updatedEvaluations");
              var evaList = component.get("v.evalIds");
              //console.log('*********updatedEvalObj*********'+evaObj.Id);
             if(evaList.includes(evaObj.Id) == false){     
            	updatedEvalObj.push(evaObj);
                evaList.push(evaObj.Id);
             }
             // console.log('*********evaList*********'+evaList);
               component.set("v.evalIds", evaList);
            component.set("v.updatedEvaluations", updatedEvalObj); 
             var cmpEvent = component.getEvent("UpdatedEvalRecs");
             cmpEvent.setParams({
             "selectedEval" : component.get("v.updatedEvaluations"),
              "selectedApps" : component.get("v.updatedApplications")
             });
            cmpEvent.fire();
            var selectedColumnsInfoArray = component.get("v.selectedColumnsInfo");
                if(evaObj.Flag__c=="Other"){
                    selectedColumnsInfoArray.otherFlag = true;
                }else{
                    selectedColumnsInfoArray.otherFlag = false;
                }
                component.set("v.selectedColumnsInfo",selectedColumnsInfoArray);
            }           
        }
    },
    
    closeInlineEditIcon : function (component, event, helper) {
       //helper.mouseOutHelper(component, event,helper)
        if(event.getSource().get("v.accesskey") != undefined &&  event.getSource().get("v.accesskey")!= ''){
            var nodeName = event.getSource().get("v.accesskey");
             //component.set("v."+nodeName, false);
             var spScore = parseInt(component.get("v.evaluationRec.Superstar_Potential__c"));
         var superstarpotentialInt = component.find("superstarpotentialInt");
   		if(spScore>50){
            component.set("v.showSaveCancelBtn",false);
        	superstarpotentialInt.setCustomValidity("Superstar Potential Score shouldnt be greater than 50");        
        	
        }else{
            component.set("v.superstarPotentialEditMode", false);
        }
         if(!isNaN(superstarpotentialInt)){
        	superstarpotentialInt.reportValidity();
         }
        var brScore = parseInt(component.get("v.evaluationRec.Business_Review__c"));
         var businessReviewInt = component.find("businessReviewInt");
		if(brScore>20){
            component.set("v.showSaveCancelBtn",false);
        	businessReviewInt.setCustomValidity("Business Review Score shouldnt be greater than 20");        
        	
        }else{
            component.set("v.businessReviewEditMode", false);
        }
         if(!isNaN(businessReviewInt)){
             businessReviewInt.reportValidity();
         }
         var trScore = parseInt(component.get("v.evaluationRec.Tech_Review__c"));
         var techReviewInt = component.find("techReviewInt");
		if(trScore>30){
            component.set("v.showSaveCancelBtn",false);
        	techReviewInt.setCustomValidity("Tech Review Score shouldnt be greater than 30");        
        	
        }else{
            component.set("v.techReviewEditMode", false);
        }
         if(!isNaN(techReviewInt)){
        	techReviewInt.reportValidity();
         }
            if(nodeName!='superstarPotentialEditMode' && nodeName!='businessReviewEditMode' && nodeName!='techReviewEditMode'){
                  window.setTimeout(
                $A.getCallback(function() {
                   component.set("v."+nodeName, false);
                }), 3000
           	 );
            }
           
        }
    }
    
    
})