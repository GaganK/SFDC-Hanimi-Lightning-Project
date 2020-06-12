({
	searchTimer : {},
    doInitHelper : function(component,event){
   		component.set("v.isProcessing", true);
        var action = component.get("c.fetchfinancewrapper");
         var dayId = component.get("v.dayId");
        var isDay1 = false;
        if(dayId=='day1'){
           isDay1 = true; 
        }
          action.setParams({ 
                          searchTerm : component.get("v.searchTerm"),
                        /* sortField : component.get("v.sortField"),
                          sortAsc : component.get("v.sortAsc"),
            			"selectedVentures" : component.get("v.selectedVentures"),
           				"selecttechList" : component.get("v.selecttechList"),*/
            isDay1 :isDay1
        }); 
            action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS"){
				component.set("v.isProcessing", false);
              
             
                var oRes = response.getReturnValue();
                     var pageSize = component.get("v.pageSize");
                    var totalRecordsList = oRes;
                    var totalLength = totalRecordsList.length;
                    component.set("v.totalRecordsCount", totalLength);
                    component.set("v.startPage",0);
                    component.set("v.endPage",pageSize-1);
				   component.set('v.listOfAllApplications', oRes);
                 component.set("v.totalPagesCount", Math.floor((oRes.length + pageSize -1 )/pageSize));
               this.renderPagination(component, event);
            }
                else{
                    component.set("v.isProcessing", false);
                     helper.showToast(component, event,'Something Went wrong, Please contact your Administrator!','error');

                }

            });
          $A.enqueueAction(action); 
    },    
    // navigate to next pagination record set   
    next : function(component,event,sObjectList,end,start,pageSize){
        var Paginationlist = [];
        var counter = 0;
        for(var i = end + 1; i < end + pageSize + 1; i++){
            if(sObjectList.length > i){ 
               /* if(component.find("selectAllId").get("v.value")){
                    Paginationlist.push(sObjectList[i]);
                }else{*/
                    Paginationlist.push(sObjectList[i]);  
               // }
            }
            counter ++ ;
        }
        start = start + counter;
        end = end + counter;
        component.set("v.startPage",start);
        component.set("v.endPage",end);
        component.set('v.PaginationList', Paginationlist);
    },
   // navigate to previous pagination record set   
    previous : function(component,event,sObjectList,end,start,pageSize){
        var Paginationlist = [];
        var counter = 0;
        for(var i= start-pageSize; i < start ; i++){
            if(i > -1){
              /*  if(component.find("selectAllId").get("v.value")){
                    Paginationlist.push(sObjectList[i]);
                }else{*/
                    Paginationlist.push(sObjectList[i]); 
               // }
                counter ++;
            }else{
                start++;
            }
        }
        start = start - counter;
        end = end - counter;
        component.set("v.startPage",start);
        component.set("v.endPage",end);
        component.set('v.PaginationList', Paginationlist);
        
    },
    renderPagination : function(component, event) {

        var allApplications = component.get("v.listOfAllApplications");
        var pageSize = component.get('v.pageSize');
        var currentPageNumber = component.get("v.currentPage");
        var pageRecords = allApplications.slice((currentPageNumber-1)*pageSize, currentPageNumber*pageSize);
        component.set("v.PaginationList", pageRecords);
    },
    showToast : function(component, event,errormessage,typemessage) {
        $A.get("e.c:showToastEvent")
          .setParams({
            type: typemessage,
            title: errormessage,
            description: errormessage,
            delay: 5000
          })
          .fire();
    }
   
})