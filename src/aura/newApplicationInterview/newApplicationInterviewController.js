({
  doInit : function(component, event, helper)
  {
    window.setTimeout($A.getCallback(function()
    {
      $A.get("e.force:closeQuickAction").fire(); }), 1
    );
    var getPrimaryContact = component.get("c.getPrimaryContact");
    getPrimaryContact.setParams({appId : component.get("v.recordId")});
    getPrimaryContact.setCallback(this, function(response)
    {
      var state = response.getState(); //alert(state);
      if (state === "SUCCESS")
      {
        //alert(JSON.stringify(response.getReturnValue())); alert(JSON.parse())
        var primaryContactId = response.getReturnValue(); var createInterview;
        if (primaryContactId != '')
        {
          createInterview = $A.get("e.force:createRecord");
          createInterview.setParams
          ({
            "entityApiName" : "Interview__c",
            "defaultFieldValues" :
            {
              'Application__c' : component.get("v.recordId"),
              'Interviewee__c' : primaryContactId
            }
          });
        } else
        {
          createInterview = $A.get("e.force:createRecord");
          createInterview.setParams
          ({
            "entityApiName" : "Interview__c",
            "defaultFieldValues" :
            {
              'Application__c' : component.get("v.recordId")
            }
          });
        }
        createInterview.fire();
      }
    });
    $A.enqueueAction(getPrimaryContact);
  }
})