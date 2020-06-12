global class evaluationListController {

    @AuraEnabled(cacheable=true)
    global static List<Evaluation__c> getevaluations(string selectedInitialCDLSitePref, List<string> selectedStreamPotential,string appStage, string ownerId,Date selDate){
        List<Evaluation__c> evaList = new List<Evaluation__c>();
    /*  [SELECT
               Id, Name,Tech_Review__c,Business_Review__c,Superstar_Potential__c, Application__r.Name,Venture__c,Venture__r.Name,Overall_Score__c,Application__r.Avg_Score_Superstar_Potential__c
               FROM Evaluation__c where Application__r.Tech_Specialization__c=:selectedStreamPotential and Application__r.Initial_CDL_Site_Preference__c=:selectedInitialCDLSitePref ORDER BY Overall_Score__c desc LIMIT 2000];
               System.debug('evaList*****************'+evaList);*/
               String query = 'SELECT Id, Name,Tech_Review__c,Business_Review__c,Superstar_Potential__c, Application__r.Number_of_Co_Founders__c ,Application__r.Name,Venture__c,Venture__r.Name,Overall_Score__c,Application__r.Avg_Score_Superstar_Potential__c FROM Evaluation__c where ';
                if(selDate!=null) {
                system.debug('***********selDate*****'+selDate);
                Integer d = selDate.day();
                Integer mo = selDate.month();
                Integer yr = selDate.year();
                DateTime DT = DateTime.newInstance(yr, mo, d, 00, 00, 00);
                //String finalselDateTime = DateTime.valueOf(selDate).formatGmt('yyyy-MM-dd\'T\'HH:mm:ss.SSS\'Z\'');
                system.debug('***********finalselDateTime*****'+DT);
                    query = query + ' Application__r.CreatedDate >=:DT';
                    
                } else{
                    //date todayDate = system.today();
                    query = query + ' Application__r.CreatedDate =LAST_N_DAYS:365';
                }
                if(String.isNotBlank(selectedInitialCDLSitePref)) {
                    query = query + ' AND Application__r.Initial_CDL_Site_Preference__c = \'' + selectedInitialCDLSitePref + '\'';
                }
                if(!selectedStreamPotential.isEmpty()) {
                     query = query + ' AND Application__r.Tech_Specialization__c  INCLUDES(';
                    for(String includeValue :selectedStreamPotential)
                        query += '\''+ includeValue + '\'' + ',';
                    query = query.removeEnd(',') +')'; 
                }
                if(String.isNotBlank(appStage)) {
                    query = query + ' AND Application__r.Application_Stage__c = \'' + appStage + '\'';
                }
                if(String.isNotBlank(ownerId)) {
                    query = query + ' AND Application__r.OwnerId = \'' + ownerId + '\'';
                }
                 query = query + '  ORDER BY Overall_Score__c desc LIMIT 2000 ';
                System.debug('query*****************'+query);

    evaList = Database.query(query);
        return evaList;
    }
     @AuraEnabled(cacheable=true)
    global static List<Contact> getContacts(string applicationid){
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
    
     @AuraEnabled(cacheable=true)
    global static Map<String, integer> getAnalysisStats(string applicationId){
        Map<String, integer> analyStatsMap = new Map<String, integer>();
        Application__c appObj = new Application__c();
        appObj = [Select id,Number_of_Co_Founders__c from Application__c where id=:applicationId];
        AggregateResult[] groupedResults = [SELECT Application_Stage__c,COUNT(Number_of_Co_Founders__c) FROM Application__c where Number_of_Co_Founders__c =:appObj.Number_of_Co_Founders__c GROUP BY Application_Stage__c ];
        Integer admittedApp = 0;
        Integer totalApp = 0;
        for(AggregateResult ar : groupedResults){
            if(ar.get('Application_Stage__c')=='Admitted'){
                admittedApp = integer.valueOf(ar.get('expr0'));
                totalApp =totalApp+integer.valueOf(ar.get('expr0'));
            }else{
                totalApp =totalApp+integer.valueOf(ar.get('expr0'));
            }
        }
        analyStatsMap.put('TotalApps' , totalApp);
        analyStatsMap.put('admitted' , admittedApp);
        
        return analyStatsMap;
    } 
    @AuraEnabled //get Application Initial CDL Site Preference Picklist Values
    public static Map<String, String> getInitialCDLSitePref(){
        Map<String, String> options = new Map<String, String>();
        //get Application Initial CDL Site Preference Field Describe
        Schema.DescribeFieldResult fieldResult = Application__c.Initial_CDL_Site_Preference__c.getDescribe();
        //get Application Initial CDL Site Preference Picklist Values
        List<Schema.PicklistEntry> pList = fieldResult.getPicklistValues();
        for (Schema.PicklistEntry p: pList) {
            //Put Picklist Value & Label in Map
            options.put(p.getValue(), p.getLabel());
        }
        return options;
    }
    @AuraEnabled //get Application Stage Picklist Values
    public static Map<String, String> getApplicationStage(){
        Map<String, String> options = new Map<String, String>();
        //get Application Stage Field Describe
        Schema.DescribeFieldResult fieldResult = Application__c.Application_Stage__c.getDescribe();
        //get Application Stage Picklist Values
        List<Schema.PicklistEntry> pList = fieldResult.getPicklistValues();
        for (Schema.PicklistEntry p: pList) {
            //Put Picklist Value & Label in Map
            options.put(p.getValue(), p.getLabel());
        }
        return options;
    }
    @AuraEnabled //get Application Owner Picklist Values
    public static Map<String, String> getApplicationOwner(){
        Map<String, String> options = new Map<String, String>();
        for (User p: [SELECT Id,Name FROM User WHERE IsActive = true AND UserType = 'Standard']) {
            //Put Picklist Value & Label in Map
            options.put(p.Id, p.Name);
        }
        return options;
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