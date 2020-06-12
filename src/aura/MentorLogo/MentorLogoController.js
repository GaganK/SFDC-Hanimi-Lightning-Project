({
	myAction : function(component, event, helper) {
        
		window.addEventListener('popstate', function (e) {
          // Cancel the event
          e.preventDefault();
           if (confirm('Changes you made may not be saved.')) {
              $A.get('e.force:refreshView').fire();
            } else {
              
            }
          e.returnValue = '';
            
        });
	}
})