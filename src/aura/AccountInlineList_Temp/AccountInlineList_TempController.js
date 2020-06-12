({
    doInit: function(component, event, helper) {
        
        var myAction = component.get("c.fetchUserId"); 
        myAction.setCallback(this, function(response) { 
            
            if(response.getState() === "SUCCESS") { 
                component.set("v.loggedinUserId", response.getReturnValue()); 
            }
        }); 
        $A.enqueueAction(myAction); 
        helper.doInitHelper(component, event);
    },
    
    /* javaScript function for pagination */
    navigation: function(component, event, helper) {
        
        var sObjectList = component.get("v.listOfAllAccounts");
        var end = component.get("v.endPage");
        var start = component.get("v.startPage");
        var pageSize = component.get("v.pageSize");
        var whichBtn = event.getSource().get("v.name");
        // check if whichBtn value is 'next' then call 'next' helper method
        
        if (whichBtn == 'next') {
            
            component.set("v.currentPage", component.get("v.currentPage") + 1);
            helper.next(component, event, sObjectList, end, start, pageSize);
        }
        // check if whichBtn value is 'previous' then call 'previous' helper method
        else if (whichBtn == 'previous') {
            
            component.set("v.currentPage", component.get("v.currentPage") - 1);
            helper.previous(component, event, sObjectList, end, start, pageSize);
        }
    },
    
    navigateToWebsite: function(component, event, helper){
        
        var selectedItem = event.currentTarget;
        var strUrl = selectedItem.dataset.record;
        
        if(strUrl === '' || strUrl === null || strUrl === undefined) return;
        if(!strUrl.startsWith('http') || !strUrl.startsWith('https')) {
            
            strUrl = 'https://' + strUrl;
        }
        
        var urlEvent = $A.get("e.force:navigateToURL");
        urlEvent.setParams({
          "url": strUrl
        });
        urlEvent.fire();
    },
    inlineEditOnVenture: function(component, event, helper){
        
        var selectedItem = event.currentTarget;
        var strColumn = selectedItem.dataset.record;
        var strIndex = selectedItem.dataset.index;
        console.log(strColumn,'>>>>',strIndex);
        
        component.set("v.editIndex",strIndex);
        component.set("v.editColumn",strColumn);
                        console.log(component.get("v.editIndex"),'>>>>',component.get("v.editColumn"));

    },
    Save: function(component, event, helper) {
               var action = component.get("c.updatePartnerQuestions");
                  action.setParams({
                    'partQuest': component.get("v.PartnerQuestList")
                  });
            action.setCallback(this, function(response) {
                var state = response.getState();
                  console.log('save state...'+state);
                if (state === "SUCCESS") {
                    var storeResponse = response.getReturnValue();
                    component.set("v.PartnerQuestList", storeResponse);
                    // Hide the save and cancel buttons by setting the 'showSaveCancelBtn' false 
                    component.set("v.showSaveCancelBtn",false);
                  // alert('Updated...');
                    //location.reload(); 
                }
            });
            $A.enqueueAction(action);
        //} 
    }
})