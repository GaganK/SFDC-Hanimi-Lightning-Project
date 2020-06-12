public class myApplicationListCtrl {
public List<Application__c> applsts=new List<Application__c>();
    public  List<Application__c> getAllApplications(){
               String query = 'Select Id,Name ,Evaluator_1__c,Evaluator_2__c,Evaluator_3__c,Venture__r.Name,Initial_CDL_Site_Preference__c,Tech_Specialization__c from Application__c where CreatedDate =LAST_N_DAYS:365 ';
                string loggedUserId = Userinfo.getUserId();
               if(String.isNotBlank(loggedUserId)) {
                    query = query + ' AND OwnerId = \'' + loggedUserId + '\'';
                }
                 query = query + '  ORDER BY CreatedDate desc LIMIT 2000 ';
                System.debug('query*****************'+query);

    applsts = Database.query(query);
        return applsts;
    }
    public void updateApplication(){
        update applsts;
    }
    
}