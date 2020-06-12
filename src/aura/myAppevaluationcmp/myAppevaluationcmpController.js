({
    doInit: function(component, event, helper) {
        var roles = [
            { value: "Self", label: "My Application" },
            { value: "All", label: "All Application" }
        ];
        component.set("v.options", roles);
        var myAction = component.get("c.fetchUserId"); 
        myAction.setCallback(this, function(response) { 
            if(response.getState() === "SUCCESS") { 
                component.set("v.loggedinUserId", response.getReturnValue()); 
            }}); 
        $A.enqueueAction(myAction); 
        helper.prepareColumnsToDisplay(component, event);
        helper.getStreamPotential(component, event);
        component.set("v.currentselectedAppType", 'Self');
         component.set("v.isAppTypeSelSelf", true);
        helper.doInitHelper(component, event);
        
    },
    onCheck: function(component, event) {
        var allRecords = component.get("v.listOfAllApplications");        
        //console.log('All records are==1'+allRecords);
        var selectedRecords = [];
        for (var i = 0; i < allRecords.length; i++) {
            if (allRecords[i].appObj.isChecked) {
                selectedRecords.push(allRecords[i]);
            }
        }
        if(selectedRecords.length>0){
            var roles = [
                { value: "All", label: "All Application" },
                { value: "Self", label: "My Application" }
            ];
            component.set("v.options", roles);
        }else{
            component.set("v.options", roles);
        }
       // component.set('v.CompareList', selectedRecords);
        
       // var filteredRecord = JSON.stringify(component.get('v.CompareList'));
        
        
    }, getApplicationRecords : function(component, event, helper){
        component.set("v.isModalOpen", false);
        helper.filterData(component, event, helper);
       /* helper.doInitHelper(component, helper);
        helper.prepareColumnsToDisplay(component, event);
        component.set("v.isModalOpen", false);
        //$A.get('e.force:refreshView').fire(); */
    }
    ,
    firstPage: function(component, event, helper) {
        
        component.set("v.currentPage", 1);
        helper.renderPagination(component, event);
    },
    
    prevPage: function(component, event, helper) {
        
        component.set("v.currentPage", Math.max(component.get("v.currentPage")-1, 1));
        helper.renderPagination(component, event);
    },
    
    nextPage: function(component, event, helper) {
        
        component.set("v.currentPage", Math.min(component.get("v.currentPage")+1, component.get("v.totalPagesCount")));
        helper.renderPagination(component, event);
    },
    
    lastPage: function(component, event, helper) {
        
        component.set("v.currentPage", component.get("v.totalPagesCount"));
        helper.renderPagination(component, event);
    },
    /* javaScript function for pagination */
    navigation: function(component, event, helper) {
        var sObjectList = component.get("v.listOfAllApplications");
        var end = component.get("v.endPage");
        var start = component.get("v.startPage");
        var pageSize = component.get("v.pageSize");
        var whichBtn = event.getSource().get("v.name");
        // check if whichBtn value is 'next' then call 'next' helper method
        if (whichBtn == 'next') {
            component.set("v.currentPage", component.get("v.currentPage") + 1);
            helper.next(component, event, sObjectList, end, start, pageSize);
        }
        // check if whichBtn value is 'previous' then call 'previous' helper method
        else if (whichBtn == 'previous') {
            component.set("v.currentPage", component.get("v.currentPage") - 1);
            helper.previous(component, event, sObjectList, end, start, pageSize);
        }
    }, 
    showHideColumn : function(component, event, helper) {
        
        helper.showHideSelectedColumn(component, event);
    },
    openModel: function(component, event, helper) {
        // Set isModalOpen attribute to true
        /*var whichOne = event.getSource().getLocalId();
        component.set("v.clickedButtonId", whichOne);
        
        component.set("v.isModalOpen", true);*/
        helper.openModalAndInitiateFilter(component, event);
    },
    
    closeModel: function(component, event, helper) {
        // Set isModalOpen attribute to false  
        component.set("v.isModalOpen", false);
    },
    openColumnsModel: function(component, event, helper) {
        component.set("v.iscolumnsSelOpen", true);
    },
    
    closeColumnsModel: function(component, event, helper) {
        component.set("v.iscolumnsSelOpen", false);
    },
    appTypeSelection: function(component, event, helper) {
        
        //component.set("v.isAppTypeSelSelf", false);
        
        var selAppName = event.getSource().get("v.value"); 
        if(selAppName=='Self'){
            component.set("v.isAppTypeSelSelf", true);
        }else{
			 component.set("v.isAppTypeSelSelf", false);
        }
        component.set("v.currentselectedAppType", selAppName);
        helper.doInitHelper(component, event,helper);

        //helper.getFilteredRecords(component, helper);
    },
    handleSectionToggle: function (cmp, event) {
        var openSections = event.getParam('openSections');
        
        if (openSections.length === 0) {
            cmp.set('v.activeSectionsMessage', "All sections are closed");
        } else {
            cmp.set('v.activeSectionsMessage', "Open sections: " + openSections.join(', '));
        }
    },
    
    Save: function(component, event, helper) {
        var action = component.get("c.saveRecord");       
        var updatedApp = component.get('v.updatedApplications');
        var updatedEval = component.get('v.updatedEvaluations');
        action.setParams({
            'app': updatedApp,
            'evaList':updatedEval
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var storeResponse = response.getReturnValue();
                helper.showToast(component,event,helper,'Records Updated Successfully!!','success');
                component.set("v.showSaveCancelBtn",false);
                $A.get('e.force:refreshView').fire();
                component.set("v.isAppTypeSelSelf", true);
            }else if (state === "ERROR") {
                var errors = response.getError();
                helper.showToast(component,event,helper,'Some thing went wrong, please contact your Administator!!','Error');
            }
        });
   
        $A.enqueueAction(action);
        // } 
    },
    
    cancel : function(component,event,helper){
        // on cancel refresh the view (This event is handled by the one.app container. It’s supported in Lightning Experience, the Salesforce app, and Lightning communities. ) 
        $A.get('e.force:refreshView').fire(); 
    },
    showHideFilter : function(component, event, helper) {   
        
        component.set("v.filterEnabled", true);
        var el = component.find('searchPanel');
        $A.util.toggleClass(el,'hideFilterPanel');
    }, selectColumnToDisplay : function(component, event, helper) {
        
        component.set("v.isModalBoxOpen", true);
        var el = component.find('columnSelectionModal');
        $A.util.removeClass(el,'hideModal');
    }, closeLookupModal: function(component, event, helper) {
        
        component.set("v.isModalBoxOpen", false);
        var el = component.find('columnSelectionModal');
        $A.util.addClass(el,'hideModal');
    }, onColumnChange: function(component, event, helper) {
        
        helper.updateOrder(component, event);
    }, updateColumns: function(component, event, helper) {
        
        helper.updateSelectedColumnsInfo(component, event);
    },
    onSearch : function(component, event, helper) {   
        
        window.clearTimeout(helper.searchTimer);
        
        helper.searchTimer = window.setTimeout(
            function(){
                //console.log('## Search called');
                new Promise($A.getCallback(function(resolve, reject) {
                    component.set("v.isSearching", true);
                    helper.doInitHelper(component, helper);
                }));
            }
            , 500);
    },
    sortByfirstsitepreference: function(component, event, helper) {
        
        var sortAsc = component.get("v.sortAsc");
        sortAsc = (sortAsc === true) ? false : true;
        component.set("v.sortAsc", sortAsc);
        component.set("v.sortField", "X1st_Preference_CDL_Location__c");
        helper.doInitHelper(component, event);
        component.set("v.sortField", "X1st_Preference_CDL_Location__c");
    },
    sortbyRank: function(component, event, helper) {
        
        var sortAsc = component.get("v.sortAsc");
        sortAsc = (sortAsc === true) ? false : true;
        component.set("v.sortAsc", sortAsc);
        component.set("v.sortField", "EvaluatorsRanking__c");
        helper.doInitHelper(component, event);
        component.set("v.sortField", "EvaluatorsRanking__c");
    },
    sortBySuperstarPotential: function(component, event, helper) {
        
        var sortAsc = component.get("v.sortAsc");
        sortAsc = (sortAsc === true) ? false : true;
        component.set("v.sortAsc", sortAsc);
        component.set("v.sortField", "Superstar_Potential__c");
        helper.doInitHelper(component, event);
    },
    sortByTechReview: function(component, event, helper) {
        
        var sortAsc = component.get("v.sortAsc");
        sortAsc = (sortAsc === true) ? false : true;
        component.set("v.sortAsc", sortAsc);
        component.set("v.sortField", "Tech_Review__c");
        helper.doInitHelper(component, event);
    },
    sortByBusinessReview: function(component, event, helper) {
        
        var sortAsc = component.get("v.sortAsc");
        sortAsc = (sortAsc === true) ? false : true;
        component.set("v.sortAsc", sortAsc);
        component.set("v.sortField", "Business_Review__c");
        helper.doInitHelper(component, event);

    },
    sortByTotalScore: function(component, event, helper) {
        
        var sortAsc = component.get("v.sortAsc");
        sortAsc = (sortAsc === true) ? false : true;
        component.set("v.sortAsc", sortAsc);
        component.set("v.sortField", "Overall_Score__c");
        helper.doInitHelper(component, event);
    },sortBySecondSitePreference: function(component, event, helper) {
        
        var sortAsc = component.get("v.sortAsc");
        sortAsc = (sortAsc === true) ? false : true;
        component.set("v.sortAsc", sortAsc);
        component.set("v.sortField", "X2nd_Preference_CDL_Location__c");
        helper.doInitHelper(component, event);

    },sortByApplicationName: function(component, event, helper) {
        
        var sortAsc = component.get("v.sortAsc");
        sortAsc = (sortAsc === true) ? false : true;
        component.set("v.sortAsc", sortAsc);
        component.set("v.sortField", "Name");
        helper.doInitHelper(component, event);
    },sortByVentureName: function(component, event, helper) {
        
        var sortAsc = component.get("v.sortAsc");
        sortAsc = (sortAsc === true) ? false : true;
        component.set("v.sortAsc", sortAsc);
        component.set("v.sortField", "Venture__r.Name");
        helper.doInitHelper(component, event);
    },sortBypdfApplication: function(component, event, helper) {
        
        var sortAsc = component.get("v.sortAsc");
        sortAsc = (sortAsc === true) ? false : true;
        component.set("v.sortAsc", sortAsc);
        component.set("v.sortField", "Application_Primary_Contact__r.LinkedIn_URL__c");
        helper.doInitHelper(component, event);
    },sortByReferral: function(component, event, helper) {
        
        var sortAsc = component.get("v.sortAsc");
        sortAsc = (sortAsc === true) ? false : true;
        component.set("v.sortAsc", sortAsc);
        component.set("v.sortField", "Application_Referral_Name__c");
        helper.doInitHelper(component, event);
    },sortByCompanyWebsite: function(component, event, helper) {
        
        var sortAsc = component.get("v.sortAsc");
        sortAsc = (sortAsc === true) ? false : true;
        component.set("v.sortAsc", sortAsc);
        component.set("v.sortField", "Venture__r.Website");
        helper.doInitHelper(component, event);
    },sortByPrimatyContactInfo: function(component, event, helper) {
        
        var sortAsc = component.get("v.sortAsc");
        sortAsc = (sortAsc === true) ? false : true;
        component.set("v.sortAsc", sortAsc);
        component.set("v.sortField", "Application_Primary_Contact__r.Name");
        helper.doInitHelper(component, event);
    }, 
    resetView : function(component, event, helper) {
        
        $A.get('e.force:refreshView').fire();
    },
    onFieldSearch : function(component, event, helper) {
        
        helper.onFilterSearch(component, event, helper);
    }
    
    /*openFilterModal : function(component, event, helper) {
        
        helper.openModalAndInitiateFilter(component, event);
    },*/
})