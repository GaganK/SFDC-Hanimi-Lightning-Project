({
    /*
     * This finction defined column header
     * and calls getEvaluations helper method for column data
     * editable:'true' will make the column editable
     * */
	doInit : function(component, event, helper) { 
        var today = new Date();
        component.set('v.expdate', today);       
        component.set('v.columns', [
	          {label: 'Application Name', fieldName: 'linkName', type: 'text'},
             {label: 'Company Name', fieldName: 'companyName', type: 'text'}, 
            {label: 'Ranking', fieldName: 'ranking', type: 'number', cellAttributes: { alignment: 'left' }},
            {label: 'Tech Score', fieldName: 'techScore', type: 'number',cellAttributes: { alignment: 'left' }},
            {label: 'Marketing Score', fieldName: 'marketingScore', type: 'number',cellAttributes: { alignment: 'left' }},
            {label: 'SuperStarPotential', fieldName: 'superStarPotential', type: 'number',cellAttributes: { alignment: 'left' }},
            {label: 'Total', fieldName: 'Overall_Score__c', type: 'number',cellAttributes: { alignment: 'left' }}
        ]);
         helper.getInitialCDLSitePrefPicklist(component, event);
            helper.getStreamPotential(component, event);
            helper.getApplicationStagePicklist(component, event);
            helper.getApplicationOwnerPicklist(component, event);
        helper.getEvaluationsList(component, helper);
    },
     getEvaluationRecords : function(component, event, helper){
          helper.getEvaluationsList(component, helper);
        component.set('v.selectedEvaluationId', null);
         component.set('v.recordId', null);
         component.set('v.numberOfApplicants', 0);

        component.set("v.isModalOpen", false);
    },
    onNext : function(component, event, helper) {        
        var pageNumber = component.get("v.currentPageNumber");
        component.set("v.currentPageNumber", pageNumber+1);
        helper.buildData(component, helper);
    },
    updateSelectedText: function (cmp, event,helper) {
        var selectedRows = event.getParam('selectedRows');
         
        //alert('*****selectedRows********'+selectedRows);
        
         for (var i = 0; i < selectedRows.length; i++){
           // alert("You selected: " + selectedRows[i].Application__r.Name);
             cmp.set('v.selectedEvaluationId', selectedRows[i].Application__c);
             cmp.set('v.recordId', selectedRows[i].Id);
             cmp.set('v.numberOfApplicants', selectedRows[i].Application__r.Number_of_Co_Founders__c);
        }
        helper.getAnalysisReport(cmp, helper);
         helper.getContacts(cmp, helper);
      cmp.set('v.showSpinner', false);
       
    },
    openModel: function(component, event, helper) {
        // Set isModalOpen attribute to true
        component.set("v.isModalOpen", true);
     },
    
     closeModel: function(component, event, helper) {
        // Set isModalOpen attribute to false  
        component.set("v.isModalOpen", false);
     },
    onPrev : function(component, event, helper) {        
        var pageNumber = component.get("v.currentPageNumber");
        component.set("v.currentPageNumber", pageNumber-1);
        helper.buildData(component, helper);
    },
    
    processMe : function(component, event, helper) {
        component.set("v.currentPageNumber", parseInt(event.target.name));
        helper.buildData(component, helper);
    },
    
    onFirst : function(component, event, helper) {        
        component.set("v.currentPageNumber", 1);
        helper.buildData(component, helper);
    },
    
    onLast : function(component, event, helper) {        
        component.set("v.currentPageNumber", component.get("v.totalPages"));
        helper.buildData(component, helper);
    },
     handleLoad: function(cmp, event, helper) {
        cmp.set('v.showSpinner', false);
    },

    handleSubmit: function(cmp, event, helper) {
        cmp.set('v.disabled', true);
        cmp.set('v.showSpinner', true);
    },

    handleError: function(cmp, event, helper) {
        // errors are handled by lightning:inputField and lightning:nessages
        // so this just hides the spinnet
        cmp.set('v.showSpinner', false);
    },

    handleSuccess: function(cmp, event, helper) {
        cmp.set('v.showSpinner', false);
        cmp.set('v.saved', true);
         helper.getEvaluationsList(cmp, helper);
    }
  
})