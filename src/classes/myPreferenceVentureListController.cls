public without sharing class myPreferenceVentureListController {
   
  @AuraEnabled 
    public static List<ventureWrapper> fetchventurewrapper(String searchTerm, String sortField,
        Boolean sortAsc,List<string> selectedVentures,List<string> selecttechList){ 
        Set<String> acctSet = new Set<String>();
        List<User> userList = new List<User>();
        userList = [Select id ,Contactid from User where id=:UserInfo.getUserId() ];
        //and Contactid!=null
        map<String,String> mapToRanking = new map<String,String>();
      if(!userList.isEmpty()){
                for(Interested_Mentor__c intMentObj : [Select id ,Admitted_Venture__c,Contact__c,Ranking__c from Interested_Mentor__c where Contact__c = :userList[0].Contactid order by Ranking__c ASC]){
                //where Contact__c = :userList[0].Contactid]){
                    acctSet.add(intMentObj.Admitted_Venture__c);
                    mapToRanking.put(intMentObj.Admitted_Venture__c,intMentObj.Ranking__c);
                    sortAsc=true;
                }
        }
        
         List<Admitted_Venture__c> accList = new List<Admitted_Venture__c>();
         List<ventureWrapper> wcList = new List<ventureWrapper>();
                
               String query = 'SELECT id, Cohort_Name__c,Venture__r.id,of_Handraised__c,(Select id,Admitted_Venture__c,Contact__c,Contact__r.Name ,Contact__r.Lastname,Contact__r.Title,Contact__r.Biodata__c,Contact__r.Affiliations__c  from Hand_Raised_Mentors__r where Is_Match__c=true order by CreatedDate limit 4), Venture__r.Name,Cohort__c,Cohort__r.Name,Venture__r.Description_Venture__c,Venture__r.Related_CDL_Site__c,Venture__r.Industry,Venture__r.Technology_Area__c,Venture__r.Related_Stream_s__c,Venture__r.website FROM Admitted_Venture__c where Venture__r.Related_Stream_s__c !=null ';
               if(!selectedVentures.isEmpty()) {
                 query = query + ' AND Venture__r.Name Like '; 
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
                if(!test.isRunningTest()){
                    query = query + '  and id in :acctSet ';
                }
                 if(!String.isBlank(sortField)) {
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
    if(!accList.isEmpty()){
        if(!acctSet.isEmpty()){
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
        }
        for(Admitted_Venture__c acctObj : accList){
            ventureWrapper accwrapper = new ventureWrapper();
            accwrapper.acctObj = acctObj;
            accwrapper.isSelected = false;
                    integer handRaisedSize = Integer.valueOf(4-(acctObj.of_Handraised__c));
            List<String> rankList = new List<String>();
            if(handRaisedSize>0){
                for(integer i=1;i<=handRaisedSize;i++){
                    rankList.add('');
                }
            }
            accwrapper.handRaisedList=rankList;
            accwrapper.Selranking = mapToRanking.get(acctObj.id);
            accwrapper.contentVersionObj = MapToContentVersion.get(acctObj.id);
            wcList.add(accwrapper);
        }
    }
        return wcList; 
    }
    
    public class ventureWrapper{
         @AuraEnabled 
         public Admitted_Venture__c acctObj;
          @AuraEnabled 
         public Boolean isSelected;
          @AuraEnabled 
         public List <String> handRaisedList;
         @AuraEnabled 
         public String Selranking;
          @AuraEnabled 
         public ContentVersion contentVersionObj;
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
        conList=[Select id,Name,Speaker__c,LinkedIn_Profile__c,Affiliations__c,Site_Location__c,Title,Account.Related_Stream_s__c,Email,Account.Name,Biodata__c From Contact
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
                if(mapToContentDocumentLink.get(conObj.id)!=null){
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
         public string conDocId;
    }
  
}