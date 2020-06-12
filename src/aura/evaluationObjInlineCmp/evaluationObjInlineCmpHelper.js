({
	fetchrecommendedIntInput : function(component, event) {
		 var action = component.get("c.getEvalPicklists");
        var opts=[];
         action.setParams({
                    'fieldName': 'Recommend_Interview_2__c'
                  });
        action.setCallback(this, function(a) {
            opts.push({
                class: "optionClass",
                label: "--- None ---",
                value: ""
            });
            for(var i=0;i< a.getReturnValue().length;i++){
                opts.push({"class": "optionClass", label: a.getReturnValue()[i], value: a.getReturnValue()[i]});
            }
            component.set("v.recommendedIntoptions", opts);
             
        });
        $A.enqueueAction(action); 
	},
    showToast : function(component, event,errormessage,typemessage) {
        $A.get("e.c:showToastEvent")
          .setParams({
            type: typemessage,
            title: errormessage,
            description: errormessage,
            delay: 5000
          })
          .fire();
    },
    fetchstreamRecommend : function(component, event) {
		 var action = component.get("c.getEvalPicklists");
        var opts=[];
         action.setParams({
                    'fieldName': 'Stream_Recommendation__c'
                  });
        action.setCallback(this, function(a) {
            opts.push({
                class: "optionClass",
                label: "--- None ---",
                value: ""
            });
            for(var i=0;i< a.getReturnValue().length;i++){
                opts.push({"class": "optionClass", label: a.getReturnValue()[i], value: a.getReturnValue()[i]});
            }
            component.set("v.streamRecommendoptions", opts);
             
        });
        $A.enqueueAction(action); 
	},
    fetchtechStream : function(component, event) {
		 var action = component.get("c.getEvalPicklists");
        var opts=[];
         action.setParams({
                    'fieldName': 'Tech_Screening_Recommendation__c'
                  });
        action.setCallback(this, function(a) {
            opts.push({
                class: "optionClass",
                label: "--- None ---",
                value: ""
            });
            for(var i=0;i< a.getReturnValue().length;i++){
                opts.push({"class": "optionClass", label: a.getReturnValue()[i], value: a.getReturnValue()[i]});
            }
               component.set("v.techStreamoptions", opts);
             
        });
        $A.enqueueAction(action); 
	},
    fetchrefOtherSite : function(component, event) {
		 var action = component.get("c.getEvalPicklists");
        var opts=[];
         action.setParams({
                    'fieldName': 'Refer_to_Other_Site__c'
                  });
        action.setCallback(this, function(a) {
            opts.push({
                class: "optionClass",
                label: "--- None ---",
                value: ""
            });
            for(var i=0;i< a.getReturnValue().length;i++){
                opts.push({"class": "optionClass", label: a.getReturnValue()[i], value: a.getReturnValue()[i]});
            }
           component.set("v.refOtherSiteoptions", opts);
             
        });
        $A.enqueueAction(action); 
	},
    fetchflag : function(component, event) {
		 var action = component.get("c.getEvalPicklists");
        var opts=[];
         action.setParams({
                    'fieldName': 'Flag__c'
                  });
        action.setCallback(this, function(a) {
            opts.push({
                class: "optionClass",
                label: "--- None ---",
                value: ""
            });
            for(var i=0;i< a.getReturnValue().length;i++){
                opts.push({"class": "optionClass", label: a.getReturnValue()[i], value: a.getReturnValue()[i]});
            }
          component.set("v.flagoptions", opts);
             
        });
        $A.enqueueAction(action); 
	},
     SaveData: function(component, event, helper) {
        var action = component.get("c.saveRecord");
        var updatedApp = component.get('v.updatedApplications');
        var updatedEval = component.get('v.updatedEvaluations');
        action.setParams({
            'app': updatedApp,
            'evaList':updatedEval
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
           var unSavedChange = component.find('unsavedData');
            if (state === "SUCCESS") {  
                unSavedChange.setUnsavedChanges(false);
                var storeResponse = response.getReturnValue();
				// helper.showToast(component,event,'Records Updated Successfully!!','success');
               // component.set("v.showSaveCancelBtn",false);
                $A.get('e.force:refreshView').fire();
            }else if (state === "ERROR") {
                var errors = response.getError();
               // helper.showToast(component,event,'Some thing went wrong, please contact your Administator!!','Error');
                if (errors) {
                    if (errors[0] && errors[0].message) {
                    }
                } else {
                }
                unSavedChange.setUnsavedChanges(true);
            }
        });
        $A.enqueueAction(action);
    }
})