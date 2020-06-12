public without sharing class accountListController_Temp {
    
    @AuraEnabled 
    public static AccountWrapper fetchaccwrapper(){ 
        
        Map<String,List<SessionsWrapper>> mapStreamToVentures = new Map<String,List<SessionsWrapper>>();
        AccountWrapper accWrapper = new AccountWrapper();
        Set<String> setAccIds = new Set<String>();
        Map<String,Partner_Questionnaire__c> mapVentureToPartnerQuestionaire = new Map<String,Partner_Questionnaire__c>();
        
        for(User objUser : [SELECT id ,Contactid FROM User WHERE id=: UserInfo.getUserId() and Contactid!=null LIMIT 1] ){
            
            String loggedInContact = objUser.Contactid;
            Set<String> setCohort = new Set<String>();

            //fetch cohort-contact related to the logged in user
            For(Cohort_Contact__c cohortConObj : [SELECT id ,Cohort__c FROM Cohort_Contact__c WHERE Contact__c =: loggedInContact]){

                setCohort.add(cohortConObj.Cohort__c);
            }
            System.debug('setCohort*****************'+setCohort);
            
            //fetch ventures FROM admitted ventures related to the cohorts
            for(Admitted_Venture__c objAdmittedVenture : [SELECT id,Cohort__c,Cohort__r.Cohort_Name__c,Cohort__r.Stream__r.Name,
                                                            Venture__c,Venture__r.Name,Venture__r.Description_Venture__c,Venture__r.Core_Technology__c,
                                                            Venture__r.BillingState,Venture__r.BillingCountry,Venture__r.Technology_Area__c,
                                                            Venture__r.Website,Venture__r.Related_Stream_s__c
                                                            FROM Admitted_Venture__c 
                                                            WHERE Cohort__c in: setCohort
                                                            AND Admitted_Venture_Status__c like 'Admitted%'
                                                            ]){
                    
                setAccIds.add(objAdmittedVenture.Venture__c);
                List<SessionsWrapper> lstRelatedSessionsWrapper = new List<SessionsWrapper>();
                if(mapStreamToVentures.containsKey(objAdmittedVenture.Cohort__r.Stream__r.Name)){
                    
                    lstRelatedSessionsWrapper = mapStreamToVentures.get(objAdmittedVenture.Cohort__r.Stream__r.Name);
                }
                lstRelatedSessionsWrapper.add(new SessionsWrapper(objAdmittedVenture.Cohort__r.Cohort_Name__c,objAdmittedVenture.Cohort__r.Stream__r.Name,
                                                            objAdmittedVenture.Venture__c,objAdmittedVenture.Venture__r.Name,
                                                            objAdmittedVenture.Venture__r.Description_Venture__c,objAdmittedVenture.Venture__r.Core_Technology__c,
                                                            objAdmittedVenture.Venture__r.BillingState,objAdmittedVenture.Venture__r.BillingCountry,
                                                            objAdmittedVenture.Venture__r.Technology_Area__c,
                                                            objAdmittedVenture.Venture__r.Website));
                                                            
                mapStreamToVentures.put(objAdmittedVenture.Cohort__r.Stream__r.Name,lstRelatedSessionsWrapper);
            }
        }
        
        //fetch questionnaire for venture
        for(Partner_Questionnaire__c objPartnerQuestionnaire : [SELECT Account_Name__c,CommentsonventuresCDLSession__c,IsVentureApplicabletoyourBusiness__c,Ifyespleaseexplainwhy__c,
                                                                Wouldyouwantmoreinfo__c
                                                                FROM Partner_Questionnaire__c WHERE Account_Name__c in: setAccIds AND createdbyId=: UserInfo.getUserId() 
                                                                ORDER BY LastmodifiedDate DESC]){
                                                                    
            mapVentureToPartnerQuestionaire.put(objPartnerQuestionnaire.Account_Name__c,objPartnerQuestionnaire);
        }
        system.debug('mapStreamToVentures>>>>'+mapStreamToVentures);

        //insert questionaire to records
        // Map<String,List<SessionsWrapper>> mapStreamToVenturesTemp = new Map<String,List<SessionsWrapper>>();

        for(String strStream : mapStreamToVentures.keySet()){
            
            for(SessionsWrapper objSessionsWrapper : mapStreamToVentures.get(strStream)){
                
                if(mapVentureToPartnerQuestionaire.containsKey(objSessionsWrapper.VentureId)){
                    
                    objSessionsWrapper.objPartnerQuestionaire = mapVentureToPartnerQuestionaire.get(objSessionsWrapper.VentureId);
                }
            }
        }
        system.debug('mapStreamToVentures>>after partner questionaire>>'+mapStreamToVentures);
        
        accWrapper.mapStreamToVentures = mapStreamToVentures;
        return accWrapper;
        
    }
    
    /*@AuraEnabled 
    public static Partner_Questionnaire__c getVentureQuestionaire(String VentureId){ 
    
        Partner_Questionnaire__c objPartnerQuestionaire = new Partner_Questionnaire__c();
        If(lstPartnerQuestionaire.isEmpty()){
            
           lstPartnerQuestionaire = new Map<String,Partner_Questionnaire__c>();
        }
        
        if(lstPartnerQuestionaire.containsKey(VentureId)){
            
            
            objPartnerQuestionaire =  lstPartnerQuestionaire.get(VentureId);
        } else {
            
            objPartnerQuestionaire = [SELECT CommentsonventuresCDLSession__c,IsVentureApplicabletoyourBusiness__c,Ifyespleaseexplainwhy__c,
                                        Wouldyouwantmoreinfo__c
                                        FROM Partner_Questionnaire__c WHERE Account_Name__c in: VentureId AND createdbyId=: UserInfo.getUserId() 
                                        ORDER BY LastmodifiedDate DESC LIMIT 1];
        }
        
        return objPartnerQuestionaire;
    }*/
    
    @AuraEnabled
    public static string fetchUserId() {
        
        return UserInfo.getUserId();
    }
    
    @AuraEnabled
    public static  Partner_Questionnaire__c updatePartnerQuestion(Partner_Questionnaire__c partQuest ){
        system.debug('partQuest*************'+partQuest);
        if(partQuest != null){
            upsert partQuest Id;
        }
        
        return partQuest;
    }
    
    @AuraEnabled
    public static  List<Partner_Questionnaire__c> updatePartnerQuestions( List<Partner_Questionnaire__c> partQuest ){
        system.debug('partQuest*************'+partQuest);
        if(partQuest.size()>0){
            upsert partQuest Id;
        }
        
        return partQuest;
    }
    
    public class AccountWrapper{
        
        @AuraEnabled 
        public Map<String,List<sessionsWrapper>> mapStreamToVentures;
        
    }
    
    public class SessionsWrapper{
        
        @AuraEnabled
        public String CohortName;
        
        @AuraEnabled
        public String CohortStream;
        
        @AuraEnabled
        public String VentureId;
        
        @AuraEnabled
        public String VentureName;
        
        @AuraEnabled
        public String VentureDescription;
        
        @AuraEnabled
        public String VentureCoreTechnology;
        
        @AuraEnabled
        public String VentureBillingState;
        
        @AuraEnabled
        public String VentureBillingCountry;
        
        @AuraEnabled
        public String VentureTechnology_Area;
        
        @AuraEnabled
        public String VentureWebsite;
        
        @AuraEnabled 
        public Partner_Questionnaire__c objPartnerQuestionaire;
        
        public SessionsWrapper(String CohortName,String CohortStream,String VentureId, String VentureName,String VentureDescription,String VentureCoreTechnology,
                                String VentureBillingState,String VentureBillingCountry,String VentureTechnology_Area,String VentureWebsite){
            
            this.CohortName = CohortName;
            this.CohortStream = CohortStream;
            this.VentureId = VentureId;
            this.VentureName = VentureName;
            this.VentureDescription = VentureDescription;
            this.VentureCoreTechnology = VentureCoreTechnology;
            this.VentureBillingState = VentureBillingState;
            this.VentureBillingCountry = VentureBillingCountry;
            this.VentureTechnology_Area = VentureTechnology_Area;
            this.VentureWebsite = VentureWebsite;
            this.objPartnerQuestionaire = new Partner_Questionnaire__c(Account_Name__c=VentureId);
        }
    }
    
}