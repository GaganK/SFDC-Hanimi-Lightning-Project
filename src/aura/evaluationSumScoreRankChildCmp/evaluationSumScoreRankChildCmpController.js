({
    
    doInit: function(component, event, helper) {
      // call the fetchPickListVal(component, field_API_Name, aura_attribute_name_for_store_options) -
      // method for get picklist values dynamic   
        helper.fetchPickListVal(component, 'Tech_Specialization__c', 'StreamPotenPicklistOpts');
        var selSPList = component.get("v.singleRec.Tech_Specialization__c");
       var selnewSPList = [];
        if(selSPList!='' && selSPList!=null && selSPList!='undefined')
       selnewSPList=  selSPList.toString().split(';');
        component.set("v.streamPotenList",selnewSPList);
            //alert('****selSPList******'+component.get("v.singleRec.Ranking__c"));
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
     inlineEditms : function(component,event,helper){   
        component.set("v.masterRankEditMode", true);      
       
    },
     onMSChange : function(component,event,helper){ 
        // if picklist value change,
         component.set("v.singleRec.Master_Ranking__c", event.getParam("value")); 
        // then show save and cancel button by set attribute to true
        component.set("v.showSaveCancelBtn",true);
    },     
    
    closeMSBox : function (component, event, helper) {
       // on focus out, close the input section by setting the 'spEditMode' att. as false
        component.set("v.masterRankEditMode", false); 
    }
})