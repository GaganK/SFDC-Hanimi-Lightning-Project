public class myApplicationsCtrl_Temp {
    
    private static String lstFieldAPINames = 'Id,Name,X1st_Preference_CDL_Location__c,X2nd_Preference_CDL_Location__c,'+
                                                    'Venture__c,Venture__r.Name,Venture__r.Headquarters__c,'+
                                                    'Venture_Overview_Briefly_describe_your__c,'+
                                                    'Venture__r.Website,Application_Primary_Contact__c,'+
                                                    'Application_Primary_Contact__r.LinkedIn_Profile__c,'+
                                                    'Application_Primary_Contact__r.Name,'+
                                                    'Tech_Specialization__c,Evaluator_1__c,Evaluator_1__r.Name,Evaluator_1__r.Id,'+
                                                    'Evaluator_1__r.FullPhotoUrl,Evaluator_2__c,Evaluator_2__r.Name,'+
                                                    'Evaluator_2__r.Id,Evaluator_2__r.FullPhotoUrl,Evaluator_3__c,'+
                                                    'Evaluator_3__r.Name,Evaluator_3__r.Id,Evaluator_3__r.FullPhotoUrl';
                                                    
    public class ApplicationAssignmentWrapper{
        
        @AuraEnabled
        public List<ApplicationWrapper> lstApplications;
        
        @AuraEnabled
        public List<FieldFilterWrapper> lstFilters;
        
        public ApplicationAssignmentWrapper(){
            
            /*this.lstApplications = new List<ApplicationWrapper>();
            this.lstFilters = new List<FieldFilterWrapper>();
            for(String sFieldAPIName : lstFieldAPINames.split(',')){
            
                this.lstFilters.add(new FieldFilterWrapper(sFieldAPIName, new List<String>()));
            }*/
        }
    }
    
    public class FieldFilterWrapper {
        
        @AuraEnabled
        public String filterFieldLabel;

        @AuraEnabled
        public String filterFieldAPIName;

        @AuraEnabled
        public String filterFieldType;
        
        @AuraEnabled
        public List<String> selectedValues;
        
        @AuraEnabled
        public List<ListItem> filterFieldValues;
        
        public FieldFilterWrapper(){}
        public FieldFilterWrapper(String filterFieldAPIName,List<String> filterFieldValues){
            
            this.filterFieldAPIName = filterFieldAPIName;
            this.filterFieldValues = new List<ListItem>();
            this.selectedValues = new List<String>();
            for(String strVal : filterFieldValues){
                
                this.filterFieldValues.add(new ListItem(strVal, strVal));
            }
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
        @AuraEnabled
        public FieldFilterWrapper objFieldFilterWrapper;

        public ApplicationWrapper(Application__c application, User evaluator1, User evaluator2, User evaluator3) {

            this.objApplication = application;
            this.evaluator1 = evaluator1;
            this.evaluator2 = evaluator2;
            this.evaluator3 = evaluator3;
            this.hasFile = false;
            this.file = new ContentDocumentLink();
            this.objFieldFilterWrapper = new FieldFilterWrapper();
        }
    }
    
    @AuraEnabled
    public static ApplicationAssignmentWrapper getApplications(String sortField,Boolean sortAsc){
        
        ApplicationAssignmentWrapper objApplicationAssignmentWrapper = new ApplicationAssignmentWrapper();
        objApplicationAssignmentWrapper.lstApplications = onSearch('','','',sortField,sortAsc);
        // List<FieldFilterWrapper>  objApplicationAssignmentWrapper.lstFilters.get(sFieldAPIName);
        Map<String, List<String>> mapFieldAPIToVal = new Map<String, List<String>>();
        
        for(ApplicationWrapper objApplicationWrapper : objApplicationAssignmentWrapper.lstApplications){
            
            for(String sFieldAPIName : lstFieldAPINames.split(',')){
                
                List<String> lstFilterValues = new List<String>();
                if(mapFieldAPIToVal.containsKey(sFieldAPIName)){
                
                    lstFilterValues = mapFieldAPIToVal.get(sFieldAPIName);
                }
                
                String strFieldValue = '';
                if(sFieldAPIName.contains('__r')){
                    
                    List<String> lstRelationshipFields = new List<String>(sFieldAPIName.split('\\.'));
                    if(objApplicationWrapper.objApplication.getSObject(lstRelationshipFields[0]) != null){
                        
                        strFieldValue = String.valueOf(objApplicationWrapper.objApplication.getSObject(lstRelationshipFields[0]).get(lstRelationshipFields[1]));
                    }
                } else {
                    
                    strFieldValue = String.valueOf(objApplicationWrapper.objApplication.get(sFieldAPIName));
                }
                lstFilterValues.add(strFieldValue);
                mapFieldAPIToVal.put(sFieldAPIName,lstFilterValues);
            }
        }
        system.debug('mapFieldAPIToVal>>>'+mapFieldAPIToVal);
        
        //createFiltersWrapper
        List<FieldFilterWrapper> lstFieldFilterWrapper = new List<FieldFilterWrapper>();
        for(String strFieldAPIName : mapFieldAPIToVal.keyset()){
            
            FieldFilterWrapper objFieldFilterWrapper = new FieldFilterWrapper();
            set<string> aStringSet = new set<string>(mapFieldAPIToVal.get(strFieldAPIName));
            aStringSet.remove('');
            aStringSet.remove(null);
            lstFieldFilterWrapper.add(new FieldFilterWrapper(strFieldAPIName,new list<string>(aStringSet)));
        }
        
        objApplicationAssignmentWrapper.lstFilters = lstFieldFilterWrapper;
        return objApplicationAssignmentWrapper;
    }
    
   /* @AuraEnabled
    public static List<ApplicationWrapper> getFilteredApplications(String searchTerm,String sortField,Boolean sortAsc){
        
        // onSearch(searchTerm,sortField,sortAsc);
    }*/
    
    /*@AuraEnabled
    public static List<ApplicationWrapper> getGlobalSearchResults(String searchTerm,List<FieldFilterWrapper> lstFieldFilterWrapper,String sortField,Boolean sortAsc){
        
        String query = 'Select Id, Name, X1st_Preference_CDL_Location__c, X2nd_Preference_CDL_Location__c, Venture__c, ' +
            'Venture__r.Name, Venture__r.Headquarters__c, Venture_Overview_Briefly_describe_your__c, Venture__r.Website, ' +
            'Application_Primary_Contact__c, Application_Primary_Contact__r.LinkedIn_Profile__c, Application_Primary_Contact__r.Name, ' +
            'Tech_Specialization__c, Evaluator_1__c, Evaluator_1__r.Name, Evaluator_1__r.Id, Evaluator_1__r.FullPhotoUrl, ' +
            'Evaluator_2__c, Evaluator_2__r.Name, Evaluator_2__r.Id, Evaluator_2__r.FullPhotoUrl, ' +
            'Evaluator_3__c, Evaluator_3__r.Name, Evaluator_3__r.Id, Evaluator_3__r.FullPhotoUrl ' +
            'FROM Application__c ' + 
            'WHERE Id != null ';
        
        if(!String.isBlank(searchTerm)) {
            
            String tempSearchTerm = String.escapeSingleQuotes(searchTerm.trim());
            Set<Id> appIds = getMatchingVentureOverview(tempSearchTerm);
            searchTerm = '\'%' + tempSearchTerm + '%\'';

            query += ' AND ( ';
            
            for(FieldFilterWrapper objFieldFilterWrapper : lstFieldFilterWrapper){
                
                if(objFieldFilterWrapper.filterFieldType.toLowerCase() == 'multiselect'){
                
                    query += ' OR '+ objFieldFilterWrapper.filterFieldAPIName +'INCLUDES (\'' + tempSearchTerm + '\') ';
                } else {
                    
                    query += ' OR '+ objFieldFilterWrapper.filterFieldAPIName +' like ' + searchTerm + ' ';
                }
            }    
            
            query += ' ) ';
        }
        
        query += (String.isNotBlank(sortField)) ? ' order by ' + sortField + ' ' : ' order by Name ';
        query += (sortAsc) ? ' ASC ' : ' DESC ';
        query += ' NULLS LAST ';

        system.debug('## query : '+query);
            
    }*/
    
    private static List<ApplicationWrapper> onSearch(String searchTerm,String strSearchField,String strSearchType,String sortField,Boolean sortAsc){
        
        List<Id> lstApplicationIds = new List<Id>();
        Set<Id> applicationIds = new Set<Id>();
        List<ApplicationWrapper> lstApplications = new List<ApplicationWrapper>();
        Map<Id,ApplicationWrapper> mapApplicationIdToWrapper = new Map<Id,ApplicationWrapper>();
        
        String query = 'Select '+ lstFieldAPINames + ' '+
            'FROM Application__c ' + 
            'WHERE Id != null ';
            
        if(!String.isBlank(searchTerm)) {

            String tempSearchTerm = String.escapeSingleQuotes(searchTerm.trim());
            Set<Id> appIds = getMatchingVentureOverview(tempSearchTerm);
            searchTerm = '\'%' + tempSearchTerm + '%\'';

            query += ' AND ( ';
            
            if(strSearchType.toLowerCase() == 'multiselect'){
                
                query += ' OR '+ strSearchField +'INCLUDES (\'' + tempSearchTerm + '\') ';
            } else {
                
                query += ' OR '+ strSearchField +' like ' + searchTerm + ' ';
            }


            if(!appIds.isEmpty()) {

                query += ' OR Id IN : appIds ';
            }
            
            query += ' ) ';
        }
            
        query += (String.isNotBlank(sortField)) ? ' order by ' + sortField + ' ' : ' order by Name ';
        query += (sortAsc) ? ' ASC ' : ' DESC ';
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
    
    //only on search
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



}