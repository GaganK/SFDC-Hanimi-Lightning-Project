public  without sharing class speakersCtrl {

    @AuraEnabled
    public static List<SpeakerWrapper> getFetchSpeakerMap() {
        //..../partnerportal/profilephoto/005/F
        List<SpeakerWrapper> speakers = new List<SpeakerWrapper>();
        List<Contact> mentors = new List<Contact>([SELECT Id,Name,Speaker__c,LinkedIn_Profile__c,Title,
            Site_Location__c,Account.Related_Stream_s__c,Email,Account.Name,Account.Technology_Area__c,
            Biodata__c
            FROM Contact
            WHERE Speaker__c = true 
            order by Name,Speaker_Display_Order__c ASC limit 50000]);

         if(!mentors.isEmpty()){

            speakers = getSpeakerWrapper(mentors);
         }

         return speakers;
    }

    private static List<SpeakerWrapper> getSpeakerWrapper(List<Contact> mentors) {
        
        Map<Id, Id> mapOfContentDocIdToContact = new Map<Id, Id>();
        Map<Id,Id> mapOfContactIdToContentVersionId = new Map<Id, Id>();
        List<SpeakerWrapper> speakers = new List<SpeakerWrapper>();
        set<string> contactIds = new set<string>();

        for(Contact objContact : mentors) {

            contactIds.add(objContact.id);
        }
            
        if(!contactIds.isEmpty()){

            for(ContentDocumentLink conLink : [Select id,ContentDocumentId,LinkedEntityId from ContentDocumentLink where LinkedEntityId in : contactIds]){
                
                mapOfContentDocIdToContact.put(conLink.ContentDocumentId, conLink.LinkedEntityId);
            }
                    
            for(ContentVersion conVersion : [SELECT id,Title, VersionData, FileType, ContentUrl,ContentDocumentId,
                IsLatest
                FROM ContentVersion
                WHERE ContentDocumentId in : mapOfContentDocIdToContact.keySet()
                AND Title Like '%ProfilePicture%'
                AND IsLatest=true
                AND (FileType= 'PNG' OR FileType = 'JPEG' OR FileType = 'JPG')]) {
                    
                mapOfContactIdToContentVersionId.put(mapOfContentDocIdToContact.get(conVersion.ContentDocumentId), conVersion.Id);
            }
        }
            
        for(Contact objContact : mentors) {
            
            SpeakerWrapper spWrapper = new SpeakerWrapper();
            spWrapper.conObj = objContact;
                
            if(mapOfContactIdToContentVersionId.containsKey(objContact.Id)){
                
                spWrapper.profilePicURL = '/partners/sfc/servlet.shepherd/version/renditionDownload?rendition=THUMB720BY480&versionId='+mapOfContactIdToContentVersionId.get(objContact.Id);
            }
            
            speakers.add(spWrapper);
        }

        return speakers;
    }

    public class SpeakerWrapper{
        
        @AuraEnabled 
        public Contact conObj;
        @AuraEnabled 
        public string profilePicURL = '/partners/resource/DefaultSpeaker';
    }
}