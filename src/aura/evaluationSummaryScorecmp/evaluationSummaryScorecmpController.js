({
    initRecords: function(component, event, helper) {
       var selAppName = 'Self'; 
        component.set("v.currentselectedAppType", selAppName);
        if(selAppName=='Self'){
            component.set("v.isAppTypeSelSelf", true);
        } 
     helper.getStreamPotential(component, event);
     helper.doInitHelper(component, helper);
     helper.prepareColumnsToDisplay(component, event);
      
    },
     showHideColumn : function(component, event, helper) {

        helper.showHideSelectedColumn(component, event);
    },
      updateColumns: function(component, event, helper) {

        helper.updateSelectedColumnsInfo(component, event);
    },

    onColumnChange: function(component, event, helper) {

        helper.updateOrder(component, event);
    },
     setUpdateRecords: function(component, event, helper) {
      var selApp = event.getParam("selectedApp");
         component.set("v.UpdatedApp",selApp);       
    },
    appTypeSelection: function(component, event, helper) {
        var selAppName = event.getSource().get("v.value"); 
        component.set("v.currentselectedAppType", selAppName);
        if(selAppName=='Self'){
            component.set("v.isAppTypeSelSelf", true);
        } 
        helper.doInitHelper(component, event);
    },
    Save: function(component, event, helper) {
                 var action = component.get("c.updateApplication");
        
                  action.setParams({
                     'appObj': component.get("v.UpdatedApp")
                  });
        
            action.setCallback(this, function(response) {
                var state = response.getState();
                if (state === "SUCCESS") {
                    var storeResponse = response.getReturnValue();
                    component.set("v.showSaveCancelBtn",false);
                    $A.get('e.force:refreshView').fire(); 
                }
            });
            $A.enqueueAction(action);
    },
    
    cancel : function(component,event,helper){
       // on cancel refresh the view (This event is handled by the one.app container. It’s supported in Lightning Experience, the Salesforce app, and Lightning communities. ) 
        $A.get('e.force:refreshView').fire(); 
    },
    openColumnsModel: function(component, event, helper) {
        component.set("v.iscolumnsSelOpen", true);
    },
    
    closeColumnsModel: function(component, event, helper) {
        component.set("v.iscolumnsSelOpen", false);
    },
     onSearch : function(component, event, helper) {   
        
        window.clearTimeout(helper.searchTimer);

        helper.searchTimer = window.setTimeout(
            function(){
                console.log('## Search called');
                new Promise($A.getCallback(function(resolve, reject) {
                    component.set("v.isSearching", true);
                    helper.doInitHelper(component, helper);
                }));
            }
            , 500);
    }, openModel: function(component, event, helper) {
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
    /* javaScript function for pagination */
    navigation: function(component, event, helper) {
        var sObjectList = component.get("v.ApplicationList");
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
    sortByTotalScore: function(component, event, helper) {
        
        var sortAsc = component.get("v.sortAsc");
        sortAsc = (sortAsc === true) ? false : true;
        component.set("v.sortAsc", sortAsc);
        component.set("v.sortField", "Overall_Score__c");
        helper.doInitHelper(component, event);
        component.set("v.sortField", "name");
    },
     sortByfirstsitepreference: function(component, event, helper) {
         
        var sortAsc = component.get("v.sortAsc");
        sortAsc = (sortAsc === true) ? false : true;
        component.set("v.sortAsc", sortAsc);
        component.set("v.sortField", "X1st_Preference_CDL_Location__c");
        helper.doInitHelper(component, event);
        //component.set("v.sortField", "name");
    },sortBySecondSitePreference: function(component, event, helper) {

        var sortAsc = component.get("v.sortAsc");
        sortAsc = (sortAsc === true) ? false : true;
        component.set("v.sortAsc", sortAsc);
        component.set("v.sortField", "X2nd_Preference_CDL_Location__c");
        helper.doInitHelper(component, event);
        component.set("v.sortField", "name");
    },sortByApplicationNumber: function(component, event, helper) {

        var sortAsc = component.get("v.sortAsc");
        sortAsc = (sortAsc === true) ? false : true;
        component.set("v.sortAsc", sortAsc);
        component.set("v.sortField", "name");
        helper.doInitHelper(component, event);
        component.set("v.sortField", "name");
    },sortByVendor: function(component, event, helper) {

        var sortAsc = component.get("v.sortAsc");
        sortAsc = (sortAsc === true) ? false : true;
        component.set("v.sortAsc", sortAsc);
        component.set("v.sortField", "Venture__r.Name");
        helper.doInitHelper(component, event);
        //component.set("v.sortField", "name");
    },sortByRefferal: function(component, event, helper) {

        var sortAsc = component.get("v.sortAsc");
        sortAsc = (sortAsc === true) ? false : true;
        component.set("v.sortAsc", sortAsc);
        component.set("v.sortField", "Application_Referral_Name__c");
        helper.doInitHelper(component, event);
        component.set("v.sortField", "name");
    },sortByCompanyWebsite: function(component, event, helper) {

        var sortAsc = component.get("v.sortAsc");
        sortAsc = (sortAsc === true) ? false : true;
        component.set("v.sortAsc", sortAsc);
        component.set("v.sortField", "Venture__r.Website");
        helper.doInitHelper(component, event);
        component.set("v.sortField", "name");
    },sortByPrimaryContact: function(component, event, helper) {

        var sortAsc = component.get("v.sortAsc");
        sortAsc = (sortAsc === true) ? false : true;
        component.set("v.sortAsc", sortAsc);
        component.set("v.sortField", "Application_Primary_Contact__r.Name");
        helper.doInitHelper(component, event);
        component.set("v.sortField", "name");
    },sortByTeamRank: function(component, event, helper) {

        var sortAsc = component.get("v.sortAsc");
        sortAsc = (sortAsc === true) ? false : true;
        component.set("v.sortAsc", sortAsc);
        component.set("v.sortField", "FinalRank__c");
        helper.doInitHelper(component, event);
        component.set("v.sortField", "name");
    }
    , getApplicationRecords : function(component, event, helper){
        
        component.set("v.isModalOpen", false);
        helper.filterData(component, event, helper);
        
        /*helper.doInitHelper(component, helper);
        component.set("v.isModalOpen", false);*/
         //$A.get('e.force:refreshView').fire(); 
    }, 
    resetView : function(component, event, helper) {

        $A.get('e.force:refreshView').fire();
    },
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
    
    onFieldSearch : function(component, event, helper) {
        
        helper.onFilterSearch(component, event, helper);
    }

    
})