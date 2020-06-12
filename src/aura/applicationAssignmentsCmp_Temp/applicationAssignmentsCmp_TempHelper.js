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
            { value: "ventureWebsite", label: "Venture Website" },
            { value: "ventureLinkdin", label: "Venture's Founder Linkdin" },
            { value: "streamPotential", label: "Stream Potential" },
            { value: "pdfApplication", label: "PDF Application" },
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

        var filterBy = event.getSource().get("v.value");
        var allFilters = component.get("v.allFilters");
        console.log(typeof allFilters,'>>>allFilters>>>',allFilters);
       
        for (var i = 0; i < allFilters.length; i++) {
            
            if(allFilters[i].filterFieldAPIName === filterBy){
                
                component.set("v.filterOptions",allFilters[i].filterFieldValues);
                component.set("v.filterValue",allFilters[i].selectedValues);
                break;
            }
        }
        // filterOptions 

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

    prepareFilter : function(component, event) {

        var filterValues = component.get("c.allFilters");
        
    },

    filterData : function(component, event, helper) {

        var filterBy = component.get("v.filterBy");
        var filteredOptions = component.get("v.filteredOptions");

        if(filterBy === 'First Site Preference') {

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
            
            "sortField" : component.get("v.sortField"),
            "sortAsc" : component.get("v.sortAsc")
        });
        
        action.setCallback(this,function(response) {

            var state = response.getState();
            console.log('## state ',state);
            if (state === "SUCCESS") {
                
                var allApplications = response.getReturnValue();
                component.set("v.allFilters",allApplications.lstFilters);
                console.log('## allApplications ',allApplications);
                console.log('## allFilters ',component.get("v.allFilters"));

                allApplications = allApplications.lstApplications;
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
        
       for(var i=0; i < pageRecords.length; i++){
           var vWebsite = pageRecords[i].objApplication.VentureWebsite;
           console.log('venture Website is==='+vWebsite);
           if(vWebsite!= null && vWebsite != '' && vWebsite.includes('http'))
               console.log('contains htpp')
               else{
                   pageRecords[i].objApplication.VentureWebsite = 'http:/'+pageRecords[i].objApplication.VentureWebsite;
                   console.log('Updated website is'+pageRecords[i].objApplication.VentureWebsite);
               }               
       }
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