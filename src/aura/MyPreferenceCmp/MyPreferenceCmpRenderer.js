({
   /* afterRender : function( component, helper ) {
        this.superAfterRender();
        window.addEventListener('beforeunload', onbeforeunload);
        function onbeforeunload(e) {
            console.log('===>'+component.get("v.display"));
            if(component.get("v.display")){
                e.returnValue = 'false';
            }
            //helper.showMessage(component, event,'Reloding.....','Warning');
        }; 
    }*/
})