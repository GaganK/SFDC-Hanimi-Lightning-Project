({
    
    doInit: function(component, event, helper) {
      // call the fetchPickListVal(component, field_API_Name, aura_attribute_name_for_store_options) -
      // method for get picklist values dynamic   
        helper.fetchPickListVal(component, 'Tech_Specialization__c', 'StreamPotenPicklistOpts');
         var selSPList = [];
       selSPList = component.get("v.singleRec.Tech_Specialization__c");
       var selnewSPList = [];
        if(selSPList!='' && selSPList!=null && selSPList!='undefined')
       selnewSPList=  selSPList.toString().split(';');
        component.set("v.streamPotenList",selnewSPList);
            //alert('****selSPList******'+component.get("v.streamPotenList"));
    }, 
    
    inlineEditSp : function(component,event,helper){   
        // show the SP edit field popup 
        component.set("v.spEditMode", true);      
       
    },
     onSPChange : function(component,event,helper){ 
        // if picklist value change,
         component.set("v.singleRec.Tech_Specialization__c", event.getParam("values")); 
        // then show save and cancel button by set attribute to true
        component.set("v.showSaveCancelBtn",true);
    },     
    
    closeSPBox : function (component, event, helper) {
       // on focus out, close the input section by setting the 'spEditMode' att. as false
        component.set("v.spEditMode", false); 
    },
      inlineEditEval1 : function(component,event,helper){   
        component.set("v.eval1EditMode", true);   
       },
      onEval1Change : function(component,event,helper){ 
        // if picklist value change,
        component.set("v.singleRec.Evaluator_1__c", component.get("v.selectedEvalID.Id")); 
          console.log('enetr'+component.get("v.selectedEvalID.Id"));
        // then show save and cancel button by set attribute to true
        component.set("v.showSaveCancelBtn",true);
    },
    inlineEditEval2 : function(component,event,helper){   
        component.set("v.eval2EditMode", true);   
       },
      onEval2Change : function(component,event,helper){ 
        // if picklist value change,
        component.set("v.singleRec.Evaluator_2__c", component.get("v.selectedEval2ID.Id")); 
        component.set("v.showSaveCancelBtn",true);
    },
    inlineEditEval3 : function(component,event,helper){   
        component.set("v.eval3EditMode", true);   
       },
      onEval3Change : function(component,event,helper){ 
        component.set("v.singleRec.Evaluator_3__c", component.get("v.selectedEval3ID.Id")); 
        component.set("v.showSaveCancelBtn",true);
    }
})