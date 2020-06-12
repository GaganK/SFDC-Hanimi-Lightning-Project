({
    doInit: function(component, event, helper) {
        helper.getTabList(component, event);
        helper.doInitHelper(component, event);
    },
    closeModel: function(component, event, helper) {
        component.set("v.isModalOpen", false);
        component.set("v.isSendEmail", false);
    },
     openModel: function(component, event, helper) {
        helper.openModalAndInitiateFilter(component, event);
    },
    openSendEmailModel: function(component, event, helper) {
        var selAdminvent = event.getSource().get("v.accesskey");
        component.set("v.selAdminventId", selAdminvent);
        component.set("v.isSendEmail", true);
    },
     onFieldSearch : function(component, event, helper) {
        helper.onFilterSearch(component, event, helper);
    },
    getApplicationRecords : function(component, event, helper){
        component.set("v.isModalOpen", false);
        helper.filterData(component, event, helper);
    },
    handleSelect: function (component, event, helper) {
        helper.doInitHelper(component, event);
    },
    sortByVentureName: function(component, event, helper) {
        var sortAsc = component.get("v.sortAsc");
        sortAsc = (sortAsc === true) ? false : true;
        component.set("v.sortAsc", sortAsc);
        component.set("v.sortField", "Venture__r.Name");
        helper.doInitHelper(component, event);
        component.set("v.sortField", "Venture__r.Name");
    },
	sortByLocation: function(component, event, helper) {
        var sortAsc = component.get("v.sortAsc");
        sortAsc = (sortAsc === true) ? false : true;
        component.set("v.sortAsc", sortAsc);
        component.set("v.sortField", "Venture__r.BillingState");
        helper.doInitHelper(component, event);
        component.set("v.sortField", "Venture__r.BillingState");
    },
	sortByTech: function(component, event, helper) {
        var sortAsc = component.get("v.sortAsc");
        sortAsc = (sortAsc === true) ? false : true;
        component.set("v.sortAsc", sortAsc);
        component.set("v.sortField", "Venture__r.Technology_Area__c");
        helper.doInitHelper(component, event);
        component.set("v.sortField", "Venture__r.Technology_Area__c");
    },
	sortBySiteStream: function(component, event, helper) {
        var sortAsc = component.get("v.sortAsc");
        sortAsc = (sortAsc === true) ? false : true;
        component.set("v.sortAsc", sortAsc);
        component.set("v.sortField", "Cohort__r.Cohort_Name__c");
        helper.doInitHelper(component, event);
        component.set("v.sortField", "Cohort__r.Cohort_Name__c");
    },	
    showHideFilter : function(component, event, helper) {   
        
        component.set("v.filterEnabled", true);
        var el = component.find('searchPanel');
        $A.util.toggleClass(el,'hideFilterPanel');
    },
   onSearch : function(component, event, helper) {         
        window.clearTimeout(helper.searchTimer);
        helper.searchTimer = window.setTimeout(
            function(){
                new Promise($A.getCallback(function(resolve, reject) {
                    component.set("v.isSearching", true);
                    helper.doInitHelper(component, helper);
                }));
            }
            , 500);
    },
     getVentureRecords : function(component, event, helper){
        helper.doInitHelper(component, helper);
    },
    resetView : function(component, event, helper) {
        $A.get('e.force:refreshView').fire();
    },
    Send: function(component, event,helper) {
        component.set("v.isSendEmail", true);
        component.set("v.isProcessing", true);
        var action = component.get("c.sendEmail");
        action.setParams({ 
            			  selAdminventId :component.get("v.selAdminventId"),
                          Subject:component.get("v.subjecttext"),
                          Message : component.get("v.bodyMessage"),
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
              component.set("v.isSendEmail", false);
            if (state === "SUCCESS") {
                
            }else{
                                   
                }
          component.set("v.isProcessing", false);
          component.set("v.selAdminventId",'');
          component.set("v.subjecttext",'');
          component.set("v.bodyMessage",'');
        });
        $A.enqueueAction(action);
    },
})