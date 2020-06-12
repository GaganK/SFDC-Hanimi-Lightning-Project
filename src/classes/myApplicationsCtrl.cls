public class myApplicationsCtrl {

    public class EvaluatorUpdateInfoWrapper {

        @AuraEnabled
        public boolean isSuccess;
        @AuraEnabled
        public string message;

        public EvaluatorUpdateInfoWrapper(Boolean isSuccess, String message) {

            this.isSuccess = isSuccess;
            this.message = message;
        }
    }

    public class FilterWrapper {

        @AuraEnabled
        public List<ListItem> firstSitePreferances;
        @AuraEnabled
        public List<ListItem> secondSitePreferances;
        @AuraEnabled
        public List<ListItem> assignedToUsers;
        @AuraEnabled
        public List<ListItem> allStreamPotentials;
        @AuraEnabled
        public List<ListItem> allVentures;
        @AuraEnabled
        public List<ListItem> allApplicationNumbers;
        @AuraEnabled
        public List<ListItem> allVentureHeadQuarters;

        public FilterWrapper() {

            firstSitePreferances = new List<ListItem>();
            secondSitePreferances = new List<ListItem>();
            assignedToUsers = new List<ListItem>();
            allStreamPotentials = new List<ListItem>();
            allVentures = new List<ListItem>();
            allApplicationNumbers = new List<ListItem>();
            allVentureHeadQuarters = new List<ListItem>();
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

    public class ApplicationWrapper {

        @AuraEnabled
        public Application__c objApplication;
        @AuraEnabled
        public User evaluator1;
        @AuraEnabled
        public User evaluator2;
        @AuraEnabled
        public User evaluator3;
        @AuraEnabled
        public boolean hasFile;
        @AuraEnabled
        public ContentDocumentLink file;

        public ApplicationWrapper(Application__c application, User evaluator1, User evaluator2, User evaluator3) {

            this.objApplication = application;
            this.evaluator1 = evaluator1;
            this.evaluator2 = evaluator2;
            this.evaluator3 = evaluator3;
            this.hasFile = false;
            this.file = new ContentDocumentLink();
        }
    }

    public class ColumnWrapper {

        @AuraEnabled
        public String label;
        @AuraEnabled
        public String apiName;
        @AuraEnabled
        public Boolean isSortable;

        public ColumnWrapper() {

            label = apiName = '';
            isSortable = false;
        }
    }

    @AuraEnabled
    public static List<ApplicationWrapper> getApplications(String searchTerm,
        List<String> filteredFirstSitePreference,
        List<String> filteredSecondSitePreference,
        List<String> filteredEvaluator1,
        List<String> filteredEvaluator2,
        List<String> filteredEvaluator3,
        List<String> filteredStreamPotentials,
        List<String> filteredApplicationNumbers,
        List<String> filteredVentures,
        List<String> filteredVentureHeadQuarters,
        String sortField,
        Boolean sortAsc) {
        
        System.debug('## sortField : '+sortField);

        List<Id> lstApplicationIds = new List<Id>();
        Set<Id> applicationIds = new Set<Id>();
        List<ApplicationWrapper> lstApplications = new List<ApplicationWrapper>();
        Map<Id,ApplicationWrapper> mapApplicationIdToWrapper = new Map<Id,ApplicationWrapper>();

        String query = 'Select Id, Name, X1st_Preference_CDL_Location__c, X2nd_Preference_CDL_Location__c, Venture__c, ' +
            'Venture__r.Name, Venture__r.Headquarters__c, Venture_Overview_Briefly_describe_your__c, Venture__r.Website, ' +
            'Application_Primary_Contact__c, Application_Primary_Contact__r.LinkedIn_Profile__c,Application_Primary_Contact__r.LinkedIn_URL__c, Application_Primary_Contact__r.Name, ' +
            'Tech_Specialization__c, Evaluator_1__c, Evaluator_1__r.Name, Evaluator_1__r.Id, Evaluator_1__r.FullPhotoUrl, ' +
            'Evaluator_2__c, Evaluator_2__r.Name, Evaluator_2__r.Id, Evaluator_2__r.FullPhotoUrl, ' +
            'Evaluator_3__c, Evaluator_3__r.Name, Evaluator_3__r.Id, Evaluator_3__r.FullPhotoUrl ' +
            'FROM Application__c ' + 
            'WHERE Id != null ';
            //'WHERE OwnerId = \'' + Userinfo.getUserId() + '\' ';

        if(!String.isBlank(searchTerm)) {

            String tempSearchTerm = String.escapeSingleQuotes(searchTerm.trim());
            Set<Id> appIds = getMatchingVentureOverview(tempSearchTerm);
            searchTerm = '\'%' + tempSearchTerm + '%\'';

            query += ' AND ( ';
            query += ' Name like ' + searchTerm + ' ';
            query += ' OR X1st_Preference_CDL_Location__c like ' + searchTerm + ' ';
            query += ' OR X2nd_Preference_CDL_Location__c like ' + searchTerm + ' ';
            query += ' OR Venture__r.Name like ' + searchTerm + ' ';
            query += ' OR Venture__r.Headquarters__c like ' + searchTerm + ' ';
            query += ' OR Venture__r.Website like ' + searchTerm + ' ';
            query += ' OR Application_Primary_Contact__r.Name like ' + searchTerm + ' ';
            query += ' OR Application_Primary_Contact__r.LinkedIn_Profile__c like ' + searchTerm + ' ';
            query += ' OR Tech_Specialization__c INCLUDES (\'' + tempSearchTerm + '\') ';
            query += ' OR Evaluator_1__r.Name like ' + searchTerm + ' ';
            query += ' OR Evaluator_2__r.Name like ' + searchTerm + ' ';
            query += ' OR Evaluator_3__r.Name like ' + searchTerm + ' ';

            if(!appIds.isEmpty()) {

                query += ' OR Id IN : appIds ';
            }
            
            query += ' ) ';
        }
        
        if(filteredFirstSitePreference != null && !filteredFirstSitePreference.isEmpty()) {

            query += ' AND X1st_Preference_CDL_Location__c IN : filteredFirstSitePreference ';
        }
        
        if(filteredSecondSitePreference != null && !filteredSecondSitePreference.isEmpty()) {

            query += ' AND X2nd_Preference_CDL_Location__c IN : filteredSecondSitePreference ';
        }

        if(filteredEvaluator1 != null && !filteredEvaluator1.isEmpty()) {

            query += ' AND Evaluator_1__c IN : filteredEvaluator1 ';
        }

        if(filteredEvaluator2 != null && !filteredEvaluator2.isEmpty()) {

            query += ' AND Evaluator_2__c IN : filteredEvaluator2 ';
        }

        if(filteredEvaluator3 != null && !filteredEvaluator3.isEmpty()) {

            query += ' AND Evaluator_3__c IN : filteredEvaluator3 ';
        }

        if(filteredStreamPotentials != null && !filteredStreamPotentials.isEmpty()) {
            
            query += ' AND Tech_Specialization__c INCLUDES ( ';

            Boolean hasMoreValue = false;
            for(String val : filteredStreamPotentials) {
                
                query += (hasMoreValue) ? ',\'' + val + '\'' : '\'' + val + '\'';
                hasMoreValue = true;
            }

            query += ' ) ';
        }

        if(filteredApplicationNumbers != null && !filteredApplicationNumbers.isEmpty()) {

            query += ' AND Name IN : filteredApplicationNumbers ';
        }

        if(filteredVentures != null && !filteredVentures.isEmpty()) {

            query += ' AND Venture__r.Name IN : filteredVentures ';
        }

        if(filteredVentureHeadQuarters != null && !filteredVentureHeadQuarters.isEmpty()) {

            query += ' AND Venture__r.Headquarters__c IN : filteredVentureHeadQuarters ';
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

        system.debug('## query : '+query);

        for(Application__c objApplication : Database.query(query)) {

            lstApplicationIds.add(objApplication.Id);
            mapApplicationIdToWrapper.put(objApplication.Id, new ApplicationWrapper(objApplication, objApplication.Evaluator_1__r, objApplication.Evaluator_2__r, objApplication.Evaluator_3__r));
        }

        for(ContentDocumentLink file : [SELECT ContentDocumentId, LinkedEntityId, ContentDocument.Title
            FROM ContentDocumentLink
            WHERE LinkedEntityId IN ( SELECT Id FROM Application__c WHERE Id IN : lstApplicationIds)
            AND LinkedEntity.Type = 'Application__c'
            order by ContentDocument.CreatedDate desc]) {
            
            if(applicationIds.contains(file.LinkedEntityId)) continue;
            mapApplicationIdToWrapper.get(file.LinkedEntityId).file = file;
            mapApplicationIdToWrapper.get(file.LinkedEntityId).hasFile = true;
            applicationIds.add(file.LinkedEntityId);
        }

        for(Id applicationId : lstApplicationIds) {

            lstApplications.add(mapApplicationIdToWrapper.get(applicationId));
        }

        System.debug('## lstApplications : '+lstApplications);
        
        return lstApplications;
    }

    private static Set<Id> getMatchingVentureOverview(String searchTerm) {

        System.debug('## searchTerm : '+searchTerm);

        Set<Id> applicationIds = new Set<Id>();
        List<Application__c> lstApplication = [Select Id, Venture_Overview_Briefly_describe_your__c FROM Application__c];

        for(Application__c application : lstApplication) {
            
            if(!String.isBlank(application.Venture_Overview_Briefly_describe_your__c) && application.Venture_Overview_Briefly_describe_your__c.contains(searchTerm)) {

                applicationIds.add(application.Id);
            }
        }

        return applicationIds;
    }

    @AuraEnabled
    public static EvaluatorUpdateInfoWrapper updateEvaluator(String applicationId, String apiName, String userId) {

        try {

            Application__c objApp = new Application__c(Id = applicationId);
            objApp.put(apiName,userId);
            update objApp;
           /* if(userId!=null && userId!=''){
            Evaluation__c objEva = new Evaluation__c(Application__c= applicationId,CDL_Evaluator__c=userId);
            insert objEva;
            }*/
            return new EvaluatorUpdateInfoWrapper(true, 'The record has been updated successfully.');
        } catch(Exception e) {

            return new EvaluatorUpdateInfoWrapper(false, 'Error occured while updating Evaluator : '+e.getMessage());
        }
    }

    @AuraEnabled
    public static List<ApplicationWrapper> copyEvaluatorToAllApplication(String apiName,
        String userId,
        List<String> applicationIds,
        String searchTerm,
        List<String> filteredFirstSitePreference,
        List<String> filteredSecondSitePreference,
        List<String> filteredEvaluator1,
        List<String> filteredEvaluator2,
        List<String> filteredEvaluator3,
        List<String> filteredStreamPotentials,
        List<String> filteredApplicationNumbers,
        List<String> filteredVentures,
        List<String> filteredVentureHeadQuarters,
        String sortField,
        Boolean sortAsc) {

        List<Application__c> lstApplications = new List<Application__c>();

        for(String applicationId : applicationIds) {

            Application__c objApp = new Application__c(Id = applicationId);
            objApp.put(apiName,userId);
            lstApplications.add(objApp);
        }

        update lstApplications;

        return getApplications(searchTerm, filteredFirstSitePreference, filteredSecondSitePreference, filteredEvaluator1, filteredEvaluator2, filteredEvaluator3, filteredStreamPotentials, filteredApplicationNumbers, filteredVentures, filteredVentureHeadQuarters, sortField, sortAsc);
    }

    @AuraEnabled
    public static FilterWrapper getFilters() {

        FilterWrapper objFilterWrapper = new FilterWrapper();
        Set<String> ventureNames = new Set<String>();
        Set<String> ventureHeadQuarters = new Set<String>();
        
        for(Schema.PicklistEntry pickVal : Application__c.X1st_Preference_CDL_Location__c.getDescribe().getPicklistValues()) {

            objFilterWrapper.firstSitePreferances.add(new ListItem(pickVal.getLabel(), pickVal.getValue()));
        }

        for(Schema.PicklistEntry pickVal : Application__c.X2nd_Preference_CDL_Location__c.getDescribe().getPicklistValues()) {

            objFilterWrapper.secondSitePreferances.add(new ListItem(pickVal.getLabel(), pickVal.getValue()));
        }

        for(Schema.PicklistEntry pickVal : Application__c.Tech_Specialization__c.getDescribe().getPicklistValues()) {

            objFilterWrapper.allStreamPotentials.add(new ListItem(pickVal.getLabel(), pickVal.getValue()));
        }

        for(User objUser : [SELECT Id, Name, Title, FullPhotoURL
            FROM User
            WHERE IsActive = true
            AND UserType = 'Standard'
            order by createdDate
            DESC limit 100]) {

            objFilterWrapper.assignedToUsers.add(new ListItem(objUser.Name, objUser.Id));
        }



        for(Application__c objApplication : [SELECT Venture__c, Venture__r.Name, Venture__r.Headquarters__c, Name
            FROM Application__c limit 1000]) {
            
            ventureNames.add(objApplication.Venture__r.Name);
            ventureHeadQuarters.add(objApplication.Venture__r.Headquarters__c);
            objFilterWrapper.allApplicationNumbers.add(new ListItem(objApplication.Name, objApplication.Name));
        }

        for(String ventureName : ventureNames) {

            objFilterWrapper.allVentures.add(new ListItem(ventureName, ventureName));
        }

        for(String ventureHeadQuarter : ventureHeadQuarters) {

            objFilterWrapper.allVentureHeadQuarters.add(new ListItem(ventureHeadQuarter, ventureHeadQuarter));
        }

        objFilterWrapper.firstSitePreferances = selectOptionSortByLabel(objFilterWrapper.firstSitePreferances);
        objFilterWrapper.secondSitePreferances = selectOptionSortByLabel(objFilterWrapper.secondSitePreferances);
        objFilterWrapper.allStreamPotentials = selectOptionSortByLabel(objFilterWrapper.allStreamPotentials);
        objFilterWrapper.assignedToUsers = selectOptionSortByLabel(objFilterWrapper.assignedToUsers);
        objFilterWrapper.allApplicationNumbers = selectOptionSortByLabel(objFilterWrapper.allApplicationNumbers);
        objFilterWrapper.allVentures = selectOptionSortByLabel(objFilterWrapper.allVentures);
        objFilterWrapper.allVentureHeadQuarters = selectOptionSortByLabel(objFilterWrapper.allVentureHeadQuarters);

        return objFilterWrapper;
    }
    
    private static list<ListItem> selectOptionSortByLabel(list<ListItem>
                                                            selectOptionsToSort) {
        if(selectOptionsToSort == null || selectOptionsToSort.size() <= 1){
            return selectOptionsToSort;
        }
        List<ListItem> lessSelectOption = new List<ListItem>();
        List<ListItem> greaterSelectOption = new List<ListItem>();
        integer pivot = selectOptionsToSort.size() / 2;
        
        //save the pivot and remove it from the selectOption list
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

    @AuraEnabled
    public static List <User> fetchLookUpValues(String searchKeyWord) {
        
        searchKeyWord = String.escapeSingleQuotes(searchKeyWord.trim()) + '%';
        return new List<User>([SELECT Id, Name, Title, FullPhotoURL
            FROM User
            WHERE Name like : searchKeyWord
            AND IsActive = true
            AND UserType = 'Standard'
            order by createdDate
            DESC limit 5]);
    }
}