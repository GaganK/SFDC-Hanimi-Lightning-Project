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
            { value: "ventureOverview", label: "Venture Overview" },
            { value: "ventureHeadquarters", label: "Venture HQ" },
            { value: "ventureLinkdin", label: "Founder Linkdin" },
            { value: "streamPotential", label: "Stream Potential" },
            { value: "referOtherSite", label: "Site Referral" },
            { value: "refer", label: "Referral" },
            { value: "finalRank", label: "Rank" },
            { value: "oneLineDescription", label: "One Line Description" },
            { value: "totalScore", label: "Total Score" },
            { value: "interviewRecommendation", label: "Interview recommendation" },
            { value: "ReasonList", label: "Reason" },
            { value: "finalStreamRecommendation", label: "Final Stream recommendation" },
            { value: "techScreening", label: "Tech Screening Recommendation" },
            { value: "CommentsBox", label: "Comment" },
            { value: "generalComment", label: "General Comment" },
            { value: "reasonforRecommendation", label: "Reason for Recommendation" },
            { value: "primaryContact", label: "Primary Contact" },
            { value: "superstarPotential", label: "Superstar Potential" },
            { value: "superstarPotentialComments", label: "Comments" },
            { value: "techReview", label: "Tech Review" },
            { value: "techReviewComments", label: "Comments" },
            { value: "businessReview", label: "Business Review" },
            { value: "businessReviewComments", label: "Comments" }
        ];
        
        for(var index = 0; index < columns.length; index++) {
            
            var column = columns[index];
            
            selectedColumns.push(column.value);
            if(column.value=="otherFlag"){
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
    
    /* doInitHelper funcation to fetch all records, and set attributes value on component load */
    doInitHelper : function(component,event){
        component.set("v.isProcessing", true);
        component.set("v.bNoRecordsFound", false);
        //console.log('selected app type is'+component.get("v.currentselectedAppType"));
        var filteredRecord = JSON.stringify(component.get('v.CompareList'));
        //console.log('fitered records are'+filteredRecord);
        
        var action = component.get("c.fetchAppwrapper");
        var selectedApplications = component.get("v.selectedApplications");
        var selectedVentures = component.get("v.selectedVentures");
        var selectfirstsitepreference = component.get("v.selectfirstsitepreference");
        var selectedStreamPotentialList = component.get("v.selectedStreamPotentialList");
       // var selectedMaster = component.get("v.selectedMaster");
        var selectedsecondsitepreference = component.get("v.selectedsecondsitepreference");
        /*var selectedComputed = component.get("v.selectedComputed");
        var selectedSuperStar = component.get("v.selectedSuperStar");
        var selectedTech = component.get("v.selectedTech");
        var selectedBiz = component.get("v.selectedBiz");
        var selectedOverall = component.get("v.selectedOverall");*/
        var currentselectedAppType = component.get("v.currentselectedAppType");
        var selectreferal = component.get("v.selectreferal");
        //var selectfinalrank = component.get("v.selectfinalrank");
        var selectinterviewRecommendation = component.get("v.selectinterviewRecommendation");
        var selectStreamRecommendation = component.get("v.selectStreamRecommendation");
        var selectTechStreamRecommendation = component.get("v.selectTechStreamRecommendation");
        var selectSiteReferral = component.get("v.selectSiteReferral");
        var selectReasonRecommendation = component.get("v.selectreasonRecommendation");
        //alert(currentselectedAppType);
        action.setParams({ selectedApplications :selectedApplications,
                          selectedVentures:selectedVentures, 
                          selectedStreamPotential:selectedStreamPotentialList,
                          currentselectedAppType:currentselectedAppType,
                          selectedFirstSitePreference:selectfirstsitepreference,
                          selectedsecondsitepreference : selectedsecondsitepreference,
                          selectreferal : selectreferal,
                          searchTerm : component.get("v.searchTerm"),
                          sortField : component.get("v.sortField"),
                          sortAsc : component.get("v.sortAsc"),
                          selectInterviewRecommendation : selectinterviewRecommendation,
                           selectStreamRecommendation : selectStreamRecommendation,
                           selectTechStreamRecommendation : selectTechStreamRecommendation,
                           selectSiteReferral : selectSiteReferral,
                          selectReasonRecommendation : selectReasonRecommendation
                         });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS"){
                component.set("v.isProcessing", false);
                if(component.get("v.searchTerm") !=null && component.get("v.searchTerm") !=''){
                    var allRecords = component.get("v.listOfAllApplications");
                    component.set('v.AllApplications', allRecords);
                    //console.log('Comparing both the list===');
                    var oRes = response.getReturnValue();
                    var lsttocompare = component.get('v.CompareList');
                    if(oRes.length > 0 && lsttocompare.length > 0){
                        for(var i=0; i < oRes.length; i++){                               
                            for (var j=0; j<lsttocompare.length; j++){
                                if(lsttocompare[j].appObj.Id == oRes[i].appObj.Id){
                                    oRes[i].appObj.isChecked =true;
                                }
                            }
                            
                        }
                    }
                    
                    component.set('v.listOfAllApplications', oRes);
                    component.set('v.isSearchedBefore', true);
                    
                }
                
                else if(component.get('v.isSearchedBefore')){
                    //console.log('Searched has been made already'+component.get('v.AllApplications'));
                    var oRes = component.get('v.AllApplications');
                    component.set('v.listOfAllApplications', oRes);
                }
                    else {
                        var oRes = response.getReturnValue();
                        component.set('v.listOfAllApplications', oRes);
                    }
                
                //alert('in'+JSON.stringify(oRes[0].appObj));
                if(oRes.length > 0){
                    
                    //alert(JSON.stringify(component.get('v.listOfAllApplications')));
                    var pageSize = component.get("v.pageSize");
                    var totalRecordsList = oRes;
                    
                    var totalLength = totalRecordsList.length ;
                    component.set("v.totalRecordsCount", totalLength);
                    component.set("v.startPage",0);
                    component.set("v.endPage",pageSize-1);
                    var irValues = [];
                    var PaginationLst = [];
                    var plValues = [];
                    var rfValues = [];
                    var uniquerfValues = [];
                    var FsValues = [];
                    var uniqueFsValues = [];
                    var SsValues = [];
                    var uniqueSsValues = [];
                    var venValues = [];
                    var uniquevenValues = [];
                    var FrValues = [];
                    var mastValues = [];
                    var compValues = [];
                    var spValues = [];
                    var techValues = [];
                    var bizValues = [];
                    var overallValues = [];
                     var streamrecommendation = [];
                     var techStream = [];
                     var siteReferral = [];
                     var reasonRecommendation = [];
                    for(var i=0; i < pageSize; i++){
                        
                        if(component.get("v.listOfAllApplications").length > i){
                            PaginationLst.push(oRes[i]);
                            plValues.push({
                                label: oRes[i].appObj.Name,
                                value: oRes[i].appObj.Name
                            });
                            
                            
                            if(oRes[i].appObj.Venture__c!=null){
                                if(uniquevenValues.includes(oRes[i].appObj.Venture__r.Name) == false)
                                {
                                    uniquevenValues.push(oRes[i].appObj.Venture__r.Name);
                                    venValues.push({
                                        label: oRes[i].appObj.Venture__r.Name,
                                        value: oRes[i].appObj.Venture__r.Name
                                    });  
                                }
                            }
                            //alert(venValues.includes(oRes[i].appObj.Venture__r.Name));
                            if(oRes[i].appObj.X1st_Preference_CDL_Location__c!=null){
                                if(uniqueFsValues.includes(oRes[i].appObj.X1st_Preference_CDL_Location__c) == false)
                                {
                                    uniqueFsValues.push(oRes[i].appObj.X1st_Preference_CDL_Location__c)
                                    FsValues.push({
                                        label: oRes[i].appObj.X1st_Preference_CDL_Location__c,
                                        value: oRes[i].appObj.X1st_Preference_CDL_Location__c
                                    });
                                }
                            }
                            if(oRes[i].appObj.Application_Referral_Name__c!=null){
                                if(uniquerfValues.includes(oRes[i].appObj.Application_Referral_Name__c) == false){
                                    
                                    uniquerfValues.push(oRes[i].appObj.Application_Referral_Name__c)
                                    rfValues.push({
                                        label: oRes[i].appObj.Application_Referral_Name__c,
                                        value: oRes[i].appObj.Application_Referral_Name__c
                                    });
                                }
                            }
                            if(oRes[i].appObj.X2nd_Preference_CDL_Location__c!=null){
                                if(uniqueSsValues.includes(oRes[i].appObj.X2nd_Preference_CDL_Location__c) == false)
                                {
                                    uniqueSsValues.push(oRes[i].appObj.X2nd_Preference_CDL_Location__c);
                                    SsValues.push({
                                        label: oRes[i].appObj.X2nd_Preference_CDL_Location__c,
                                        value: oRes[i].appObj.X2nd_Preference_CDL_Location__c
                                    });
                                }
                            }
                             if(oRes[i].evaObj.Recommend_Interview_2__c!=null){
                                irValues.push({
                                    label: oRes[i].evaObj.Recommend_Interview_2__c,
                                    value: oRes[i].evaObj.Recommend_Interview_2__c
                                });
                            }
                              if(oRes[i].evaObj.Stream_Recommendation__c!=null){
                                streamrecommendation.push({
                                    label: oRes[i].evaObj.Stream_Recommendation__c,
                                    value: oRes[i].evaObj.Stream_Recommendation__c
                                });
                            }
                              if(oRes[i].evaObj.Tech_Screening_Recommendation__c!=null){
                                techStream.push({
                                    label: oRes[i].evaObj.Tech_Screening_Recommendation__c,
                                    value: oRes[i].evaObj.Tech_Screening_Recommendation__c
                                });
                            }
                              if(oRes[i].evaObj.Refer_to_Other_Site__c!=null){
                                siteReferral.push({
                                    label: oRes[i].evaObj.Refer_to_Other_Site__c,
                                    value: oRes[i].evaObj.Refer_to_Other_Site__c
                                });
                            }
                              if(oRes[i].evaObj.Reason_for_Recommending_Other_Site__c!=null){
                                reasonRecommendation.push({
                                    label: oRes[i].evaObj.Reason_for_Recommending_Other_Site__c,
                                    value: oRes[i].evaObj.Reason_for_Recommending_Other_Site__c
                                });
                            }
                            
                            /* if(oRes[i].appObj.Evaluations__r[0].EvaluatorsRanking__c!=null){
                                FrValues.push({
                                    label: oRes[i].appObj.Evaluations__r[0].EvaluatorsRanking__c,
                                    value: oRes[i].appObj.Evaluations__r[0].EvaluatorsRanking__c
                                });
                            }*/
                            /*var masterRanking = oRes[i].appObj.Master_Ranking__c;
                            var stringMasterRanking = masterRanking.toString();
                            mastValues.push({
                                    label: stringMasterRanking,
                                    value: stringMasterRanking
                                });
                             var Ranking = oRes[i].appObj.Ranking__c;
                            var stringRanking = Ranking.toString();
                            compValues.push({
                                    label: stringRanking,
                                    value: stringRanking
                                });
                            var spScore = oRes[i].appObj.Sum_Superstar_Potential__c;
                            var stringspScore = spScore.toString();
                            spValues.push({
                                    label: stringspScore,
                                    value: stringspScore
                                });
                            var techScore = oRes[i].appObj.Sum_Tech_Review__c;
                            var stringtechScore = techScore.toString();
                            techValues.push({
                                    label: stringtechScore,
                                    value: stringtechScore
                                });
                             var bizScore = oRes[i].appObj.Sum_Business_Review__c;
                            var stringbizScore = bizScore.toString();
                            bizValues.push({
                                    label: stringbizScore,
                                    value: stringbizScore
                                });
                              var overAllScore = oRes[i].appObj.Overall_Score__c;
                            var stringoverAllScore = overAllScore.toString();
                            overallValues.push({
                                    label: stringoverAllScore,
                                    value: stringoverAllScore
                                });*/
                            
                            
                            // Loop through array values
                            
                            
                            component.set('v.secondsitepreferenceList', SsValues);
                            component.set('v.refferalList', rfValues);
                            component.set('v.interviewRecommendationList', irValues);
                            component.set('v.streamRecommendationList', streamrecommendation);
                            component.set('v.techStreamRecommendationList', techStream);
                            component.set('v.siteReferralList', siteReferral);
                            component.set('v.reasonRecommendationList', reasonRecommendation);
                            
                            component.set('v.finalrankList', FrValues);
                            component.set('v.VentureList', venValues);
                            component.set('v.ApplicationList', plValues);
                            component.set('v.firstsitepreferenceList', FsValues);
                            
                            /*component.set('v.MasterList', mastValues);
                             component.set('v.ComputedList', compValues);
                             component.set('v.SuperStartList', spValues);
                            component.set('v.TechList', techValues);
                            component.set('v.BizList', bizValues);
                            component.set('v.OverallList',overallValues);*/
                        } 
                    }
                    /* component.set('v.PaginationList', PaginationLst);
                    component.set("v.selectedCount" , 0);
                    component.set("v.totalPagesCount", Math.ceil(totalLength / pageSize));*/
                    
                    var pageSize = component.get('v.pageSize');
                    component.set("v.totalPagesCount", Math.floor((oRes.length + pageSize -1 )/pageSize));
                    this.renderPagination(component, event);
                    
                }else{
                    // if there is no records then display message
                    component.set("v.bNoRecordsFound" , true);
                } 
            }
            else{
                alert('Error...');
            }
        });
        $A.enqueueAction(action);  
    },
    
    getFilteredRecords : function(component,event){

        component.set("v.isProcessing", false);  
        var allRecords3 = component.get("v.AllAppRecords");
        
        //console.log('All records are==3'+allRecords3);
        if(component.get("v.currentselectedAppType")== 'Compare Application'){
            var oRes = component.get('v.CompareList');
        }
        else{
            var oRes = component.get("v.AllAppRecords"); 
        }
        
        //alert('in'+JSON.stringify(oRes[0].appObj));
        if(oRes.length > 0){
            component.set('v.listOfAllApplications', oRes);
            //alert(JSON.stringify(component.get('v.listOfAllApplications')));
            var pageSize = component.get("v.pageSize");
            var totalRecordsList = oRes;
            
            var totalLength = totalRecordsList.length ;
            component.set("v.totalRecordsCount", totalLength);
            component.set("v.startPage",0);
            component.set("v.endPage",pageSize-1);
            var irValues = [];
            var PaginationLst = [];
            var plValues = [];
            var rfValues = [];
            var uniquerfValues = [];
            var FsValues = [];
            var uniqueFsValues = [];
            var SsValues = [];
            var uniqueSsValues = [];
            var venValues = [];
            var uniquevenValues = [];
            var FrValues = [];
            var mastValues = [];
            var compValues = [];
            var spValues = [];
            var techValues = [];
            var bizValues = [];
            var overallValues = [];
            for(var i=0; i < pageSize; i++){
                
                if(component.get("v.listOfAllApplications").length > i){
                    PaginationLst.push(oRes[i]);
                    plValues.push({
                        label: oRes[i].appObj.Name,
                        value: oRes[i].appObj.Name
                    });
                    
                    
                    if(oRes[i].appObj.Venture__c!=null){
                        if(uniquevenValues.includes(oRes[i].appObj.Venture__r.Name) == false)
                        {
                            uniquevenValues.push(oRes[i].appObj.Venture__r.Name);
                            venValues.push({
                                label: oRes[i].appObj.Venture__r.Name,
                                value: oRes[i].appObj.Venture__r.Name
                            });  
                        }
                    }
                    //alert(venValues.includes(oRes[i].appObj.Venture__r.Name));
                    if(oRes[i].appObj.X1st_Preference_CDL_Location__c!=null){
                        if(uniqueFsValues.includes(oRes[i].appObj.X1st_Preference_CDL_Location__c) == false)
                        {
                            uniqueFsValues.push(oRes[i].appObj.X1st_Preference_CDL_Location__c)
                            FsValues.push({
                                label: oRes[i].appObj.X1st_Preference_CDL_Location__c,
                                value: oRes[i].appObj.X1st_Preference_CDL_Location__c
                            });
                        }
                    }
                    if(oRes[i].appObj.Application_Referral_Name__c!=null){
                        if(uniquerfValues.includes(oRes[i].appObj.Application_Referral_Name__c) == false){
                            
                            uniquerfValues.push(oRes[i].appObj.Application_Referral_Name__c)
                            rfValues.push({
                                label: oRes[i].appObj.Application_Referral_Name__c,
                                value: oRes[i].appObj.Application_Referral_Name__c
                            });
                        }
                    }
                    if(oRes[i].appObj.X2nd_Preference_CDL_Location__c!=null){
                        if(uniqueSsValues.includes(oRes[i].appObj.X2nd_Preference_CDL_Location__c) == false)
                        {
                            uniqueSsValues.push(oRes[i].appObj.X2nd_Preference_CDL_Location__c);
                            SsValues.push({
                                label: oRes[i].appObj.X2nd_Preference_CDL_Location__c,
                                value: oRes[i].appObj.X2nd_Preference_CDL_Location__c
                            });
                        }
                    }
                    
                    
                    component.set('v.secondsitepreferenceList', SsValues);
                    component.set('v.refferalList', rfValues);
                    component.set('v.interviewRecommendationList', irValues);
                    
                    
                    component.set('v.finalrankList', FrValues);
                    component.set('v.VentureList', venValues);
                    component.set('v.ApplicationList', plValues);
                    component.set('v.firstsitepreferenceList', FsValues);
                    
                    
                } 
            }
            
            
            var pageSize = component.get('v.pageSize');
            component.set("v.totalPagesCount", Math.floor((oRes.length + pageSize -1 )/pageSize));
            this.renderPagination(component, event);
            
        }else{
            // if there is no records then display message
            component.set("v.bNoRecordsFound" , true);
        } 
        
        
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
    getApplicationURL: function(component, event) {
        var action = component.get("c.getApplicationURL");
        var appId = component.get("v.selectedEvaluationId");
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
    }, requiredValidation : function(component,event) {
        // get all accounts.. 	
        var allRecords = component.get("v.AccountList");
        var isValid = true;
        // play a for loop on all account list and check that account name is not null,   
        for(var i = 0; i < allRecords.length;i++){
            if(allRecords[i].Name == null || allRecords[i].Name.trim() == ''){
                alert('Complete this field : Row No ' + (i+1) + ' Name is null' );
                isValid = false;
            }  
        }
        return isValid;
    },
    renderPagination : function(component, event) {
        
        var allApplications = component.get("v.listOfAllApplications");
        var pageSize = component.get('v.pageSize');
        var currentPageNumber = component.get("v.currentPage");
        var pageRecords = allApplications.slice((currentPageNumber-1)*pageSize, currentPageNumber*pageSize);
        component.set("v.PaginationList", pageRecords);
    },
    showToast : function(component, event, helper,errormessage,typemessage) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            mode: 'dismissible',
            duration:' 300',
            message: errormessage,
            type : typemessage
        });
        toastEvent.fire();
    },
    openModalAndInitiateFilter : function(component, event, helper) {

        var filterBy = event.getSource().get("v.ariaLabel");
        
        if(filterBy === 'Application Number') {
			
            component.set('v.allAvailableOptions',component.get("v.ApplicationList"));
            component.set('v.availableOptions',component.get("v.ApplicationList"));
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
        } else if(filterBy === 'Stream Potential') {

            component.set('v.allAvailableOptions',component.get("v.StreamPotentialList"));
            component.set('v.availableOptions',component.get("v.StreamPotentialList"));
            component.set('v.filteredOptions',component.get("v.filteredStreamPotentials"));
        } else if(filterBy === 'Referral By') {
			  component.set('v.allAvailableOptions',component.get("v.refferalList"));
            component.set('v.availableOptions',component.get("v.refferalList"));
            component.set('v.filteredOptions',component.get("v.filteredReferralBy"));
        }else if(filterBy === 'Interview Recommendation') {
			  component.set('v.allAvailableOptions',component.get("v.interviewRecommendationList"));
            component.set('v.availableOptions',component.get("v.interviewRecommendationList"));
            component.set('v.filteredOptions',component.get("v.filteredInterviewRecommendation"));
        }
        else if(filterBy === 'Stream Recommendation') {
			  component.set('v.allAvailableOptions',component.get("v.streamRecommendationList"));
            component.set('v.availableOptions',component.get("v.streamRecommendationList"));
            component.set('v.filteredOptions',component.get("v.filteredStreamRecommendation"));
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
        }

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
        } else if(filterBy === 'Venture Name') {

            component.set('v.selectedVentures',filteredOptions);
        }  else if(filterBy === 'First Site Preference') {

            component.set('v.selectfirstsitepreference',filteredOptions);
        } else if(filterBy === 'Second Site Preference') {

            component.set('v.selectedsecondsitepreference',filteredOptions);
        } else if(filterBy === 'Stream Potential') {

            component.set('v.selectedStreamPotentialList',filteredOptions);
        }
		else if(filterBy === 'Stream Potential') {

            component.set('v.selectedStreamPotentialList',filteredOptions);
        }
		else if(filterBy === 'Referral By') {

            component.set('v.selectreferal',filteredOptions);
        }else if(filterBy === 'Interview Recommendation') {

            component.set('v.selectinterviewRecommendation',filteredOptions);
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
        }

        helper.doInitHelper(component, event);
    }
})