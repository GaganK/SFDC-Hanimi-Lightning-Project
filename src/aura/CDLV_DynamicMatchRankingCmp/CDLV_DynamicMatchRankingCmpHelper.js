({
	 showMessage : function(component, event,errormessage,typemessage) {
          $A.get("e.c:showToastEvent")
          .setParams({
            type: typemessage,
            title: errormessage,
            description: errormessage,
            delay: 2000
          })
          .fire();
    },
     getRankingList: function(component, event) {
         var allAppLst = component.get("v.listOfAllApplications");        
                var result = component.get("v.currentApplication.rankingList");
               var plValues = [];
               result = result.sort(function(a, b){return a - b});
                     
                 plValues.push({
                        label: '--None--',
                        value: ''
                    });
                for (var i = 0; i <allAppLst.length; i++) {
                    plValues.push({
                        label: result[i],
                        value: result[i]
                    });
                }
         
                component.set("v.options", plValues);
    }
})