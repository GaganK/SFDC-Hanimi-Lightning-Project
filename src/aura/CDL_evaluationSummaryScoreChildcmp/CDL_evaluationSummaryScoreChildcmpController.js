({
    
    doInit: function(component, event, helper) {
        // call the fetchPickListVal(component, field_API_Name, aura_attribute_name_for_store_options) -
        // method for get picklist values dynamic   
        
        helper.getApplicationURL(component, helper);
        var SelAppObj = component.get("v.singleRec");
        var appEval = component.get("v.singleEva");
    },
    inlineEditClick : function(component,event,helper){   
        var clickVar = event.getSource().getLocalId();
        /*
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
         }*/
    },
    onValueChange : function(component,event,helper){
        /*
         if(event.getSource().get("v.value") != undefined &&  event.getSource().get("v.value")!= ''){ 
              var SelAppObj = component.get("v.singleRec");
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
        }*/
    },
    closeInlineEditIcon : function (component, event, helper) {
        /*
         window.setInterval(
            $A.getCallback(function() { 
                component.set("v.RankEditMode", false);
                component.set("v.teamSPSScoreEditMode", false);
                component.set("v.teamTRSScoreEditMode", false);
                component.set("v.teamBRSScoreEditMode", false);
                component.set("v.teamScoreEditMode", false);
                component.set("v.teamInterviewDecisionEditMode", false);
                component.set("v.teamSREditMode", false);
                component.set("v.teamSSREditMode", false);
                component.set("v.techSREditMode", false);
                component.set("v.commentEditMode", false);
            }), 3000
        ); 

        */
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