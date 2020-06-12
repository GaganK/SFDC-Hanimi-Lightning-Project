({
	day1helper : function(component, event) {
		   var tab1 = component.find('day1');
        var TabOnedata = component.find('day1TabDataId');
 
        var tab2 = component.find('day2');
        var TabTwoData = component.find('day2TabDataId');

        //show and Active fruits tab
        $A.util.addClass(tab1, 'slds-active');
        $A.util.addClass(TabOnedata, 'slds-show');
        $A.util.removeClass(TabOnedata, 'slds-hide');
        // Hide and deactivate others tab
        $A.util.removeClass(tab2, 'slds-active');
        $A.util.removeClass(TabTwoData, 'slds-show');
        $A.util.addClass(TabTwoData, 'slds-hide');
	},
    day2helper : function(component, event) {
         var tab1 = component.find('day1');
        var TabOnedata = component.find('day1TabDataId');
 
        var tab2 = component.find('day2');
        var TabTwoData = component.find('day2TabDataId');

 
        //show and Active vegetables Tab
        $A.util.addClass(tab2, 'slds-active');
        $A.util.removeClass(TabTwoData, 'slds-hide');
        $A.util.addClass(TabTwoData, 'slds-show');
        // Hide and deactivate others tab
        $A.util.removeClass(tab1, 'slds-active');
        $A.util.removeClass(TabOnedata, 'slds-show');
        $A.util.addClass(TabOnedata, 'slds-hide');
    },
    showMessage : function(component, event,errormessage,typemessage) {
        $A.get("e.c:showToastEvent")
        .setParams({
            type: typemessage,
            title: errormessage,
            description: errormessage,
            delay: 4000
        })
        .fire();
    },
})