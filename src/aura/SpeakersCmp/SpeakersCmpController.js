({
    // Function called on initial page loading to get contact list from server
    getContactsList : function(component, event, helper) {
        helper.speakerList(component, event, helper);            
    },
    
    openModel: function(component, event, helper) {
        var ctarget = event.currentTarget;
        var selConId = ctarget.dataset.value;
        var allcontactRecords = component.get("v.NewSpeakersList");       
        for(var index = 0; index < allcontactRecords.length; index++) {
            if(allcontactRecords[index].conObj.Id === selConId){
                component.set('v.SpeakerDetail', allcontactRecords[index]);
                component.set("v.isModalOpen", true);
            }
        }
    },
    
    closeModel: function(component, event, helper) {
        component.set("v.isModalOpen", false);
    },
    
    submitDetails: function(component, event, helper) {
        // Set isModalOpen attribute to false
        //Add your code to call apex method or do some processing
        component.set("v.isModalOpen", false);
    },
})