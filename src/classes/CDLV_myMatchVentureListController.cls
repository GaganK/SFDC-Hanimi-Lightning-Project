public class CDLV_myMatchVentureListController {
    @AuraEnabled 
    public static List<mentorWrapper> fetchmentorwrapper(String searchTerm, String sortField,
        Boolean sortAsc,List<string> selectedMentors,List<string> selectedIndustryArea,Boolean isDay1, List<String> selectedFilterCompany){ 
     
        List<User> userList = new List<User>();
        userList = [Select id ,Contactid,Contact.AccountId,Day_2_Stream__c from User where id=: UserInfo.getUserId() and contactid != null];
        //UserInfo.getUserId() and contactid != null];
        
         set<string> dayOneRoomSet = new set<string>();
          set<string> dayTwoRoomSet = new set<string>();
      if(!userList.isEmpty()){
            for(Admitted_Venture__c admVenObj : [Select id ,Venture__c,Day_1_Stream__c,Day_2_Stream__c from Admitted_Venture__c where Venture__c =:userList[0].Contact.AccountId]){
                dayOneRoomSet.add(admVenObj.Day_1_Stream__c);
                dayTwoRoomSet.add(admVenObj.Day_2_Stream__c);
            }
        }
        map<String,String> mapToRanking = new map<String,String>();
      if(!userList.isEmpty()){
                for(Venture_Mentor__c   intMentObj : [Select id ,Account__c,Contact__c,Ranking__c from Venture_Mentor__c where Account__c = :userList[0].Contact.accountid  order by Ranking__c ASC]){
                //where Contact__c = :userList[0].Contactid]){
                    mapToRanking.put(intMentObj.Contact__c,intMentObj.Ranking__c);
                    sortAsc=true;
                }
        }
         List<user> usrList = new List<user>();
         List<mentorWrapper> wcList = new List<mentorWrapper>();
                 String query ='';
                Id recTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByDeveloperName().get('Mentor_Contact').getRecordTypeId();
                                
               query = 'SELECT id,Contact.Name,Contact.Title,Contact.Account.Name,Contact.Account.Website,Contact.Biodata__c,Contact.Industry_Area_Focuses__c FROM User ';
               query = query + 'where Contact.RecordTypeId= \''+ recTypeId + '\'';
                if(isDay1){
                      query = query + ' and Day_1_Stream__c!=null  AND Day_1_Stream__c IN : dayOneRoomSet';
                 }else{
                      if(userList[0].Day_2_Stream__c != null) {
                          string day2Stream = '\'' + userList[0].Day_2_Stream__c + '\'';
                        // query = query + ' and Day_2_Stream__c!=null AND Day_2_Stream__c IN :'+ dayTwoRoomSet;
                         query = query + ' and Day_2_Stream__c!=null AND Day_2_Stream__c =' + day2Stream;
                     }
                 }
               if(!selectedMentors.isEmpty()) {
                 query = query + ' AND contact.Name Like '; 
                  for(String includeValue :selectedMentors)
                    query += '\''+ includeValue + '\'' + ',';
                query = query.removeEnd(',') ;
                
                }
            
                /******* Company ********/
                if(!selectedFilterCompany.isEmpty()) {
                   if(selectedFilterCompany.size()==1){
                    query = query + ' AND Contact.Account.Name Like ';
                        for(String includeValue :selectedFilterCompany)
                            query += '\''+ includeValue + '\'' + ',';
                        query = query.removeEnd(',') ;
                   }else {
                        query += ' AND Contact.Account.Name IN : selectedFilterCompany ';
                   }
                     
                }
                /************************/
                            
            
                if(!selectedIndustryArea.isEmpty()) {
                 query = query + ' AND Contact.Industry_Area_Focuses__c Like '; 
                  for(String includeValue :selectedIndustryArea)
                    query += '\''+ includeValue + '\'' + ',';
                query = query.removeEnd(',') ;
                
                }
                if(!String.isBlank(searchTerm)) {
                    String tempSearchTerm = String.escapeSingleQuotes(searchTerm.trim());
                    searchTerm = '\'%' + tempSearchTerm + '%\'';
                    query += ' AND ( ';
                    query += ' contact.Name like ' + searchTerm + ' ';
                    query += ' OR Contact.Industry_Area_Focuses__c like ' + searchTerm + ' ';
                    query += ' ) ';
                }
                if(!String.isBlank(sortField)) {
                        query += ' order by ' + sortField + ' ';
                    } else {
                        query += ' order by contact.Name ';
                    }
                    if(sortAsc) {
                        query += ' ASC ';
                    } else {
                        query += ' DESC ';
                    }
                    query += ' NULLS LAST ';
                System.debug('query Mentor portal*****************'+query);

    usrList = Database.query(query);
        if(!usrList.isEmpty()){
            List<String> rankingList = new List<String>();
            Integer i = 1;
            for(User userObj : usrList){
                rankingList.add(string.ValueOf(i++));
            }
            for(User userObj : usrList){
                mentorWrapper accwrapper = new mentorWrapper();
                accwrapper.userObj = userObj;
                accwrapper.rankingList = rankingList;
                accwrapper.isSelectedVal = mapToRanking.get(userObj.contactId);
                wcList.add(accwrapper);
            }
        }
            return wcList; 
    }
   @AuraEnabled 
    public static void saveAdmit(List<string> admitMentWrap){
      List<Venture_Mentor__c> delIntMentList = new List<Venture_Mentor__c>();
       List<User> userList = new List<User>();
       userList = [Select id ,Contactid,contact.accountid from User where id=:UserInfo.getUserId() and Contactid!=null];
        List<Venture_Mentor__c> intMentList = new List<Venture_Mentor__c>();
        Set<String> conidSet = new Set<String>();
       for(String admitMent: admitMentWrap){
            string admitMentContactId = admitMent.SubStringBefore('&&');
            string ranking = admitMent.substringAfter('&&');
            Venture_Mentor__c  intMent = new Venture_Mentor__c();
            intMent.Account__c = userList[0].contact.accountid;
            intMent.Contact__c = admitMentContactId;
            intMent.Ranking__c = ranking;
            intMentList.add(intMent);
            conidSet.add(intMent.Contact__c);
        }
        if(!intMentList.isEmpty()){
            delIntMentList = [Select id from Venture_Mentor__c where Contact__c in :conidSet];
           if(!test.isrunningtest()){
            delete delIntMentList;
            insert intMentList;
            }
        }
    }
    public class mentorWrapper{
         @AuraEnabled 
         public User userObj;
          @AuraEnabled 
         public String isSelectedVal;
         @AuraEnabled 
         public List <String> rankingList;
    }

    @AuraEnabled
    public static List <String> getRankingList() {
        List<String> plValues = new List<String>();
        Schema.SObjectType objType = Schema.getGlobalDescribe().get('Venture_Mentor__c');
        Schema.DescribeSObjectResult objDescribe = objType.getDescribe();
        Schema.DescribeFieldResult objFieldInfo = objDescribe.fields.getMap().get('Ranking__c').getDescribe();
         
        //Get the picklist field values.
        List<Schema.PicklistEntry> picklistvalues = objFieldInfo.getPicklistValues();
         
        //Add the picklist values to list.
        //plValues.add('--None--');
        for(Schema.PicklistEntry plv: picklistvalues) {
            plValues.add(plv.getValue());
        }
        plValues.sort();
        return plValues;
    }
}