({
    doInit: function(component, event, helper) {
        helper.doInitHelper(component, event);
        window.addEventListener('beforeunload', function (e) {
          e.returnValue = 'Changes you made may not be saved!!!';
            
        });
    },
    openModel: function(component, event, helper) {
       /* var whichOne = event.getSource().getLocalId();
        component.set("v.clickedButtonId", whichOne);
        component.set("v.isModalOpen", true); */
        helper.openModalAndInitiateFilter(component, event);
     },
     closeModel: function(component, event, helper) {
         component.set("v.isModalOpen", false);
     },
    cancel : function(component,event,helper){
        $A.get('e.force:refreshView').fire(); 
    },
    showHideFilter : function(component, event, helper) {   
        component.set("v.filterEnabled", true);
        var el = component.find('searchPanel');
        $A.util.toggleClass(el,'hideFilterPanel');
    },
    showHideColumn : function(component, event, helper) {

        helper.showHideSelectedColumn(component, event);
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
    },
    onFieldSearch : function(component, event, helper) {
        
        helper.onFilterSearch(component, event, helper);
    },
    getMentorRecords : function(component, event, helper){
        helper.doInitHelper(component, helper);
        component.set("v.isModalOpen", false);
    },
    resetView : function(component, event, helper) {
         var isUnsavedData = component.get("v.showSaveCancelBtn");
      /*  if (confirm('Changes you made may not be saved.')) {
            $A.get('e.force:refreshView').fire();
        }*/
        if(isUnsavedData){
            confirm('Changes you made may not be saved.');
       }else {
            $A.get('e.force:refreshView').fire();
        } 
    },
    handleVentureRanking: function(component, event, helper){
        component.set("v.showSaveCancelBtn", false);
        var selectCmp = event.getSource().get("v.value");
        console.log(selectCmp);
        var selvenId = event.getSource().get("v.accesskey");
        console.log('****auraId*****'+selvenId);
        var selVentures = component.get("v.selectedMentorList");
        var existingRankingList = component.get("v.existingRankingList");
         var errormessage = 'This Ranking was already selected , Please select another Rank \n';
        var uniqueRankingVal=component.get("v.existingRankingList");
        var selVenVal = selvenId+'&&'+selectCmp;
           if(uniqueRankingVal.includes(selectCmp) == true){           
           }else{
               selVentures.push(selVenVal);
               uniqueRankingVal.push(selectCmp);
               component.set("v.showSaveCancelBtn", true); 
           }      
        component.set("v.existingRankingList", uniqueRankingVal);
        component.set("v.selectedMentorList", selVentures);
    },
    Save: function(component, event, helper){
         var existingRankingList = component.get("v.existingRankingList");
        console.log(existingRankingList.length);

        if(existingRankingList.length>20){
            helper.showToast(component, event,'You can choose only 20','error');
        }else{
            helper.SaveAdmit(component, event,helper);
        }
    },
    
    getApplicationRecords : function(component, event, helper){
        
        component.set("v.isModalOpen", false);
        helper.filterData(component, event, helper);
    },firstPage: function(component, event, helper) {

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
    }
})