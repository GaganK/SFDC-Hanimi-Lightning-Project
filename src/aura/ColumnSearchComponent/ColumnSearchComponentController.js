({
	onSearch : function(component, event, helper) {
		
		window.clearTimeout(helper.searchTimer);
        
        helper.searchTimer = window.setTimeout(
        function(){
            console.log('## Search called');
            new Promise($A.getCallback(function(resolve, reject) {
                
                // component.set("v.isSearching", true);
                helper.fetchData(component, event);
            }));
        }
        , 500);
	},
	checkboxSelect : function(component, event, helper) {
	    
	    var checkbox = event.getSource();
	    var searchField = '"'+component.get("v.searchField")+'"';
	   //var searchField = component.get("v.searchField");
        var selectedOptions = [];
        selectedOptions = Object.values(component.get("v.selectedOptions"));
        // console.log(selectedOptions.length,'>>selectedOptions>>>>>',selectedOptions);
        
        if(selectedOptions.length > 0){
            
            if(checkbox.get("v.value")){
                    
                // console.log(selectedOptions.length,'>>>>>>if>>>>>',checkbox.get("v.text"));
                selectedOptions.push(checkbox.get("v.text"));
            } else {
                
                // console.log(selectedOptions.length,'>>>>>>else>>>>>',checkbox.get("v.text"));
                for(var i = 0; i<selectedOptions.length; i++){
                        
                    // console.log(checkbox.get("v.text"),'>>>>>>else>>>>>',selectedOptions[i]);
                    if(checkbox.get("v.text") == selectedOptions[i]){
                        
                        selectedOptions.splice(i, 1);
                    }
                }
            }
        } else {
            
            selectedOptions[0] = checkbox.get("v.text");
        }
        component.set("v.selectedOptions",selectedOptions);
        console.log(selectedOptions);
        
        var parentComponent = component.get("v.parent");
        var parentFilters = parentComponent.get("v.allFilters");
        console.log('parentFilters>>>',parentFilters);
        
        var myMap = {};
        myMap[searchField] = selectedOptions;
        console.log('selectedOptions>>>>>',typeof myMap);
        /*for (let [key, value] of Object.entries(myMap)) {
        
            console.log(key+'>>>>'+value);
        }*/

        parentComponent.set("v.allFilters",myMap);
        parentComponent.searchAction();
	},
    showSpinner: function(component, event, helper) {

        component.set("v.spinner", true); 
    },
    hideSpinner : function(component,event,helper){

        component.set("v.spinner", false);
    }
})