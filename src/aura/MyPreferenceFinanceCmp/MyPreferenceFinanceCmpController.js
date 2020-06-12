({
    /* day1Tab: function(component, event, helper) {
        helper.day1helper(component, event, helper);
        
    },*/
    day2Tab: function(component, event, helper) {
        if (confirm('Changes you made may not be saved.')) {
            helper.day2helper(component, event, helper);
        } else {
            helper.day1helper(component, event, helper);
        }
        
    },
    handleComponentEvent :function(component, event,helper) {
        var Showalert = event.getParam("showSaveCancelBtn");
        console.log('12345='+Showalert);
        // set the handler attributes based on event data
        component.set("v.showSaveCancelBtn", Showalert);
    },
    showMessage : function(component, event,helper) {
        helper.showMessage(component, event,'Page Loding.....','Warning');
        
    },
    /* redirecteduPage : function(component, event, helper) {
        var urlEvent = $A.get("e.force:navigateToURL");
        urlEvent.setParams({
            "url": "/my-preference"
        });
        
        urlEvent.fire();
    },
    redirectCDLMentor : function(component, event, helper) {
        var urlEvent = $A.get("e.force:navigateToURL");
        urlEvent.setParams({
            "url": "/cdlmentors"
        });
        
        urlEvent.fire();
    },*/
    tabSelected: function(component,event,helper) {
        
        console.log('====>'+component.get("v.showSaveCancelBtn"));
        var tabId = component.get("v.selTabId");
        console.log(component.get("v.selTabId") + 'selected tab id');
        if(component.get("v.showSaveCancelBtn")){
            if (confirm('Changes you made may not be saved.')) {
                console.log('confirm');
                component.set("v.showSaveCancelBtn", false);
                console.log(component.get("v.selTabId") + 'selected tab id');
                return false;
            } else {
                console.log('else');
                return false;
            }
        }
    },
    
    ChangeselectTab:function(component,event,helper){
        debugger;
        console.log(component.get("v.showSaveCancelBtn"));
        var tabId = component.get("v.selTabId");
        console.log(component.get("v.selTabId"));
        if(component.get("v.showSaveCancelBtn2")){
        if(component.get("v.showSaveCancelBtn")){
            if (confirm('Changes you made may not be saved.')) {
                if(tabId == 'day1'){
                component.set("v.showSaveCancelBtn2", false);
                    component.set("v.selTabId",'day2');
                }
                else if(tabId == 'day2'){
                component.set("v.showSaveCancelBtn2", false);
                    component.set("v.selTabId",'day1');
                }
                console.log('confirm');
                console.log(component.get("v.selTabId"));
                return false;
            } else {
                console.log('else');
                return false;
            }
        }
        }
    },
    
    /* redirectCDLpi: function(component, event, helper) {
        var urlEvent = $A.get("e.force:navigateToURL");
        urlEvent.setParams({
            "url": "/my-preference"
        });
        urlEvent.fire();
       $A.get('e.force:refreshView').fire(); 
    },
    redirectCDLSession: function(component, event, helper) {
        var urlEvent = $A.get("e.force:navigateToURL");
        urlEvent.setParams({
            "url": "/my-sessions"
        });
        
        urlEvent.fire();
    },
    redirectSchedule: function(component, event, helper) {
        var tab = "partner";
        var urlEvent = $A.get("e.force:navigateToURL");
        urlEvent.setParams({
            "url": "/my-sessions?tab="+ tab,

        });
        urlEvent.fire();
    },
    redirectfa:function(component, event, helper) {
        var urlEvent = $A.get("e.force:navigateToURL");
        urlEvent.setParams({
            "url": "/mentor-profiles"
        });
        
        urlEvent.fire();
    },
    redirectPage : function(component, event, helper) {
        var urlEvent = $A.get("e.force:navigateToURL");
        urlEvent.setParams({
            "url": "/machine-learning-conference-"
        });
        
        urlEvent.fire();
    },
    redirectFn : function(component, event, helper) {
        var urlEvent = $A.get("e.force:navigateToURL");
        urlEvent.setParams({
            "url": "/mentor-family-newsletter"
        })
        urlEvent.fire();
    }, 
    redirectcdlPartner: function(component, event, helper) {
        var urlEvent = $A.get("e.force:navigateToURL");
        urlEvent.setParams({
            "url": "/cdl-partners"
        });
       
        urlEvent.fire();
    },*/
})