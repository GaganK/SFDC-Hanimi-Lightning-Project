/**
 * Name: CrossSiteMatchingAndFinalInterviewCtrl
 * Created By: Nishant Sharma
 * Description: Apex class for Cross Site Matching and Scheduling final interview component.
 */
public class CrossSiteMatchingAndFinalInterviewCtrl {

    /**
     * Description: Wrapper class to share result of update operation.
     */
    public class UpdateInfoWrapper {

        @AuraEnabled
        public boolean isSuccess;
        @AuraEnabled
        public string message;

        public UpdateInfoWrapper(Boolean isSuccess, String message) {

            this.isSuccess = isSuccess;
            this.message = message;
        }
    }

    /**
     * Description: Wrapper class to consolidate all filters applicable on page 4.
     */
    public class FilterWrapper {

        @AuraEnabled
        public List<ListItem> firstSitePreferances;
        @AuraEnabled
        public List<ListItem> secondSitePreferances;
        @AuraEnabled
        public List<ListItem> allVentures;
        @AuraEnabled
        public List<ListItem> allApplicationNumbers;
        @AuraEnabled
        public List<ListItem> allVentureHeadQuarters;
        @AuraEnabled
        public List<ListItem> teamStreamRecommendations;
        @AuraEnabled
        public List<ListItem> teamInterviewDecisions;
        @AuraEnabled
        public List<ListItem> recommendedByFirstSitePreferences;
        @AuraEnabled
        public List<ListItem> crossSiteMatchings;
        @AuraEnabled
        public List<ListItem> allInterviewStatus;
        @AuraEnabled
        public List<ListItem> leadInterviewers;
        @AuraEnabled
        public List<ListItem> guestInterviewers;
        @AuraEnabled
        public List<ListItem> primaryContacts;
        @AuraEnabled
        public List<ListItem> interviewMadalities;
        @AuraEnabled
        public List<ListItem> interviewTimeZones;

        public FilterWrapper() {

            firstSitePreferances = new List<ListItem>();
            secondSitePreferances = new List<ListItem>();
            allVentures = new List<ListItem>();
            allApplicationNumbers = new List<ListItem>();
            allVentureHeadQuarters = new List<ListItem>();
            teamStreamRecommendations = new List<ListItem>();
            teamInterviewDecisions = new List<ListItem>();
            recommendedByFirstSitePreferences = new List<ListItem>();
            crossSiteMatchings = new List<ListItem>();
            allInterviewStatus = new List<ListItem>();
            leadInterviewers = new List<ListItem>();
            guestInterviewers = new List<ListItem>();
            primaryContacts = new List<ListItem>();
            interviewMadalities = new List<ListItem>();
            interviewTimeZones = new List<ListItem>();
        }
    }

    /**
     * Description: Wrapper class to hold value label pair. Being utilized in FilterWrapper wrapper class.
     */
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

    /**
     * Description: wrapper class for application record
     */
    public class ApplicationWrapper {

        @AuraEnabled
        public Application__c objApplication;
        @AuraEnabled
        public User leadInterviewer;
        @AuraEnabled
        public User guestInterviewer;
        @AuraEnabled
        public boolean hasFile;
        @AuraEnabled
        public ContentDocumentLink applicationPDFFile;

        public ApplicationWrapper(Application__c application, User leadInterviewer, User guestInterviewer) {

            this.objApplication = application;
            this.leadInterviewer = leadInterviewer;
            this.guestInterviewer = guestInterviewer;
            this.hasFile = false;
            this.applicationPDFFile = new ContentDocumentLink();
        }
    }

    /**
     * Description: method to dynamically frame the query and fetch application data
     */
    @AuraEnabled
    public static List<ApplicationWrapper> getApplications(String searchTerm,
        List<String> filteredFirstSitePreference,
        List<String> filteredSecondSitePreference,
        List<String> filteredApplicationNumbers,
        List<String> filteredVentures,
        List<String> filteredVentureHeadQuarters,
        List<String> filteredTeamStreamRecommendations,
        List<String> filteredTeamInterviewDecisions,
        List<String> filteredRecommendedByFirstSitePreferences,
        List<String> filteredCrossSiteMatchings,
        List<String> filteredInterviewStatus,
        List<String> filteredLeadInterviewers,
        List<String> filteredGuestInterviewers,
        List<String> filteredPrimaryContacts,
        List<String> filteredInterviewMadalities,
        List<String> filteredInterviewTimeZones,
        String sortField,
        Boolean sortAsc) {
        
        List<Id> lstApplicationIds = new List<Id>();
        Set<Id> applicationIds = new Set<Id>();
        List<ApplicationWrapper> lstApplications = new List<ApplicationWrapper>();
        Map<Id,ApplicationWrapper> mapApplicationIdToWrapper = new Map<Id,ApplicationWrapper>();

        String query = 'Select Id, Name, X1st_Preference_CDL_Location__c, X2nd_Preference_CDL_Location__c, ' +
            'Venture__c, Venture__r.Id, Venture__r.Name, Venture__r.Headquarters__c, Venture__r.Website, ' +
            'Team_Stream_Recommendation__c, Team_Interview_Decision__c, Recommended_by_First_Site_Preference_for__c, ' +
            'Cross_Site_Matching__c, Interview_Status__c, Interview_Date_Time__c, Interview_Timezone__c, Interview_Modality__c,' +
            'Lead_Interviewer__c, Lead_Interviewer__r.Id, Lead_Interviewer__r.Name, Lead_Interviewer__r.FullPhotoUrl, ' +
            'Guest_Interviewer__c, Guest_Interviewer__r.Id, Guest_Interviewer__r.Name, Guest_Interviewer__r.FullPhotoUrl, ' +
            'Application_Primary_Contact__c, Application_Primary_Contact__r.Name, Application_Primary_Contact__r.Email, Application_Primary_Contact__r.Phone, ' + 
            'Room_Hangouts_Link__c, Post_Interview_Email_Sent__c ' +
            'FROM Application__c ' + 
            'WHERE Id != null ';

        // filter is user provide any search term
        if(!String.isBlank(searchTerm)) {

            String tempSearchTerm = String.escapeSingleQuotes(searchTerm.trim());
            searchTerm = '\'%' + tempSearchTerm + '%\'';

            query += ' AND ( ';
            query += ' Name like ' + searchTerm + ' ';
            query += ' OR X1st_Preference_CDL_Location__c like ' + searchTerm + ' ';
            query += ' OR X2nd_Preference_CDL_Location__c like ' + searchTerm + ' ';
            query += ' OR Venture__r.Name like ' + searchTerm + ' ';
            query += ' OR Venture__r.Headquarters__c like ' + searchTerm + ' ';
            query += ' OR Application_Primary_Contact__r.Name like ' + searchTerm + ' ';
            query += ' OR Application_Primary_Contact__r.Email like ' + searchTerm + ' ';
            query += ' OR Application_Primary_Contact__r.Phone like ' + searchTerm + ' ';
            query += ' OR Team_Stream_Recommendation__c like ' + searchTerm + ' ';
            query += ' OR Team_Interview_Decision__c like ' + searchTerm + ' ';
            query += ' OR Recommended_by_First_Site_Preference_for__c like ' + searchTerm + ' ';
            query += ' OR Cross_Site_Matching__c INCLUDES (\'' + tempSearchTerm + '\') ';
            query += ' OR Interview_Status__c like ' + searchTerm + ' ';
            query += ' OR Lead_Interviewer__r.Name like ' + searchTerm + ' ';
            query += ' OR Guest_Interviewer__r.Name like ' + searchTerm + ' ';
            query += ' OR Interview_Modality__c like ' + searchTerm + ' ';
            query += ' ) ';
        }
        
        // filter for first site preferance
        if(filteredFirstSitePreference != null && !filteredFirstSitePreference.isEmpty()) {

            query += ' AND X1st_Preference_CDL_Location__c IN : filteredFirstSitePreference ';
        }
        
        // filter for second site preferance
        if(filteredSecondSitePreference != null && !filteredSecondSitePreference.isEmpty()) {

            query += ' AND X2nd_Preference_CDL_Location__c IN : filteredSecondSitePreference ';
        }

        // filter for Team Stream Recommendations
        if(filteredTeamStreamRecommendations != null && !filteredTeamStreamRecommendations.isEmpty()) {

            query += ' AND Team_Stream_Recommendation__c IN : filteredTeamStreamRecommendations ';
        }

        // filter for Team Interview Decisions
        if(filteredTeamInterviewDecisions != null && !filteredTeamInterviewDecisions.isEmpty()) {

            query += ' AND Team_Interview_Decision__c IN : filteredTeamInterviewDecisions ';
        }

        // filter for Recommended by First Site Preferance
        if(filteredRecommendedByFirstSitePreferences != null && !filteredRecommendedByFirstSitePreferences.isEmpty()) {

            query += ' AND Recommended_by_First_Site_Preference_for__c IN : filteredRecommendedByFirstSitePreferences ';
        }

        // filter for Cross Site Matching
        if(filteredCrossSiteMatchings != null && !filteredCrossSiteMatchings.isEmpty()) {
            
            query += ' AND Cross_Site_Matching__c INCLUDES ( ';

            Boolean hasMoreValue = false;
            for(String val : filteredCrossSiteMatchings) {
                
                query += (hasMoreValue) ? ',\'' + val + '\'' : '\'' + val + '\'';
                hasMoreValue = true;
            }

            query += ' ) ';
        }

        // filter for Interview Status
        if(filteredInterviewStatus != null && !filteredInterviewStatus.isEmpty()) {

            query += ' AND Interview_Status__c IN : filteredInterviewStatus ';
        }

        // filter for Lead Interviews
        if(filteredLeadInterviewers != null && !filteredLeadInterviewers.isEmpty()) {

            query += ' AND Lead_Interviewer__r.Name IN : filteredLeadInterviewers ';
        }

        // filter for Guest Interviews
        if(filteredGuestInterviewers != null && !filteredGuestInterviewers.isEmpty()) {

            query += ' AND Guest_Interviewer__r.Name IN : filteredGuestInterviewers ';
        }

        // filter for Primary Contacts
        if(filteredPrimaryContacts != null && !filteredPrimaryContacts.isEmpty()) {

            query += ' AND Application_Primary_Contact__r.Name IN : filteredPrimaryContacts ';
        }

        // filter for Interview Modality
        if(filteredInterviewMadalities != null && !filteredInterviewMadalities.isEmpty()) {

            query += ' AND Interview_Modality__c IN : filteredInterviewMadalities ';
        }

        // filter for Applications by Application number
        if(filteredApplicationNumbers != null && !filteredApplicationNumbers.isEmpty()) {

            query += ' AND Name IN : filteredApplicationNumbers ';
        }

        // filter for Ventures
        if(filteredVentures != null && !filteredVentures.isEmpty()) {

            query += ' AND Venture__r.Name IN : filteredVentures ';
        }

        // filter for Venture's Headquarters
        if(filteredVentureHeadQuarters != null && !filteredVentureHeadQuarters.isEmpty()) {

            query += ' AND Venture__r.Headquarters__c IN : filteredVentureHeadQuarters ';
        }

        // filter for Timezone
        if(filteredInterviewTimeZones != null && !filteredInterviewTimeZones.isEmpty()) {

            query += ' AND Interview_Timezone__c IN : filteredInterviewTimeZones ';
        }

        if(!String.isBlank(sortField)) {

            query += ' order by ' + sortField + ' ';
        } else {

            query += ' order by Name ';
        }

        if(sortAsc) {

            query += ' ASC ';
        } else {

            query += ' DESC ';
        }

        query += ' NULLS LAST ';

        for(Application__c objApplication : Database.query(query)) {

            lstApplicationIds.add(objApplication.Id);
            mapApplicationIdToWrapper.put(objApplication.Id, new ApplicationWrapper(objApplication, objApplication.Lead_Interviewer__r, objApplication.Guest_Interviewer__r));
        }

        for(ContentDocumentLink applicationPDFFile : [SELECT ContentDocumentId, LinkedEntityId, ContentDocument.Title
            FROM ContentDocumentLink
            WHERE LinkedEntityId IN ( SELECT Id FROM Application__c WHERE Id IN : lstApplicationIds)
            AND LinkedEntity.Type = 'Application__c'
            AND ContentDocument.FileType = 'PDF'
            order by ContentDocument.CreatedDate desc]) {
            
            if(applicationIds.contains(applicationPDFFile.LinkedEntityId)) continue;
            mapApplicationIdToWrapper.get(applicationPDFFile.LinkedEntityId).applicationPDFFile = applicationPDFFile;
            mapApplicationIdToWrapper.get(applicationPDFFile.LinkedEntityId).hasFile = true;
            applicationIds.add(applicationPDFFile.LinkedEntityId);
        }

        for(Id applicationId : lstApplicationIds) {

            lstApplications.add(mapApplicationIdToWrapper.get(applicationId));
        }
        
        return lstApplications;
    }

    /**
     * Description: Method for supporting auto save feature on inline edit on table.
     */
    @AuraEnabled
    public static UpdateInfoWrapper updateApplicationValue(String applicationId, String apiName, String value, Boolean isDate, Boolean isDateTime) {

        try {

            Application__c objApp = new Application__c(Id = applicationId);

            if(isDateTime){
                
                Datetime dt = (DateTime)JSON.deserialize('"' + value + '"', DateTime.class);
                
                objApp.put(apiName,dt);
            } else if(isDate){
                
                objApp.put(apiName,Date.parse(value));
            } else {
                
                objApp.put(apiName,value);
            }
            
            update objApp;

            return new UpdateInfoWrapper(true, 'The record has been updated successfully.');
        } catch(Exception e) {
            
            return new UpdateInfoWrapper(false, 'Error occured while updating Evaluator : '+e.getMessage());
        }
    }

    /**
     * Description: Method to accumulate all filter options.
     */
    @AuraEnabled
    public static FilterWrapper getFilters() {

        FilterWrapper objFilterWrapper = new FilterWrapper();
        
        for(Schema.PicklistEntry pickVal : Application__c.X1st_Preference_CDL_Location__c.getDescribe().getPicklistValues()) {

            objFilterWrapper.firstSitePreferances.add(new ListItem(pickVal.getLabel(), pickVal.getValue()));
        }

        for(Schema.PicklistEntry pickVal : Application__c.X2nd_Preference_CDL_Location__c.getDescribe().getPicklistValues()) {

            objFilterWrapper.secondSitePreferances.add(new ListItem(pickVal.getLabel(), pickVal.getValue()));
        }

        for(Schema.PicklistEntry pickVal : Application__c.Cross_Site_Matching__c.getDescribe().getPicklistValues()) {

            objFilterWrapper.crossSiteMatchings.add(new ListItem(pickVal.getLabel(), pickVal.getValue()));
        }

        for(Schema.PicklistEntry pickVal : Application__c.Team_Stream_Recommendation__c.getDescribe().getPicklistValues()) {

            objFilterWrapper.teamStreamRecommendations.add(new ListItem(pickVal.getLabel(), pickVal.getValue()));
        }

        for(Schema.PicklistEntry pickVal : Application__c.Team_Interview_Decision__c.getDescribe().getPicklistValues()) {

            objFilterWrapper.teamInterviewDecisions.add(new ListItem(pickVal.getLabel(), pickVal.getValue()));
        }

        for(Schema.PicklistEntry pickVal : Application__c.Recommended_by_First_Site_Preference_for__c.getDescribe().getPicklistValues()) {

            objFilterWrapper.recommendedByFirstSitePreferences.add(new ListItem(pickVal.getLabel(), pickVal.getValue()));
        }

        for(Schema.PicklistEntry pickVal : Application__c.Interview_Status__c.getDescribe().getPicklistValues()) {

            objFilterWrapper.allInterviewStatus.add(new ListItem(pickVal.getLabel(), pickVal.getValue()));
        }

        for(Schema.PicklistEntry pickVal : Application__c.Interview_Modality__c.getDescribe().getPicklistValues()) {

            objFilterWrapper.interviewMadalities.add(new ListItem(pickVal.getLabel(), pickVal.getValue()));
        }

        for(Schema.PicklistEntry pickVal : Application__c.Interview_Timezone__c.getDescribe().getPicklistValues()) {

            objFilterWrapper.interviewTimeZones.add(new ListItem(pickVal.getLabel(), pickVal.getValue()));
        }

        for(Application__c objApplication : [SELECT Venture__c, Venture__r.Name, Venture__r.Headquarters__c, Name,
            Application_Primary_Contact__c, Application_Primary_Contact__r.Name, Lead_Interviewer__r.Name, Guest_Interviewer__r.Name
            FROM Application__c limit 10000]) {
            
            if(objApplication.Venture__c != null) {

                objFilterWrapper.allVentures.add(new ListItem(objApplication.Venture__r.Name, objApplication.Venture__r.Name));
                objFilterWrapper.allVentureHeadQuarters.add(new ListItem(objApplication.Venture__r.Headquarters__c, objApplication.Venture__r.Headquarters__c));
            }
            
            objFilterWrapper.allApplicationNumbers.add(new ListItem(objApplication.Name, objApplication.Name));

            if(objApplication.Lead_Interviewer__c != null) {

                objFilterWrapper.leadInterviewers.add(new ListItem(objApplication.Lead_Interviewer__r.Name, objApplication.Lead_Interviewer__r.Name));
            }

            if(objApplication.Guest_Interviewer__c != null) {

                objFilterWrapper.guestInterviewers.add(new ListItem(objApplication.Guest_Interviewer__r.Name, objApplication.Guest_Interviewer__r.Name));
            }

            if(objApplication.Application_Primary_Contact__c != null) {

                objFilterWrapper.primaryContacts.add(new ListItem(objApplication.Application_Primary_Contact__r.Name, objApplication.Application_Primary_Contact__r.Name));
            }
        }

        objFilterWrapper.firstSitePreferances = selectOptionSortByLabel(objFilterWrapper.firstSitePreferances);
        objFilterWrapper.secondSitePreferances = selectOptionSortByLabel(objFilterWrapper.secondSitePreferances);
        objFilterWrapper.allApplicationNumbers = selectOptionSortByLabel(objFilterWrapper.allApplicationNumbers);
        objFilterWrapper.allVentures = selectOptionSortByLabel(objFilterWrapper.allVentures);
        objFilterWrapper.allVentureHeadQuarters = selectOptionSortByLabel(objFilterWrapper.allVentureHeadQuarters);
        objFilterWrapper.leadInterviewers = selectOptionSortByLabel(objFilterWrapper.leadInterviewers);
        objFilterWrapper.guestInterviewers = selectOptionSortByLabel(objFilterWrapper.guestInterviewers);
        objFilterWrapper.primaryContacts = selectOptionSortByLabel(objFilterWrapper.primaryContacts);
        objFilterWrapper.interviewMadalities = selectOptionSortByLabel(objFilterWrapper.interviewMadalities);
        objFilterWrapper.allInterviewStatus = selectOptionSortByLabel(objFilterWrapper.allInterviewStatus);
        objFilterWrapper.recommendedByFirstSitePreferences = selectOptionSortByLabel(objFilterWrapper.recommendedByFirstSitePreferences);
        objFilterWrapper.teamInterviewDecisions = selectOptionSortByLabel(objFilterWrapper.teamInterviewDecisions);
        objFilterWrapper.teamStreamRecommendations = selectOptionSortByLabel(objFilterWrapper.teamStreamRecommendations);
        objFilterWrapper.crossSiteMatchings = selectOptionSortByLabel(objFilterWrapper.crossSiteMatchings);
        objFilterWrapper.interviewTimeZones = selectOptionSortByLabel(objFilterWrapper.interviewTimeZones);

        return objFilterWrapper;
    }
    
    /**
     * Description: Method to sort filter options alphabetically.
     */
    private static list<ListItem> selectOptionSortByLabel(list<ListItem>
                                                            selectOptionsToSort) {
        if(selectOptionsToSort == null || selectOptionsToSort.size() <= 1){
            return selectOptionsToSort;
        }
        List<ListItem> lessSelectOption = new List<ListItem>();
        List<ListItem> greaterSelectOption = new List<ListItem>();
        integer pivot = selectOptionsToSort.size() / 2;
        
        ListItem pivotValue = selectOptionsToSort[pivot];
        selectOptionsToSort.remove(pivot);
        for(ListItem SO : selectOptionsToSort){
            if(SO.label <= pivotValue.label){
                lessSelectOption.add(SO);
            }else if(SO.label > pivotValue.label){
                greaterSelectOption.add(SO);   
            }
        }

        list<ListItem> sortedSelectOptions = new list<ListItem>(); 
        sortedSelectOptions.addAll(selectOptionSortByLabel(lessSelectOption));
        sortedSelectOptions.add(pivotValue);
        sortedSelectOptions.addAll(selectOptionSortByLabel(greaterSelectOption));
        return SortedSelectOptions;
    }
}