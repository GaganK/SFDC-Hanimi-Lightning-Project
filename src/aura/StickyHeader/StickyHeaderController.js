({
doInit : function(component, event, helper) {
     var action = component.get("c.fetchUserDetail");
    action.setCallback(this, function(response) {

        var userInfo = response.getReturnValue();
        component.set("v.userContactId", userInfo.ContactId);
       
    })
    $A.enqueueAction(action);
}
})