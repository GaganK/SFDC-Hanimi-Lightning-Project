({
    /* doInitHelper funcation to fetch all records, and set attributes value on component load */
    doInitHelper: function(component, event) {
        var action = component.get("c.fetchaccwrapper");
        action.setCallback(this, function(response) {
            
            var state = response.getState();
            if (state === "SUCCESS") {
                
                var oRes = response.getReturnValue();
                
                if (oRes) {
                    
                    component.set('v.listOfAllAccounts',oRes);
                    var mapVar = component.get('v.listOfAllAccounts').mapStreamToVentures;
                    var finalMapVar = Object.keys(mapVar).map(function(key){return {name: key, value: mapVar[key]} });
                    // console.log('finalMapVar>>>',finalMapVar);
                    component.set('v.mapVentureList',finalMapVar);
                    
                    var acctRelatedPartnerQuest = [];

                        for(var key in mapVar){
                            
                            var wrapperList = mapVar[key];
                            
                            for(var i=0; i< wrapperList.length; i++){
                                
                                acctRelatedPartnerQuest.push(wrapperList[i].objPartnerQuestionaire);
                            }
                        }
                    
                    console.log('acctRelatedPartnerQuest---',acctRelatedPartnerQuest);
                    component.set('v.PartnerQuestList', acctRelatedPartnerQuest);

                } else {
                    // if there is no records then display message
                    component.set("v.bNoRecordsFound", true);
                }
            } else {
                alert('Error...');
            }
        });
        $A.enqueueAction(action);
    },
    // navigate to next pagination record set   
    next: function(component, event, sObjectList, end, start, pageSize) {
        var Paginationlist = [];
        var counter = 0;
        for (var i = end + 1; i < end + pageSize + 1; i++) {
            if (sObjectList.length > i) {
                /* if(component.find("selectAllId").get("v.value")){
                     Paginationlist.push(sObjectList[i]);
                 }else{*/
                Paginationlist.push(sObjectList[i]);
                // }
            }
            counter++;
        }
        start = start + counter;
        end = end + counter;
        component.set("v.startPage", start);
        component.set("v.endPage", end);
        component.set('v.PaginationList', Paginationlist);
    },
    // navigate to previous pagination record set   
    previous: function(component, event, sObjectList, end, start, pageSize) {
        var Paginationlist = [];
        var counter = 0;
        for (var i = start - pageSize; i < start; i++) {
            if (i > -1) {
                /*  if(component.find("selectAllId").get("v.value")){
                      Paginationlist.push(sObjectList[i]);
                  }else{*/
                Paginationlist.push(sObjectList[i]);
                // }
                counter++;
            } else {
                start++;
            }
        }
        start = start - counter;
        end = end - counter;
        component.set("v.startPage", start);
        component.set("v.endPage", end);
        component.set('v.PaginationList', Paginationlist);
    },
    showToast: function(component, event, helper) {
        // Use \n for line breake in string 
        var sMsg = 'Records updated successfully!!';
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            mode: 'sticky',
            message: sMsg,
            type: 'success'
        });
        toastEvent.fire();
    }
})