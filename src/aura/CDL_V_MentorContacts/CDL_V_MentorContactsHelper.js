({
    searchTimer : {},

    refresh : function(component, event, helper) {

        component.set("v.searchTerm","");
        component.set("v.filteredSites",[]);
        component.set("v.filteredStreams",[]);
        helper.getMentorContacts(component, event);
    },

    getMentorContacts : function(component, event, helper) {
        
        var action = component.get("c.fetchMentorContacts");
        
        action.setParams({ 

            "searchTerm" : component.get("v.searchTerm"),
            "filteredSites" : component.get("v.filteredSites"),
            "filteredStreams" : component.get("v.filteredStreams")
        });

        action.setCallback(this,function(response) {

            var state = response.getState();

            if (state === "SUCCESS") {
                
                var mentorContacts = response.getReturnValue();
                var pageSize = component.get("v.pageSize");
                if(mentorContacts && mentorContacts.length && mentorContacts.length > 0) {
                                    
                    component.set("v.allMentorContacts", mentorContacts);
                    component.set("v.maxPageNumber",Math.ceil(mentorContacts.length/pageSize));
                    var pageRecords = mentorContacts.slice(0, 1*pageSize);
                    component.set("v.mentorContacts", pageRecords);
                    
                } else {

                    component.set("v.allMentorContacts", []);
                    component.set("v.mentorContacts", []);
                }
                
            } else if(state === "ERROR") {

                var errors = response.getError();
                if (errors) {

                    if (errors[0] && errors[0].message) {

                        console.log("Error message: ",errors[0].message);
                    }
                } else {

                    console.log("Unknown error");
                }
            }

            component.set("v.loadPage", true);
        });
        
        $A.enqueueAction(action);
    },

    getSitesAndStreamOptions : function(component, event) {

        var action = component.get("c.fetchSitesAndStreamOptions");
        
        action.setCallback(this,function(response) {

            var state = response.getState();
            
            if (state === "SUCCESS") {
                
                var filters = response.getReturnValue();

                var allSites = [];
                var allStreams = [];

                for(var index = 0; index < filters.sites.length; index++) {

                    var site = filters.sites[index];

                    allSites.push({value: site.value,
                        label: site.label,flag:false});
                }

                component.set("v.allSites", allSites);

                for(var index = 0; index < filters.streams.length; index++) {

                    var stream = filters.streams[index];

                    allStreams.push({value: stream.value,
                        label: stream.label,flag:false});
                }

                component.set("v.allStreams", allStreams);

            } else if(state === "ERROR") {

                var errors = response.getError();
                if (errors) {

                    if (errors[0] && errors[0].message) {

                        console.log("Error message: ",errors[0].message);
                    }
                } else {

                    console.log("Unknown error");
                }
            }

            component.set("v.isProcessing", false);
        });
        
        $A.enqueueAction(action);
    },

    getCurrentPaginationList: function(component, event, helper) {
     
        var pageSize = component.get("v.pageSize");
        var records = component.get("v.allMentorContacts");
        var pageNumber = component.get("v.currentPageNumber");
        var pageRecords = records.slice((pageNumber-1)*pageSize, pageNumber*pageSize);
        
        component.set("v.mentorContacts", pageRecords);
    },

    sendEmailToMentor: function(component, event, helper) {

        console.log('## in sendEmailToMentor');
        
        var selectedMentor = component.get("v.selectedMentor");

        console.log('## selectedMentor: ',selectedMentor);
        console.log('## emailSubject: ',component.get("v.emailSubject"));
        console.log('## emailBody: ',component.get("v.emailBody"));
        console.log('## selectedRequests: ',component.get("v.selectedRequests"));

        var action = component.get("c.sendEmailToMentor");

        action.setParams({ 

            "mentorId" : selectedMentor.objContact.Id,
            "emailSubject" : component.get("v.emailSubject"),
            "emailBody" : component.get("v.emailBody"),
            "requests" : component.get("v.selectedRequests")
        });

        action.setCallback(this,function(response) {

            var state = response.getState();

            if (state === "SUCCESS") {
                
                var hasEmailSent = response.getReturnValue();
                var toastEvent = $A.get("e.force:showToast");

                if(hasEmailSent === true) {

                    toastEvent.setParams({
                        "type":"success",
                        "title": "Success!",
                        "message": "Email sent successfully."
                    });

                    component.set("v.isSendEmail", false);
                    component.set("v.isModalOpen", true);
                } else {

                    toastEvent.setParams({
                        "type":"error",
                        "title": "Error!",
                        "message": "Something went wrong while sending an email. Please contact administrator."
                    });   
                }

                toastEvent.fire();
                
            } else if(state === "ERROR") {

                var errors = response.getError();
                if (errors) {

                    if (errors[0] && errors[0].message) {

                        console.log("Error message: ",errors[0].message);
                    }
                } else {

                    console.log("Unknown error");
                }
            }

            component.set("v.loadPage", true);
        });
        
        $A.enqueueAction(action);
    }
})