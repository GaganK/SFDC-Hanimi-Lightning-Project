({
    doInit: function(component, event, helper) {
        
        component.set("v.isProcessing", true);
        helper.prepareColumnsToDisplay(component, event);
        helper.prepareFilter(component, event);
        helper.fetchData(component, event);
    },

    onPicklistChangeHandler: function(component, event, helper) {

        var applicationId = event.getSource().get("v.label");
        var apiName = event.getSource().getLocalId();
        var value = event.getSource().get("v.value");

        helper.updateApplicationVal(component, applicationId, apiName, value, false, false);
    },

    onTextChangeHandler: function(component, event, helper) {
        
        var applicationId = event.getSource().get("v.label");
        var apiName = event.getSource().getLocalId();
        var value = event.getSource().get("v.value");

        helper.updateApplicationVal(component, applicationId, apiName, value, false, false);
    },
    
    onDateChangeHandler: function(component, event, helper) {
        
        var applicationId = event.getSource().get("v.label");
        var apiName = event.getSource().getLocalId();
        var value = event.getSource().get("v.value");
        value = $A.localizationService.formatDate(value, "dd/MM/yyyy");
        helper.updateApplicationVal(component, applicationId, apiName, value, true, false);
    },

    onDateTimeChangeHandler: function(component, event, helper) {
        
        var applicationId = event.getSource().get("v.label");
        var apiName = event.getSource().getLocalId();
        var value = event.getSource().get("v.value");
        value = $A.localizationService.formatDate(value,"yyyy-MM-ddThh:mm:ssZ");
        helper.updateApplicationVal(component, applicationId, apiName, value, false, true);
    },

    openWebsitesAndRecordPage: function(component, event, helper) {
        
        var ctarget = event.currentTarget; 
        var id_str = ctarget.dataset.value;

        if(id_str == 'http:/undefined'){}
        else {

            var urlEvent = $A.get("e.force:navigateToURL");
            urlEvent.setParams({
                "url": id_str
            });
            urlEvent.fire();
        }
    },

    downloadPDF: function(component, event, helper) {
        
        var id_str = event.currentTarget.dataset.value;
        
        var urlEvent = $A.get("e.force:navigateToURL");

        urlEvent.setParams({
            "url": '/sfc/servlet.shepherd/document/download/' +id_str+'?operationContext=S1'
        });

        urlEvent.fire();
    },
    onFilterSelect : function(component, event, helper) {
		let firstSitePreferances = component.get("v.firstSitePreferances");
        let secondSitePreferances = component.get("v.secondSitePreferances");
        
        let filteredFirstSitePreference = [];
        let filteredSecondSitePreference = [];
        
        for(let itm of firstSitePreferances) {
            if(itm.flag) {
                filteredFirstSitePreference.push(itm.value);
            }
        }
        for(let itm of secondSitePreferances) {
            if(itm.flag) {
                filteredSecondSitePreference.push(itm.value);
            }
        }
            
        component.set("v.filteredFirstSitePreference",filteredFirstSitePreference);
        component.set("v.filteredSecondSitePreference",filteredSecondSitePreference);
        helper.fetchData(component, event);
    },
    openFilterModal : function(component, event, helper) {
        
        helper.openModalAndInitiateFilter(component, event);
    },
    
    refreshView : function(component, event, helper) {
        
        $A.get('e.force:refreshView').fire();
    },
    
    showHideColumn : function(component, event, helper) {
        
        helper.showHideSelectedColumn(component, event);
    },
    
    sortByApplicationNumber: function(component, event, helper) {
        
        var sortAsc = component.get("v.sortAsc");
        sortAsc = (sortAsc === true) ? false : true;
        component.set("v.sortAsc", sortAsc);
        component.set("v.sortField", "Name");
        helper.fetchData(component, event);
    },
    
    sortByFirstSitePref: function(component, event, helper) {
        
        var sortAsc = component.get("v.sortAsc");
        sortAsc = (sortAsc === true) ? false : true;
        component.set("v.sortAsc", sortAsc);
        component.set("v.sortField", "X1st_Preference_CDL_Location__c");
        helper.fetchData(component, event);
    },
    
    sortBySecondSitePref: function(component, event, helper) {
        
        var sortAsc = component.get("v.sortAsc");
        sortAsc = (sortAsc === true) ? false : true;
        component.set("v.sortAsc", sortAsc);
        component.set("v.sortField", "X2nd_Preference_CDL_Location__c");
        helper.fetchData(component, event);
    },
    
    sortByVentureName: function(component, event, helper) {
        
        var sortAsc = component.get("v.sortAsc");
        sortAsc = (sortAsc === true) ? false : true;
        component.set("v.sortAsc", sortAsc);
        component.set("v.sortField", "Venture__r.Name");
        helper.fetchData(component, event);
    },
    
    sortByVentureHeadquarters: function(component, event, helper) {
        
        var sortAsc = component.get("v.sortAsc");
        sortAsc = (sortAsc === true) ? false : true;
        component.set("v.sortAsc", sortAsc);
        component.set("v.sortField", "Venture__r.Headquarters__c");
        helper.fetchData(component, event);
    },

    sortByTeamStreamRecommendation: function(component, event, helper) {
        
        var sortAsc = component.get("v.sortAsc");
        sortAsc = (sortAsc === true) ? false : true;
        component.set("v.sortAsc", sortAsc);
        component.set("v.sortField", "Team_Stream_Recommendation__c");
        helper.fetchData(component, event);
    },

    sortByTeamInterviewDecision: function(component, event, helper) {
        
        var sortAsc = component.get("v.sortAsc");
        sortAsc = (sortAsc === true) ? false : true;
        component.set("v.sortAsc", sortAsc);
        component.set("v.sortField", "Team_Interview_Decision__c");
        helper.fetchData(component, event);
    },

    sortByRecommendedByFSPreferance: function(component, event, helper) {
        
        var sortAsc = component.get("v.sortAsc");
        sortAsc = (sortAsc === true) ? false : true;
        component.set("v.sortAsc", sortAsc);
        component.set("v.sortField", "Recommended_by_First_Site_Preference_for__c");
        helper.fetchData(component, event);
    },

    sortByCrossSiteMatching: function(component, event, helper) {
        
        var sortAsc = component.get("v.sortAsc");
        sortAsc = (sortAsc === true) ? false : true;
        component.set("v.sortAsc", sortAsc);
        component.set("v.sortField", "Cross_Site_Matching__c");
        helper.fetchData(component, event);
    },

    sortByInterviewStatus: function(component, event, helper) {
        
        var sortAsc = component.get("v.sortAsc");
        sortAsc = (sortAsc === true) ? false : true;
        component.set("v.sortAsc", sortAsc);
        component.set("v.sortField", "Interview_Status__c");
        helper.fetchData(component, event);
    },
    
    sortByLeadInterviewer: function(component, event, helper) {
        
        var sortAsc = component.get("v.sortAsc");
        sortAsc = (sortAsc === true) ? false : true;
        component.set("v.sortAsc", sortAsc);
        component.set("v.sortField", "Lead_Interviewer__r.Name");
        helper.fetchData(component, event);
    },

    sortByGuestInterviewer: function(component, event, helper) {
        
        var sortAsc = component.get("v.sortAsc");
        sortAsc = (sortAsc === true) ? false : true;
        component.set("v.sortAsc", sortAsc);
        component.set("v.sortField", "Guest_Interviewer__r.Name");
        helper.fetchData(component, event);
    },

    sortByInterviewDateTime: function(component, event, helper) {
        
        var sortAsc = component.get("v.sortAsc");
        sortAsc = (sortAsc === true) ? false : true;
        component.set("v.sortAsc", sortAsc);
        component.set("v.sortField", "Interview_Date_Time__c");
        helper.fetchData(component, event);
    },

    sortByInterviewTimeZone: function(component, event, helper) {
        
        var sortAsc = component.get("v.sortAsc");
        sortAsc = (sortAsc === true) ? false : true;
        component.set("v.sortAsc", sortAsc);
        component.set("v.sortField", "Interview_Timezone__c");
        helper.fetchData(component, event);
    },

    sortByInterviewModality: function(component, event, helper) {
        
        var sortAsc = component.get("v.sortAsc");
        sortAsc = (sortAsc === true) ? false : true;
        component.set("v.sortAsc", sortAsc);
        component.set("v.sortField", "Interview_Modality__c");
        helper.fetchData(component, event);
    },

    sortByRoomHangoutLink: function(component, event, helper) {
        
        var sortAsc = component.get("v.sortAsc");
        sortAsc = (sortAsc === true) ? false : true;
        component.set("v.sortAsc", sortAsc);
        component.set("v.sortField", "Room_Hangouts_Link__c");
        helper.fetchData(component, event);
    },

    sortByPostInterviewEmailSent: function(component, event, helper) {
        
        var sortAsc = component.get("v.sortAsc");
        sortAsc = (sortAsc === true) ? false : true;
        component.set("v.sortAsc", sortAsc);
        component.set("v.sortField", "Post_Interview_Email_Sent__c");
        helper.fetchData(component, event);
    },

    sortByPrimaryContact: function(component, event, helper) {
        
        var sortAsc = component.get("v.sortAsc");
        sortAsc = (sortAsc === true) ? false : true;
        component.set("v.sortAsc", sortAsc);
        component.set("v.sortField", "Application_Primary_Contact__r.Name");
        helper.fetchData(component, event);
    },

    sortByPrimaryContactEmail: function(component, event, helper) {
        
        var sortAsc = component.get("v.sortAsc");
        sortAsc = (sortAsc === true) ? false : true;
        component.set("v.sortAsc", sortAsc);
        component.set("v.sortField", "Application_Primary_Contact__r.Email");
        helper.fetchData(component, event);
    },

    sortByPrimaryContactPhone: function(component, event, helper) {
        
        var sortAsc = component.get("v.sortAsc");
        sortAsc = (sortAsc === true) ? false : true;
        component.set("v.sortAsc", sortAsc);
        component.set("v.sortField", "Application_Primary_Contact__r.Phone");
        helper.fetchData(component, event);
    },

    closeLookupModal: function(component, event, helper) {
        
        component.set("v.isModalOpen", false);
    },

    openDualBoxModal: function(component, event, helper) {
        
        var selectedItem = event.currentTarget;
        var selectedItemVal = selectedItem.dataset.record;
        var applicationId = selectedItem.dataset.label;
        var apiName = selectedItem.dataset.name;
        var res = [];

        if(selectedItemVal){
            
            component.set("v.selectedMultiSelect",selectedItemVal.split(";"));
        }
        
        component.set("v.isMultiSelectModalOpen", true);
        component.set("v.selectedMultiSelectAPIName",apiName);
        component.set("v.selectedMultiSelectId",applicationId);
    },

    closeDualBoxModal: function(component, event, helper) {

        component.set("v.isMultiSelectModalOpen", false);
        component.set("v.selectedMultiSelect","");
        component.set("v.selectedMultiSelectId","");
        component.set("v.selectedMultiSelectAPIName","");
    },

    saveDualBoxValues: function(component, event, helper) {
        
        var selectedVals = component.get("v.selectedMultiSelect").join(";");
        var applicationId = component.get("v.selectedMultiSelectId");
        var currentApplications = component.get("v.currentApplications");
        var totalApplications = currentApplications.length;
        for(var index = 0; index < totalApplications; index++) {

            if(currentApplications[index].objApplication.Id === applicationId) {

                currentApplications[index].objApplication.Cross_Site_Matching__c = selectedVals;
            }
        }

        component.set("v.currentApplications", currentApplications);
        helper.updateApplicationVal(component, applicationId, component.get("v.selectedMultiSelectAPIName"), selectedVals, false, false);
        component.set("v.isMultiSelectModalOpen", false);
    },
    
    filterApplication : function(component, event, helper) {   
        
        component.set("v.isModalOpen", false);
        helper.filterData(component, event, helper);
    },
    
    onSearch : function(component, event, helper) {   
        
        window.clearTimeout(helper.searchTimer);
        
        helper.searchTimer = window.setTimeout(
            function(){
                new Promise($A.getCallback(function(resolve, reject) {
                    
                    component.set("v.isSearching", true);
                    helper.fetchData(component, event);
                }));
            }
            , 500);
    },
    
    onEvalChange : function(component, event, helper) {   
        
        helper.updateInterviewer(component, event, helper);
    },
    
    firstPage: function(component, event, helper) {
        
        component.set("v.currentPageNumber", 1);
        helper.renderPagination(component, event);
    },
    
    prevPage: function(component, event, helper) {
        
        component.set("v.currentPageNumber", Math.max(component.get("v.currentPageNumber")-1, 1));
        helper.renderPagination(component, event);
    },
    
    nextPage: function(component, event, helper) {
        
        component.set("v.currentPageNumber", Math.min(component.get("v.currentPageNumber")+1, component.get("v.maxPageNumber")));
        helper.renderPagination(component, event);
    },
    
    lastPage: function(component, event, helper) {
        
        component.set("v.currentPageNumber", component.get("v.maxPageNumber"));
        helper.renderPagination(component, event);
    },

    onFieldSearch : function(component, event, helper) {
        
        helper.onFilterSearch(component, event, helper);
    }
})