public without sharing  class  CDLM_RecoverInterfaceCtrl {
    
    @AuraEnabled 
    public static List<Admitted_Venture__c> fetchGraduatedVentures(List<string> selectedVentures, List<string> selectedTech,String searchTerm,String sortField,Boolean sortAsc,String tabName){ 
        
        String userContactID = [SELECT Id,ContactId FROM User WHERE Id=:UserInfo.getUserId() LIMIT 1].ContactId;
        
        Set<String> sessionIds = new Set<String>();
        for(Session_Attendee__c mentorRegistration : [SELECT Id,
                                                      Session__c
                                                      FROM Session_Attendee__c 
                                                      WHERE Contact__c =:userContactID 
                                                     ])
        {
            sessionIds.add(mentorRegistration.Session__c);
        }
    
        Set<String> ventureIdSet = new Set<String>();
        String cohortQuery = 'SELECT Id,Session__r.Cohort__c,Admitted_Venture_Raised_For__c,Session__r.Session_Start__c FROM Session_Attendee__c WHERE Session__c =:sessionIds AND Session__r.Cohort__r.Stream__r.Active__c = True ';
        if(!String.isBlank(tabName)) {
            if(tabName == 'Latest Intake') {
            }
            else if(tabName == 'Public Health') {
                cohortQuery += ' AND Session__r.Cohort__r.Stream__r.Name = \'Public Health\' ';
            }
            else if(tabName == 'Economic Recovery') {
                cohortQuery += ' AND Session__r.Cohort__r.Stream__r.Name = \'Economic Recovery\' ';
            }
        }
		cohortQuery += ' ORDER BY Session__r.Session_Start__c DESC LIMIT 2 ';
        DateTime latestSessionStartTime;
        for(Session_Attendee__c sessionAttendee: Database.query(cohortQuery)) {
            if(latestSessionStartTime == null) {
                latestSessionStartTime = sessionAttendee.Session__r.Session_Start__c;
                ventureIdSet.add(sessionAttendee.Admitted_Venture_Raised_For__c);
            } else {
                if(latestSessionStartTime.day() == sessionAttendee.Session__r.Session_Start__c.day() &&
                  latestSessionStartTime.month() == sessionAttendee.Session__r.Session_Start__c.month()  &&
                  latestSessionStartTime.year() == sessionAttendee.Session__r.Session_Start__c.year()
                  ) {
                    ventureIdSet.add(sessionAttendee.Admitted_Venture_Raised_For__c);
                }
            }
        }
                
        List<Admitted_Venture__c> accList = new List<Admitted_Venture__c>();
        String query ='';
        query = 'SELECT id,Cohort_Name__c,Venture__c,Cohort__r.Cohort_Name__c,Cohort_Stream__c,Cohort_CDL_Site__c,Venture__r.Related_CDL_Site__c,Venture__r.id,Cohort_Year__c,Venture__r.Name,Venture__r.Description_Venture__c,Venture__r.BillingState,Venture__r.BillingCountry,Venture__r.Related_Stream_s__c,Venture__r.Technology_Area__c,Venture__r.Website_Secure__c';
        query += ' FROM Admitted_Venture__c where Id IN:ventureIdSet ';

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
        if(!selectedTech.isEmpty()) {
            if(selectedTech.size()==1){
                query = query + ' AND Venture__r.Technology_Area__c Like '; 
                for(String includeValue :selectedTech)
                    query += '\''+ includeValue + '\'' + ',';
                query = query.removeEnd(',') ;
            }else {
                query += ' AND Venture__r.Technology_Area__c IN : selectedTech ';
            }   
        }
        if(!String.isBlank(searchTerm)) {
            String tempSearchTerm = String.escapeSingleQuotes(searchTerm.trim());
            searchTerm = '\'%' + tempSearchTerm + '%\'';
            query += ' AND ( ';
            query += ' Venture__r.Name like ' + searchTerm + ' ';
            query += ' OR Venture__r.Related_CDL_Site__c INCLUDES (\'' + tempSearchTerm + '\') ';
            query += ' OR Venture__r.Related_Stream_s__c INCLUDES (\'' + tempSearchTerm + '\') ';
            query += ' OR Cohort__r.Cohort_Name__c like ' + searchTerm + ' ';
            query += ' OR Venture__r.Technology_Area__c like ' + searchTerm + ' ';
            query += ' OR Venture__r.BillingState like ' + searchTerm + ' ';
            query += ' OR Venture__r.BillingCountry like ' + searchTerm + ' ';
            query += ' ) ';
        }
        query += ' order by CreatedDate,Venture__r.Name ';
        if(sortAsc) {
            query += ' ASC ';
        } else {
            query += ' DESC ';
        }
        query += ' NULLS LAST ';
        try{
            accList = Database.query(query);
            //Check if same date and latest
            
        }
        catch (Exception e){
            system.debug(e.getmessage());
            system.debug(e.getlinenumber());
        }
        return accList;
    }
    
    @AuraEnabled
    public static List <String> getTabList() {
        List<String> plValues = new List<String>();
        plValues.add('Latest Intake');
        plValues.add('Public Health');
        plValues.add('Economic Recovery');
        return plValues;
    }
    
    @AuraEnabled
    public static List <String> getStreamList(String Stream) {
        
        String userContactID = [SELECT Id,ContactId FROM User WHERE Id=:UserInfo.getUserId() LIMIT 1].ContactId;
        Set<String> plValuesSet = new Set<String>();
        for(Session_Attendee__c sessionAttendee: [SELECT Id,Session__r.Cohort__r.Stream__r.Name FROM Session_Attendee__c WHERE Contact__c =:userContactID AND Session__r.Cohort__r.Stream__r.Active__c = True]) {
       		plValuesSet.add(sessionAttendee.Session__r.Cohort__r.Stream__r.Name);
        }
        List<String> plValues = new List<String>(plValuesSet);
        plValues.sort();
        return plValues;
    }
    
    @AuraEnabled
    public static string sendEmail(String selAdminventId, String Subject, String Message){
        String sMessage='';
        List<Contact> conList = new List<Contact>();
        conList = [Select id,Accountid,Email from Contact where Accountid=:selAdminventId and Primary_Contact__c=true and email!=null limit 1];
        if(!conList.isEmpty()){
            String email=conList[0].Email;
            try{
                Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                String[] toAddresses = new String[] {email}; 
                    mail.setToAddresses(toAddresses);
                mail.setSubject(Subject);
                mail.setHtmlBody(Message);
                mail.setTargetObjectId(conList[0].id);
                mail.setSaveAsActivity(true);
                String currentUserEmail = UserInfo.getUserEmail();
                String[] ccAddresses = new String[] {currentUserEmail};
                    mail.setccAddresses(ccAddresses);
                Messaging.SendEmailResult [] results = Messaging.sendEmail(new Messaging.SingleEmailMessage[] {mail});
                sMessage='Success';
            }
            catch(Exception ex){
                sMessage=ex.getLineNumber()+'\n'+ex.getCause()+'\n'+ex.getMessage()+'\n'+ex.getStackTraceString();
            }
        }
        return sMessage;
    }
}