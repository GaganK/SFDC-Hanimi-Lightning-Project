({
    searchTimer : {},
    /* doInitHelper funcation to fetch all records, and set attributes value on component load */
    doInitHelper : function(component,event){
         component.set("v.isProcessing", true);
        var action = component.get("c.fetchventurewrapper");
         var dayId = component.get("v.dayId");
        var isDay1 = false;
        if(dayId=='day1'){
           isDay1 = true; 
        }
        action.setParams({ 
                          searchTerm : component.get("v.searchTerm"),
                          sortField : component.get("v.sortField"),
                          sortAsc : component.get("v.sortAsc"),
            			"selectedVentures" : component.get("v.selectedVentures"),
           				"selecttechList" : component.get("v.selecttechList"),
            isDay1 :isDay1
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
                 var uniqueSelectedVentureValues = [];
                var uniqueRankingVal = [];
                var oRes = response.getReturnValue();
                if(oRes.length > 0){
                    component.set('v.listOfAllApplications', oRes);
                    for(var i=0; i < oRes.length; i++){
                        if(oRes[i].isSelectedVal!='undefined' && oRes[i].isSelectedVal!='' && oRes[i].isSelectedVal!=null){
                           uniqueSelectedVentureValues.push(oRes[i].acctObj.Id+'&&'+oRes[i].isSelectedVal);
                            if(uniqueRankingVal.includes(oRes[i].isSelectedVal) == false){
                                uniqueRankingVal.push(oRes[i].isSelectedVal);
                            }
                        }
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
                 helper.showToast(component, event,'Something Went wrong, Please contact your Administrator!','error');
            }
            component.set("v.selectedVenturesList",uniqueSelectedVentureValues);
            component.set("v.existingRankingList",uniqueRankingVal);
        
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
   
    beforeUnloadHandler: function(component, event) {
  		confirm('before unload handler has been called.');
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
    SaveAdmit : function(component, event) {
        var action = component.get("c.saveAdmit");
        var updatedList = [];
        var selUpdatedVentures=[];
        var appList = component.get("v.listOfAllApplications");
        for (var i = 0; i < appList.length; i++) {
            if(appList[i].isSelectedVal!=null & appList[i].isSelectedVal!='')
            selUpdatedVentures.push(appList[i].acctObj.Id+'&&'+appList[i].isSelectedVal);
        }
        component.set("v.UpdatedVenturesList", selUpdatedVentures);
         var selVentures = component.get("v.UpdatedVenturesList");
        console.log('*******selVentures******'+selVentures);
        action.setParams({
           "admitVentWrap": component.get("v.UpdatedVenturesList")
        });
        action.setCallback(this, function(response) {
             var state = response.getState();
            console.log('**********state************'+state);
            if (state === "SUCCESS") {
               /* var unsavedData = component.find('unsavedData');
                unsavedData.setUnsavedChanges(false);*/
                this.showToast(component, event,'Your ranking was updated successfully!!','Success');
                $A.get('e.force:refreshView').fire(); 
            }else{
               this.showToast(component, event,'Something went wrong, Please contact your Admin!','Error');
 
            }
        } );
        $A.enqueueAction(action);
    }
   
})