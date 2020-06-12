({
	 closeQuickAction : function(component,event,helper){
        var quickActionClose = $A.get("e.force:closeQuickAction");
        quickActionClose.fire();    
    },
})