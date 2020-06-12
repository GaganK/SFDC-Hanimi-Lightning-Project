({
    validate : function(Component) {
        Component.find('plaintexthtml').validate();
        Component.set('v.validated',Component.find('plaintexthtml').get('v.validated'));
    }
})