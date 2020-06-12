({
    OpenValueToggle:function(component,event,helper) {

        var action=component.find("droplist_value");
        $A.util.removeClass(action,"slds-dropdown slds-dropdown--left slds-hide");
        $A.util.addClass(action,"slds-dropdown slds-dropdown--left slds-show");
    },
    
    HideValueToggle:function(component,event,helper) {

        var action=component.find("droplist_value");
        $A.util.removeClass(action,"slds-dropdown slds-dropdown--left slds-show");
        $A.util.addClass(action,"slds-dropdown slds-dropdown--left slds-hide");

        var ySelected=component.get("v.Selected");  

        if(ySelected=="1") {

            var arrValueID=new Array();           
            var isValueSelect=false;                   
            var valueResult=JSON.parse(JSON.stringify(component.get("v.ValueList")));
            if(valueResult !=null){
                for(var res in valueResult){
                    if(valueResult[res].flag==true){
                        arrValueID.push(valueResult[res].label);                       
                    }
                }                
            }            
        }
    },
    
    AllValueUnCheck:function(component,event,helper) {

        component.set("v.SelectedAllValue",false);
        component.set("v.SelectedValue",null);
        var values=[];
        var valueList=component.get("v.ValueList");
        for(var i in valueList){
            var obj={
                value:valueList[i].value,
                label:valueList[i].label,
                flag:false
            }  
            values.push(obj);
        }
        component.set("v.Selected","1");        
        component.set("v.ValueList",values);
        helper.showSelectedValue(component);
    },
    
    AllValueCheck:function(component,event,helper){

        component.set("v.SelectedAllValue",true);
        component.set("v.SelectedValue",null);
        var values=[];
        var valueList=component.get("v.ValueList");

        for(var i in valueList){
            var obj={
                value:valueList[i].value,
                label:valueList[i].label,
                flag:true
            }  
            values.push(obj);
        }
        component.set("v.Selected","1");
        component.set("v.SelectedValue",values.length);
        component.set("v.ValueList",values);  
        helper.showSelectedValue(component);

    },
    
    ValueCheck:function(component, event, helper){
        
        var ValueId=event.target.getAttribute('id');
        var valueList=component.get("v.ValueList");
        component.set("v.SelectedAllValue",false);
        var count=1;
        var values=[];

        for(var i in valueList){
        
            if(valueList[i].value==ValueId){
                // console.log('here in if');
                var obj={
                    value:valueList[i].value,
                    label:valueList[i].label,
                    flag:true
                }

                values.push(obj);                
            }
            else{
                
                var obj={
                    value:valueList[i].value,
                    label:valueList[i].label,
                    flag:valueList[i].flag
                }

                values.push(obj);
            }
        }
        
        for(var a in values){
            
            if(valueList[a].flag==true){

                count +=1;
            }
        }
        component.set("v.Selected","1");
        component.set("v.SelectedValue",count);
        component.set("v.ValueList",values);  
        helper.showSelectedValue(component);
    },
    
    ValueUnCheck:function(component, event, helper){
        var ValueId=event.target.getAttribute('id'); 
        var valueList=component.get("v.ValueList");
        component.set("v.SelectedAllValue",false);
        var count=component.get("v.SelectedValue");        
        var values=[];
        for(var i in valueList){
            if(valueList[i].value==ValueId){
                var obj={
                    value:valueList[i].value,
                    label:valueList[i].label,
                    flag:false
                }  
                values.push(obj);
                count -=1;  
            }
            else{
                var obj={
                    value:valueList[i].value,
                    label:valueList[i].label,
                    flag:valueList[i].flag
                }  
                values.push(obj);                
            }
        }        
        if(count==0){
            component.set("v.SelectedValue",null);
        }
        else{
            component.set("v.SelectedValue",count);
        }
        component.set("v.Selected","1");
        component.set("v.ValueList",values);
        helper.showSelectedValue(component);
    } 
 })