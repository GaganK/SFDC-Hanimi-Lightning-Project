({
    doInit : function(component, event, helper) {

        helper.getSitesAndStreamOptions(component, event);
        helper.getMentorContacts(component, event);
    },

    onSearch : function(component, event, helper) {

        window.clearTimeout(helper.searchTimer);

        helper.searchTimer = window.setTimeout(
            function(){
                console.log('## Search called');
                new Promise($A.getCallback(function(resolve, reject) {

                    helper.getMentorContacts(component, event);
                }));
            }
            , 500);
    },

    onFilter : function(component, event, helper) {

        helper.getMentorContacts(component, event);
    },

    showHideFilter : function(component, event, helper) {   
        
        var el = component.find('searchPanel');
        $A.util.toggleClass(el,'hideFilterPanel');
    },

    onRefresh : function(component, event, helper) {

        helper.refresh(component, event, helper);
    },

    onOpenModal : function(component, event, helper) {

        var mentorContacts = component.get("v.mentorContacts");
        var selectedItem = event.currentTarget;
        var rowIndex = selectedItem.dataset.record;
        component.set("v.selectedMentor",mentorContacts[rowIndex]);
        component.set("v.isModalOpen", true);
    },

    onCloseModal : function(component, event, helper) {

        component.set("v.isModalOpen", false);
        component.set("v.showFullBio", false);
    },
    
    showFullBioAction : function(component, event, helper) {
        
        component.set("v.showFullBio", true); 
    },
    
    showShortBioAction : function(component, event, helper) {
        
        component.set("v.showFullBio", false); 
    },

    firstPage: function(component, event, helper) {

        component.set("v.currentPageNumber", 1);
    },

    prevPage: function(component, event, helper) {

        component.set("v.currentPageNumber", Math.max(component.get("v.currentPageNumber")-1, 1));
    },

    nextPage: function(component, event, helper) {

        component.set("v.currentPageNumber", Math.min(component.get("v.currentPageNumber")+1, component.get("v.maxPageNumber")));
    },

    lastPage: function(component, event, helper) {

        component.set("v.currentPageNumber", component.get("v.maxPageNumber"));
    }, 

    renderPage: function(component, event, helper) {
        
        helper.getCurrentPaginationList(component, event, helper);
    }
})