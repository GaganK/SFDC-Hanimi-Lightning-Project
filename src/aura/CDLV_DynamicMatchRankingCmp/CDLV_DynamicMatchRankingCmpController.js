({ 
    doInit: function(component, event, helper) {
      helper.getRankingList(component, event);
	},
	 handleVentureRanking: function(component, event, helper){
        component.set("v.showSaveCancelBtn", false);
        var selectCmp = event.getSource().get("v.value");
        console.log(selectCmp);
        var selvenId = event.getSource().get("v.accesskey");
         //alert(selvenId)''
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
             if(currentRankings[i].value!=null && currentRankings[i].value!=''){
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
                  var currentsel =  parseInt(allAppLst[i].isSelectedVal);
				   console.log('********currentsel********'+ currentsel);
                  console.log('********parseNumber********'+ parseNumber);
				 if(allAppLst[i].isSelectedVal!=null && allAppLst[i].isSelectedVal!=''){
					 if(currentsel==parseNumber && selvenId==allAppLst[i].userObj.Contact.AccountId){
                         console.log('selvenId');
						allAppLst[i].isSelectedVal = currentsel;
						 uniqueRanks.push(allAppLst[i].isSelectedVal);
						  console.log('********CurrentRank********');
                         
						selVentures.push(allAppLst[i].userObj.Contact.AccountId+'&&'+parseInt(allAppLst[i].isSelectedVal));
					} else if(currentsel<parseNumber && uniqueRanks.includes(currentsel)==false && arrayLastRank.includes(currentsel+1)==true && selvenId!=allAppLst[i].userObj.Contact.AccountId){
						 console.log('********Else CurrentRank********');
						allAppLst[i].isSelectedVal = currentsel;
						 uniqueRanks.push(allAppLst[i].isSelectedVal);
						selVentures.push(allAppLst[i].userObj.Contact.AccountId+'&&'+parseInt(allAppLst[i].isSelectedVal));
					} else if(currentsel<parseNumber && arrayLastRank.includes(currentsel-1)==true && selvenId!=allAppLst[i].userObj.Contact.AccountId){
						 console.log('********Else Else CurrentRank********');
						allAppLst[i].isSelectedVal = currentsel-1;
						 uniqueRanks.push(allAppLst[i].isSelectedVal);
						selVentures.push(allAppLst[i].userObj.Contact.AccountId+'&&'+parseInt(allAppLst[i].isSelectedVal));
					}
                   else if(arrayLastRank.includes(currentsel+1)==true && selvenId!=allAppLst[i].userObj.Contact.AccountId){
						 console.log('********Else Else Else CurrentRank********');
						allAppLst[i].isSelectedVal = currentsel+1;
						 uniqueRanks.push(allAppLst[i].isSelectedVal);
						selVentures.push(allAppLst[i].userObj.Contact.AccountId+'&&'+parseInt(allAppLst[i].isSelectedVal));
					}else if(currentsel>parseNumber && uniqueRanks.includes(currentsel-(currentsel-1))==false && arrayLastRank.includes(currentsel-1)==true && selvenId!=allAppLst[i].userObj.Contact.AccountId){
						 console.log('********Else Else Else Else CurrentRank********');
						allAppLst[i].isSelectedVal = currentsel-(currentsel-1);
						 uniqueRanks.push(allAppLst[i].isSelectedVal);
						selVentures.push(allAppLst[i].userObj.Contact.AccountId+'&&'+parseInt(allAppLst[i].isSelectedVal));
					}
				 }
			}
             /*for (var i = 0; i < allAppLst.length; i++) {
                  var currentsel =  parseInt(allAppLst[i].isSelectedVal);
                  console.log('********currentsel********'+ currentsel);
                  console.log('********parseNumber********'+ parseNumber);
                 if(allAppLst[i].isSelectedVal!=null && allAppLst[i].isSelectedVal!=''){
                   if(selventIds.includes(allAppLst[i].acctObj.Id) == true && (currentsel>parseNumber) 
                    && arrayLastRank.includes(currentsel+1)==true){
                     allAppLst[i].isSelectedVal = currentsel+1;
                     console.log('********currentRanking********'+ allAppLst[i].isSelectedVal);
                     uniqueRanks.push(allAppLst[i].isSelectedVal);
                      selVentures.push(allAppLst[i].acctObj.Id+'&&'+parseInt(allAppLst[i].isSelectedVal));
    
                   } else if(selventIds.includes(allAppLst[i].acctObj.Id) == true && (currentsel>=parseNumber) 
                    && arrayLastRank.includes(currentsel+1)==true){
                     allAppLst[i].isSelectedVal = currentsel+1;
                     console.log('********Equal currentRanking********'+ allAppLst[i].isSelectedVal);
                     uniqueRanks.push(allAppLst[i].isSelectedVal);
                      selVentures.push(allAppLst[i].acctObj.Id+'&&'+parseInt(allAppLst[i].isSelectedVal));
    
                   }else if(uniqueRanks.includes(currentsel)==false){
                     allAppLst[i].isSelectedVal = currentsel;
                        uniqueRanks.push(allAppLst[i].isSelectedVal);
                      selVentures.push(allAppLst[i].acctObj.Id+'&&'+parseInt(allAppLst[i].isSelectedVal));
                     console.log('********Else currentRanking********'+ allAppLst[i].isSelectedVal);
                   } 
                     else if(uniqueRanks.includes(currentsel+1)==false){
                     allAppLst[i].isSelectedVal = currentsel-1;
                       uniqueRanks.push(allAppLst[i].isSelectedVal);
                      selVentures.push(allAppLst[i].acctObj.Id+'&&'+parseInt(allAppLst[i].isSelectedVal));
                     console.log('********Else Else currentRanking********'+ allAppLst[i].isSelectedVal);
                   }
					            	}
             }*/
              uniqueRankingVal.push(selectCmp);
          component.set("v.listOfAllApplications", allAppLst);
          component.set("v.showSaveCancelBtn", true); 
        component.set("v.existingRankingList", uniqueRankingVal);
        component.set("v.selectedVenturesList", selVentures);
       // component.set("v.UpdatedVenturesList", selUpdatedVentures);
		
    }
})