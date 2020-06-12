({
 /*   afterRender : function( component, helper ) {
        this.superAfterRender();
        window.addEventListener('beforeunload', onbeforeunload);
        function onbeforeunload(e) {
            console.log('==check with undefined=>'+component.get("v.showSaveCancelBtn") == 'undefined');
            console.log('==showcancelbutton=>'+component.get("v.showSaveCancelBtn"));
            if(component.get("v.showSaveCancelBtn")){
                e.returnValue = 'false';
            }
            //helper.showMessage(component, event,'Reloding.....','Warning');
        }; 
		}*/
})