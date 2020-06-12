public class CDL_evaluationSummaryScoreCtrl {
    @AuraEnabled
    public static List<Application__c> getAllApplications(String searchTerm, List<String> selectedFilterApp,List<string> selectFirstsitepreference, List<String> selectedsecondsitepreference, String sortField, Boolean sortAsc,List<String> selectedVentures,List<String> selectedStreamPotentialList,List<String> selectreferal,List<String> selectfinalrank , List<String> selectinterviewRecommendation,List<String> selectstreamRecommendation,List<String> selecttechScreeningRecommendation,String currentselectedAppType){
    List<Application__c> appList = new List<Application__c>();
               String query = 'Select Id,Name,Evaluator_1__c,Evaluator_2__c,Evaluator_3__c,FinalRank__c,Team_Score__c,Team_Superstar_Potential_Score__c,Team_Tech_Review_Score__c,Team_Business_Review_Score__c,War_Comments__c,Team_Interview_Recommendations__c,Team_Stream_Recommendation__c,Team_Sub_Stream_Recommendation__c,TechScreening__c,(select id,CDL_Evaluator__r.Name,Evaluator_Name__c,CDL_Evaluator__c,Refer_to_Other_Site__c,Superstar_Potential__c,Tech_Review__c,Business_Review__c,Name,EvaluatorsRanking__c,Tech_Screening_Recommendation__c,Recommend_Interview_2__c,Stream_Recommendation__c from Evaluations__r ORDER BY Name DESC LIMIT 3),Venture__r.Name,Venture_Overview_Briefly_describe_your__c ,Cohort__r.Name,ShouldCDLInterviewthisVenture__c,Evaluator_1_Recommendation_Reasonsing__c,Evaluator_2_Recommendation_Reasonsing__c,X1st_Preference_CDL_Location__c,X2nd_Preference_CDL_Location__c,Evaluator_3_Recommendation_Reasonsing__c,Evaluator_1__r.Name,Avg_Score_Overall__c,Evaluator_2__r.Name,Owner.Name,Evaluator_3__r.Name,Application_Referral_Name__c,Application_Primary_Contact__r.LinkedIn_URL__c,Venture__c,Venture__r.Website,Venture__r.BillingStreet,Venture__r.BillingCity,Venture__r.BillingState,Venture__r.BillingCountry,Application_Primary_Contact__r.Firstname,Application_Primary_Contact__r.Lastname,Application_Primary_Contact__r.Email,Application_Primary_Contact__r.Phone,Initial_CDL_Site_Preference__c,Tech_Specialization__c,Evaluator_1_Score__c,Evaluator_2_Score__c,Evaluator_3_Score__c from Application__c where CreatedDate =LAST_N_DAYS:365 ';
                string loggedUserId = Userinfo.getUserId();
  
                if(currentselectedAppType == 'Self'){
                    //query = query + ' AND OwnerId = \'' + loggedUserId + '\'';
                    query = query + ' AND (Evaluator_1__c = \'' + loggedUserId + '\' OR Evaluator_2__c = \'' + loggedUserId + '\' OR Evaluator_3__c = \'' + loggedUserId + '\')';

                }
                if(!selectedFilterApp.isEmpty()) {
                   if(selectedFilterApp.size()==1){
                    query = query + ' AND Name Like ';
                        for(String includeValue :selectedFilterApp)
                            query += '\''+ includeValue + '\'' + ',';
                        query = query.removeEnd(',') ;
                   }else {
                        query += ' AND Name IN : selectedFilterApp ';
                   }
                     
                }
                if(!selectfinalrank.isEmpty()) {
                    query = query + ' AND (';
                    for(String includeValue :selectfinalrank){
                        query = query + '( FinalRank__c = ' + integer.valueOf(includeValue) + ')';
                        query += ' OR ';
                    }
                    query = query.removeEnd(' OR ') ;
                    query = query.removeEnd(',') ;
                     query += ' ) ';
                }
                system.debug('selectFirstsitepreference----->'+selectFirstsitepreference);
                if(!selectFirstsitepreference.isEmpty()) {
                   
                     query = query + ' AND X1st_Preference_CDL_Location__c  IN(';
                    for(String includeValue1 :selectFirstsitepreference)
                        query += '\''+ includeValue1 + '\'' + ',';
                    query = query.removeEnd(',') +')'; 
                }
                  if(!selectedVentures.isEmpty()) {
                    if(selectedVentures.size()==1){
                     query = query + ' AND Venture__r.Name Like '; 
                      for(String includeValue :selectedVentures)
                        query += '\''+ includeValue + '\'' + ',';
                    query = query.removeEnd(',') ;
                    }else {
                        query += ' AND Venture__r.Name IN : selectedVentures ';
                   }
                    
                }
                if(!selectedsecondsitepreference.isEmpty()) {
                   
                     query = query + ' AND X2nd_Preference_CDL_Location__c  IN(';
                    for(String includeValue :selectedsecondsitepreference)
                        query += '\''+ includeValue + '\'' + ',';
                    query = query.removeEnd(',') +')'; 
                }
                if(!selectreferal.isEmpty()) {
                    if(selectreferal.size()==1){
                     query = query + ' AND Application_Referral_Name__c Like '; 
                      for(String includeValue :selectreferal)
                        query += '\''+ includeValue + '\'' + ',';
                    query = query.removeEnd(',') ;
                    }else {
                        query += ' AND Application_Referral_Name__c IN : selectreferal ';
                   }
                    
                }
                if(!selectedStreamPotentialList.isEmpty()) {
                    
                     query = query + ' AND Tech_Specialization__c  INCLUDES(';
                    for(String includeValue :selectedStreamPotentialList)
                        query += '\''+ includeValue + '\'' + ',';
                    query = query.removeEnd(',') +')'; 
                }
        
                 /*if(!selecttechScreeningRecommendation.isEmpty()) {
                     query = query + ' AND TechScreening__c  IN :'+selecttechScreeningRecommendation; 
                 }*/
                if(!selecttechScreeningRecommendation.isEmpty()) {
                   
                     query = query + ' AND TechScreening__c  IN(';
                    for(String includeValue :selecttechScreeningRecommendation)
                        query += '\''+ includeValue + '\'' + ',';
                    query = query.removeEnd(',') +')'; 
                }
        
                 if(!String.isBlank(searchTerm)) {
                    query += ' AND ( ';
                    String tempSearchTerm = String.escapeSingleQuotes(searchTerm.trim());
                     Set<Id> appIds = getMatchingVentureOverview(tempSearchTerm);
                    searchTerm = '\'%' + tempSearchTerm + '%\'';
                    query += ' Name like ' + searchTerm + ' ';
                    query += ' OR X1st_Preference_CDL_Location__c like ' + searchTerm + ' ';
                    query += ' OR X2nd_Preference_CDL_Location__c like ' + searchTerm + ' ';
                    query += ' OR Venture__r.Name like ' + searchTerm + ' ';
                    query += ' OR Venture__r.Headquarters__c like ' + searchTerm + ' ';
                    query += ' OR Venture__r.Website like ' + searchTerm + ' ';
                    query += ' OR Application_Primary_Contact__r.Name like ' + searchTerm + ' ';
                     query += ' OR Evaluator_1__r.Name like ' + searchTerm + ' ';
                      query += ' OR Evaluator_2__r.Name like ' + searchTerm + ' ';
                       query += ' OR Evaluator_3__r.Name like ' + searchTerm + ' ';
                    query += ' OR Application_Primary_Contact__r.LinkedIn_Profile__c like ' + searchTerm + ' ';
                    if(!appIds.isEmpty()) {
                        query += ' OR Id IN : appIds ';
                    }       
                    query += ' ) ';
                }    
          if(!String.isBlank(sortField)) {
        query += ' order by ' + sortField + ' ';
    } 
    if(sortAsc) {
        query += ' ASC ';
    } else {
        query += ' DESC ';
    }
        query += ' NULLS LAST ';

                 //query = query + '  ORDER BY CreatedDate desc LIMIT 2000 ';
                System.debug('query*****************'+query);

    appList = Database.query(query);
        system.debug('====>'+JSON.serialize(appList));
        return appList;
    }
    
      @AuraEnabled
    public static Application__c updateApplication(Application__c appObj){
        System.debug('appObjList'+appObj);
        update appObj;
        return appObj;
    }
     // method for fetch picklist values dynamic  
    @AuraEnabled
    public static List < String > getselectOptions(sObject objObject, string fld) {
        system.debug('objObject --->' + objObject);
        system.debug('fld --->' + fld);
        List < String > allOpts = new list < String > ();
        // Get the object type of the SObject.
        Schema.sObjectType objType = objObject.getSObjectType();
        
        // Describe the SObject using its object type.
        Schema.DescribeSObjectResult objDescribe = objType.getDescribe();
        
        // Get a map of fields for the SObject
        map < String, Schema.SObjectField > fieldMap = objDescribe.fields.getMap();
        
        // Get the list of picklist values for this field.
        list < Schema.PicklistEntry > values =
            fieldMap.get(fld).getDescribe().getPickListValues();
        
        // Add these values to the selectoption list.
        for (Schema.PicklistEntry a: values) {
            allOpts.add(a.getValue());
        }
        system.debug('allOpts ---->' + allOpts);
        allOpts.sort();
        return allOpts;
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
    private static Set<Id> getMatchingVentureOverview(String searchTerm) {

        System.debug('## searchTerm : '+searchTerm);

        Set<Id> applicationIds = new Set<Id>();
        List<Application__c> lstApplication = [Select Id, Venture_Overview_Briefly_describe_your__c FROM Application__c];

        for(Application__c application : lstApplication) {
            
            if(!String.isBlank(application.Venture_Overview_Briefly_describe_your__c) && application.Venture_Overview_Briefly_describe_your__c.contains(searchTerm)) {

                applicationIds.add(application.Id);
            }
        }

        return applicationIds;
    }
     @AuraEnabled
    public static List < sObject > fetchLookUpValues(String searchKeyWord, String ObjectName) {
        system.debug('ObjectName-->' + ObjectName);
        String searchKey = searchKeyWord + '%';
        
        List < sObject > returnList = new List < sObject > ();
      
        // Create a Dynamic SOQL Query For Fetch Record List with LIMIT 5   
        String sQuery =  'select id, Name,FullPhotoUrl from ' +ObjectName + ' where Name LIKE: searchKey order by createdDate DESC limit 1000';
        List < sObject > lstOfRecords = Database.query(sQuery);
        
        for (sObject obj: lstOfRecords) {
            returnList.add(obj);
        }
        return returnList;
    }
     @AuraEnabled
    public static ContentVersion getApplicationURL(string applicationid){
        ContentVersion latestFile = new ContentVersion();
         list<ContentDocumentLink> lstCntLinks = new list<ContentDocumentLink>();
          Set<Id> setCntDocIds = new set<Id>();
        lstCntLinks = [Select id,LinkedEntityId,ContentDocumentId from ContentDocumentLink where LinkedEntityId=:applicationid];
        for(ContentDocumentLink clIterator : lstCntLinks) {
              setCntDocIds.add(clIterator.ContentDocumentId);
        }
         if(!setCntDocIds.isEmpty()) {
             for(ContentVersion conVerObj : [SELECT ContentDocumentId,Id,Title FROM ContentVersion WHERE ContentDocumentId IN :setCntDocIds order by lastmodifiedDate Desc limit 1]){
                latestFile = conVerObj;
            }
         }
         return latestFile;
    }
    @AuraEnabled
    public static List <String> getStreamPotential() {
        List<String> plValues = new List<String>();
         
        //Get the object type from object name. Here I've used custom object Book.
        Schema.SObjectType objType = Schema.getGlobalDescribe().get('Application__c');
         
        //Describe the sObject using its object type.
        Schema.DescribeSObjectResult objDescribe = objType.getDescribe();
         
        //Get the specific field information from field name. Here I've used custom field Genre__c of Book object.
        Schema.DescribeFieldResult objFieldInfo = objDescribe.fields.getMap().get('Tech_Specialization__c').getDescribe();
         
        //Get the picklist field values.
        List<Schema.PicklistEntry> picklistvalues = objFieldInfo.getPicklistValues();
         
        //Add the picklist values to list.
        for(Schema.PicklistEntry plv: picklistvalues) {
            plValues.add(plv.getValue());
        }
        plValues.sort();
        return plValues;
    }
}