({
    doInit: function(component, event, helper) {
        
        component.set("v.isProcessing", true);
        helper.prepareColumnsToDisplay(component, event);
        helper.fetchData(component, event);
        // helper.prepareFilter(component, event);

    },
    openFilterModal : function(component, event, helper) {
        // var btnValue = event.getSource().get("v.value");
        // console.log('btnValue>>',btnValue);
        helper.openModalAndInitiateFilter(component, event);
    },
    closeLookupModal: function(component, event, helper) {
        
        component.set("v.fieldSearchTerm","");
        component.set("v.isModalOpen", false);
    },
    filterApplication : function(component, event, helper) {   
        
        component.set("v.isModalOpen", false);
        helper.filterData(component, event, helper);
    },
    onSearch : function(component, event, helper) {   
        
        window.clearTimeout(helper.searchTimer);
        
        helper.searchTimer = window.setTimeout(
            function(){
                console.log('## Search called');
                new Promise($A.getCallback(function(resolve, reject) {
                    
                    component.set("v.isSearching", true);
                    helper.fetchData(component, event);
                }));
            }
            , 500);
    },
    firstPage: function(component, event, helper) {
        
        component.set("v.currentPageNumber", 1);
        helper.renderPagination(component, event);
    },
    
    prevPage: function(component, event, helper) {
        
        component.set("v.currentPageNumber", Math.max(component.get("v.currentPageNumber")-1, 1));
        helper.renderPagination(component, event);
    },
    
    nextPage: function(component, event, helper) {
        
        component.set("v.currentPageNumber", Math.min(component.get("v.currentPageNumber")+1, component.get("v.maxPageNumber")));
        helper.renderPagination(component, event);
    },
    
    lastPage: function(component, event, helper) {
        
        component.set("v.currentPageNumber", component.get("v.maxPageNumber"));
        helper.renderPagination(component, event);
    },
    handleChange: function(component, event, helper) {
        
        var selectedVals = event.getParam('value');
        var allFilters = component.get("v.allFilters");
        // console.log(typeof allFilters,'>>>allFilters>>>',allFilters);
       
        for (var i = 0; i < allFilters.length; i++) {
            
            if(allFilters[i].filterFieldAPIName === component.get("v.filterBy")){
                
                allFilters[i].selectedValues =[];
                for(var value in selectedVals)
                    allFilters[i].selectedValues.push(selectedVals[value]);
                break;
            }
        }
        
        component.set("v.allFilters",allFilters);
        // console.log(typeof allFilters,'>>>after allFilters>>>',allFilters);

    },
    onFieldSearch : function(component, event, helper) {
        
        var searchString = component.get("v.fieldSearchTerm").toLowerCase();
        var allFilters = component.get("v.allFilters");
        var filterOptions = [];
        var newFilterOptions = [];

        for (var i = 0; i < allFilters.length; i++) {
            
            if(allFilters[i].filterFieldAPIName === component.get("v.filterBy")){
                
                filterOptions = allFilters[i].filterFieldValues;
                break;
            }
        }
        console.log('filterOptions>>>',filterOptions);

        for(var option in filterOptions){
            
            // console.log(filterOptions[option].value);
            if(filterOptions[option].value.toLowerCase().includes(searchString))
                newFilterOptions.push(filterOptions[option]);
        }
        console.log('newFilterOptions>>>',newFilterOptions);
        component.set("v.filterOptions",newFilterOptions);
    }
})