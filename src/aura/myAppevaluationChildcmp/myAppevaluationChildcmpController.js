({
    
    doInit: function(component, event, helper) {
        var selSPList = component.get("v.streamPotenList");
       var selnewSPList = [];
        if(selSPList!='' && selSPList!=null && selSPList!='undefined')
       selnewSPList=  selSPList.toString().split(';');
        component.set("v.updatedstreamPotenList",selnewSPList);
            //alert('****selSPList******'+component.get("v.streamPotenList"));
    }
})