public without sharing class myMatchVentureListController {
   
  @AuraEnabled 
    public static List<ventureWrapper> fetchventurewrapper(String searchTerm, String sortField,
        Boolean sortAsc,List<string> selectedVentures,List<string> selecttechList,Boolean isDay1){ 
        Set<String> acctSet = new Set<String>();
        List<User> userList = new List<User>();
        userList = [Select id ,Contactid,Day_1_Stream__c,Day_2_Stream__c from User where id=:UserInfo.getUserId() ];
        map<String,String> mapToRanking = new map<String,String>();
      if(!userList.isEmpty()){
                for(Interested_Mentor__c intMentObj : [Select id ,Admitted_Venture__c,Contact__c,Ranking__c from Interested_Mentor__c where Contact__c = :userList[0].Contactid]){
                    mapToRanking.put(intMentObj.Admitted_Venture__c,intMentObj.Ranking__c);
                   // sortAsc=true;
                }
        }
         List<Admitted_Venture__c> accList = new List<Admitted_Venture__c>();
         List<ventureWrapper> wcList = new List<ventureWrapper>();
                 String query ='';
                   query = 'SELECT id,Cohort_Name__c,Venture__r.id,(Select id,Admitted_Venture__c,Registration__r.Contact__c,Registration__r.Contact__r.Name ,Registration__r.Session__r.Session_Type__c,Registration__r.Session__c from Hand_Raised_Mentors__r where Registration__r.Session__r.Session_Type__c !=null and Registration__r.Session__c!=null order by Registration__r.Session__r.Session_Type__c), Venture__r.Name,Venture__r.Description_Venture__c,Venture__r.Technology_Area__c,Venture__r.Related_Stream_s__c,Venture__r.website,Venture__r.Website_Secure__c FROM Admitted_Venture__c ';
                 if(isDay1){
                     string day1Stream = '\'' + userList[0].Day_1_Stream__c + '\'';
                      query = query + ' where Day_1_Stream__c!=null  AND Day_1_Stream__c ='+ day1Stream;
                 }else{
                      string day2Stream = '\'' + userList[0].Day_2_Stream__c + '\'';
                     query = query + ' where Day_2_Stream__c!=null AND Day_2_Stream__c ='+ day2Stream;
                 }
               if(!selectedVentures.isEmpty()) {
                 query = query + ' AND Cohort_Name__c Like '; 
                  for(String includeValue :selectedVentures)
                    query += '\''+ includeValue + '\'' + ',';
                query = query.removeEnd(',') ;
                
                }
                
                if(!selecttechList.isEmpty()) {
                     query = query + ' AND Venture__r.Technology_Area__c  IN(';
                    for(String includeValue :selecttechList)
                        query += '\''+ includeValue + '\'' + ',';
                    query = query.removeEnd(',') +')'; 
                }
                if(!String.isBlank(searchTerm)) {
                    String tempSearchTerm = String.escapeSingleQuotes(searchTerm.trim());
                    searchTerm = '\'%' + tempSearchTerm + '%\'';
                    query += ' AND ( ';
                    query += ' Venture__r.Name like ' + searchTerm + ' ';
                    query += ' OR Venture__r.Related_Stream_s__c INCLUDES (\'' + tempSearchTerm + '\') ';
                    query += ' OR Venture__r.Related_CDL_Site__c INCLUDES (\'' + tempSearchTerm + '\') ';
                    query += ' OR Cohort_Name__c like ' + searchTerm + ' ';
                    query += ' OR Venture__r.Technology_Area__c like ' + searchTerm + ' ';
                    query += ' ) ';
                }
                String ProgramYear = System.Today().year()-1+'-'+System.Today().year();
                 ProgramYear = '\'' + ProgramYear + '\'';
                String status = 'Active';
                status = '\'' + status + '\'';
                 String admittedStatus = 'Admitted';
                admittedStatus = '\'' + admittedStatus + '\'';
                if(!test.isRunningTest()){
                    query = query + '  and Cohort_Year__c =' + ProgramYear + ' and Cohort__r.Status__c='+ status +' and Admitted_Venture_Status__c Like '+ admittedStatus;
                }
                 if(!String.isBlank(sortField) && sortField != 'Ranking__c') {
                        query += ' order by ' + sortField + ' ';
                    } else {
                        query += ' order by Venture__r.Name ';
                    }
                    if(sortAsc) {
                        query += ' ASC ';
                    } else {
                        query += ' DESC ';
                    }
                    query += ' NULLS LAST ';
                System.debug('query*****************'+query);

    accList = Database.query(query);
     Map<String,ContentVersion> MapToContentVersion = new  Map<String,ContentVersion>();
     system.debug(sortField + 'sortfield==');
    if(!accList.isEmpty()){
        List<String> rankingList = new List<String>();
        Integer i = 1;
        for(Admitted_Venture__c admVenObj : accList){
            acctSet.add(admVenObj.id);
            rankingList.add(string.ValueOf(i++));
        }
        Set<Id> setCntDocIds = new set<Id>();
            Map<String, String> mapToLinkedId = new  Map<String, String>();
            for(ContentDocumentLink clIterator : [Select id,LinkedEntityId,ContentDocumentId from ContentDocumentLink where LinkedEntityId in :acctSet]) {
                  setCntDocIds.add(clIterator.ContentDocumentId);
                  mapToLinkedId.put(clIterator.ContentDocumentId,clIterator.LinkedEntityId);
            }
             if(!setCntDocIds.isEmpty()) {
                 for(ContentVersion conVerObj : [SELECT ContentDocumentId,Id,Title FROM ContentVersion WHERE ContentDocumentId IN :setCntDocIds order by lastmodifiedDate Desc limit 1]){
                    if(mapToLinkedId.ContainsKey(conVerObj.ContentDocumentId) && mapToLinkedId.get(conVerObj.ContentDocumentId)!=null)
                        MapToContentVersion.put(mapToLinkedId.get(conVerObj.ContentDocumentId),conVerObj);
                }
             }   
        for(Admitted_Venture__c acctObj : accList){
            ventureWrapper accwrapper = new ventureWrapper(); 
                accwrapper.acctObj = acctObj;
                accwrapper.SessionOneList = new List<Hand_Raised_Mentor__c>();
                accwrapper.SessionTwoList = new List<Hand_Raised_Mentor__c>();
                accwrapper.SessionThreeList = new List<Hand_Raised_Mentor__c>();
                accwrapper.SessionFourList = new List<Hand_Raised_Mentor__c>();
            if(acctObj.Hand_Raised_Mentors__r.size()>0){
               
                for(Hand_Raised_Mentor__c handRaised : acctObj.Hand_Raised_Mentors__r){
                    if(handRaised.Registration__r.Session__r.Session_Type__c!=null && handRaised.Registration__r.Session__r.Session_Type__c=='Session 1'){
                        accwrapper.SessionOneList.add(handRaised);
                    } else if(handRaised.Registration__r.Session__r.Session_Type__c!=null && handRaised.Registration__r.Session__r.Session_Type__c=='Session 2'){
                        accwrapper.SessionTwoList.add(handRaised);
                    }else if(handRaised.Registration__r.Session__r.Session_Type__c!=null && handRaised.Registration__r.Session__r.Session_Type__c=='Session 3'){
                        accwrapper.SessionThreeList.add(handRaised);
                    }else if(handRaised.Registration__r.Session__r.Session_Type__c!=null && handRaised.Registration__r.Session__r.Session_Type__c=='Session 4'){
                        accwrapper.SessionFourList.add(handRaised);
                    }
                }
            }
                accwrapper.rankingList = rankingList;
                accwrapper.isSelectedVal = mapToRanking.get(acctObj.id);
                accwrapper.previousSelVal = mapToRanking.get(acctObj.id);
                accwrapper.contentVersionObj = MapToContentVersion.get(acctObj.id);
                wcList.add(accwrapper);
        }
    } 
        if(sortField=='Ranking__c') {
                wcList.sort();
        }
        
        return wcList; 
    }
   @AuraEnabled 
    public static void saveAdmit(List<string> admitVentWrap){
          List<Interested_Mentor__c> delIntMentList = new List<Interested_Mentor__c>();
           List<User> userList = new List<User>();
       userList = [Select id ,Contactid from User where id=:UserInfo.getUserId() and Contactid!=null];
        Map<String,String> admitToMap = new Map<String,String>();
        List<Interested_Mentor__c> intMentList = new List<Interested_Mentor__c>();
        Set<String> admitVentSet = new Set<String>();
        Set<String> conidSet = new Set<String>();
       for(String admitVent: admitVentWrap){
            string admitVentId = admitVent.SubStringBefore('&&');
            string ranking = admitVent.substringAfter('&&');
            admitToMap.put(admitVentId,ranking);
            Interested_Mentor__c intMent = new Interested_Mentor__c();
            intMent.Admitted_Venture__c = admitVentId;
            intMent.Contact__c = userList[0].Contactid;
            intMent.Is_Match__c = true;
            intMent.Ranking__c = ranking;
            intMentList.add(intMent);
            admitVentSet.add(admitVentId);
            conidSet.add(intMent.Contact__c);
        }
        if(!intMentList.isEmpty()){
            delIntMentList = [Select id from Interested_Mentor__c where Contact__c in :conidSet];
           delete delIntMentList;
            insert intMentList;
        }
    }
    public class ventureWrapper implements Comparable{
         @AuraEnabled 
         public Admitted_Venture__c acctObj;
          @AuraEnabled 
         public String isSelectedVal;
          @AuraEnabled 
         public String previousSelVal;
         @AuraEnabled 
         public List <String> rankingList;
         @AuraEnabled 
         public ContentVersion contentVersionObj;
         @AuraEnabled 
         public List<Hand_Raised_Mentor__c> SessionOneList;
          @AuraEnabled 
         public List<Hand_Raised_Mentor__c> SessionTwoList;
          @AuraEnabled 
         public List<Hand_Raised_Mentor__c> SessionThreeList;
           @AuraEnabled 
         public List<Hand_Raised_Mentor__c> SessionFourList;
         
         Public Integer compareTo (Object compareTo) {
                ventureWrapper appwrap = (ventureWrapper)compareTo;
                Integer returnValue = 0;               
                If (integer.valueof(isSelectedVal) > integer.valueof(appwrap.isSelectedVal)) {
                    returnValue = 1;
                } else if (integer.valueof(isSelectedVal) < integer.valueof(appwrap.isSelectedVal)) {
                    returnValue = -1;
                } else if (integer.valueof(isSelectedVal) == integer.valueof(appwrap.isSelectedVal)) {
                    returnValue = 0;
                 }
               
                return returnValue; 

         }
    }
    @AuraEnabled
    public static List <String> getStreamList() {
        List<String> plValues = new List<String>();
        Schema.SObjectType objType = Schema.getGlobalDescribe().get('Account');
        Schema.DescribeSObjectResult objDescribe = objType.getDescribe();
        Schema.DescribeFieldResult objFieldInfo = objDescribe.fields.getMap().get('Related_Stream_s__c').getDescribe();
         
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
    public static List <String> getSiteList() {
        List<String> plValues = new List<String>();
        Schema.SObjectType objType = Schema.getGlobalDescribe().get('Account');
        Schema.DescribeSObjectResult objDescribe = objType.getDescribe();
        Schema.DescribeFieldResult objFieldInfo = objDescribe.fields.getMap().get('Related_CDL_Site__c').getDescribe();
         
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
    public static List <String> getRankingList() {
        List<String> plValues = new List<String>();
        Schema.SObjectType objType = Schema.getGlobalDescribe().get('Interested_Mentor__c');
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
    @AuraEnabled 
    public static List<conWrapper> fetchConInfowrapper(string conId){ 
        User userObj = new User();
        userObj = [SELECT Location__c, Id FROM User WHERE Id = : UserInfo.getUserId()];
        String speakerLocation = userObj.Location__c;
        List<Contact> conList = new List<Contact>();
        conList=[Select id,Name,Speaker__c,Speaker_Profile_Photo__c,Contact_Type__c,Site_and_Stream__c,LinkedIn_Profile__c,Affiliations__c,Site_Location__c,Title,Account.Related_Stream_s__c,Email,Account.Name,Biodata__c From Contact
                Where  id =:conId limit 1];
         List<conWrapper> wcList = new List<conWrapper>();
         if(!conList.isEmpty()){
            wcList = getconWrapper(conList);
         }
         system.debug(wcList);
         return wcList;
    }
        public static List<conWrapper> getconWrapper(List<Contact> conList){
         List<conWrapper> wcList = new List<conWrapper>();
             map<string,List<ContentVersion >> mapToContentVersion = new map<string,List<ContentVersion >>();
             map<string,List<ContentDocumentLink >> mapToContentDocumentLink = new map<string,List<ContentDocumentLink >>();
            set<string> conidsSet = new set<string>();
            for(Contact conObj :conList ){
                conidsSet.add(conObj.id);
            }
            if(!conidsSet.isEmpty()){
                 set<string> ContentDocumentIds = new set<string>();
                for(ContentDocumentLink conLink : [Select id,ContentDocumentId,LinkedEntityId from ContentDocumentLink where LinkedEntityId in : conidsSet]){
                        ContentDocumentIds.add(conLink.ContentDocumentId);
                        if(mapToContentDocumentLink.containsKey(conLink.LinkedEntityId)){
                            mapToContentDocumentLink.get(conLink.LinkedEntityId).add(conLink);
                        }else{
                            mapToContentDocumentLink.put(conLink.LinkedEntityId,new List<ContentDocumentLink>{conLink});
                        }
                    }
                for(ContentVersion conVersion : [Select id,VersionData, ContentUrl,ContentDocumentId,IsLatest from ContentVersion where ContentDocumentId in : ContentDocumentIds and IsLatest=true and Is_Speaker_Photo__c =true]){
                        if(mapToContentVersion.containsKey(conVersion.ContentDocumentId)){
                            mapToContentVersion.get(conVersion.ContentDocumentId).add(conVersion);
                        }else{
                            mapToContentVersion.put(conVersion.ContentDocumentId,new List<ContentVersion>{conVersion});
                        }
                    }
                    
            }
             for(Contact conObj : conList){
                conWrapper spWrapper = new conWrapper();
                spWrapper.conObj = conObj;
            if(String.isNotBlank(conObj.Biodata__c)){
                
                Integer intLength = (conObj.Biodata__c.length() > 290) ? 290 : conObj.Biodata__c.length();
                spWrapper.strShortBio = conObj.Biodata__c.substring(0,intLength);
            }
                if(mapToContentDocumentLink.get(conObj.id)!=null){
                   //  spWrapper.conDocId = String.valueOf((mapToContentDocumentLink.get(conObj.id)[0]).ContentDocumentId).substring(0, 15);
                    if(mapToContentVersion.get((mapToContentDocumentLink.get(conObj.id)[0]).ContentDocumentId)!=null){
                        spWrapper.conDocId = mapToContentVersion.get((mapToContentDocumentLink.get(conObj.id)[0]).ContentDocumentId)[0].id;
                        
                    }
                }else{
                    spWrapper.conDocId = '';
                }
                wcList.add(spWrapper);
            }
            system.debug('**********wcList*********'+wcList);
            return wcList;
    }
     public class conWrapper{
         @AuraEnabled 
         public Contact conObj;
          @AuraEnabled
        public String strShortBio;
          @AuraEnabled 
         public string conDocId;
    }
  
}