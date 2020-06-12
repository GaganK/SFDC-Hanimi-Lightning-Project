/**
* Controller for displaying company information on mentor portal.
*
* @author Sachin Rathore
* @since 26/03/2020
*
*/
public class CompanyOverviewController {
    
    /**
*  Wrapper class to hold company information
*
* @author Sachin Rathore
* @since 26/03/2020
*
*/
    public class CompanyWrapper {
        
        /**Fileds to be displayed on the page**/
        @AuraEnabled
        public String site {get;set;}
        @AuraEnabled
        public String stream {get;set;}
        @AuraEnabled
        // Error meesage to be displayed on the Page
        public String message {get;set;}
        @AuraEnabled
        public Boolean isSuccess {get;set;}
        @AuraEnabled
        public Boolean isIndVal1 {get;set;}
        @AuraEnabled
        public Boolean isIndVal2 {get;set;}
        @AuraEnabled
        public Boolean isSiteVal {get;set;}
        @AuraEnabled
        public Boolean updateFlag {get;set;}
        @AuraEnabled
        public String externalURL {get;set;}
        @AuraEnabled
        public Boolean isTechVal1 {get;set;}
        @AuraEnabled
        public Boolean isTechVal2 {get;set;}
        @AuraEnabled
        public String description {get;set;}        
        @AuraEnabled
        public string companyName {get;set;}
        @AuraEnabled
        public Boolean isStreamVal {get;set;}
        @AuraEnabled
        public Boolean overviewFlag {get;set;}
        @AuraEnabled
        public Boolean pitchDeckFlag {get;set;}
        @AuraEnabled
        public String billingAddress {get;set;}
        @AuraEnabled
        public String companyWebsite {get;set;}
        @AuraEnabled
        public String updateContentId {get;set;}
        @AuraEnabled
        public String companyIndustry1 {get;set;}
        @AuraEnabled
        public String companyIndustry2 {get;set;}        
        @AuraEnabled
        public String overviewContentId {get;set;}
        @AuraEnabled
        public String pitchDeckContentId {get;set;}
        @AuraEnabled
        public String companyCoreTechnology1 {get;set;}
        @AuraEnabled
        public String companyCoreTechnology2 {get;set;}
        
        @AuraEnabled
        public String teamSize {get;set;}
        @AuraEnabled
        public String TeamDescription {get;set;}
        
        @AuraEnabled
        public Decimal amountRaising {get;set;}
        @AuraEnabled
        public Decimal amountCommitted {get;set;}
        @AuraEnabled
        public String terms {get;set;}
        @AuraEnabled
        public List<String> committedInvestors {get;set;}
        @AuraEnabled
        public List<String> cdlMembershipHands {get;set;}
        
        @AuraEnabled
        public String teamPhoto1 {get;set;}
        @AuraEnabled
        public String teamPhoto2 {get;set;}
        @AuraEnabled
        public String productPhotoURL {get;set;}
        @AuraEnabled
        public List<TeamWrapper> teams {get;set;}
        @AuraEnabled
        public Contact primaryContact {get;set;}
    }

    public class TeamWrapper {

        @AuraEnabled
        public String strPhotoURL;
        @AuraEnabled
        public Contact teamMember;

        public TeamWrapper(Contact teamMember) {

            this.strPhotoURL = '/mentorportal/profilephoto/005/F';
            this.teamMember = teamMember;
        }
    }
    
    /**
    * This method is being called when the companyinfomration page is loaded
    * Holds business logic
    * @author Sachin Rathore
    * @since 26/03/2020
    *
    */
    @AuraEnabled
    public static List<CompanyWrapper> getCompanyDetails(String recordId) {
        List<CompanyWrapper> wrapperList = null;
        CompanyWrapper wrapper = new CompanyWrapper();
        //Initializing the file flags
        wrapper.updateFlag = TRUE;
        wrapper.overviewFlag = TRUE;
        wrapper.pitchDeckFlag = TRUE;
        
        List<Admitted_Venture__c> admittedVentureList = [SELECT Venture__c,Venture__r.name,Venture__r.Website, Venture__r.BillingState,Venture__r.Core_Technology__c, 
                                                         Venture__r.BillingCountry, Venture__r.Description_Venture__c,Venture__r.Industry_Multi__c,  Cohort_Stream__c, 
                                                         Cohort_CDL_Site__c,Venture__r.Team_Size__c,Venture__r.Team_Description__c,
                                                         (SELECT Id,Contact__r.Name FROM Admitted_Venture_Contacts__r WHERE Contact__c != null),
                                                         (SELECT Id,Contact__r.Name FROM Hand_Raised_Mentors__r WHERE Contact__c != null)
                                                         FROM Admitted_Venture__c 
                                                         WHERE Id = :recordId ];
        
        
        
        if(admittedVentureList.isEmpty()) {
            wrapper.isSuccess = FALSE;
            wrapper.message = 'Record Not Found';
        } else {

            for(ContentDocumentLink applicationPDFFile : [SELECT ContentDocumentId, ContentDocument.LatestPublishedVersion.File_Type__c
                                                          FROM ContentDocumentLink
                                                          WHERE LinkedEntityId IN ( SELECT Id FROM Admitted_Venture__c WHERE Id = :recordId )
                                                          AND LinkedEntity.Type = 'Admitted_Venture__c'
                                                          AND (ContentDocument.FileType = 'PDF' OR ContentDocument.FileType = 'JPEG' OR ContentDocument.FileType = 'PNG')
                                                          order by ContentDocument.CreatedDate desc]) {
                if(applicationPDFFile != null) {

                    if(String.isNotBlank(applicationPDFFile.ContentDocumentId) && applicationPDFFile.ContentDocument.LatestPublishedVersion != null) {

                        wrapper.updateContentId =  String.isNotBlank(applicationPDFFile.ContentDocument.LatestPublishedVersion.File_Type__c) && applicationPDFFile.ContentDocument.LatestPublishedVersion.File_Type__c == 'Update' ? applicationPDFFile.ContentDocumentId : null;
                        wrapper.overviewContentId = String.isNotBlank(applicationPDFFile.ContentDocument.LatestPublishedVersion.File_Type__c) && applicationPDFFile.ContentDocument.LatestPublishedVersion.File_Type__c == 'Overview' ? applicationPDFFile.ContentDocumentId : null;
                        wrapper.pitchDeckContentId = String.isNotBlank(applicationPDFFile.ContentDocument.LatestPublishedVersion.File_Type__c) && applicationPDFFile.ContentDocument.LatestPublishedVersion.File_Type__c == 'Pitch Deck' ? applicationPDFFile.ContentDocumentId : null;
                        String productContentDocumentId = String.isNotBlank(applicationPDFFile.ContentDocument.LatestPublishedVersion.File_Type__c) && applicationPDFFile.ContentDocument.LatestPublishedVersion.File_Type__c == 'Product' ? applicationPDFFile.ContentDocumentId : null;

                        if(!String.isBlank(productContentDocumentId)) {

                            wrapper.productPhotoURL = Site.getPathPrefix().replace('/s', '') + '/sfc/servlet.shepherd/document/download/' + productContentDocumentId + '?operationContext=S1';
                        } else {

                            wrapper.productPhotoURL = '';
                        }
                        
                        wrapper.updateFlag = wrapper.updateContentId == null;
                        wrapper.overviewFlag = wrapper.overviewContentId == null;
                        wrapper.pitchDeckFlag = wrapper.pitchDeckContentId == null;
                    } 
                }
            }
            
            wrapper.billingAddress = '';
            if(String.isNotBlank(admittedVentureList[0].Venture__r.BillingState)&& String.isNotBlank(admittedVentureList[0].Venture__r.BillingCountry)) {
                wrapper.billingAddress = '('+admittedVentureList[0].Venture__r.BillingCountry+', ' +admittedVentureList[0].Venture__r.BillingState+')';
            }else if(String.isNotBlank(admittedVentureList[0].Venture__r.BillingState) && String.isBlank(admittedVentureList[0].Venture__r.BillingCountry)){
                wrapper.billingAddress = '('+admittedVentureList[0].Venture__r.BillingState+')';
            }else if(String.isBlank(admittedVentureList[0].Venture__r.BillingState) && String.isNotBlank(admittedVentureList[0].Venture__r.BillingCountry)){
                wrapper.billingAddress = '('+admittedVentureList[0].Venture__r.BillingCountry+')';
            }
            wrapper.externalURL = URL.getSalesforceBaseUrl().toExternalForm();
            wrapper.isSuccess = TRUE;
            wrapper.companyName = admittedVentureList[0].Venture__r.name;
            wrapper.description = admittedVentureList[0].Venture__r.Description_Venture__c;
            wrapper.stream = admittedVentureList[0].Cohort_Stream__c;
            wrapper.site = admittedVentureList[0].Cohort_CDL_Site__c;
            wrapper.companyWebsite = admittedVentureList[0].Venture__r.Website;
            wrapper.isSiteVal = String.isNotEmpty(wrapper.site);
            wrapper.isStreamVal = String.isNotEmpty(wrapper.stream);
            if(String.isNotEmpty(admittedVentureList[0].Venture__r.Industry_Multi__c))
            {
                String tempString = admittedVentureList[0].Venture__r.Industry_Multi__c;
                List<String> stringList = new List<String>(); 
                stringList.addAll(tempString.split(';'));
                Integer listSize = stringList.size();
                if(listSize > 0)
                {
                    wrapper.companyIndustry1 = stringList[0];
                    wrapper.isIndVal1 = String.isNotEmpty(stringList[0]);
                    if(listSize > 1) {
                        wrapper.companyIndustry2 = stringList[1];
                        wrapper.isIndVal2 =  String.isNotEmpty(stringList[1]);
                    }else{
                        wrapper.isIndVal2 = false;
                    }
                }
            }
            if(String.isNotEmpty(admittedVentureList[0].Venture__r.Core_Technology__c))
            {
                String tempString = admittedVentureList[0].Venture__r.Core_Technology__c;
                List<String> stringList = new List<String>(); 
                stringList.addAll(tempString.split(';'));
                Integer listSize = stringList.size();
                if(listSize > 0)
                {
                    wrapper.companyCoreTechnology1 = stringList[0];
                    wrapper.isTechVal1 = String.isNotEmpty(stringList[0]);
                    if(listSize > 1) {
                        wrapper.companyCoreTechnology2 = stringList[1];
                        wrapper.isTechVal2 = String.isNotEmpty(stringList[1]);
                    }else{
                        wrapper.isTechVal2 = false;
                    }
                    
                }
            }
        }
        
        wrapper.teamSize = admittedVentureList[0].Venture__r.Team_Size__c;
        wrapper.teamDescription = admittedVentureList[0].Venture__r.Team_Description__c;
        
        if(admittedVentureList[0].Venture__c != null) {

            for(FinancingEvent__c event : [SELECT Id,Amount_Being_Raised__c,Amount_Currently_Committed__c,Terms_convertible_note__c 
                                           FROM FinancingEvent__c 
                                           WHERE Venture_Name__c=:admittedVentureList[0].Venture__c 
                                           AND Status__c = 'Open' 
                                           ORDER BY CreatedDate DESC 
                                           LIMIT 1]) {

                wrapper.amountRaising = event.Amount_Being_Raised__c;
                wrapper.amountCommitted = event.Amount_Currently_Committed__c;
                wrapper.terms = event.Terms_convertible_note__c;
            }
        }
        
        if(admittedVentureList[0].Admitted_Venture_Contacts__r != null) {
            wrapper.committedInvestors = new List<String>();
            for(Admitted_Venture_Contact__c ventureContact : admittedVentureList[0].Admitted_Venture_Contacts__r) 
            {
                wrapper.committedInvestors.add(ventureContact.Contact__r.Name);
            }
        }
        
        if(admittedVentureList[0].Hand_Raised_Mentors__r != null) {
            wrapper.cdlMembershipHands = new List<String>();
            for(Hand_Raised_Mentor__c hrm : admittedVentureList[0].Hand_Raised_Mentors__r) 
            {
                wrapper.cdlMembershipHands.add(hrm.Contact__r.Name);
            }
        }

        Map<Id, TeamWrapper> mapContactIdToTeam = new Map<Id, TeamWrapper>();

        for(Contact objTeamMember : [SELECT Id, Name, Email, LinkedIn_URL__c
            FROM Contact
            WHERE AccountId =: admittedVentureList[0].Venture__c
            AND (Primary_Contact__c = true OR Is_Primary_Application_Contact__c = true)
            limit 2]) {

            mapContactIdToTeam.put(objTeamMember.Id, new TeamWrapper(objTeamMember));

            if(wrapper.primaryContact == null) {

                wrapper.primaryContact = objTeamMember;
            }
        }

        for(ContentDocumentLink objCDL : [SELECT LinkedEntityId, ContentDocumentId, ContentDocument.LatestPublishedVersionId
            FROM ContentDocumentLink
            WHERE LinkedEntityId IN : mapContactIdToTeam.keySet()
            AND Visibility = 'AllUsers'
            AND ContentDocument.Title like '%ProfilePicture%'
            AND (ContentDocument.FileType = 'JPEG' OR ContentDocument.FileType = 'PNG')]) {
            
                TeamWrapper objTeamWrapper = mapContactIdToTeam.get(objCDL.LinkedEntityId);
                objTeamWrapper.strPhotoURL = Site.getPathPrefix().replace('/s', '') + '/sfc/servlet.shepherd/document/download/' + objCDL.ContentDocumentId + '?operationContext=S1';
                mapContactIdToTeam.put(objCDL.LinkedEntityId, objTeamWrapper);
        }
        
        wrapper.teams = new List<TeamWrapper>();
        wrapper.teams.addAll(mapContactIdToTeam.values());

        if(wrapper.primaryContact == null) {

            wrapper.primaryContact = new Contact();
        }
        
        wrapper.teamPhoto1 ='';
        wrapper.teamPhoto2 ='';
        //wrapper.productPhotoURL ='';
        
       
        /*
        AMount Raising - From Account &gt; Financial Event Object w Status = Open&gt; Amount_Being_Raised__c
        Amount Committed - From Account &gt; Financial Event Object w Status = Open &gt; 
        Terms - rom Account &gt; Financial Event Object w Status = Open&gt; 
        CDL Membership Hands – Admitted Venture &gt; Commitments -&gt; Contact lookup

        2
        On Content Document/Content Version
        File Type [Primary Contact, Product]
        */
        wrapperList = new List<CompanyWrapper>();
        wrapperList.add(wrapper);
        
        return wrapperList;
    }
    
}