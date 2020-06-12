({
    
    doInit: function(component, event, helper) {
      // call the fetchPickListVal(component, field_API_Name, aura_attribute_name_for_store_options) -
      // method for get picklist values dynamic   
        helper.fetchPickListVal(component, 'Tech_Specialization__c', 'StreamPotenPicklistOpts');
        helper.fetchPickListVal(component, 'Team_Interview_Recommendations__c', 'teamInterviewRecommdoptions');
       	helper.fetchPickListVal(component, 'Team_Stream_Recommendation__c', 'teamStreamRecommdoptions');
       	helper.fetchPickListVal(component, 'Team_Sub_Stream_Recommendation__c', 'teamSubStreamRecommdoptions');
       	helper.fetchPickListVal(component, 'TechScreening__c', 'techStreamRecommdoptions');

        helper.getApplicationURL(component, helper);
        var spScore = parseInt(component.get("v.singleRec.Team_Superstar_Potential_Score__c"));
        if(isNaN(spScore)){
            spScore = 0;
        }
        var brScore = parseInt(component.get("v.singleRec.Team_Tech_Review_Score__c"));
         if(isNaN(brScore)){
            brScore = 0;
        }
        var trScore = parseInt(component.get("v.singleRec.Team_Business_Review_Score__c"));
           if(isNaN(trScore)){
            trScore = 0;
        }
         var totalScore = spScore+brScore+trScore;
            component.set("v.totalScore",totalScore);
        var selSPList = component.get("v.singleRec.Tech_Specialization__c");
       var selnewSPList = [];
        if(selSPList!='' && selSPList!=null && selSPList!='undefined')
       selnewSPList=  selSPList.toString().split(';');
        component.set("v.streamPotenList",selnewSPList);
            //alert('****selSPList******'+component.get("v.streamPotenList"));
      var SelAppObj = component.get("v.singleRec");
      var appEval = component.get("v.singleEva");
        if(!$A.util.isUndefinedOrNull(appEval)){
            var evalrecInt1;
            var evalrecInt2;
            var evalrecInt3;
        for (var i = 0; i < appEval.length; i++) {
            if(appEval[i].CDL_Evaluator__c==SelAppObj.Evaluator_1__c){
                component.set("v.evalutor1Rec",appEval[i]);
                evalrecInt1 = appEval[i].Recommend_Interview_2__c;
            }else  if(appEval[i].CDL_Evaluator__c==SelAppObj.Evaluator_2__c){
                component.set("v.evalutor2Rec",appEval[i]);
                evalrecInt2 = appEval[i].Recommend_Interview_2__c;
            }else  if(appEval[i].CDL_Evaluator__c==SelAppObj.Evaluator_3__c){
                component.set("v.evalutor3Rec",appEval[i]);
                evalrecInt3 = appEval[i].Recommend_Interview_2__c;
            }
            if(isNaN(evalrecInt1)){
                evalrecInt1 = '';
            }
            if(isNaN(evalrecInt2)){
                evalrecInt2 = '';
            }
            if(isNaN(evalrecInt3)){
                evalrecInt3 = '';
            }
            if((evalrecInt1.includes("Yes") || evalrecInt1.includes("No")) && (evalrecInt2.includes("Yes") || evalrecInt2.includes("No")) && (evalrecInt3.includes("Yes") || evalrecInt3.includes("No"))){
                component.set("v.teamDecision",'AGREE');
            }else{
               component.set("v.teamDecision",'DISAGREE');
            }
            
        }
       }
    },
    inlineEditClick : function(component,event,helper){   
        var clickVar = event.getSource().getLocalId();
         if(clickVar=="finalRanking"){
        	component.set("v.RankEditMode", true); 
         }else if(clickVar=="teamSPSScore"){
               component.set("v.teamSPSScoreEditMode", true);  
         }else if(clickVar=="teamTRSScore"){
               component.set("v.teamTRSScoreEditMode", true);  
         }else if(clickVar=="teamBRSScore"){
               component.set("v.teamBRSScoreEditMode", true);  
         }else if(clickVar=="teamInterviewDecision"){
               component.set("v.teamInterviewDecisionEditMode", true);  
         }else if(clickVar=="teamSR"){
               component.set("v.teamSREditMode", true);  
         }else if(clickVar=="teamSSR"){
               component.set("v.teamSSREditMode", true);  
         }else if(clickVar=="techSR"){
               component.set("v.techSREditMode", true);  
         }else if(clickVar=="comment"){
               component.set("v.commentEditMode", true);  
         }
    },
       handleSave: function(component, event, helper) {
         helper.SaveData(component, event,helper);
    },
    
    handleDiscard: function(component, event, helper) {
        var unsavedData = component.find('unsavedData');
        unsavedData.setUnsavedChanges(false);
        component.set("v.showSaveCancelBtn",false);
        $A.get('e.force:refreshView').fire();
    },
    onValueChange : function(component,event,helper){
         if(event.getSource().get("v.value") != undefined &&  event.getSource().get("v.value")!= ''){ 
              var SelAppObj = component.get("v.singleRec");
               var unsavedData = component.find('unsavedData');
              unsavedData.setUnsavedChanges(true, {label: 'You have unsaved changes, did you want to save before navigating away from the page?'});
           
             if(SelAppObj!= undefined){
                 var spScore = parseInt(component.get("v.singleRec.Team_Superstar_Potential_Score__c"));
                 if(isNaN(spScore)){
                     spScore = 0;
                 }
                 var brScore = parseInt(component.get("v.singleRec.Team_Tech_Review_Score__c"));
                 if(isNaN(brScore)){
                     brScore = 0;
                 }
                 var trScore = parseInt(component.get("v.singleRec.Team_Business_Review_Score__c"));
                 if(isNaN(trScore)){
                     trScore = 0;
                 }
                 var totalScore = spScore+brScore+trScore;
                 component.set("v.totalScore",totalScore);
                 helper.updaterecords(component, helper);
                 component.set("v.showSaveCancelBtn",true); 
            }           
        }
    },
    closeInlineEditIcon : function (component, event, helper) {
  		 helper.mouseOutHelper(component, event,helper);        
    }
    
    /* onRankChange : function(component,event,helper){ 
       component.set("v.singleEva[0].EvaluatorsRanking__c", component.find("finalRanking").get("v.value")); 
        // then show save and cancel button by set attribute to true
     	helper.updaterecords(component, helper);
         component.set("v.showSaveCancelBtn",true);
    },
    closeRankBox : function (component, event, helper) {
        component.set("v.RankEditMode", false); 
    },
     inlineEditSp : function(component,event,helper){   
        // show the SP edit field popup 
        component.set("v.spEditMode", true);      
       
    },
     onSPChange : function(component,event,helper){ 
        // if picklist value change,
         component.set("v.singleRec.Tech_Specialization__c", event.getParam("values")); 
         helper.updaterecords(component, helper);
        // then show save and cancel button by set attribute to true
        component.set("v.showSaveCancelBtn",true);
    },     
    
    closeSPBox : function (component, event, helper) {
       // on focus out, close the input section by setting the 'spEditMode' att. as false
        component.set("v.spEditMode", false); 
    }
    , 
    
    inlineEditcdl : function(component,event,helper){   
        // show the SP edit field popup 
        component.set("v.cdlEditMode", true);      
       
    },
     onCDLChange : function(component,event,helper){ 
          var selectVal = component.find("InputSelectMultiple");
        // if picklist value change,
         component.set("v.singleRec.ShouldCDLInterviewthisVenture__c", selectVal.get("v.value")); 
        // then show save and cancel button by set attribute to true
        component.set("v.showSaveCancelBtn",true);
    },     
    
    closeCDLBox : function (component, event, helper) {
       // on focus out, close the input section by setting the 'cdlEditMode' att. as false
        component.set("v.cdlEditMode", false); 
    }*/
})