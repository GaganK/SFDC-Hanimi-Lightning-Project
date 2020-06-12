public class interviewEvaluationCtrl {

  @AuraEnabled 
    public static List<applicationEvaluationWrapper> fetchAppwrapper(){     
         List<Application__c> appList = new List<Application__c>();
         List<applicationEvaluationWrapper> wcList = new List<applicationEvaluationWrapper>();
               String query = 'SELECT Id,Ranking__c, Name,Number_of_Co_Founders__c ,Avg_Score_Superstar_Potential__c,Tech_Specialization__c,Venture__c,Venture__r.Name FROM Application__c where CreatedDate =LAST_N_DAYS:365 ';
                string loggedUserId = Userinfo.getUserId();
               if(String.isNotBlank(loggedUserId)) {
                    query = query + ' AND (Evaluator_1__c = \'' + loggedUserId + '\' OR Evaluator_2__c = \'' + loggedUserId + '\' OR Evaluator_3__c = \'' + loggedUserId + '\')';
                }
                  
                 query = query + ' ORDER BY Avg_Score_Overall__c Desc LIMIT 2000 ';
                System.debug('query*****************'+query);

    appList = Database.query(query);
    if(!appList.isEmpty()){
        map<string,Evaluation__c> mapToApp = new map<string,Evaluation__c>();
        set<string> appidsSet = new set<string>();
        for(Application__c appObj :appList ){
            appidsSet.add(appObj.id);
            
        }
        if(!appidsSet.isEmpty()){
            for(Evaluation__c evaObj : [Select id,Superstar_Potential__c,Tech_Review__c,Business_Review__c,Recommendation_Reasonsing__c,CDL_Evaluator__c,Application__c from Evaluation__c where Application__c  in :appidsSet]){
                mapToApp.put(evaObj.Application__c+'&&'+evaObj.CDL_Evaluator__c,evaObj);
            }
        }
        for(Application__c appObj : appList){
            applicationEvaluationWrapper appwrapper = new applicationEvaluationWrapper();
            appwrapper.appObj = appObj;
            appwrapper.evaluationObj = mapToApp.get(appObj.id+'&&'+Userinfo.getUserId());
            wcList.add(appwrapper);
        }
    }
        return wcList; 
    }
    @AuraEnabled(cacheable=true)
    public static List<Contact> getContacts(string applicationid){
        List<Contact> conList = new List<Contact>();
        Set<String> conSet = new Set<String>();
        for(Application_Contact__c appCon : [Select id, Contact__c,Cofounder_Number__c from Application_Contact__c where Application__c =:applicationid]){
            conSet.add(appCon.Contact__c);
        }
        if(!conSet.isEmpty()){
            conList = [Select id, Name, Email , Hours_Spent_on_Venture_in_Last_30_Days__c,Relevant_Experience__c,Key_Awards_and_Achievements__c,
                        Why_Co_Founder_is_Important_for_Venture__c,Hrs_Expected_on_Venture_for_Next_8_Mths__c,(Select id, Contact__c,Degree__c,Degree_Number__c,GPA__c,Graduation_Year__c,Institute__c,Specialization__c from Education__r) from Contact where id in :conSet];
            
        }
        return conList;
    }
    @AuraEnabled
    public static string fetchUserId() {

        return UserInfo.getUserId();
    }

    public class applicationEvaluationWrapper{
         @AuraEnabled
         public Evaluation__c evaluationObj;
         @AuraEnabled 
         public Application__c appObj;
    }
  
}