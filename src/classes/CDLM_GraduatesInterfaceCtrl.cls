public without sharing  class CDLM_GraduatesInterfaceCtrl{
   @AuraEnabled 
    public static List<Admitted_Venture__c> fetchGraduatedVentures(List<string> selectedVentures, List<string> selectedTech,List<string> selectedLocation,String searchTerm,String sortField,Boolean sortAsc,String siteName, String streamName){ 
        List<Admitted_Venture__c> accList = new List<Admitted_Venture__c>();
                 String query ='';
                 string cohortYear = string.valueof(System.Today().year()-1) + '-' + string.valueof(System.Today().year());
                  string graduatedStatus = system.label.Graduated_Status + '%';  
                   query = 'SELECT id,Cohort_Name__c,Venture_Location__c,Venture__c,Cohort__r.Cohort_Name__c,Cohort_Stream__c,Cohort_CDL_Site__c,Venture__r.Related_CDL_Site__c,Venture__r.id,Cohort_Year__c,Venture__r.Name,Venture__r.Description_Venture__c,Venture__r.BillingState,Venture__r.BillingCountry,Venture__r.Related_Stream_s__c,Venture__r.Technology_Area__c,Venture__r.Website_Secure__c FROM Admitted_Venture__c where Admitted_Venture_Status__c like : graduatedStatus AND Cohort_Year__c =: cohortYear ';
                if(!String.isBlank(siteName) && siteName!='all') {
                     query += ' AND Venture__r.Related_CDL_Site__c INCLUDES (\'' + siteName + '\') ';
                }
                if(!String.isBlank(streamName)) {
                     query += ' AND Venture__r.Related_Stream_s__c INCLUDES (\'' + streamName + '\') ';
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
                if(!selectedLocation.isEmpty()) {
                    if(selectedLocation.size()==1){
                     query = query + ' AND Venture_Location__c Like '; 
                      for(String includeValue :selectedLocation)
                        query += '\''+ includeValue + '\'' + ',';
                    query = query.removeEnd(',') ;
                    }else {
                        query += ' AND Venture_Location__c IN : selectedLocation ';
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
                     query += ' OR Venture_Location__c like ' + searchTerm + ' ';
                    query += ' ) ';
                }
                    query += ' order by Venture__r.Name ';
                    if(sortAsc) {
                        query += ' ASC ';
                    } else {
                        query += ' DESC ';
                    }
                    query += ' NULLS LAST ';
        try{
            accList = Database.query(query);
        }
        catch (Exception e){
            system.debug(e.getmessage());
              system.debug(e.getlinenumber());
        }
        return accList;
    }
     @AuraEnabled
    public static List <String> getStreamList() {
        List<String> plValues = new List<String>();
      
         for(Stream__c plv: [Select id,Name from Stream__c where Active__c=true]) {
            plValues.add(plv.Name);
        }
        return plValues;
    }
     @AuraEnabled
    public static List <String> getSiteList() {
        List<String> plValues = new List<String>();
          for(CDL_Site__c plv: [Select id,Name from CDL_Site__c where Active__c=true]) {
            plValues.add(plv.Name);
        }
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