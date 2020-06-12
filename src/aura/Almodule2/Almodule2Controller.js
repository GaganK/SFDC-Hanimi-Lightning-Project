({
	doInit : function(component, event, helper) {
  	component.set("v.previewPreReadingM",true);
	},
    openAIPreview : function(component,event,helper){
        component.set("v.previewPreReadingM",false);
        component.set("v.previewAIPrimer",true);
    },
    openPreReadingPreview : function(component,event,helper){
        component.set("v.previewPreReadingM",true);
        component.set("v.previewAIPrimer",false);
    }
})