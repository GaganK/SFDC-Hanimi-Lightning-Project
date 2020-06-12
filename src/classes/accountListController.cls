public without sharing class accountListController {
    
    @AuraEnabled 
    public static List<SiteToStreamWrapper> getVentures(){ 
        
        Set<String> ventureIds = new Set<String>();
        Map<String, SiteToStreamWrapper> mapOfSiteToStreamToVentures = new Map<String,SiteToStreamWrapper>();
        Map<String,Partner_Questionnaire__c> mapVentureToPartnerQuestionaire = new Map<String,Partner_Questionnaire__c>();
        
        // Queries inside this loop is safe as this is just going to iterate once.
        for(User objUser : [SELECT Id, Contactid FROM User
            WHERE Id =: UserInfo.getUserId()
            AND ContactId != null LIMIT 1] ){
            
            String loggedInContactId = objUser.ContactId;
            Set<String> cohortIds = new Set<String>();

            //fetch cohort-contact related to the logged in user
            For(Cohort_Contact__c cohortContact : [SELECT Id, Cohort__c FROM Cohort_Contact__c WHERE Contact__c =: loggedInContactId]){

                cohortIds.add(cohortContact.Cohort__c);
            }
            
            //fetch ventures FROM admitted ventures related to the cohorts
            Integer index = 0;

            for(Admitted_Venture__c objAdmittedVenture : [SELECT Id, Cohort__c, Cohort__r.Cohort_Name__c, Cohort__r.Stream__r.Name, 
                Cohort__r.CDL_Site__r.Name, Venture__c, Venture__r.Name, Venture__r.Description_Venture__c, Venture__r.Core_Technology__c,
                Venture__r.BillingState, Venture__r.BillingCountry, Venture__r.Technology_Area__c, Venture__r.Website,Venture__r.Related_Stream_s__c
                FROM Admitted_Venture__c 
                WHERE Cohort__c in: cohortIds
                AND Admitted_Venture_Status__c like 'Admitted%'
                ORDER BY Venture__c]){
                    
                ventureIds.add(objAdmittedVenture.Venture__c);
                
                SiteToStreamWrapper objSiteToStreamWrapper;
                String streamName = objAdmittedVenture.Cohort__r.Stream__r.Name;
                String siteName = objAdmittedVenture.Cohort__r.CDL_Site__r.Name;

                if(mapOfSiteToStreamToVentures.containsKey(siteName)){
                    
                    objSiteToStreamWrapper = mapOfSiteToStreamToVentures.get(siteName);

                    for(StreamSessionWrapper objStreamSessionWrapper : objSiteToStreamWrapper.streams) {

                        if(objStreamSessionWrapper.streamName == streamName) {

                            objStreamSessionWrapper.sessions.add(new AdmittedVentureWrapper(objAdmittedVenture.Cohort__r.Cohort_Name__c,
                                streamName,
                                objAdmittedVenture.Venture__c,
                                objAdmittedVenture.Venture__r.Name,
                                objAdmittedVenture.Venture__r.Description_Venture__c,
                                objAdmittedVenture.Venture__r.Core_Technology__c,
                                objAdmittedVenture.Venture__r.BillingState,
                                objAdmittedVenture.Venture__r.BillingCountry,
                                objAdmittedVenture.Venture__r.Technology_Area__c,
                                objAdmittedVenture.Venture__r.Website,
                                index));
                        }
                    }
                } else {

                    objSiteToStreamWrapper = new SiteToStreamWrapper(siteName);
                    StreamSessionWrapper objStreamSessionWrapper = new StreamSessionWrapper(streamName);
                    objStreamSessionWrapper.sessions.add(new AdmittedVentureWrapper(objAdmittedVenture.Cohort__r.Cohort_Name__c,
                        streamName,
                        objAdmittedVenture.Venture__c,
                        objAdmittedVenture.Venture__r.Name,
                        objAdmittedVenture.Venture__r.Description_Venture__c,
                        objAdmittedVenture.Venture__r.Core_Technology__c,
                        objAdmittedVenture.Venture__r.BillingState,
                        objAdmittedVenture.Venture__r.BillingCountry,
                        objAdmittedVenture.Venture__r.Technology_Area__c,
                        objAdmittedVenture.Venture__r.Website,
                        index));

                    objSiteToStreamWrapper.streams.add(objStreamSessionWrapper);
                }

                index += 1;

                mapOfSiteToStreamToVentures.put(siteName,objSiteToStreamWrapper);
            }
        }
        
        //fetch questionnaire for venture
        for(Partner_Questionnaire__c objPartnerQuestionnaire : [SELECT Account_Name__c, CommentsonventuresCDLSession__c,    IsVentureApplicabletoyourBusiness__c,
            Ifyespleaseexplainwhy__c, Wouldyouwantmoreinfo__c
            FROM Partner_Questionnaire__c
            WHERE Account_Name__c IN : ventureIds
            AND CreatedById =: UserInfo.getUserId()
            ORDER BY LastModifiedDate DESC]){
                                                                    
            mapVentureToPartnerQuestionaire.put(objPartnerQuestionnaire.Account_Name__c,objPartnerQuestionnaire);
        }

        for(SiteToStreamWrapper objSiteToStreamWrapper : mapOfSiteToStreamToVentures.values()) {

            for(StreamSessionWrapper objStreamSessionWrapper : objSiteToStreamWrapper.streams) {

                for(AdmittedVentureWrapper objAdmittedVentureWrapper : objStreamSessionWrapper.sessions) {
    
                    objAdmittedVentureWrapper.objPartnerQuestionaire = mapVentureToPartnerQuestionaire.get(objAdmittedVentureWrapper.VentureId);
                }
            }
        }

        return mapOfSiteToStreamToVentures.values();
    }
    
    @AuraEnabled
    public static  Partner_Questionnaire__c updatePartnerQuestion(Partner_Questionnaire__c partnerQuestion){
        
        if(partnerQuestion != null){

            upsert partnerQuestion Id;
        }
        
        return partnerQuestion;
    }
    
    public class SiteToStreamWrapper {

        @AuraEnabled
        public string siteName;
        @AuraEnabled
        public List<StreamSessionWrapper> streams;

        public SiteToStreamWrapper(String siteName) {

            this.siteName = siteName;
            this.streams = new List<StreamSessionWrapper>();
        }
    }

    public class StreamSessionWrapper {

        @AuraEnabled
        public string streamName;
        @AuraEnabled
        public List<AdmittedVentureWrapper> sessions;

        public StreamSessionWrapper(String streamName) {

            this.streamName = streamName;
            this.sessions = new List<AdmittedVentureWrapper>();
        }
    }
    
    public class AdmittedVentureWrapper{
        
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
        @AuraEnabled
        public Integer questionIndex;
        
        public AdmittedVentureWrapper(String CohortName, String CohortStream, String VentureId, String VentureName, String VentureDescription,
            String VentureCoreTechnology, String VentureBillingState, String VentureBillingCountry, String VentureTechnology_Area, String VentureWebsite,
            Integer questionIndex){
            
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
            this.questionIndex = questionIndex;
        }
    }
}