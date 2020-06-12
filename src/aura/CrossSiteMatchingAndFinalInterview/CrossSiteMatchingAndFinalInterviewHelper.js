({  
    searchTimer : {},

    copyTimer : {},

    prepareColumnsToDisplay : function(component, event) {

        var selectedColumnsInfo = {};

        var columns = [
            { value: "applicationNumber", label: "Application Number" },
            { value: "firstSitePreference", label: "First Site Preference" },
            { value: "secondSitePreference", label: "Second Site Preference" },
            { value: "ventureName", label: "Venture Name" },
            { value: "teamStreamRecommendation", label: "Team Stream Recommendation" },
            { value: "teamInterviewDecision", label: "Team Interview Decision" },
            { value: "recommondedByFirstSitePreferance", label: "Recommonded By First Site Preferance" },
            { value: "crossSiteMatching", label: "Cross Site Matching" },
            { value: "interviewStatus", label: "Interview Status" },
            { value: "leadInterviewer", label: "Lead Interviewer" },
            { value: "guestInterviewer", label: "Guest Interviewer" },
            { value: "interviewDateTime", label: "Interview Date/Time" },
            { value: "interviewTimeZone", label: "Interview Time Zone" },
            { value: "interviewModality", label: "Interview Modality" },
            { value: "roomHangoutLink", label: "Room/Hangout Link" },
            { value: "postInterviewEmailSent", label: "Post Interview Email Sent" },
            { value: "primaryContactName", label: "Primary Contact" },
            { value: "primaryContactEmail", label: "Primary Contact's Email" },
            { value: "primaryContactPhone", label: "Primary Contact's Phone" },
            { value: "ventureHeadquarters", label: "Venture Headquarters" }
        ];

        for(var index = 0; index < columns.length; index++) {

            var column = columns[index];
            selectedColumnsInfo[column.value] = true;
        }

        component.set("v.selectedColumnsInfo", selectedColumnsInfo);
    },

    openModalAndInitiateFilter : function(component, event, helper) {

        var filterBy = event.getSource().get("v.ariaLabel");
        
        var filterMap = {"Application Number": {"availableOptions" : "allApplicationNumbers","filteredOptions" : "filteredApplicationNumbers"},
            "Venture Name": {"availableOptions" : "allVentures","filteredOptions" : "filteredVentures"},
            "Venture Headquarter": {"availableOptions" : "allVentureHeadQuarters","filteredOptions" : "filteredVentureHeadQuarters"},
            "First Site Preference": {"availableOptions" : "firstSitePreferances","filteredOptions" : "filteredFirstSitePreference"},
            "Second Site Preference": {"availableOptions" : "secondSitePreferances","filteredOptions" : "filteredSecondSitePreference"},
            "Team Stream Recommendation": {"availableOptions" : "teamStreamRecommendations","filteredOptions" : "filteredTeamStreamRecommendations"},
            "Team Interview Decision": {"availableOptions" : "teamInterviewDecisions","filteredOptions" : "filteredTeamInterviewDecisions"},
            "Recommended By First Site Preferance": {"availableOptions" : "recommendedByFirstSitePreferences","filteredOptions" : "filteredRecommendedByFirstSitePreferences"},
            "Cross Site Matching": {"availableOptions" : "crossSiteMatchings","filteredOptions" : "filteredCrossSiteMatchings"},
            "Interview Status": {"availableOptions" : "allInterviewStatus","filteredOptions" : "filteredInterviewStatus"},
            "Lead Interviewer": {"availableOptions" : "leadInterviewers","filteredOptions" : "filteredLeadInterviewers"},
            "Guest Interviewer": {"availableOptions" : "guestInterviewers","filteredOptions" : "filteredGuestInterviewers"},
            "Interview TimeZone": {"availableOptions" : "interviewTimeZones","filteredOptions" : "filteredInterviewTimeZones"},
            "Interview Modality": {"availableOptions" : "interviewMadalities","filteredOptions" : "filteredInterviewMadalities"},
            "Primary Contact": {"availableOptions" : "primaryContacts","filteredOptions" : "filteredPrimaryContacts"}
        };

        component.set('v.allAvailableOptions',component.get("v." + filterMap[filterBy].availableOptions));
        component.set('v.availableOptions',component.get("v." + filterMap[filterBy].availableOptions));
        var filteredOptions = component.get("v." + filterMap[filterBy].filteredOptions);

        if(filteredOptions !== undefined && filteredOptions.length > 0) {

            component.set('v.filteredOptions',component.get("v." + filterMap[filterBy].filteredOptions));
        } else {

            component.set('v.filteredOptions',[]);
        }

        component.set("v.fieldSearchTerm","");
        component.set("v.filterBy",filterBy);
        component.set("v.isModalOpen", true);
    },

    showHideSelectedColumn : function(component, event, helper) {

        var selectedColumnsInfo = component.get("v.selectedColumnsInfo");
        var columnVar = event.getSource().get("v.ariaLabel");
        var currentValue = selectedColumnsInfo[columnVar];
        if(currentValue && currentValue === true) {

            currentValue = false;
        } else {

            currentValue = true;
        }

        selectedColumnsInfo[columnVar] = currentValue;
        component.set("v.selectedColumnsInfo", selectedColumnsInfo);
    },

    onFilterSearch : function(component, event, helper) {

        var searchString = component.get("v.fieldSearchTerm").toLowerCase();
        var allAvailableOptions = component.get("v.allAvailableOptions");
        var availableOptions = [];

        if(searchString === '') {

            component.set("v.availableOptions",allAvailableOptions);
        } else {

            for(var index = 0; index < allAvailableOptions.length; index++){

                var filterOption = allAvailableOptions[index];

                if(filterOption.label.toLowerCase().includes(searchString)) {

                    availableOptions.push(filterOption)
                }
            }

            component.set("v.availableOptions",availableOptions);
        }
    },

    prepareFilter : function(component, event) {

        var action = component.get("c.getFilters");
        
        action.setCallback(this,function(response) {

            var state = response.getState();
            
            if (state === "SUCCESS") {
                
                var filters = response.getReturnValue();
                
                var filterArray = ["firstSitePreferances", "secondSitePreferances", "allVentures", "allApplicationNumbers", "allVentureHeadQuarters",
                "teamStreamRecommendations", "teamInterviewDecisions", "recommendedByFirstSitePreferences", "crossSiteMatchings", "allInterviewStatus",
                "leadInterviewers", "guestInterviewers", "primaryContacts", "interviewMadalities", "interviewTimeZones"];

                for(var indexI = 0; indexI < filterArray.length; indexI++) {

                    var filterType = filters[filterArray[indexI]];
                    var filterCollection = [];

                    for(var index = 0; index < filterType.length; index++) {

                        var objFilter = filterType[index];
                        
                        if(objFilter.value !== '') {

                            filterCollection.push({value: objFilter.value,
                                label: objFilter.label});
                        }
                    }

                    component.set("v." + filterArray[indexI], filterCollection);
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
        });
        
        $A.enqueueAction(action);
    },

    filterData : function(component, event, helper) {

        var filterBy = component.get("v.filterBy");
        var filteredOptions = component.get("v.filteredOptions");

        var filterMap = {"Application Number": {"availableOptions" : "allApplicationNumbers","filteredOptions" : "filteredApplicationNumbers"},
            "Venture Name": {"availableOptions" : "allVentures","filteredOptions" : "filteredVentures"},
            "Venture Headquarter": {"availableOptions" : "allVentureHeadQuarters","filteredOptions" : "filteredVentureHeadQuarters"},
            "First Site Preference": {"availableOptions" : "firstSitePreferances","filteredOptions" : "filteredFirstSitePreference"},
            "Second Site Preference": {"availableOptions" : "secondSitePreferances","filteredOptions" : "filteredSecondSitePreference"},
            "Team Stream Recommendation": {"availableOptions" : "teamStreamRecommendations","filteredOptions" : "filteredTeamStreamRecommendations"},
            "Team Interview Decision": {"availableOptions" : "teamInterviewDecisions","filteredOptions" : "filteredTeamInterviewDecisions"},
            "Recommended By First Site Preferance": {"availableOptions" : "recommendedByFirstSitePreferences","filteredOptions" : "filteredRecommendedByFirstSitePreferences"},
            "Cross Site Matching": {"availableOptions" : "crossSiteMatchings","filteredOptions" : "filteredCrossSiteMatchings"},
            "Interview Status": {"availableOptions" : "allInterviewStatus","filteredOptions" : "filteredInterviewStatus"},
            "Lead Interviewer": {"availableOptions" : "leadInterviewers","filteredOptions" : "filteredLeadInterviewers"},
            "Guest Interviewer": {"availableOptions" : "guestInterviewers","filteredOptions" : "filteredGuestInterviewers"},
            "Interview TimeZone": {"availableOptions" : "interviewTimeZones","filteredOptions" : "filteredInterviewTimeZones"},
            "Interview Modality": {"availableOptions" : "interviewMadalities","filteredOptions" : "filteredInterviewMadalities"},
            "Primary Contact": {"availableOptions" : "primaryContacts","filteredOptions" : "filteredPrimaryContacts"}
        };

        component.set('v.' + filterMap[filterBy].filteredOptions,filteredOptions);

        helper.fetchData(component, event);
    },

	fetchData : function(component, event) {
        
        var _helper = this;
        component.set("v.isProcessing", true);
        
        var action = component.get("c.getApplications");

        action.setParams({ 

            "searchTerm" : component.get("v.searchTerm"),
            "filteredFirstSitePreference" : component.get("v.filteredFirstSitePreference"),
            "filteredSecondSitePreference" : component.get("v.filteredSecondSitePreference"),
            "filteredApplicationNumbers" : component.get("v.filteredApplicationNumbers"),
            "filteredVentures" : component.get("v.filteredVentures"),
            "filteredVentureHeadQuarters" : component.get("v.filteredVentureHeadQuarters"),
            "filteredTeamStreamRecommendations" : component.get("v.filteredTeamStreamRecommendations"),
            "filteredTeamInterviewDecisions" : component.get("v.filteredTeamInterviewDecisions"),
            "filteredRecommendedByFirstSitePreferences" : component.get("v.filteredRecommendedByFirstSitePreferences"),
            "filteredCrossSiteMatchings" : component.get("v.filteredCrossSiteMatchings"),
            "filteredInterviewStatus" : component.get("v.filteredInterviewStatus"),
            "filteredLeadInterviewers" : component.get("v.filteredLeadInterviewers"),
            "filteredGuestInterviewers" : component.get("v.filteredGuestInterviewers"),
            "filteredPrimaryContacts" : component.get("v.filteredPrimaryContacts"),
            "filteredInterviewMadalities" : component.get("v.filteredInterviewMadalities"),
            "filteredInterviewTimeZones" : component.get("v.filteredInterviewTimeZones"),
            "sortField" : component.get("v.sortField"),
            "sortAsc" : component.get("v.sortAsc")
        });
        
        action.setCallback(this,function(response) {

            var state = response.getState();
            
            if (state === "SUCCESS") {
                
                var allApplications = response.getReturnValue();
                
                allApplications.forEach(function(application) {
                    
                    if(application.objApplication.Venture__c) {

                        application.objApplication.VentureName = application.objApplication.Venture__r.Name;
                        application.objApplication.VentureHeadquarters = application.objApplication.Venture__r.Headquarters__c;
                        application.objApplication.VentureWebsite = application.objApplication.Venture__r.Website;
                        application.objApplication.hasWebsite = false;
                        if(application.objApplication.VentureWebsite != undefined && application.objApplication.VentureWebsite != null && application.objApplication.VentureWebsite !== '') {

                            application.objApplication.hasWebsite = true;
                            if (!application.objApplication.VentureWebsite.startsWith('http') && !application.objApplication.VentureWebsite.startsWith('https')) {

                                application.objApplication.VentureWebsite = 'https://' + application.objApplication.VentureWebsite;
                            }
                        }
                    }
                    
                    if(application.objApplication.Application_Primary_Contact__c) {

                        application.objApplication.VentureLinkdin = application.objApplication.Application_Primary_Contact__r.LinkedIn_Profile__c;
                    }

                    application.leadInterviewerSelected = (application.leadInterviewer) ? true : false;
                    application.guestInterviewerSelected = (application.guestInterviewer) ? true : false;
                });

                var pageSize = component.get('v.pageSize');
                component.set("v.allApplications",allApplications);
                component.set("v.maxPageNumber", Math.floor((allApplications.length + pageSize -1 )/pageSize));
                _helper.renderPagination(component, event);

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
            component.set("v.isSearching", false);
        });
        
        $A.enqueueAction(action);
    },

    renderPagination : function(component, event) {

        var allApplications = component.get("v.allApplications");
        var pageSize = component.get('v.pageSize');
        var currentPageNumber = component.get("v.currentPageNumber");
        var pageRecords = allApplications.slice((currentPageNumber-1)*pageSize, currentPageNumber*pageSize);
        
        component.set("v.currentApplications", pageRecords);
    },

    updateInterviewer : function(component, event, helper) {

        var value = event.getParam("value");
        var applicationId = event.getParam("applicationId");
        var apiName = event.getParam("apiName");

        helper.updateApplicationVal(component, applicationId, apiName, value, false, false);
    },

    updateApplicationVal : function(component, applicationId, apiName, value, isDate, isDateTime) {

        component.set("v.isProcessing", true);
        
        var action = component.get("c.updateApplicationValue");
        
        action.setParams({ 

            "applicationId" : applicationId,
            "apiName" : apiName,
            "value" : value,
            "isDate": isDate,
            "isDateTime": isDateTime
        });
        
        action.setCallback(this,function(response) {

            var state = response.getState();
            if (state === "SUCCESS") {
                
                var objEvaluatorUpdateInfoWrapper = response.getReturnValue();
                var toastEvent = $A.get("e.force:showToast");

                if(objEvaluatorUpdateInfoWrapper.isSuccess === true) {

                    toastEvent.setParams({
                        "title": "Success!",
                        "type" : "success",
                        "message": objEvaluatorUpdateInfoWrapper.message
                    });

                } else {

                    toastEvent.setParams({
                        "title": "Error",
                        "type" : "error",
                        "message": objEvaluatorUpdateInfoWrapper.message
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
            component.set("v.selectedMultiSelect","");
            component.set("v.selectedMultiSelectId","");
            component.set("v.selectedMultiSelectAPIName","");
            component.set("v.isProcessing", false);
        });
        
        $A.enqueueAction(action);
    }
})