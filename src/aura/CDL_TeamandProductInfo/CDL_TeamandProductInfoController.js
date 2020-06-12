({
	doInit : function(component, event, helper) {
        helper.getdata(component, event, helper);
	},

	openModel : function(component, event, helper) {

		component.set("v.showPrimaryContact", true);
	},

	closeModel : function(component, event, helper) {

		component.set("v.showPrimaryContact", false);
	}
})