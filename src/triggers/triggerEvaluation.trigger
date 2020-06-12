trigger triggerEvaluation on Evaluation__c (after insert) {
    set<string> appSet = new set<string>();
    for(Evaluation__c evalObj : trigger.new){
        appSet.add(evalObj.Application__c);
    }
    if(!appSet.isEmpty()){
        map<string,Evaluation__c> mapToEval = new map<string,Evaluation__c>();
        for(Evaluation__c evalObj : [Select Recommendation_Reasonsing__c,CDL_Evaluator__r.Name,Application__r.Name,Evaluator_Type__c,Overall_Score__c from Evaluation__c where Application__c in :appSet  order by createddate limit 3]){
            mapToEval.put(evalObj.Application__r.Name+'&&'+evalObj.CDL_Evaluator__r.Name,evalObj);
        }
        if(mapToEval.size()>0){
            List<Application__c> appList = new List<Application__c>();
            for(Application__c appObj :[Select Id,Name ,Evaluator_1__r.Name,Evaluator_2__r.Name,Owner.Name,Evaluator_3__r.Name,Evaluator_1_Score__c,Evaluator_2_Score__c,Evaluator_3_Score__c from Application__c where id in :appSet ]){
                if(mapToEval.ContainsKey(appObj.Name+'&&'+appObj.Evaluator_1__r.Name) && mapToEval.get(appObj.Name+'&&'+appObj.Evaluator_1__r.Name)!=null){
                    appObj.Evaluator_1_Score__c = mapToEval.get(appObj.Name+'&&'+appObj.Evaluator_1__r.Name).Overall_Score__c;
                     appObj.Evaluator_1_Recommendation_Reasonsing__c = mapToEval.get(appObj.Name+'&&'+appObj.Evaluator_1__r.Name).Recommendation_Reasonsing__c;}
                  if(mapToEval.ContainsKey(appObj.Name+'&&'+appObj.Evaluator_2__r.Name) && mapToEval.get(appObj.Name+'&&'+appObj.Evaluator_2__r.Name)!=null){
                    appObj.Evaluator_2_Score__c = mapToEval.get(appObj.Name+'&&'+appObj.Evaluator_2__r.Name).Overall_Score__c;
                     appObj.Evaluator_2_Recommendation_Reasonsing__c = mapToEval.get(appObj.Name+'&&'+appObj.Evaluator_2__r.Name).Recommendation_Reasonsing__c;
                }
                if(mapToEval.ContainsKey(appObj.Name+'&&'+appObj.Evaluator_3__r.Name) && mapToEval.get(appObj.Name+'&&'+appObj.Evaluator_3__r.Name)!=null){
                    appObj.Evaluator_3_Score__c = mapToEval.get(appObj.Name+'&&'+appObj.Evaluator_3__r.Name).Overall_Score__c;
                     appObj.Evaluator_3_Recommendation_Reasonsing__c = mapToEval.get(appObj.Name+'&&'+appObj.Evaluator_3__r.Name).Recommendation_Reasonsing__c;
                }
                appList.add(appObj);
            }
            if(!appList.isEmpty()){
                update appList;
            }
        }
    }
}