({
    OpenValueToggle:function(component, event, helper) {

        var action = component.find("droplist_value");
        $A.util.removeClass(action,"slds-dropdown slds-dropdown--left slds-hide");
        $A.util.addClass(action,"slds-dropdown slds-dropdown--left slds-show");
    },
    
    HideValueToggle:function(component,event,helper){

        var action = component.find("droplist_value");
        $A.util.removeClass(action,"slds-dropdown slds-dropdown--left slds-show");
        $A.util.addClass(action,"slds-dropdown slds-dropdown--left slds-hide");

        var ySelected = component.get("v.Selected");

        if(ySelected === "1"){

            var arrValueID=new Array();           
            var isValueSelect=false;                   
            var ValueResult=JSON.parse(JSON.stringify(component.get("v.ValueList")));

            if(ValueResult !=null){

                for(var res in ValueResult){

                    if(ValueResult[res].flag==true){

                        arrValueID.push(ValueResult[res].label);                       
                    }
                }                
            }            
        }
    },
    
    AllValueUnCheck:function(component,event,helper){

        component.set("v.SelectedAllValue",false);
        component.set("v.SelectedValue",null);
        var Values=[];
        var ValueList=component.get("v.ValueList");
        for(var i in ValueList){
            var obj = {
                value:ValueList[i].value,
                label:ValueList[i].label,
                flag:false
            };

            Values.push(obj);
        }

        component.set("v.Selected","1");        
        component.set("v.ValueList",Values);
        helper.showSelectedValue(component);

    },
    
    AllValueCheck:function(component,event,helper){

        component.set("v.SelectedAllValue",true);
        component.set("v.SelectedValue",null);
        var Values=[];
        var ValueList=component.get("v.ValueList");

        for(var i in ValueList){

            var obj={
                value:ValueList[i].value,
                label:ValueList[i].label,
                flag:true
            };

            Values.push(obj);
        }

        component.set("v.Selected","1");
        component.set("v.SelectedValue",Values.length);
        component.set("v.ValueList",Values);  
        helper.showSelectedValue(component);
    },
    
    ValueCheck:function(component, event, helper){
        
        var ValueId=event.target.getAttribute('id'); 
        var ValueList=component.get("v.ValueList");
        component.set("v.SelectedAllValue",false);
        var count=1;
        var Values=[];

        for(var i in ValueList){
        
            if(ValueList[i].value==ValueId){
        
                var obj={
                    value:ValueList[i].value,
                    label:ValueList[i].label,
                    flag:true
                }  
        
                Values.push(obj);                
            }
            else{
                
                var obj={
                    value:ValueList[i].value,
                    label:ValueList[i].label,
                    flag:ValueList[i].flag
                }  
                
                Values.push(obj);
            }
        }
        
        for(var a in Values){
            
            if(ValueList[a].flag==true){

                count +=1;
            }
        }
        component.set("v.Selected","1");
        component.set("v.SelectedValue",count);
        component.set("v.ValueList",Values);  
        helper.showSelectedValue(component);
    },
    
    ValueUnCheck:function(component, event, helper){

        var ValueId=event.target.getAttribute('id'); 
        var ValueList=component.get("v.ValueList");
        component.set("v.SelectedAllValue",false);
        var count=component.get("v.SelectedValue");        
        var Values=[];

        for(var i in ValueList){

            if(ValueList[i].value==ValueId){

                var obj={
                    value:ValueList[i].value,
                    label:ValueList[i].label,
                    flag:false
                };

                Values.push(obj);
                count -=1;  
            } else{
                var obj={
                    value:ValueList[i].value,
                    label:ValueList[i].label,
                    flag:ValueList[i].flag
                };

                Values.push(obj);                
            }
        }       

        if(count==0){

            component.set("v.SelectedValue",null);
        } else{
            
            component.set("v.SelectedValue",count);
        }

        component.set("v.Selected","1");
        component.set("v.ValueList",Values);
        helper.showSelectedValue(component);
    } 
 })