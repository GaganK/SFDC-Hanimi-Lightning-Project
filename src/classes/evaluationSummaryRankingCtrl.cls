public class evaluationSummaryRankingCtrl {
    @AuraEnabled
    public static List<Application__c> getAllApplications(List<string> selectedStreamPotential){
    List<Application__c> appList = new List<Application__c>();
    string loggedUserId = Userinfo.getUserId();
    System.debug('loggedUserId *****************'+loggedUserId );
               String query = 'Select Id,Name ,Avg_Score__c,Master_Ranking__c,Ranking__c,Avg_Score_Overall__c,Evaluator_1__r.Name,Evaluator_2__r.Name,Owner.Name,Evaluator_3__r.Name,Venture__r.Name,Initial_CDL_Site_Preference__c,Tech_Specialization__c,Evaluator_1_Score__c,Evaluator_2_Score__c,Evaluator_3_Score__c from Application__c where CreatedDate =LAST_N_DAYS:365 ';
                
               if(String.isNotBlank(loggedUserId)) {
                    query = query + '  AND OwnerId = \'' + loggedUserId + '\'';
                }
                if(!selectedStreamPotential.isEmpty()) {
                     query = query + ' AND Tech_Specialization__c  INCLUDES(';
                    for(String includeValue :selectedStreamPotential)
                        query += '\''+ includeValue + '\'' + ',';
                    query = query.removeEnd(',') +')'; 
                }
                 query = query + '  ORDER BY Avg_Score__c DESC LIMIT 2000 ';
                System.debug('query*****************'+query);

    appList = Database.query(query);
        return appList;
    }
    @AuraEnabled
    public static List < Application__c > updateApplication(List<Application__c> app ){
        update app;
        return app;
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
    
}