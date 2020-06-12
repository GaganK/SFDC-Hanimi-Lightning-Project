({
   // fetch picklist values dynamic from apex controller 
    fetchPickListVal: function(component, fieldName, picklistOptsAttributeName) {
        var action = component.get("c.getselectOptions");
        action.setParams({
            "objObject": component.get("v.objInfoForPicklistValues"),
            "fld": fieldName
        });
        var opts = [];
        action.setCallback(this, function(response) {
            if (response.getState() == "SUCCESS") {
                var allValues = response.getReturnValue();
 
                if (allValues != undefined && allValues.length > 0) {
                    opts.push({
                        //class: "optionClass",
                        label: "--- None ---",
                        value: ""
                    });
                }
                for (var i = 0; i < allValues.length; i++) {
                    opts.push({
                        //class: "optionClass",
                        label: allValues[i],
                        value: allValues[i]
                    });
                }
                component.set("v." + picklistOptsAttributeName, opts);
            }
        });
        $A.enqueueAction(action);
    },
    updaterecords: function(component, event, helper) {
         var cmpEvent = component.getEvent("UpdatedRecs");
         cmpEvent.setParams({
         "selectedApp" : component.get("v.singleRec")});
        cmpEvent.fire();
    },
     SaveData: function(component, event, helper) {
                 var action = component.get("c.updateApplication");
        
                  action.setParams({
                     'appObj': component.get("v.singleRec")
                  });
        var unSavedChange = component.find('unsavedData');
            action.setCallback(this, function(response) {
                var state = response.getState();
                if (state === "SUCCESS") {
                      unSavedChange.setUnsavedChanges(false);
                    var storeResponse = response.getReturnValue();
                    component.set("v.showSaveCancelBtn",false);
                    $A.get('e.force:refreshView').fire(); 
                }
            });
            $A.enqueueAction(action);
    },
    getApplicationURL: function(component, event) {
        var action = component.get("c.getApplicationURL");
         var appId = component.get("v.singleRec.Id");
         action.setParams({  applicationid : appId});
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var result = response.getReturnValue();
                  component.set("v.contentVersionObj", result);
                //component.set('v.showSpinner', false);
            }
        });
        $A.enqueueAction(action);
    },
    mouseOutHelper : function (component, event) {
       var spScore = parseInt(component.get("v.singleRec.Team_Superstar_Potential_Score__c"));
       var teamSuperStarPotential = component.find("teamSPSScoreint");
   		if(spScore>50){
            component.set("v.showSaveCancelBtn",false);
        	teamSuperStarPotential.setCustomValidity("Superstar Potential Score shouldnt be greater than 50");        
        	
        }else{
            component.set("v.teamSPSScoreEditMode", false);
        }
         if(!isNaN(teamSuperStarPotential)){
        	teamSuperStarPotential.reportValidity();
         }
        var trScore = parseInt(component.get("v.singleRec.Team_Tech_Review_Score__c"));
       var teamTRSScore = component.find("teamTRSScoreint");
   		if(trScore>30){
            component.set("v.showSaveCancelBtn",false);
        	teamTRSScore.setCustomValidity("Tech Review Score shouldnt be greater than 30");        
        	
        }else{
            component.set("v.teamTRSScoreEditMode", false);
        }
         if(!isNaN(teamTRSScore)){
        	teamTRSScore.reportValidity();
         }
          var brScore = parseInt(component.get("v.singleRec.Team_Business_Review_Score__c"));
       var teamBRSScore = component.find("teamBRSScoreint");
   		if(brScore>20){
            component.set("v.showSaveCancelBtn",false);
        	teamBRSScore.setCustomValidity("Business Review Score shouldnt be greater than 30");        
        	
        }else{
            component.set("v.teamBRSScoreEditMode", false);
        }
         if(!isNaN(teamBRSScore)){
        	teamBRSScore.reportValidity();
         }
         window.setInterval(
            $A.getCallback(function() { 
                component.set("v.RankEditMode", false);
                //component.set("v.teamSPSScoreEditMode", false);
                //component.set("v.teamTRSScoreEditMode", false);
                //component.set("v.teamBRSScoreEditMode", false);
                component.set("v.teamScoreEditMode", false);
                component.set("v.teamInterviewDecisionEditMode", false);
                component.set("v.teamSREditMode", false);
                component.set("v.teamSSREditMode", false);
                component.set("v.techSREditMode", false);
                component.set("v.commentEditMode", false);
            }), 3000
        ); 

        
    }
})