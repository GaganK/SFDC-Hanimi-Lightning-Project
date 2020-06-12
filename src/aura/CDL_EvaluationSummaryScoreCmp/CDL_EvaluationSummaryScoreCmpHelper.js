({
	searchTimer : {},
     copyTimer : {},

    prepareColumnsToDisplay : function(component, event) {

        var selectedColumnsInfo = {};
        var selectedColumns = [];

        var columns = [
            { value: "applicationNumber", label: "Application Number" },
            { value: "firstSitePreference", label: "First Site Preference" },
            { value: "secondSitePreference", label: "Second Site Preference" },
            { value: "ventureName", label: "Venture Name" },
            { value: "founderName", label: "Founder Name" },
            { value: "founderEmail", label: "Founder Email" },
            { value: "streamRecommendation", label: "Stream Recommendation" },
            { value: "subStreamCategory", label: "Sub-Stream Category" },
            { value: "interviewAlignment", label: "Interview Alignment" },
            { value: "interviewer1Name", label: "Interviewer 1 Name" },
            { value: "interviewer1Score", label: "Interviewer 1 Score" },
            { value: "interviewer1Decision", label: "Interviewer 1 Decision" },
            { value: "interviewer1Comments", label: "Interviewer 1 Comments" },
            { value: "interviewer2Name", label: "Interviewer 2 Name" },
            { value: "interviewer2Score", label: "Interviewer 2 Score" },
            { value: "interviewer2Decision", label: "Interviewer 2 Decision" },
            { value: "interviewer2Comments", label: "Interviewer 2 Comment" },
            { value: "FAReviewer1Name", label: " FA Reviewer 1 Name" },
            { value: "FAReviewer1InOutTooEarly", label: "FA Reviewer 1 In/Out/Too Early" },
            { value: "FAReviewer1Comments", label: "FA Reviewer 1 Comments" },
            { value: "FAReviewer2Name", label: " FA Reviewer 2 Name" },
            { value: "FAReviewer2InOutTooEarly", label: "FA Reviewer 2 In/Out/Too Early" },
            { value: "FAReviewer2Comments", label: "FA Reviewer 2 Comments" },
            { value: "PreInterviewRank", label: "Pre Interview Rank" },
            { value: "PostInterviewAcceptanceDecision", label: "Post Interview Acceptance Decision" },
            { value: "TechAssessment", label: "Tech Assessment" },
            { value: "TechAssessmentScientist", label: "Tech Assessment Scientist" },
            { value: "TechAssessmentScientistSuitedtoReview", label: "Tech Assessment Scientist- Suited to Review?" },
            { value: "TechAssessmentOutcome", label: "Tech Assessment Outcome" },
            { value: "TechAssessmentFollowUpRequired", label: "Tech Assessment Follow Up Required?" }
        ];

        for(var index = 0; index < columns.length; index++) {

            var column = columns[index];

            selectedColumns.push(column.value);
            if(column.value=='evaluator1InterviewRecommendation' || column.value=='evalOneScore' || column.value=='evalTwoscore' 
               || column.value=='evalThreescore' || column.value=='evaluator2InterviewRecommendation' || column.value=='evaluator3InterviewRecommendation'
               || column.value=='evaluator1StreamRecommendation' || column.value=='evaluator2StreamRecommendation' || column.value=='evaluator3StreamRecommendation'){
                selectedColumnsInfo[column.value] = false;
            }else{
                 selectedColumnsInfo[column.value] = true;
            }
           
        }

        component.set("v.selectedColumnsInfo", selectedColumnsInfo);
        component.set("v.availableColumns", columns);
        component.set("v.selectedColumns", selectedColumns);
        component.set("v.requiredColumns", ["applicationNumber"]);
    },

    showHideSelectedColumn : function(component, event, helper) {

        var selectedColumnsInfo = component.get("v.selectedColumnsInfo");
        var columnVar = event.getSource().get("v.ariaLabel");
        var currentValue = selectedColumnsInfo[columnVar];
        if(currentValue && currentValue === true) {

            currentValue = false;
        } else {

            currentValue = true;
        }

        selectedColumnsInfo[columnVar] = currentValue;
        component.set("v.selectedColumnsInfo", selectedColumnsInfo);
    },

    updateSelectedColumnsInfo : function(component, event) {

        var selectedColumnsInfo = component.get("v.selectedColumnsInfo");
        var selectedColumns = component.get("v.selectedColumns");

        for(var key in selectedColumnsInfo) {

            selectedColumnsInfo[key] = false;
        }

        for(var index = 0; index < selectedColumns.length; index++) {

            selectedColumnsInfo[selectedColumns[index]] = true;
        }

        component.set("v.selectedColumnsInfo", selectedColumnsInfo);
        component.set("v.iscolumnsSelOpen", false);
        /*var el = component.find('columnSelectionModal');
        $A.util.addClass(el,'hideModal');*/
    },

    updateOrder : function(component, event) {

        var availableColumns = component.get("v.availableColumns");
        var selectedColumns = component.get("v.selectedColumns");
        var orderedSelectedColumns = [];

        for(var indexI = 0; indexI < availableColumns.length; indexI++) {

            var column = availableColumns[indexI];

            for(var indexJ = 0; indexJ < selectedColumns.length; indexJ++) {

                var selectedColumn = selectedColumns[indexJ];

                if(selectedColumn === column.value) {

                    orderedSelectedColumns.push(selectedColumn);
                }
            }
        }

        component.set("v.selectedColumns", orderedSelectedColumns);
    },

    doInitHelper : function(component,event) {
		 // call the apex class method and fetch app list 
		 component.set("v.isProcessing", true); 
         var action = component.get("c.getAllApplications");
       action.setParams({ 
            "searchTerm" : component.get("v.searchTerm"),
            "selectedFilterApp" : component.get("v.selectedApplications"),
            "selectFirstsitepreference" : component.get("v.selectfirstsitepreference"),
            "selectedsecondsitepreference" : component.get("v.selectedsecondsitepreference"),
              "sortField" : component.get("v.sortField"),
               "sortAsc" : component.get("v.sortAsc"),
           "selectedVentures" : component.get("v.selectedVentures"),
          /* "selectedFounderNameList" : component.get("v.selectedFounderNameList"),
           "selectedFounderEmailList" : component.get("v.selectedFounderEmailList"),
           "selectStreamRecomendationList" : component.get("v.selectSteamRecomendationList"),
           "selectSubStreamCategoryList" : component.get("v.selectSubStreamCategoryList"),
           "selectInterviewAlignmentList" : component.get("v.selectInterviewAlignmentList"),
           "selectInterview1NameList" : component.get("v.selectInterview1NameList"),
           "selectInterview1ScopeList" : component.get("v.selectInterview1ScopeList"),
           "selectInterview1DecisionList" : component.get("v.selectInterview1DecisionList"),
           "selectInterview1CommentList" : component.get("v.selectInterview1CommentList"), 
           "selectInterview2NameList" : component.get("v.selectInterview2NameList"),
           "selectInterview2ScopeList" : component.get("v.selectInterview2ScopeList"),
           "selectInterview2DecisionList" : component.get("v.selectInterview2DecisionList"),
           "selectInterview2CommentList" : component.get("v.selectInterview2CommentList"),*/
           "selectfinalrank" : component.get("v.selectfinalrank"),
           "selectinterviewRecommendation" : component.get("v.selectinterviewRecommendation"),
           "selectstreamRecommendation" : component.get("v.selectstreamRecommendation"),
         
           "currentselectedAppType" : component.get("v.currentselectedAppType")
        });
        
        //alert(component.get("v.selectedStreamPotentialList"));
             action.setCallback(this, function(response) {
              var state = response.getState();
              if (state === "SUCCESS") {
                  var storeResponse = response.getReturnValue();
                   var pageSize = component.get("v.pageSize");
                    var totalRecordsList = storeResponse;
                    var totalLength = totalRecordsList.length;
                    component.set("v.totalRecordsCount", totalLength);
                    component.set("v.startPage",0);
                    component.set("v.endPage",pageSize-1);
                  
                  console.log(JSON.stringify(storeResponse));
               // set ApplicationList list with return value from server.
                  component.set("v.ApplicationList", storeResponse);
                  var PaginationLst = [];
                   var plValues = [];
                   var FsValues = [];
                   var uniqueFsValues = [];
                   var SsValues = [];
                   var uniqueSsValues = [];
                   var venValues = [];
                   var uniquevenValues = [];
                   var spValues = [];
                   var uniquevenspValues = [];
                  
                   var rfValues = [];
                   var uniquerfValues = [];
                   var FrValues = [];
                  
                    var uniquerrankValues = [];
                   var rankValues = [];
                  
                   var FsValues = [];
                   var mastValues = [];
                   var compValues = [];
                  
                   var techValues = [];
				   var streamP = [];
                  
                   var uniquetecScrenValues = [];
                   var tecScrenValues = [];
                  
                  //for(var i=0; i < component.get("v.ApplicationList").length; i++){
                   for(var i=0; i < pageSize; i++){
                        if(component.get("v.ApplicationList").length > i){
                        PaginationLst.push(storeResponse[i]);
                       plValues.push({
                                    label: storeResponse[i].Name,
                                    value: storeResponse[i].Name
                                });
                      component.set('v.ApplList', plValues);
                      
                      
                       if(storeResponse[i].X1st_Preference_CDL_Location__c!=null){
                                if(uniqueFsValues.includes(storeResponse[i].X1st_Preference_CDL_Location__c) == false)
                                {
                                uniqueFsValues.push(storeResponse[i].X1st_Preference_CDL_Location__c)
                                FsValues.push({
                                    label: storeResponse[i].X1st_Preference_CDL_Location__c,
                                    value: storeResponse[i].X1st_Preference_CDL_Location__c
                                });
                                }
                            }
                       component.set('v.firstsitepreferenceList', FsValues);
                      
                       if(storeResponse[i].X2nd_Preference_CDL_Location__c!=null){
                                 if(uniqueSsValues.includes(storeResponse[i].X2nd_Preference_CDL_Location__c) == false)
                                 {
                                 uniqueSsValues.push(storeResponse[i].X2nd_Preference_CDL_Location__c);
                                SsValues.push({
                                    label: storeResponse[i].X2nd_Preference_CDL_Location__c,
                                    value: storeResponse[i].X2nd_Preference_CDL_Location__c
                                });
                                 }
                            }
                      component.set('v.secondsitepreferenceList', SsValues);
                      
                   
                        
                       
                       if(uniquevenValues.includes(storeResponse[i].Venture__r.Name) == false){
                                {
                             uniquevenValues.push(storeResponse[i].Venture__r.Name);
                                  venValues.push({
                                        label: storeResponse[i].Venture__r.Name,
                                        value: storeResponse[i].Venture__r.Name
                                    });  
                                }
                       }
                       component.set('v.VentureList', venValues);
                      
                            
                            
                       /*if(storeResponse[i].Tech_Specialization__c!=null){
                                 if(uniquevenspValues.includes(storeResponse[i].Tech_Specialization__c) == false)
                                 {
                                 uniquevenspValues.push(storeResponse[i].Tech_Specialization__c);
                                spValues.push({
                                    label: storeResponse[i].Tech_Specialization__c,
                                    value: storeResponse[i].Tech_Specialization__c
                                });
                                 }
                       }     
                       component.set('v.StreamPotentialList', spValues);*/                           
                      
                       
                       if(storeResponse[i].Application_Referral_Name__c!=null){
                                 if(uniquerfValues.includes(storeResponse[i].Application_Referral_Name__c) == false)
                                 {
                                 uniquerfValues.push(storeResponse[i].Application_Referral_Name__c);
                                 rfValues.push({
                                    label: storeResponse[i].Application_Referral_Name__c,
                                    value: storeResponse[i].Application_Referral_Name__c
                                 });
                                 }
                       }  
                       component.set('v.refferalList', rfValues);
                            
                            
                            if(storeResponse[i].FinalRank__c!=null){
                                if(uniquerrankValues.includes(storeResponse[i].FinalRank__c) == false)
                                {
                                    var finalRank = storeResponse[i].FinalRank__c;
                                    finalRank = finalRank.toString();
                                    uniquerrankValues.push(finalRank);
                                    rankValues.push({
                                        label: finalRank,
                                        value: finalRank
                                    });
                                }
                            }
                            component.set('v.teamrank', rankValues);
                            
                            /*if(storeResponse[i].Tech_Specialization__c!=null){
                                if(uniquerrankValues.includes(storeResponse[i].Tech_Specialization__c) == false)
                                {
                                    uniquerrankValues.push(storeResponse[i].Tech_Specialization__c);
                                    streamP.push({
                                        label: storeResponse[i].Tech_Specialization__c,
                                        value: storeResponse[i].Tech_Specialization__c
                                    });
                                }
                            }*/
                            
                            
                            
                           
                            
                            if(storeResponse[i].TechScreening__c!=null){
                                if(uniquetecScrenValues.includes(storeResponse[i].TechScreening__c) == false)
                                {
                                    uniquetecScrenValues.push(storeResponse[i].TechScreening__c);
                                    tecScrenValues.push({
                                        label: storeResponse[i].TechScreening__c,
                                        value: storeResponse[i].TechScreening__c
                                    });
                                }
                            }
                            component.set('v.techScreeningRec', tecScrenValues);
                            
                       //component.set('v.finalrankList', rankValues);
                      
                       //alert(JSON.stringify(storeResponse[i].Evaluations__r[0]));
                       //alert(storeResponse[i].Evaluations__r[0].EvaluatorsRanking__c);
                       /*if(storeResponse[i].Evaluations__r[0].EvaluatorsRanking__c != null){
					   	
                           FrValues.push({
                                    label: storeResponse[i].Evaluations__r[0].EvaluatorsRanking__c,
                                    value: storeResponse[i].Evaluations__r[0].EvaluatorsRanking__c
                       	});					
                       	component.set('v.finalrankList', FrValues);
                           alert(storeResponse[i].Evaluations__r[0].EvaluatorsRanking__c);
                       }*/
                      
                       
                        }  
                  }
                  /* component.set('v.PaginationList', PaginationLst);
                   component.set("v.totalPagesCount", Math.ceil(totalLength / pageSize));*/
                  
                  
                  /*component.set('v.firstsitepreferenceList', FsValues);
                  component.set('v.secondsitepreferenceList', SsValues);
                  component.set('v.VentureList', venValues);
                  component.set('v.StreamPotentialList', streamP);*/
                  
                  
                  /*component.set('v.refferalList', venValues);
                  
                  component.set('v.refferalList', venValues);
                  component.set('v.refferalList', venValues);
                  component.set('v.refferalList', venValues);
                  component.set('v.refferalList', venValues);*/
                  
                  component.set("v.isProcessing", false);
            	  component.set("v.isSearching", false);
                   var pageSize = component.get('v.pageSize');
                  component.set("v.totalPagesCount", Math.floor((storeResponse.length + pageSize -1 )/pageSize));
                  this.renderPagination(component, event);
                  
            }else{
				 alert('@Error...')
				 component.set("v.isProcessing", false);
            	 component.set("v.isSearching", false);
			}
        });
        $A.enqueueAction(action);
	},
    // navigate to next pagination record set   
    next : function(component,event,sObjectList,end,start,pageSize){
        var Paginationlist = [];
        var counter = 0;
        for(var i = end + 1; i < end + pageSize + 1; i++){
            if(sObjectList.length > i){ 
               /* if(component.find("selectAllId").get("v.value")){
                    Paginationlist.push(sObjectList[i]);
                }else{*/
                    Paginationlist.push(sObjectList[i]);  
               // }
            }
            counter ++ ;
        }
        start = start + counter;
        end = end + counter;
        component.set("v.startPage",start);
        component.set("v.endPage",end);
        component.set('v.PaginationList', Paginationlist);
    },
   // navigate to previous pagination record set   
    previous : function(component,event,sObjectList,end,start,pageSize){
        var Paginationlist = [];
        var counter = 0;
        for(var i= start-pageSize; i < start ; i++){
            if(i > -1){
              /*  if(component.find("selectAllId").get("v.value")){
                    Paginationlist.push(sObjectList[i]);
                }else{*/
                    Paginationlist.push(sObjectList[i]); 
               // }
                counter ++;
            }else{
                start++;
            }
        }
        start = start - counter;
        end = end - counter;
        component.set("v.startPage",start);
        component.set("v.endPage",end);
        component.set('v.PaginationList', Paginationlist);
        
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
    renderPagination : function(component, event) {

        var allApplications = component.get("v.ApplicationList");
        var pageSize = component.get('v.pageSize');
        var currentPageNumber = component.get("v.currentPage");
        var pageRecords = allApplications.slice((currentPageNumber-1)*pageSize, currentPageNumber*pageSize);
        component.set("v.PaginationList", pageRecords);
    },
    
    openModalAndInitiateFilter : function(component, event, helper) {

        var filterBy = event.getSource().get("v.ariaLabel");
        
        if(filterBy === 'Application Number') {
			
            component.set('v.allAvailableOptions',component.get("v.ApplList"));
            component.set('v.availableOptions',component.get("v.ApplList"));
            component.set('v.filteredOptions',component.get("v.filteredApplicationNumbers"));
        } else if(filterBy === 'Venture Name') {

            component.set('v.allAvailableOptions',component.get("v.VentureList"));
            component.set('v.availableOptions',component.get("v.VentureList"));
            component.set('v.filteredOptions',component.get("v.filteredVentures"));
        }  else if(filterBy === 'First Site Preference') {

            component.set('v.allAvailableOptions',component.get("v.firstsitepreferenceList"));
            component.set('v.availableOptions',component.get("v.firstsitepreferenceList"));
            component.set('v.filteredOptions',component.get("v.filteredFirstSitePreference"));
        } else if(filterBy === 'Second Site Preference') {

            component.set('v.allAvailableOptions',component.get("v.secondsitepreferenceList"));
            component.set('v.availableOptions',component.get("v.secondsitepreferenceList"));
            component.set('v.filteredOptions',component.get("v.filteredSecondSitePreference"));
        }  
            /*else if(filterBy === 'Referred By') {
			  component.set('v.allAvailableOptions',component.get("v.refferalList"));
            component.set('v.availableOptions',component.get("v.refferalList"));
            component.set('v.filteredOptions',component.get("v.filteredReferralBy"));
        }
        else if(filterBy === 'Tech Screening Recommendation') {
			  component.set('v.allAvailableOptions',component.get("v.techScreeningRec"));
            component.set('v.availableOptions',component.get("v.techScreeningRec"));
            component.set('v.filteredOptions',component.get("v.filteredtechScreeningRec"));
        }
        else if(filterBy === 'Tech Stream Recommendation') {
			  component.set('v.allAvailableOptions',component.get("v.techStreamRecommendationList"));
            component.set('v.availableOptions',component.get("v.techStreamRecommendationList"));
            component.set('v.filteredOptions',component.get("v.filteredTechStreamRecommendation"));
        }
        else if(filterBy === 'Site Referral') {
			  component.set('v.allAvailableOptions',component.get("v.siteReferralList"));
            component.set('v.availableOptions',component.get("v.siteReferralList"));
            component.set('v.filteredOptions',component.get("v.filteredSiteReferral"));
        }
        else if(filterBy === 'Reason Recommendation') {
			  component.set('v.allAvailableOptions',component.get("v.reasonRecommendationList"));
            component.set('v.availableOptions',component.get("v.reasonRecommendationList"));
            component.set('v.filteredOptions',component.get("v.filteredReasonRecommendation"));
        }*/

        component.set("v.fieldSearchTerm","");
        component.set("v.filterBy",filterBy);
        component.set("v.isModalOpen", true);
    },
    
    
    onFilterSearch : function(component, event, helper) {

        var searchString = component.get("v.fieldSearchTerm").toLowerCase();
        var allAvailableOptions = component.get("v.allAvailableOptions");
        var availableOptions = [];

        if(searchString === '') {

            component.set("v.availableOptions",allAvailableOptions);
        } else {

            for(var index = 0; index < allAvailableOptions.length; index++){

                var filterOption = allAvailableOptions[index];

                if(filterOption.label.toLowerCase().includes(searchString)) {

                    availableOptions.push(filterOption)
                }
            }

            component.set("v.availableOptions",availableOptions);
        }
    },
     filterData : function(component, event, helper) {

        var filterBy = component.get("v.filterBy");
        var filteredOptions = component.get("v.filteredOptions");

        if(filterBy === 'Application Number') {

            component.set('v.selectedApplications',filteredOptions);
        }else if(filterBy === 'Venture Name') {
			
            component.set('v.selectedVentures',filteredOptions);
        }else if(filterBy === 'First Site Preference') {

            component.set('v.selectfirstsitepreference',filteredOptions);
        }else if(filterBy === 'Second Site Preference') {

            component.set('v.selectedsecondsitepreference',filteredOptions);
        }
            /*else if(filterBy === 'Stream Potential') {
			
            component.set('v.selectedStreamPotentialList',filteredOptions);
        }
            else if(filterBy === 'Referred By') {

            component.set('v.selectreferal',filteredOptions);
        }
            else if(filterBy === 'Team Rank') {
            //alert('testTeam:--'+filteredOptions);
            component.set('v.selectfinalrank',filteredOptions);
        }
         else if(filterBy === 'Stream Recommendation') {

            component.set('v.selectStreamRecommendation',filteredOptions);
        }
         else if(filterBy === 'Tech Stream Recommendation') {

            component.set('v.selectTechStreamRecommendation',filteredOptions);
        }
         else if(filterBy === 'Site Referral') {

            component.set('v.selectSiteReferral',filteredOptions);
        }
         else if(filterBy === 'Reason Recommendation') {

            component.set('v.selectreasonRecommendation',filteredOptions);
        }*/

        helper.doInitHelper(component, event);
    }
})