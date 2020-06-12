({
    searchTimer : {},
    doInitHelper : function(component,event){
         component.set("v.isProcessing", true);
        var action = component.get("c.fetchmentorwrapper");
         var dayId = component.get("v.dayId");
        var isDay1 = false;
        if(dayId=='day1'){
           isDay1 = true; 
        }
        action.setParams({ 
                          searchTerm : component.get("v.searchTerm"),
                          sortField : component.get("v.sortField"),
                          sortAsc : component.get("v.sortAsc"),
            			"selectedMentors" : component.get("v.selectedMentors"),
           				"selectedIndustryArea" : component.get("v.selectIndustryList"),
            			"selectedFilterCompany" : component.get("v.selectedCompany"),
            isDay1 :isDay1
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS"){
                
                 component.set("v.isProcessing", false);
                var venValues = [];
                var uniquevenValues = [];
                var industryValues = [];
                var uniqueindustryValues = [];
                 var uniqueSelectedMentorValues = [];
                var uniqueRankingVal = [];
                var companyVal = [];
                var uniquecompanyValues = [];                
                
                var oRes = response.getReturnValue();
                
            
                 
             
                if(oRes.length > 0){
                     component.set('v.listOfAllMentors', oRes);
                        var pageSize = component.get("v.pageSize");
                    var totalRecordsList = oRes;
                    var totalLength = totalRecordsList.length;
                    component.set("v.totalRecordsCount", totalLength);
                    component.set("v.startPage",0);
                    component.set("v.endPage",pageSize-1);
				 
                   
                        var PaginationList = [];
                for(var i=0; i< pageSize; i++){
                    if(component.get("v.listOfAllMentors").length> i)
                        PaginationList.push(response.getReturnValue()[i]);    
                }
                component.set('v.PaginationList', PaginationList);
                
           component.set("v.totalPagesCount", Math.floor((oRes.length + pageSize -1 )/pageSize));
               this.renderPagination(component, event);
                    
                    for(var i=0; i < oRes.length; i++){
                        if(oRes[i].isSelectedVal!='undefined' && oRes[i].isSelectedVal!='' && oRes[i].isSelectedVal!=null){
                           uniqueSelectedMentorValues.push(oRes[i].userObj.ContactId+'&&'+oRes[i].isSelectedVal);
                            if(uniqueRankingVal.includes(oRes[i].isSelectedVal) == false){
                                uniqueRankingVal.push(oRes[i].isSelectedVal);
                            }
                        }
                         if(uniquevenValues.includes(oRes[i].userObj.Contact.Name) == false){
                                {
                             uniquevenValues.push(oRes[i].userObj.Contact.Name);
                                  venValues.push({
                                        label: oRes[i].userObj.Contact.Name,
                                        value: oRes[i].userObj.Contact.Name
                                    });  
                                }
                       	}
                       component.set('v.MentorList', venValues);
                        
                       if(oRes[i].userObj.Contact.Industry_Area_Focuses__c!=null){
                           if(uniqueindustryValues.includes(oRes[i].userObj.Contact.Industry_Area_Focuses__c) == false){                           
                                   uniqueindustryValues.push(oRes[i].userObj.Contact.Industry_Area_Focuses__c);
                                   industryValues.push({
                                       label: oRes[i].userObj.Contact.Industry_Area_Focuses__c,
                                       value: oRes[i].userObj.Contact.Industry_Area_Focuses__c
                                   });  
                               
                            }
                       }
                       component.set('v.IndustryList', industryValues);
                        
                        
                        /********* Company ********/
                        if(uniquecompanyValues.includes(oRes[i].userObj.Contact.Account.Name) == false){
                                {
                             uniquecompanyValues.push(oRes[i].userObj.Contact.Account.Name);
                                  companyVal.push({
                                        label: oRes[i].userObj.Contact.Account.Name,
                                        value: oRes[i].userObj.Contact.Account.Name
                                    });  
                                }
                       	}
                       component.set('v.CompanyList', companyVal);
                        /**************************/
                        
                    } // end for
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
            component.set("v.selectedMentorList",uniqueSelectedMentorValues);
            component.set("v.existingRankingList",uniqueRankingVal);
        
        
        });
        $A.enqueueAction(action);  
    }, 
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
        var selUpdatedMentors=[];
        var appList = component.get("v.listOfAllMentors");
        for (var i = 0; i < appList.length; i++) {
            if(appList[i].isSelectedVal!=null & appList[i].isSelectedVal!='')
            selUpdatedMentors.push(appList[i].userObj.ContactId+'&&'+appList[i].isSelectedVal);
        }
        component.set("v.UpdatedMentorsList", selUpdatedMentors);
         var selVentures = component.get("v.UpdatedMentorsList");
        console.log('*******selVentures******'+selVentures);
        action.setParams({
           "admitMentWrap": component.get("v.UpdatedMentorsList")
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
    openModalAndInitiateFilter : function(component, event, helper) {

        var filterBy = event.getSource().get("v.ariaLabel");
        
        if(filterBy === 'Company') {			
            component.set('v.allAvailableOptions',component.get("v.CompanyList"));
            component.set('v.availableOptions',component.get("v.CompanyList"));
            component.set('v.filteredOptions',component.get("v.filteredCompaniess"));
        } else if(filterBy === 'Industry') {
            component.set('v.allAvailableOptions',component.get("v.IndustryList"));
            component.set('v.availableOptions',component.get("v.IndustryList"));
            component.set('v.filteredOptions',component.get("v.filteredIndustries"));
        } else if(filterBy === 'ContactName') {
            component.set('v.allAvailableOptions',component.get("v.MentorList"));
            component.set('v.availableOptions',component.get("v.MentorList"));
            component.set('v.filteredOptions',component.get("v.filteredContacts"));
        }

        component.set("v.fieldSearchTerm","");
        component.set("v.filterBy",filterBy);
        component.set("v.isModalOpen", true);
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
     filterData : function(component, event, helper) {

        var filterBy = component.get("v.filterBy");
        var filteredOptions = component.get("v.filteredOptions");

        if(filterBy === 'Company') {
            component.set('v.selectedCompany',filteredOptions);
        } else if(filterBy === 'Industry') {            
            component.set('v.selectIndustryList',filteredOptions);
        } else if(filterBy === 'ContactName') {            
            component.set('v.selectedMentors',filteredOptions);
        }

        helper.doInitHelper(component, event);
    },
    //navigate to next pagination record set   
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
    renderPagination : function(component, event) {

        var allApplications = component.get("v.listOfAllMentors");
        var pageSize = component.get('v.pageSize');
        var currentPageNumber = component.get("v.currentPage");
        var pageRecords = allApplications.slice((currentPageNumber-1)*pageSize, currentPageNumber*pageSize);
        component.set("v.PaginationList", pageRecords);
    }
   
})