public without sharing class CDL_MentorContactsController {

    public class MentorWrapper {
        
        @AuraEnabled
        public Contact objContact;
        @AuraEnabled
        public String strShortBio;
        @AuraEnabled
        public String strContactRoles;
        @AuraEnabled
        public String strPhotoURL;
        @AuraEnabled
        public List<String> lstHandVentures;
        @AuraEnabled
        public List<String> lstStreamVentures;
        @AuraEnabled
        public List<Integer> countHandVentures;
        @AuraEnabled
        public List<Integer> countStreamVentures;
        
        public MentorWrapper(){
            
            this.strPhotoURL = '/mentorportal/profilephoto/005/F';
            this.objContact = new Contact();
            this.strShortBio = '';
            this.strContactRoles = '';
            this.lstHandVentures = new List<String>();
            this.lstStreamVentures = new List<String>();
            this.countHandVentures = new List<Integer>();
            this.countStreamVentures = new List<Integer>();
        }
    }

    public class FilterWrapper {

        @AuraEnabled
        public List<ListItem> sites;
        @AuraEnabled
        public List<ListItem> streams;
        
        public FilterWrapper() {

            sites = new List<ListItem>();
            streams = new List<ListItem>();
        }
    }

    public class ListItem {

        @AuraEnabled
        public String label;
        @AuraEnabled
        public String value;

        public ListItem(String label, String value) {

            this.label = label;
            this.value = value;
        }
    }
    
    @AuraEnabled
    public static FilterWrapper fetchSitesAndStreamOptions() {

        FilterWrapper objFilterWrapper = new FilterWrapper();
        Map<Id,String> siteMap = new Map<Id,String>();
        Map<Id,String> streamMap = new Map<Id,String>();
        
        for(CDL_Site__c objSite : [SELECT Id,Name FROM CDL_Site__c WHERE Active__c = true order by Name]){
            
            objFilterWrapper.sites.add(new ListItem(objSite.Name, objSite.Name));
        }
        
        for(Stream__c objStream : [SELECT Id,Name FROM Stream__c WHERE Active__c = true order by Name]){
            
            objFilterWrapper.streams.add(new ListItem(objStream.Name, objStream.Name));
        }

        return objFilterWrapper;
    }

    @AuraEnabled
    public static List<MentorWrapper> fetchMentorContacts(String searchTerm,
                                                            List<String> filteredSites,
                                                            List<String> filteredStreams){
        
        List<MentorWrapper> lstMentorWrapper = new List<MentorWrapper>();
        List<Contact> filteredMentors = new List<Contact>();

        filteredMentors = filterMentors(searchTerm,filteredSites,filteredStreams);
        lstMentorWrapper = fetchStreamAndSiteDataForChart(filteredMentors);
        
        return lstMentorWrapper;
    }
        
    private static List<Contact> filterMentors(String searchTerm, List<String> filteredSites, List<String> filteredStreams) {
        
        List<Contact> lstContacts = new List<Contact>();
        Set<String> siteAndStreamNames = new Set<String>();
        Boolean hasFilteredSites = (filteredSites != null && !filteredSites.isEmpty());
        Boolean hasFilteredStream = (filteredStreams != null && !filteredStreams.isEmpty());

        String query = 'SELECT Id, Site_and_Stream__c, Speaker_Profile_Photo__c, Name, Title, Related_CDL_Site__c, Related_Stream_s__c, Industry_Area_Focuses__c, ' +
            ' Account.Name, Contact_Type__c, Biodata__c ' +
            ' FROM Contact ' +
            ' WHERE RecordTypeId = \'' + Schema.SObjectType.Contact.getRecordTypeInfosByDeveloperName().get('Mentor_Contact').getRecordTypeId() + '\' ' +
            ' AND Contact_Type__c INCLUDES (\'Fellow\',\'Associate\',\'Scientist\',\'Investigator\')';

        if(!String.isBlank(searchTerm)) {

            String tempSearchTerm = String.escapeSingleQuotes(searchTerm.trim());
            Set<Id> searchTermMentorIds = getMatchingMentorForAdditionalFilter(tempSearchTerm);
            searchTerm = '\'%' + tempSearchTerm + '%\'';

            query += ' AND ( ';
            query += ' Name like ' + searchTerm + ' ';
            query += ' OR Title like ' + searchTerm + ' ';
            query += ' OR Contact_Type__c INCLUDES (\'' + tempSearchTerm + '\') ';
            query += ' OR Account.Name like ' + searchTerm + ' ';
            query += ' OR Industry_Area_Focuses__c like ' + searchTerm + ' ';
            query += ' OR Id IN : searchTermMentorIds ';
            query += ' ) ';
        }

        if(hasFilteredSites || hasFilteredStream) {

            query += ' AND Site_and_Stream__c <> null ';

            if(hasFilteredSites != hasFilteredStream) {

                if(hasFilteredSites) {

                    siteAndStreamNames.addAll(filteredSites);
                }
        
                if(hasFilteredStream) {
                    
                    siteAndStreamNames.addAll(filteredStreams);
                }
            } else {

                query += ' AND Site_and_Stream__c INCLUDES ( ';
                Boolean hasMoreValue = false;

                for(String siteName : filteredSites) {

                    for(String streamName : filteredStreams) {

                        String val = SiteName + ': ' + streamName;
                        query += (hasMoreValue) ? ',\'' + val + '\'' : '\'' + val + '\'';
                        hasMoreValue = true;
                    }       
                }

                query += ' ) ';
            }
        }

        query += ' order by Name ';

        System.debug('## query : '+query);

        if(siteAndStreamNames.isEmpty()) {

            return Database.query(query);
        } else {

            for(Contact contact : Database.query(query)) {

                System.debug('## contact.Site_and_Stream__c : '+contact.Site_and_Stream__c);

                for(String siteAndStream : siteAndStreamNames) {

                    if(contact.Site_and_Stream__c.contains(siteAndStream)) {

                        lstContacts.add(contact);
                        break;
                    }
                }
            }
            
            return lstContacts;
        }
    }

    private static Set<Id> getMatchingMentorForAdditionalFilter(String searchTerm) {

        Set<Id> mentorIds = new Set<Id>();

        for(Contact mentor : [SELECT Id, Biodata__c
            FROM Contact
            WHERE RecordTypeId =: Schema.SObjectType.Contact.getRecordTypeInfosByDeveloperName().get('Mentor_Contact').getRecordTypeId()]) {
            
            if(!String.isBlank(mentor.Biodata__c) && mentor.Biodata__c.contains(searchTerm)) {

                mentorIds.add(mentor.Id);
            }
        }

        searchTerm = '%' + searchTerm + '%';
        
        for(Interested_Mentor__c objIM : [SELECT Contact__c
            FROM Interested_Mentor__c
            WHERE Contact__r.RecordTypeId =: Schema.SObjectType.Contact.getRecordTypeInfosByDeveloperName().get('Mentor_Contact').getRecordTypeId()
            AND (Admitted_Venture__r.Cohort__r.CDL_Site__r.Name like : searchTerm
            OR Admitted_Venture__r.Cohort__r.Stream__r.Name like : searchTerm)]) {

            mentorIds.add(objIM.Contact__c);
        }

        return mentorIds;
    }
    
    private static List<MentorWrapper> fetchStreamAndSiteDataForChart(List<Contact> lstContacts) {
        
        List<MentorWrapper> lstMentorWrapper = new List<MentorWrapper>();
        Map<String,Map<String,Set<String>>> mapMentorToStreamToVentureIds = new Map<String,Map<String,Set<String>>>();

        if(lstContacts.isEmpty()) return lstMentorWrapper;
        
        Map<String,MentorWrapper> mapMentorIdToMentorWrapper = new Map<String,MentorWrapper>();
        for(Contact objContact : lstContacts){
            
            MentorWrapper objMentorWrapper = new MentorWrapper();
            objMentorWrapper.objContact = objContact;
            if(!String.isBlank(objContact.Site_and_Stream__c)) {

                objContact.Site_and_Stream__c = objContact.Site_and_Stream__c.replaceAll(';',', ');
            }
            //fill short bio
            if(String.isNotBlank(objContact.Biodata__c)){
                
                Integer intLength = (objContact.Biodata__c.length() > 290) ? 290 : objContact.Biodata__c.length();
                objMentorWrapper.strShortBio = objContact.Biodata__c.substring(0,intLength);
            }
            
            //fill contact type
            if(String.isNotBlank(objContact.Contact_Type__c)){
                
                objMentorWrapper.strContactRoles = splitMultiselectValues(objContact.Contact_Type__c);
            }
            mapMentorIdToMentorWrapper.put(objContact.Id,objMentorWrapper); 
        }
        
        for(AggregateResult objHandsRecords : [SELECT Contact__c, Admitted_Venture__r.Venture__r.Name ventureName,count(Id) cnt
                                                    FROM Hand_Raised_Mentor__c WHERE Contact__c =: mapMentorIdToMentorWrapper.keySet()
                                                    GROUP BY Contact__c,Admitted_Venture__r.Venture__r.Name]){
                                                        
            MentorWrapper objMentorWrapper = new MentorWrapper();
            objMentorWrapper = mapMentorIdToMentorWrapper.get(String.valueOf(objHandsRecords.get('Contact__c')));
            objMentorWrapper.lstHandVentures.add(String.valueOf(objHandsRecords.get('ventureName')));
            objMentorWrapper.countHandVentures.add(Integer.valueOf(objHandsRecords.get('cnt')));
        }
        
        /*for(AggregateResult objStreamRecords : [SELECT Contact__c,Admitted_Venture__r.Cohort__r.Stream__r.Name streamName,count(Admitted_Venture__r.Venture__r.Name) cnt
                                                    FROM Hand_Raised_Mentor__c WHERE Contact__c =: mapMentorIdToMentorWrapper.keySet()
                                                    GROUP BY Contact__c,Admitted_Venture__r.Cohort__r.Stream__r.Name]){
                                                        
            MentorWrapper objMentorWrapper = new MentorWrapper();
            objMentorWrapper = mapMentorIdToMentorWrapper.get(String.valueOf(objStreamRecords.get('Contact__c')));
            objMentorWrapper.lstStreamVentures.add(String.valueOf(objStreamRecords.get('streamName')));
            objMentorWrapper.countStreamVentures.add(Integer.valueOf(objStreamRecords.get('cnt')));                                                
        }*/

        for(Hand_Raised_Mentor__c objHandRaised : [SELECT Id, Contact__c, Admitted_Venture__r.Cohort__r.Stream__r.Name, Admitted_Venture__r.Venture__c
            FROM Hand_Raised_Mentor__c
            WHERE Contact__c =: mapMentorIdToMentorWrapper.keySet()]) {

            Map<String,Set<String>> mapStreamToVentureId = new Map<String,Set<String>>();

            if(mapMentorToStreamToVentureIds.containsKey(objHandRaised.Contact__c)) {

                mapStreamToVentureId.putAll(mapMentorToStreamToVentureIds.get(objHandRaised.Contact__c));
            }
            
            if(mapStreamToVentureId.containsKey(objHandRaised.Admitted_Venture__r.Cohort__r.Stream__r.Name)) {

                mapStreamToVentureId.get(objHandRaised.Admitted_Venture__r.Cohort__r.Stream__r.Name).add(objHandRaised.Admitted_Venture__r.Venture__c);
            } else {

                Set<String> setVentureIds = new Set<String>();
                setVentureIds.add(objHandRaised.Admitted_Venture__r.Venture__c);
                mapStreamToVentureId.put(objHandRaised.Admitted_Venture__r.Cohort__r.Stream__r.Name,setVentureIds);
            }

            mapMentorToStreamToVentureIds.put(objHandRaised.Contact__c, mapStreamToVentureId);
        }

        for(String mentorId : mapMentorToStreamToVentureIds.keySet()) {

            MentorWrapper objMentorWrapper = new MentorWrapper();
            objMentorWrapper = mapMentorIdToMentorWrapper.get(mentorId);
            Map<String, Set<String>> mapStreamToVentureIds = mapMentorToStreamToVentureIds.get(mentorId);

            for(String streamName : mapStreamToVentureIds.keySet()) {

                objMentorWrapper.lstStreamVentures.add(streamName);
                objMentorWrapper.countStreamVentures.add(mapStreamToVentureIds.get(streamName).size());  
            }
        }
        
        for(ContentDocumentLink objCDL : [SELECT LinkedEntityId, ContentDocumentId, ContentDocument.LatestPublishedVersionId
            FROM ContentDocumentLink
            WHERE LinkedEntityId IN : mapMentorIdToMentorWrapper.keySet()
            AND Visibility = 'AllUsers'
            AND ContentDocument.Title like '%ProfilePicture%'
            AND (ContentDocument.FileType = 'JPEG' OR ContentDocument.FileType = 'PNG')]) {
            
            MentorWrapper objMentorWrapper = new MentorWrapper();
            objMentorWrapper = mapMentorIdToMentorWrapper.get(objCDL.LinkedEntityId); 
            objMentorWrapper.strPhotoURL = Site.getPathPrefix().replace('/s', '') + '/sfc/servlet.shepherd/document/download/' + objCDL.ContentDocumentId + '?operationContext=S1';
        }
        
        lstMentorWrapper.addAll(mapMentorIdToMentorWrapper.values());
        
        return lstMentorWrapper;
    }
    
    private static String splitMultiselectValues(String strMultiselectValues){
        
        String strFormattedValues = '';
        strFormattedValues = strMultiselectValues.replaceAll(';',', ');
        return strFormattedValues;
    }
}