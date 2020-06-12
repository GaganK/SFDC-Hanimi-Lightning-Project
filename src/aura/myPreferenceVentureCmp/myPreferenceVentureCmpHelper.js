({
    searchTimer : {},
    /* doInitHelper funcation to fetch all records, and set attributes value on component load */
    doInitHelper : function(component,event){
         component.set("v.isProcessing", true);
        var action = component.get("c.fetchventurewrapper");
        action.setParams({ 
                          searchTerm : component.get("v.searchTerm"),
                          sortField : component.get("v.sortField"),
                          sortAsc : component.get("v.sortAsc"),
            			"selectedVentures" : component.get("v.selectedVentures"),
           				"selecttechList" : component.get("v.selecttechList")                                     
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS"){
                 component.set("v.isProcessing", false);
                var venValues = [];
                var uniquevenValues = [];
                var techValues = [];
                var uniquetechValues = [];
                var industryValues = [];
                var uniqueindustryValues = [];
                var siteValues = [];
                var uniquesiteValues = [];
                var streamValues = [];
                var uniquestreamValues = [];
                
                var oRes = response.getReturnValue();
                //alert('in'+JSON.stringify(oRes[0].appObj));
                if(oRes.length > 0){
                    component.set('v.listOfAllApplications', oRes);
                    for(var i=0; i < oRes.length; i++){
                        if(uniquevenValues.includes(oRes[i].acctObj.Cohort_Name__c) == false){
                                {
                             uniquevenValues.push(oRes[i].acctObj.Cohort_Name__c);
                                  venValues.push({
                                        label: oRes[i].acctObj.Cohort_Name__c,
                                        value: oRes[i].acctObj.Cohort_Name__c
                                    });  
                                }
                       	}
                       component.set('v.VentureList', venValues);
                       if(uniquetechValues.includes(oRes[i].acctObj.Venture__r.Technology_Area__c) == false){
                                {
                             uniquetechValues.push(oRes[i].acctObj.Venture__r.Technology_Area__c);
                                  techValues.push({
                                        label: oRes[i].acctObj.Venture__r.Technology_Area__c,
                                        value: oRes[i].acctObj.Venture__r.Technology_Area__c
                                    });  
                                }
                       	}
                       component.set('v.techList', techValues);
                       if(uniqueindustryValues.includes(oRes[i].acctObj.Venture__r.Industry) == false){
                                {
                             uniqueindustryValues.push(oRes[i].acctObj.Venture__r.Industry);
                                  industryValues.push({
                                        label: oRes[i].acctObj.Venture__r.Industry,
                                        value: oRes[i].acctObj.Venture__r.Industry
                                    });  
                                }
                       	}
                       component.set('v.IndustryList', industryValues);
                       /* if(uniquesiteValues.includes(oRes[i].acctObj.Related_CDL_Site__c) == false){
                                {
                             uniquesiteValues.push(oRes[i].acctObj.Related_CDL_Site__c);
                                  siteValues.push({
                                        label: oRes[i].acctObj.Related_CDL_Site__c,
                                        value: oRes[i].acctObj.Related_CDL_Site__c
                                    });  
                                }
                       	}
                       component.set('v.SiteList', siteValues);
                        if(uniquestreamValues.includes(oRes[i].acctObj.Related_Stream_s__c) == false){
                                {
                             uniquestreamValues.push(oRes[i].acctObj.Related_Stream_s__c);
                                  streamValues.push({
                                        label: oRes[i].acctObj.Related_Stream_s__c,
                                        value: oRes[i].acctObj.Related_Stream_s__c
                                    });  
                                }
                       	}
                       component.set('v.StreamList', streamValues);*/
                    }
                }else{
                    component.set("v.isProcessing", false);
                    // if there is no records then display message
                    component.set("v.bNoRecordsFound" , true);
                } 
            }
            else{
                component.set("v.isProcessing", false);
                alert('Error...');
            }
            
        });
        $A.enqueueAction(action);  
    }, getStreamList: function(component, event) {
        var action = component.get("c.getStreamList");
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var result = response.getReturnValue();
               var plValues = [];
                for (var i = 0; i < result.length; i++) {
                    plValues.push({
                        label: result[i],
                        value: result[i]
                    });
                }
                component.set("v.StreamList", plValues);
            }
        });
        $A.enqueueAction(action);
    },
    getSiteList: function(component, event) {
        var action = component.get("c.getSiteList");
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var result = response.getReturnValue();
               var plValues = [];
                for (var i = 0; i < result.length; i++) {
                    plValues.push({
                        label: result[i],
                        value: result[i]
                    });
                }
                component.set("v.SiteList", plValues);
            }
        });
        $A.enqueueAction(action);
    }
    ,
    getRankingList: function(component, event) {
        var action = component.get("c.getRankingList");
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var result = response.getReturnValue();
               var plValues = [];
                result = result.sort(function(a, b){return a - b});
                 plValues.push({
                        label: '--None--',
                        value: ''
                    });
                for (var i = 0; i < result.length; i++) {
                    plValues.push({
                        label: result[i],
                        value: result[i]
                    });
                }
                component.set("v.RankingList", plValues);
            }
        });
        $A.enqueueAction(action);
    },
    showToast : function(component, event, helper,errormessage,typemessage) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            mode: 'sticky',
            message: errormessage,
            type : typemessage
        });
        toastEvent.fire();
    }   
})