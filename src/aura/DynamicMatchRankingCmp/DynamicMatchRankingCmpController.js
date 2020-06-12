({ 
    doInit: function(component, event, helper) {
      helper.getRankingList(component, event);
      
	},
     
	 handleVentureRanking: function(component, event, helper){
        
        component.set("v.showSaveCancelBtn", false);
        var selectCmp = event.getSource().get("v.value");
        
        console.log(selectCmp);
        var selvenId = event.getSource().get("v.accesskey");
        console.log('****auraId*****'+selvenId);
        var selVentures =component.get("v.selectedVenturesList");
        var existingRankingList = component.get("v.existingRankingList");
         var errormessage = 'This Ranking was already selected , Please select another Rank \n';
        var uniqueRankingVal=component.get("v.existingRankingList");
        var selVenVal = selvenId+'&&'+selectCmp;
		 var parseNumber =  parseInt(selectCmp);
         var allAppLst = component.get("v.listOfAllApplications");
         var currentRankings = component.get("v.options");
         var arrayLastRank = [];
         for(var i = 0; i < currentRankings.length; i++){
             if(currentRankings[i].value!=null && currentRankings[i].value!='' ){
                  arrayLastRank.push(parseInt(currentRankings[i].value));                 
             }
            
         }
        
           if(uniqueRankingVal.includes(selectCmp) == true){ 
          	helper.showMessage(component, event,'We have auto-adjusted the ranking of ventures to meet the new rank you have selected','warning');
           }
             var selventIds =[];
             for(var i = 0; i < selVentures.length; i++){
                 selventIds.push(selVentures[i].substring(0, selVentures[i].indexOf("&&")));
             }
         	var uniqueRanks = [];
         	selVentures = [];
         for (var i = 0; i < allAppLst.length; i++) {
       	var currentsel =  parseInt(allAppLst[i].previousSelVal);
		
      if(allAppLst[i].isSelectedVal!=null && allAppLst[i].isSelectedVal!=''){
            if(currentsel>parseNumber&&currentsel ==allAppLst.length&&selvenId!=allAppLst[i].acctObj.Id){
               
                   if(uniqueRanks.includes(currentsel-(currentsel-1))==false) {                    
                    allAppLst[i].isSelectedVal = currentsel-(currentsel-1);
                     allAppLst[i].previousSelVal = currentsel-(currentsel-1);
                      uniqueRanks.push(allAppLst[i].isSelectedVal);
                } else {
                    allAppLst[i].isSelectedVal = allAppLst.length +1;
                }
			      selVentures.push(allAppLst[i].acctObj.Id+'&&'+parseInt(allAppLst[i].isSelectedVal));
               }
			   else if(currentsel>parseNumber&&arrayLastRank.includes(currentsel-(currentsel-1))==true&&selvenId!=allAppLst[i].acctObj.Id){
                   
                allAppLst[i].isSelectedVal = currentsel+1;
                allAppLst[i].previousSelVal = currentsel+1;
				uniqueRanks.push(allAppLst[i].isSelectedVal);
			      selVentures.push(allAppLst[i].acctObj.Id+'&&'+parseInt(allAppLst[i].isSelectedVal));
                }
               else if(currentsel==parseNumber&&selvenId!=allAppLst[i].acctObj.Id&&currentsel ==allAppLst.length){
                  
                allAppLst[i].isSelectedVal = currentsel-(currentsel-1);
                allAppLst[i].previousSelVal = currentsel-(currentsel-1);
				uniqueRanks.push(allAppLst[i].isSelectedVal);
			    selVentures.push(allAppLst[i].acctObj.Id+'&&'+parseInt(allAppLst[i].isSelectedVal));
                }
               else if(currentsel==parseNumber&& selvenId!=allAppLst[i].acctObj.Id&&currentsel !=allAppLst.length
                       && uniqueRanks.includes(currentsel+1)== false){
                 
               // allAppLst[i].isSelectedVal = currentsel- (currentsel-1);
                allAppLst[i].isSelectedVal = currentsel+1;
                allAppLst[i].previousSelVal = currentsel+1;
				uniqueRanks.push(allAppLst[i].isSelectedVal);
			    selVentures.push(allAppLst[i].acctObj.Id+'&&'+parseInt(allAppLst[i].isSelectedVal));
                 }
                else if(currentsel<parseNumber&&arrayLastRank.includes(currentsel-(currentsel-1))==true && selvenId==allAppLst[i].acctObj.Id){
                                         
                   uniqueRanks.push(allAppLst[i].isSelectedVal); 
			      selVentures.push(allAppLst[i].acctObj.Id+'&&'+parseInt(allAppLst[i].isSelectedVal));
                }
                else if (currentsel<parseNumber && arrayLastRank.includes(currentsel-(currentsel-1))==true&&selvenId!=allAppLst[i].acctObj.Id){
                   
                  // if(uniqueRanks.includes(currentsel+1)== false) {
                       allAppLst[i].isSelectedVal = currentsel+1;
                       allAppLst[i].previousSelVal = currentsel+1;  
                       uniqueRanks.push(allAppLst[i].isSelectedVal);
                  // }                  
                  
			    selVentures.push(allAppLst[i].acctObj.Id+'&&'+parseInt(allAppLst[i].isSelectedVal));
                      }
                else if (currentsel<parseNumber && ( currentsel+1)!=allAppLst.length && arrayLastRank.includes(currentsel-(currentsel-1))!=true&&selvenId!=allAppLst[i].acctObj.Id){                  
                allAppLst[i].isSelectedVal = currentsel-1;
                allAppLst[i].previousSelVal = currentsel-1;
				uniqueRanks.push(allAppLst[i].isSelectedVal);
			    selVentures.push(allAppLst[i].acctObj.Id+'&&'+parseInt(allAppLst[i].isSelectedVal));
                 }
                 /* else if(currentsel>parseNumber && ( currentsel+1)==allAppLst.length&&selvenId!=allAppLst[i].acctObj.Id){
                      //alert('6');
                   allAppLst[i].isSelectedVal = currentsel-1;
                  allAppLst[i].previousSelVal = currentsel-1;
				   uniqueRanks.push(allAppLst[i].isSelectedVal);
			    selVentures.push(allAppLst[i].acctObj.Id+'&&'+parseInt(allAppLst[i].isSelectedVal));
                  }*/
             else if(currentsel>parseNumber&&arrayLastRank.includes(currentsel-(currentsel-1))==true && selvenId==allAppLst[i].acctObj.Id){
                   uniqueRanks.push(allAppLst[i].isSelectedVal); 
			      selVentures.push(allAppLst[i].acctObj.Id+'&&'+parseInt(allAppLst[i].isSelectedVal));
                }
               else if(currentsel==parseNumber&&selvenId==allAppLst[i].acctObj.Id&& currentsel!= allAppLst.length){
                                   
                   if(uniqueRanks.includes(currentsel) == false && arrayLastRank.includes(currentsel+1)==true)  {                      
                       allAppLst[i].isSelectedVal = currentsel;
                       allAppLst[i].previousSelVal = currentsel;
                   } else {                   
                   	allAppLst[i].isSelectedVal = currentsel+(currentsel+1);
                    allAppLst[i].previousSelVal = currentsel+(currentsel+1);
                   }
				uniqueRanks.push(allAppLst[i].isSelectedVal);
			    selVentures.push(allAppLst[i].acctObj.Id+'&&'+parseInt(allAppLst[i].isSelectedVal));
                 }
             else if(currentsel==parseNumber&&selvenId==allAppLst[i].acctObj.Id&& currentsel== allAppLst.length){                  
                allAppLst[i].isSelectedVal = currentsel;
                  allAppLst[i].previousSelVal = currentsel;
				uniqueRanks.push(allAppLst[i].isSelectedVal);                 
			    selVentures.push(allAppLst[i].acctObj.Id+'&&'+parseInt(allAppLst[i].isSelectedVal));
                 }
             

		}
	}
         
        
         uniqueRankingVal.push(selectCmp);
         component.set("v.listOfAllApplications", allAppLst);
         component.set("v.showSaveCancelBtn", true); 
         component.set("v.existingRankingList", uniqueRankingVal);
         component.set("v.selectedVenturesList", selVentures);
       	//component.set("v.UpdatedVenturesList", selUpdatedVentures);
       	 var isUnsavedData = component.get("v.showSaveCancelBtn");
       console.log(isUnsavedData + 'unsave from do init=='); 
         console.log('==hi==');
        window.addEventListener("beforeunload", function (e) {
              e.preventDefault();
            if(isUnsavedData){
                e.returnValue = 'Changes you made may not be saved!!!';
            }
        });
  /*  window.addEventListener("mousemove", function() {
     if(isUnsavedData){
        confirm('Changes you made may not be saved!!!');
     }
    }, false); 
    document.addEventListener("visibilitychange", function(e) {
			
            if (isUnsavedData && document.hidden){
                alert('Changes you made may not be saved!!!');
            }
    },false); */
		
    }
})