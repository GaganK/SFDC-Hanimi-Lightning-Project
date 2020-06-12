({
	doInit : function(component, event, helper) {
          helper.doInitHelper(component, event);
        
	}, 
    firstPage: function(component, event, helper) {

        component.set("v.currentPage", 1);
        helper.renderPagination(component, event);
    },
 cancel : function(component,event,helper){
        $A.get('e.force:refreshView').fire(); 
    },
    onSelAdmit : function(component,event,helper){
        if(event.getSource().get("v.checked") != undefined &&  event.getSource().get("v.checked")== true){ 
        	component.set("v.showSaveCancelBtn", true);
        }else{
            component.set("v.showSaveCancelBtn", false);
        }
          
    },
    prevPage: function(component, event, helper) {

        component.set("v.currentPage", Math.max(component.get("v.currentPage")-1, 1));
        helper.renderPagination(component, event);
    },

    nextPage: function(component, event, helper) {

        component.set("v.currentPage", Math.min(component.get("v.currentPage")+1, component.get("v.totalPagesCount")));
        helper.renderPagination(component, event);
    },

    lastPage: function(component, event, helper) {

        component.set("v.currentPage", component.get("v.totalPagesCount"));
        helper.renderPagination(component, event);
    }, 
    onSearch : function(component, event, helper) {   
        
        window.clearTimeout(helper.searchTimer);

        helper.searchTimer = window.setTimeout(
            function(){
                console.log('## Search called');
                new Promise($A.getCallback(function(resolve, reject) {
                    component.set("v.isSearching", true);
                    helper.doInitHelper(component, helper);
                }));
            }
            , 500);
    },
    resetView : function(component, event, helper) {
           $A.get('e.force:refreshView').fire();
     
    },/* javaScript function for pagination */
    navigation: function(component, event, helper) {
        var sObjectList = component.get("v.ApplicationList");
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
    handleSelectAllVenture: function(component, event, helper) {
        var getID = component.get("v.PaginationList");
        var checkvalue = component.find("selectAll").get("v.checked");        
        var checkVenture  = component.find("checkventure"); 
        if(checkvalue == true){
            for(var i=0; i<checkVenture.length; i++){
                checkVenture[i].set("v.checked",true);
            }
            component.set("v.showSaveCancelBtn", true);
        }
        else{ 
            for(var i=0; i<checkVenture.length; i++){
                checkVenture[i].set("v.checked",false);
            }
            component.set("v.showSaveCancelBtn", false);
        }
    },
    handleSelectedAdmits: function(component, event, helper) {
        var admitList = component.get("v.PaginationList"); 
        var isSelectAll = component.get("v.isSelectAll");
         var selectedAdmits = [];
          if(isSelectAll){
            selectedAdmits = admitList;
        }
        else{
            var k = 0;
            for (var i=0; i<admitList.length; i++){
                var c = admitList[i];
                if(c.isSelected) {
                    selectedAdmits[k] = c;
                    k++; 
                }     
            }
        }
        
        if(selectedAdmits.length > 0){
            var action = component.get("c.saveAdmit");
             var selectedAdmitList = JSON.stringify(selectedAdmits);
            action.setParams({
                selAdmitVent : selectedAdmitList
            });
            action.setCallback(this, function(result){
                var state = result.getState();
                if (state === "SUCCESS"){
                
               // helper.showToast(component, event,'Interested Mentor successfully!!','Success');
                $A.get('e.force:refreshView').fire(); 
                }
                else if(state == "ERROR"){
              // helper.showToast(component, event,'Something went wrong, Please contact your Admin!','Error');
                }
            });
            $A.enqueueAction(action);
        }
    }
    
})