({
    selectRecord : function(component, event, helper){      
        console.log('## Select Record called');
        var getSelectRecord = component.get("v.oRecord");
        var compEvent = component.getEvent("oSelectedRecordEvent");
        compEvent.setParams({"recordByEvent" : getSelectRecord });  
        compEvent.fire();
    },
})