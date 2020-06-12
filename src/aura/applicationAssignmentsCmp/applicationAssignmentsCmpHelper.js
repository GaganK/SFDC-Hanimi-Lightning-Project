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
            { value: "ventureOverview", label: "Venture Overview" },
            { value: "ventureHeadquarters", label: "Venture Headquarters" },
            { value: "ventureLinkdin", label: "Venture's Founder Linkdin" },
            { value: "streamPotential", label: "Stream Potential" },
            { value: "evaluator1", label: "Evaluator 1" },
            { value: "evaluator2", label: "Evaluator 2" },
            { value: "evaluator3", label: "Evaluator 3" }
        ];

        for(var index = 0; index < columns.length; index++) {

            var column = columns[index];
            selectedColumnsInfo[column.value] = true;
        }

        component.set("v.selectedColumnsInfo", selectedColumnsInfo);
    },

    openModalAndInitiateFilter : function(component, event, helper) {

        var filterBy = event.getSource().get("v.ariaLabel");
        //
        //alert("test:-"+filterBy);
        if(filterBy === 'Application Number') {

            component.set('v.allAvailableOptions',component.get("v.allApplicationNumbers"));
            component.set('v.availableOptions',component.get("v.allApplicationNumbers"));
            component.set('v.filteredOptions',component.get("v.filteredApplicationNumbers"));
        } else if(filterBy === 'Venture Name') {

            component.set('v.allAvailableOptions',component.get("v.allVentures"));
            component.set('v.availableOptions',component.get("v.allVentures"));
            component.set('v.filteredOptions',component.get("v.filteredVentures"));
        } else if(filterBy === 'Venture Headquarter') {

            console.log('## I am in headquarter',component.get("v.allVentureHeadQuarters"));
            component.set('v.allAvailableOptions',component.get("v.allVentureHeadQuarters"));
            component.set('v.availableOptions',component.get("v.allVentureHeadQuarters"));
            component.set('v.filteredOptions',component.get("v.filteredVentureHeadQuarters"));
        } else if(filterBy === 'First Site Preference') {

            component.set('v.allAvailableOptions',component.get("v.firstSitePreferances"));
            component.set('v.availableOptions',component.get("v.firstSitePreferances"));
            component.set('v.filteredOptions',component.get("v.filteredFirstSitePreference"));
        } else if(filterBy === 'Second Site Preference') {

            component.set('v.allAvailableOptions',component.get("v.secondSitePreferances"));
            component.set('v.availableOptions',component.get("v.secondSitePreferances"));
            component.set('v.filteredOptions',component.get("v.filteredSecondSitePreference"));
        } else if(filterBy === 'Stream Potential') {

            component.set('v.allAvailableOptions',component.get("v.allStreamPotentials"));
            component.set('v.availableOptions',component.get("v.allStreamPotentials"));
            component.set('v.filteredOptions',component.get("v.filteredStreamPotentials"));
        } else if(filterBy === 'Evaluator 1') {

            component.set('v.allAvailableOptions',component.get("v.assignedToUsers"));
            component.set('v.availableOptions',component.get("v.assignedToUsers"));
            component.set('v.filteredOptions',component.get("v.filteredEvaluator1"));
        } else if(filterBy === 'Evaluator 2') {

            component.set('v.allAvailableOptions',component.get("v.assignedToUsers"));
            component.set('v.availableOptions',component.get("v.assignedToUsers"));
            component.set('v.filteredOptions',component.get("v.filteredEvaluator2"));
        } else if(filterBy === 'Evaluator 3') {

            component.set('v.allAvailableOptions',component.get("v.assignedToUsers"));
            component.set('v.availableOptions',component.get("v.assignedToUsers"));
            component.set('v.filteredOptions',component.get("v.filteredEvaluator3"));
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
            console.log('## state ',state);
            if (state === "SUCCESS") {
                
                var filters = response.getReturnValue();
                var firstSitePreferances = [];
                var secondSitePreferances = [];
                var assignedToUsers = [];
                var allStreamPotentials = [];
                var allVentures = [];
                var allApplicationNumbers = [];
                var allVentureHeadQuarters = [];

                for(var index = 0; index < filters.firstSitePreferances.length; index++) {

                    var firstSitePreferance = filters.firstSitePreferances[index];

                    firstSitePreferances.push({value: firstSitePreferance.value,
                        label: firstSitePreferance.label});
                }

                component.set("v.firstSitePreferances", firstSitePreferances);

                for(var index = 0; index < filters.secondSitePreferances.length; index++) {

                    var secondSitePreferance = filters.secondSitePreferances[index];

                    secondSitePreferances.push({value: secondSitePreferance.value,
                        label: secondSitePreferance.label});
                }

                component.set("v.secondSitePreferances", secondSitePreferances);

                for(var index = 0; index < filters.assignedToUsers.length; index++) {

                    var user = filters.assignedToUsers[index];

                    assignedToUsers.push({value: user.value,
                        label: user.label});
                }

                component.set("v.assignedToUsers", assignedToUsers);

                for(var index = 0; index < filters.allStreamPotentials.length; index++) {

                    var streamPotential = filters.allStreamPotentials[index];

                    allStreamPotentials.push({value: streamPotential.value,
                        label: streamPotential.label});
                }

                component.set("v.allStreamPotentials", allStreamPotentials);

                for(var index = 0; index < filters.allVentures.length; index++) {

                    var venture = filters.allVentures[index];

                    allVentures.push({value: venture.value,
                        label: venture.label});
                }

                component.set("v.allVentures", allVentures);

                for(var index = 0; index < filters.allApplicationNumbers.length; index++) {

                    var applicationNumber = filters.allApplicationNumbers[index];

                    allApplicationNumbers.push({value: applicationNumber.value,
                        label: applicationNumber.label});
                }

                component.set("v.allApplicationNumbers", allApplicationNumbers);

                for(var index = 0; index < filters.allVentureHeadQuarters.length; index++) {

                    var ventureHeadQuarter = filters.allVentureHeadQuarters[index];

                    allVentureHeadQuarters.push({value: ventureHeadQuarter.value,
                        label: ventureHeadQuarter.label});
                }

                console.log('## allVentureHeadQuarters ',allVentureHeadQuarters);
                component.set("v.allVentureHeadQuarters", allVentureHeadQuarters);

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

        if(filterBy === 'Application Number') {

            component.set('v.filteredApplicationNumbers',filteredOptions);
        } else if(filterBy === 'Venture Name') {

            component.set('v.filteredVentures',filteredOptions);
        } else if(filterBy === 'Venture Headquarter') {

            component.set('v.filteredVentureHeadQuarters',filteredOptions);
        } else if(filterBy === 'First Site Preference') {

            component.set('v.filteredFirstSitePreference',filteredOptions);
        } else if(filterBy === 'Second Site Preference') {

            component.set('v.filteredSecondSitePreference',filteredOptions);
        } else if(filterBy === 'Stream Potential') {

            component.set('v.filteredStreamPotentials',filteredOptions);
        } else if(filterBy === 'Evaluator 1') {

            component.set('v.filteredEvaluator1',filteredOptions);
        } else if(filterBy === 'Evaluator 2') {

            component.set('v.filteredEvaluator2',filteredOptions);
        } else if(filterBy === 'Evaluator 3') {

            component.set('v.filteredEvaluator3',filteredOptions);
        }

        helper.fetchData(component, event);
    },

	fetchData : function(component, event) {
        
        console.log('## I am called');
        var _helper = this;
        component.set("v.isProcessing", true);
        
        var action = component.get("c.getApplications");

        action.setParams({ 

            "searchTerm" : component.get("v.searchTerm"),
            "filteredFirstSitePreference" : component.get("v.filteredFirstSitePreference"),
            "filteredSecondSitePreference" : component.get("v.filteredSecondSitePreference"),
            "filteredEvaluator1" : component.get("v.filteredEvaluator1"),
            "filteredEvaluator2" : component.get("v.filteredEvaluator2"),
            "filteredEvaluator3" : component.get("v.filteredEvaluator3"),
            "filteredStreamPotentials" : component.get("v.filteredStreamPotentials"),
            "filteredApplicationNumbers" : component.get("v.filteredApplicationNumbers"),
            "filteredVentures" : component.get("v.filteredVentures"),
            "filteredVentureHeadQuarters" : component.get("v.filteredVentureHeadQuarters"),
            "sortField" : component.get("v.sortField"),
            "sortAsc" : component.get("v.sortAsc")
        });
        
        action.setCallback(this,function(response) {

            var state = response.getState();
            console.log('## state ',state);
            if (state === "SUCCESS") {
                
                var allApplications = response.getReturnValue();
                console.log('## allApplications ',allApplications);
                allApplications.forEach(function(application) {
                    
                    if(application.objApplication.Venture__c) {

                        application.objApplication.VentureName = application.objApplication.Venture__r.Name;
                        application.objApplication.VentureHeadquarters = application.objApplication.Venture__r.Headquarters__c;
                        application.objApplication.VentureWebsite = application.objApplication.Venture__r.Website;
                        application.objApplication.hasWebsite = false;
                        console.log('## Before Website : ',application.objApplication.Venture__r.Website);
                        if(application.objApplication.VentureWebsite != undefined && application.objApplication.VentureWebsite != null && application.objApplication.VentureWebsite !== '') {

                            application.objApplication.hasWebsite = true;
                            if (!application.objApplication.VentureWebsite.startsWith('http') && !application.objApplication.VentureWebsite.startsWith('https')) {

                                application.objApplication.VentureWebsite = 'https://' + application.objApplication.VentureWebsite;
                            }
                        }
                        console.log('## After Website : ',application.objApplication.VentureWebsite);
                    }
                    
                    if(application.objApplication.Application_Primary_Contact__c) {

                        application.objApplication.VentureLinkdin = application.objApplication.Application_Primary_Contact__r.LinkedIn_Profile__c;
                    }

                    application.evaluator1Selected = (application.evaluator1) ? true : false;
                    application.evaluator2Selected = (application.evaluator2) ? true : false;
                    application.evaluator3Selected = (application.evaluator3) ? true : false;
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
        
       /*for(var i=0; i < pageRecords.length; i++){
           var vWebsite = pageRecords[i].objApplication.VentureWebsite;
           console.log('venture Website is==='+vWebsite);
           if(vWebsite!= null && vWebsite != '' && vWebsite.includes('http'))
               console.log('contains htpp')
               else{
                   pageRecords[i].objApplication.VentureWebsite = 'http:/'+pageRecords[i].objApplication.VentureWebsite;
                   console.log('Updated website is'+pageRecords[i].objApplication.VentureWebsite);
               }               
       }*/
        component.set("v.currentApplications", pageRecords);
    },

    updateEvaluator : function(component, event) {

        window.clearTimeout(this.copyTimer);

        var value = event.getParam("value");
        var applicationId = event.getParam("applicationId");
        var apiName = event.getParam("apiName");

        console.log('## value : ',value);
        console.log('## applicationId : ',applicationId);
        console.log('## apiName : ',apiName);

        component.set("v.isProcessing", true);
        
        if(value === '') {

            component.set('v.isRemove',true);
        } else {

            component.set('v.isRemove',false);
        }

        var action = component.get("c.updateEvaluator");

        action.setParams({ 

            "applicationId" : applicationId,
            "apiName" : apiName,
            "userId" : value
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

                    component.set("v.lastEvaluatorFieldName", apiName);
                    component.set("v.lastEvaluatorId", value);
                    component.set("v.lastApplicationId", applicationId);
                    
                    this.copyTimer = window.setTimeout(function(){

                        component.set("v.lastApplicationId", '');
                        component.set("v.lastEvaluatorFieldName", '');
                        component.set("v.lastEvaluatorId", '');
                    }, 10000);

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

            component.set("v.isProcessing", false);
        });
        
        $A.enqueueAction(action);
    },
    
    copyEvaluator : function(component, event, helper) {

        component.set("v.isProcessing", true);
        
        var _helper = this;
        var allApplications = component.get("v.allApplications");
        var length = allApplications.length;
        var applicationIds = [];
        var lastApplicationId = component.get("v.lastApplicationId");
        var flag = false;

        for(var index = 0; index < length; index++) {

            var application = allApplications[index];

            if(application.objApplication.Id === lastApplicationId || flag === true) {

                applicationIds.push(application.objApplication.Id);
                flag = true;
            }
        }
        
        var action = component.get("c.copyEvaluatorToAllApplication");

        action.setParams({ 

            "apiName" : component.get("v.lastEvaluatorFieldName"),
            "userId" : component.get("v.lastEvaluatorId"),
            "applicationIds" : applicationIds,
            "searchTerm" : component.get("v.searchTerm"),
            "filteredFirstSitePreference" : component.get("v.filteredFirstSitePreference"),
            "filteredSecondSitePreference" : component.get("v.filteredSecondSitePreference"),
            "filteredEvaluator1" : component.get("v.filteredEvaluator1"),
            "filteredEvaluator2" : component.get("v.filteredEvaluator2"),
            "filteredEvaluator3" : component.get("v.filteredEvaluator3"),
            "filteredStreamPotentials" : component.get("v.filteredStreamPotentials"),
            "filteredApplicationNumbers" : component.get("v.filteredApplicationNumbers"),
            "filteredVentures" : component.get("v.filteredVentures"),
            "filteredVentureHeadQuarters" : component.get("v.filteredVentureHeadQuarters"),
            "sortField" : component.get("v.sortField"),
            "sortAsc" : component.get("v.sortAsc")
        });
        
        action.setCallback(this,function(response) {

            var state = response.getState();
            console.log('## state ',state);
            if (state === "SUCCESS") {
                
                var allApplications = response.getReturnValue();
                console.log('## allApplications ',allApplications);
                allApplications.forEach(function(application) {
                    
                    if(application.objApplication.Venture__c) {

                        application.objApplication.VentureName = application.objApplication.Venture__r.Name;
                        application.objApplication.VentureHeadquarters = application.objApplication.Venture__r.Headquarters__c;
                        application.objApplication.VentureWebsite = application.objApplication.Venture__r.Website;
                    }
                    
                    if(application.objApplication.Application_Primary_Contact__c) {

                        application.objApplication.VentureLinkdin = application.objApplication.Application_Primary_Contact__r.LinkedIn_Profile__c;
                    }

                    application.evaluator1Selected = (application.evaluator1) ? true : false;
                    application.evaluator2Selected = (application.evaluator2) ? true : false;
                    application.evaluator3Selected = (application.evaluator3) ? true : false;
                });

                var pageSize = component.get('v.pageSize');
                component.set("v.allApplications",allApplications);
                component.set("v.maxPageNumber", Math.floor((allApplications.length + pageSize -1 )/pageSize));
                _helper.renderPagination(component, event);

                component.set("v.lastApplicationId", '');
                component.set("v.lastEvaluatorFieldName", '');
                component.set("v.lastEvaluatorId", '');

                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Success!",
                    "type" : "success",
                    "message": "Evaluator copied successfully."
                });

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

            component.set("v.isProcessing", false);
        });
        
        $A.enqueueAction(action);
	}
})