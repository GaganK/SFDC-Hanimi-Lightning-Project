({
    doInit: function(component, event, helper) {
        
        component.set("v.isProcessing", true);
        helper.prepareColumnsToDisplay(component, event);
        helper.prepareFilter(component, event);
        helper.fetchData(component, event);
    },

    openWebsitesAndRecordPage: function(component, event, helper) {
        
        var ctarget = event.currentTarget; 
        var id_str = ctarget.dataset.value;
        console.log('Received website value is'+id_str);
        if(id_str == 'http:/undefined'){
            console.log('Website value is Blank');
        }
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
    
    closeLookupModal: function(component, event, helper) {
        
        component.set("v.isModalOpen", false);
    },
    
    filterApplication : function(component, event, helper) {   
        
        component.set("v.isModalOpen", false);
        helper.filterData(component, event, helper);
    },
    
    onSearch : function(component, event, helper) {   
        
        window.clearTimeout(helper.searchTimer);
        
        helper.searchTimer = window.setTimeout(
            function(){
                console.log('## Search called');
                new Promise($A.getCallback(function(resolve, reject) {
                    
                    component.set("v.isSearching", true);
                    helper.fetchData(component, event);
                }));
            }
            , 500);
    },
    
    onEvalChange : function(component, event, helper) {   
        
        helper.updateEvaluator(component, event);
    },
    
    copyValues : function(component, event, helper) {   
        
        helper.copyEvaluator(component, event, helper);
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