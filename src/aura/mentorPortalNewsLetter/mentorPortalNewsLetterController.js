({
   
    doInit: function(component, event, helper) {
          window.addEventListener('beforeunload', function (e) {
          // Cancel the event
          e.preventDefault();
           if (confirm('before unload handler has been called.')) {
              $A.get('e.force:refreshView').fire();
            } else {
              
            }
          e.returnValue = '';
            
        });
    }
})