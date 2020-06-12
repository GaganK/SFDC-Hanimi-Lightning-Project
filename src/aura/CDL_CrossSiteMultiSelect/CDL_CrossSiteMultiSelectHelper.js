({
    
    showSelectedValue: function(component) {
        
        var selectedValue=[];
        var ValueList=component.get("v.ValueList");
        
        for(var i in ValueList){           
            if(ValueList[i].flag){
                selectedValue.push(ValueList[i].value);
            }
        }

        var parentComponent = component.get("v.parent");
        var uniqueName = component.get("v.uniqueName").toLowerCase();
        
        if(uniqueName.includes('site')){
            
            parentComponent.set("v.filteredSites",selectedValue);
        } else if(uniqueName.includes('stream')){
            
            parentComponent.set("v.filteredStreams",selectedValue);
        }
        
        parentComponent.searchAction();
    }
})