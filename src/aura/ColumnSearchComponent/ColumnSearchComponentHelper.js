({
	fetchData : function(component, event) {
        
        console.log('## I am called');
        var _helper = this;
        // component.set("v.isProcessing", true);
        
        var action = component.get("c.getFieldFilters");

        action.setParams({ 

            "searchTerm" : component.get("v.searchTerm"),
            "searchField" : component.get("v.searchField"),
            "searchObject" : component.get("v.searchObject"),
            "allRecs": JSON.stringify(component.get("v.allRecords"))
        });
        
        action.setCallback(this,function(response) {

            var state = response.getState();
            console.log('## state ',state);
            if (state === "SUCCESS") {
                
                var checkboxValues = response.getReturnValue();
                component.set("v.checkboxValues",checkboxValues);
                
                console.log('checkboxValues>>>',checkboxValues);
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
    }
})