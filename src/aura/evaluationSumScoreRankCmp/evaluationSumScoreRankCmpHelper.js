({
	doInitHelper : function(component,event) {
		 // call the apex class method and fetch app list  
         var action = component.get("c.getAllApplications");
          var selectedStreamPotentialList = component.get("v.selectedStreamPotentialList");
        action.setParams({ selectedStreamPotential :  selectedStreamPotentialList});
         //action.setStorable();
             action.setCallback(this, function(response) {
              var state = response.getState();
              if (state === "SUCCESS") {                
                   var records =response.getReturnValue();
                var defaultranking = 0;
              records.forEach(function(record){
                   //alert('*************records*******************'+record.Venture__r.Name);
                   defaultranking++;
                    record.Ranking__c =defaultranking; 
                });
                 // alert(JSON.stringify(records));
               // set ApplicationList list with return value from server.
                  component.set("v.ApplicationList", records);
                   
            }
        });
        $A.enqueueAction(action);
	},
     getStreamPotential: function(component, event) {
        var action = component.get("c.getStreamPotential");
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
                component.set("v.StreamPotentialList", plValues);
            }
        });
        $A.enqueueAction(action);
    }
})