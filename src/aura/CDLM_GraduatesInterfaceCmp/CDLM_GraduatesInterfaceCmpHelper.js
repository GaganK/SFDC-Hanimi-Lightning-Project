({
    searchTimer : {},
    doInitHelper : function(component,event){
         component.set("v.isProcessing", true);
        var action = component.get("c.fetchGraduatedVentures");
        action.setParams({ 
            			  selectedVentures :component.get("v.SelectedVentureList"),
                          selectedTech:component.get("v.SelectedTechList"),
             			  selectedLocation:component.get("v.SelectedLocationList"),
                          searchTerm : component.get("v.searchTerm"),
                          sortField : component.get("v.sortField"),
                          sortAsc : component.get("v.sortAsc"),
						  siteName : component.get("v.siteName"),
						  streamName : component.get("v.selectStream")
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS"){
                component.set("v.isProcessing", false);
                var oRes = response.getReturnValue();
                if(oRes.length > 0){
                    component.set('v.listOfAllVentures', oRes);
                    var venValues = [];
            		var uniquevenValues = [];
                    var techValues = [];
            		var uniquetechValues = [];
                      var siteandStreamValues = [];
            		var uniquesiteandStreamValues = [];
                      var locationValues = [];
            		var uniquelocationValues = [];
                     for(var i=0; i < component.get("v.listOfAllVentures").length; i++){
                           if( component.get("v.listOfAllVentures").length > i ){
                                if( component.get("v.filterBy").length==0 ){
                                     if(oRes[i].Venture__c!=null){
                                            if(uniquevenValues.includes(oRes[i].Venture__r.Name) == false)
                                            {
                                                uniquevenValues.push(oRes[i].Venture__r.Name);
                                                venValues.push({
                                                    label: oRes[i].Venture__r.Name,
                                                    value: oRes[i].Venture__r.Name
                                                });  
                                            }
                                     }
                                     if(oRes[i].Venture__r.Technology_Area__c!=null){
                                            if(uniquetechValues.includes(oRes[i].Venture__r.Technology_Area__c) == false)
                                            {
                                                uniquetechValues.push(oRes[i].Venture__r.Technology_Area__c)
                                                techValues.push({
                                                    label: oRes[i].Venture__r.Technology_Area__c,
                                                    value: oRes[i].Venture__r.Technology_Area__c
                                                });
                                            }
                                        }
                                    if(oRes[i].Cohort__r.Cohort_Name__c!=null){
                                        if(uniquesiteandStreamValues.includes(oRes[i].Cohort__r.Cohort_Name__c) == false)
                                        {
                                            uniquesiteandStreamValues.push(oRes[i].Cohort__r.Cohort_Name__c)
                                            siteandStreamValues.push({
                                                label: oRes[i].Cohort__r.Cohort_Name__c,
                                                value: oRes[i].Cohort__r.Cohort_Name__c
                                            });
                                        }
                                    }
                                     if(oRes[i].Venture_Location__c!=null){
                                        if(uniquelocationValues.includes(oRes[i].Venture_Location__c) == false)
                                        {
                                            uniquelocationValues.push(oRes[i].Venture_Location__c)
                                            locationValues.push({
                                                label: oRes[i].Venture_Location__c,
                                                value: oRes[i].Venture_Location__c
                                            });
                                        }
                                    }
                                    
                                }
                           }
                     }
                    component.set('v.VentureList', venValues);
                    component.set('v.TechList', techValues);
                    component.set('v.siteAndStreamList', siteandStreamValues);
                    component.set('v.LocationList', locationValues);
                }else{
                    component.set("v.isProcessing", false);
                    component.set("v.bNoRecordsFound" , true);
                } 
            }
            else{
                component.set("v.isProcessing", false);
                 helper.showToast(component, event,'Something Went wrong, Please contact your Administrator!','error');
            }       
        });
        $A.enqueueAction(action);  
    },
    showToast : function(component, event,errormessage,typemessage) {
        $A.get("e.c:showToastEvent")
          .setParams({
            type: typemessage,
            title: errormessage,
            description: errormessage,
            delay: 5000
          })
          .fire();
    },
       getStreamList: function(component, event) {
        var action = component.get("c.getStreamList");
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var result = response.getReturnValue();
               var plValues = [];
                for (var i = 0; i < result.length; i++) {
                    plValues.push({
                        label: result[i],
                        value: result[i]
                    });
                }
                component.set("v.StreamList", plValues);
                component.set("v.isProcessing", false);
            }
        });
        $A.enqueueAction(action);
    },
    getSiteList: function(component, event) {
        var action = component.get("c.getSiteList");
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var result = response.getReturnValue();
               var plValues = [];
                 plValues.push({
                        label: 'All',
                        value: 'all'
                    });
                for (var i = 0; i < result.length; i++) {
                    plValues.push({
                        label: result[i],
                        value: result[i]
                    });
                }
                component.set("v.SiteList", plValues);
                component.set("v.isProcessing", false);
            }
        });
        $A.enqueueAction(action);
    },
    openModalAndInitiateFilter : function(component, event, helper) {
        var filterBy = event.getSource().get("v.ariaLabel");  
		if(filterBy === 'Venture Name') {
            component.set('v.allAvailableOptions',component.get("v.VentureList"));
            component.set('v.availableOptions',component.get("v.VentureList"));
            component.set('v.filteredOptions',component.get("v.SelectedVentureList"));
        }  else if(filterBy === 'Location') {
            component.set('v.allAvailableOptions',component.get("v.LocationList"));
            component.set('v.availableOptions',component.get("v.LocationList"));
            component.set('v.filteredOptions',component.get("v.SelectedLocationList"));
        } else if(filterBy === 'Tech') {
            component.set('v.allAvailableOptions',component.get("v.TechList"));
            component.set('v.availableOptions',component.get("v.TechList"));
            component.set('v.filteredOptions',component.get("v.SelectedTechList"));
        } else if(filterBy === 'siteAndStream') {
            component.set('v.allAvailableOptions',component.get("v.siteAndStreamList"));
            component.set('v.availableOptions',component.get("v.siteAndStreamList"));
            component.set('v.filteredOptions',component.get("v.SelectedsiteAndStreamList"));
        } 
        component.set("v.fieldSearchTerm","");
        component.set("v.filterBy",filterBy);
        component.set("v.isModalOpen", true);
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
     filterData : function(component, event, helper) {
        var filterBy = component.get("v.filterBy");
        var filteredOptions = component.get("v.filteredOptions");
		if(filterBy === 'Venture Name') {
            component.set('v.SelectedVentureList',filteredOptions);
        }  else if(filterBy === 'Location') {
            component.set('v.SelectedLocationList',filteredOptions);
        } else if(filterBy === 'Tech') {
            component.set('v.SelectedTechList',filteredOptions);
        } else if(filterBy === 'siteAndStream') {
            component.set('v.SelectedsiteAndStreamList',filteredOptions);
        }
        helper.doInitHelper(component, event);
    }
   
})