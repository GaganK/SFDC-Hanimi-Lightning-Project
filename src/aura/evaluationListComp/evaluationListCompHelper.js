({
    getEvaluationsList : function(component, helper) {
        var action = component.get("c.getevaluations");
        action.setStorable();
         var selectedStreamPotentialList = component.get("v.selectedStreamPotentialList");
        var selectedInitialCDLSitePref = component.get("v.selectedInitialCDLSitePref");
        var selectedApplicationStage = component.get("v.selectedApplicationStage");
        var selectedApplicationOwnerId = component.get("v.selectedApplicationOwnerId");
        var selectDate = component.get("v.createdDate");
        //alert('*******selectDate**********'+selectDate);
      
        action.setParams({  selectedInitialCDLSitePref : selectedInitialCDLSitePref,selectedStreamPotential :  selectedStreamPotentialList
        , appStage:selectedApplicationStage ,ownerId : selectedApplicationOwnerId,selDate: selectDate});
        action.setCallback(this,function(response) {
        
            var state = response.getState();
               
            if (state === "SUCCESS") {
				 var records =response.getReturnValue();
                var defaultranking = 0;
              records.forEach(function(record){
                   //alert('*************records*******************'+record.Venture__r.Name);
                   defaultranking++;
                    record.linkName = record.Application__r.Name;
                    record.companyName = record.Venture__r.Name;
                    record.techScore = record.Tech_Review__c;
                    record.marketingScore = record.Business_Review__c;
                    record.superStarPotential = record.Superstar_Potential__c;
                    record.ranking = defaultranking;
                });
                console.log('Response Time: '+((new Date().getTime())-requestInitiatedTime));
                component.set("v.totalPages", Math.ceil(response.getReturnValue().length/component.get("v.pageSize")));
                component.set("v.allData", response.getReturnValue());
                component.set("v.currentPageNumber",1);
                helper.buildData(component, helper);
            }
        });
        var requestInitiatedTime = new Date().getTime();
        $A.enqueueAction(action);
    },
    getInitialCDLSitePrefPicklist: function(component, event) {
        var action = component.get("c.getInitialCDLSitePref");
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var result = response.getReturnValue();
                var InitialCDLSitePrefMap = [];
                for(var key in result){
                    InitialCDLSitePrefMap.push({key: key, value: result[key]});
                }
                component.set("v.InitialCDLSitePrefMap", InitialCDLSitePrefMap);
            }
        });
        $A.enqueueAction(action);
    },
    getApplicationStagePicklist: function(component, event) {
        var action = component.get("c.getApplicationStage");
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var result = response.getReturnValue();
                var ApplicationStageMap = [];
                for(var key in result){
                    ApplicationStageMap.push({key: key, value: result[key]});
                }
                component.set("v.ApplicationStageMap", ApplicationStageMap);
            }
        });
        $A.enqueueAction(action);
    },
    getApplicationOwnerPicklist: function(component, event) {
        var action = component.get("c.getApplicationOwner");
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var result = response.getReturnValue();
                var ApplicationOwnerMap = [];
                for(var key in result){
                    ApplicationOwnerMap.push({key: key, value: result[key]});
                }
                component.set("v.ApplicationOwnerMap", ApplicationOwnerMap);
            }
        });
        $A.enqueueAction(action);
    },
    getAnalysisReport : function(component, helper) {
        var action = component.get("c.getAnalysisStats");
        action.setStorable();
         var selectedApplicationId = component.get("v.selectedEvaluationId");
     
        action.setParams({  applicationId : selectedApplicationId});
        action.setCallback(this,function(response) {
        
            var state = response.getState();
               
            if (state === "SUCCESS") {
                 var result = response.getReturnValue();
                 component.set('v.analysisReportMap',response.getReturnValue());
              /*  var AnalysisReportMap = [];
                for(var key in result){
                    AnalysisReportMap.push({key: key, value: result[key]});
                }
                component.set("v.analysisReportMap", AnalysisReportMap);*/
            }
        });
        $A.enqueueAction(action);
    },
     getStreamPotential: function(component, event) {
        var action = component.get("c.getStreamPotential");
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
                component.set("v.StreamPotentialList", plValues);
            }
        });
        $A.enqueueAction(action);
    },
    /*
     * this function will build table data
     * based on current page selection
     * */
    buildData : function(component, helper) {
        var data = [];
        var pageNumber = component.get("v.currentPageNumber");
        var pageSize = component.get("v.pageSize");
        var allData = component.get("v.allData");
        var x = (pageNumber-1)*pageSize;
        
        //creating data-table data
        for(; x<=(pageNumber)*pageSize; x++){
            if(allData[x]){
            	data.push(allData[x]);
            }
        }
        component.set("v.data", data);
        
        helper.generatePageList(component, pageNumber);
    },
    
    /*
     * this function generate page list
     * */
    generatePageList : function(component, pageNumber){
        pageNumber = parseInt(pageNumber);
        var pageList = [];
        var totalPages = component.get("v.totalPages");
        if(totalPages > 1){
            if(totalPages <= 10){
                var counter = 2;
                for(; counter < (totalPages); counter++){
                    pageList.push(counter);
                } 
            } else{
                if(pageNumber < 5){
                    pageList.push(2, 3, 4, 5, 6);
                } else{
                    if(pageNumber>(totalPages-5)){
                        pageList.push(totalPages-5, totalPages-4, totalPages-3, totalPages-2, totalPages-1);
                    } else{
                        pageList.push(pageNumber-2, pageNumber-1, pageNumber, pageNumber+1, pageNumber+2);
                    }
                }
            }
        }
        component.set("v.pageList", pageList);
    }, getContacts: function(component, event) {
        var action = component.get("c.getContacts");
         var appId = component.get("v.selectedEvaluationId");
         action.setParams({  applicationid : appId});
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var result = response.getReturnValue();
                  component.set("v.contacts", result);
            }
        });
        $A.enqueueAction(action);
    }
   
 })