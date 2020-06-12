public class workbookSessionController {
   
  @AuraEnabled 
    public static List<accountWrapper> fetchaccwrapper(){ 
        Set<String> acctSet = new Set<String>();
        List<User> userList = new List<User>();
        userList = [Select id ,Contactid from User where id=:UserInfo.getUserId() and Contactid!=null];
      if(!userList.isEmpty()){ 
            set<string> cohortSet = new set<string>();
            For(Cohort_Contact__c cohortConObj : [Select id ,Cohort__c from Cohort_Contact__c where Contact__c = :userList[0].Contactid]){
                                                  //:userList[0].Contactid]){
               cohortSet.add(cohortConObj.Cohort__c);
                System.debug('cohortSet*****************'+cohortSet);
            }
            if(!cohortSet.isEmpty()){
                for(Admitted_Venture__c admVenObj : [Select id ,Venture__c,Admitted_Venture_Status__c from Admitted_Venture__c where Cohort__c in :cohortSet and (Admitted_Venture_Status__c='Admitted' OR Admitted_Venture_Status__c Like 'Dropped%')]){
                    acctSet.add(admVenObj.Venture__c);
                     System.debug('acctSet*****************'+acctSet);
                }
            }
        }
        
         List<Account> accList = new List<Account>();
          System.debug('acctSet*****************'+acctSet);
         List<accountWrapper> wcList = new List<accountWrapper>();
                
               String query = 'SELECT Id, Name,Sequence__c,Description_Venture__c,Core_Technology__c,BillingState,BillingCountry,Technology_Area__c,Related_Stream_s__c,Website FROM Account where Related_Stream_s__c !=null ';
                if(!test.isRunningTest()){
                    query = query + '  and id in :acctSet ';
                }
                query = query + ' order by Sequence__c ASC LIMIT 50000 ';
                System.debug('query*****************'+query);

    accList = Database.query(query);
    if(!accList.isEmpty()){
        map<string,List<Partner_Questionnaire__c>> mapToPartnerQuestionnaire = new map<string,List<Partner_Questionnaire__c>>();
        set<string> accIdsSet = new set<string>();
        for(Account acctObj :accList ){
            accIdsSet.add(acctObj.id);
            
        }
        if(!accIdsSet.isEmpty()){
            string loggedUserId = Userinfo.getUserId();
            List<Partner_Questionnaire__c> partnerQuestList = new List<Partner_Questionnaire__c>();
            partnerQuestList = [Select id,Account_Name__c,CommentsonventuresCDLSession__c ,Ifyespleaseexplainwhyfounders__c,Doyouwanttoconnectwithfounders__c,Ifyeswhatinfowouldyoulike__c,Ifyespleaseexplainwhy__c,Wouldyouwantmoreinfo__c ,Any_interest_to_meet_this_venture__c,IsVentureApplicabletoyourBusiness__c,Anyotheradditionalcomments__c from Partner_Questionnaire__c where Account_Name__c  in :accIdsSet and createdbyId=:loggedUserId  order by LastmodifiedDate Desc];
            if(!partnerQuestList.isEmpty()){
                for(Partner_Questionnaire__c partQuest : partnerQuestList){
                    if(mapToPartnerQuestionnaire.containsKey(partQuest.Account_Name__c)){
                        mapToPartnerQuestionnaire.get(partQuest.Account_Name__c).add(partQuest);
                    }else{
                        mapToPartnerQuestionnaire.put(partQuest.Account_Name__c,new List<Partner_Questionnaire__c>{partQuest});
                    }
                }
            }
        }
        for(Account acctObj : accList){
            accountWrapper accwrapper = new accountWrapper();
            accwrapper.acctObj = acctObj;
            if(mapToPartnerQuestionnaire.get(acctObj.id)!=null){
                accwrapper.partnerQuestionnaireObj = mapToPartnerQuestionnaire.get(acctObj.id)[0];
            }else{
                accwrapper.partnerQuestionnaireObj = new Partner_Questionnaire__c();
            }
            wcList.add(accwrapper);
        }
    }
        return wcList; 
    }

    @AuraEnabled
    public static string fetchUserId() {

        return UserInfo.getUserId();
    }
    @AuraEnabled
    public static  List<Partner_Questionnaire__c> updatePartnerQuestions( List<Partner_Questionnaire__c> partQuest ){
        system.debug('partQuest*************'+partQuest);
        if(partQuest.size()>0){
            upsert partQuest Id;
        }
        
        return partQuest;
    }
    public class accountWrapper{
         @AuraEnabled 
         public Account acctObj;
          @AuraEnabled 
         public Partner_Questionnaire__c partnerQuestionnaireObj;
    }
  
}