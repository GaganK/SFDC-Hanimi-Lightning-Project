public without sharing  class FinanceMemoCtrl{
   @AuraEnabled 
    public static List<financeWrapper> fetchfinancewrapper(String searchTerm,Boolean isDay1){ 
        //Set<String> acctSet = new Set<String>();
        List<Admitted_Venture__c> accList = new List<Admitted_Venture__c>();
        List<financeWrapper> financeWrapList = new List<financeWrapper>();
                 String query ='';
                 string cohortYear = string.valueof(System.Today().year()-1) + '-' + string.valueof(System.Today().year());
                   query = 'SELECT id,Cohort_Name__c,(Select id ,Admitted_Venture__c,Investor_Contact__c,Investor_Contact__r.Name from Committed_Investors__r),Venture__c,Cohort_Stream__c,Cohort_CDL_Site__c,Venture__r.Related_CDL_Site__c,Venture__r.id,Cohort_Year__c,Venture__r.Name,Venture__r.Description_Venture__c,Venture__r.Related_Stream_s__c,Venture__r.Technology_Area__c FROM Admitted_Venture__c ';
                 if(isDay1){
                      string admittedStatus = system.label.Admitted_Status + '%';                      
                      query = query + ' where Admitted_Venture_Status__c like : admittedStatus AND Cohort_Year__c =: cohortYear';
                 }else{
                     string graduatedStatus = system.label.Graduated_Status + '%';  
                     query = query + ' where Admitted_Venture_Status__c like : graduatedStatus AND Cohort_Year__c != cohortYear';
                 }
              
               if(!String.isBlank(searchTerm)) {
                    String tempSearchTerm = String.escapeSingleQuotes(searchTerm.trim());
                      searchTerm = '\'%' + tempSearchTerm + '%\'';
                    query += ' AND ( ';
                    query += ' Venture__r.Name like ' + searchTerm + ' ';
                   query += ' OR Venture__r.Cohort_Stream__c INCLUDES (\'' + tempSearchTerm + '\') ';
                   query += ' OR Venture__r.Cohort_CDL_Site__c INCLUDES (\'' + tempSearchTerm + '\') ';
                    
                     
                   // query += ' OR Cohort_Name__c like ' + searchTerm + ' ';
                    query += ' OR Venture__r.Technology_Area__c like ' + searchTerm + ' ';
                    query += ' ) ';
                } 
                system.debug(query +'query=====');
  
        try{
             accList = Database.query(query);
            if(!accList.isEmpty()){
                Set<String> acctSet = new Set<String>();
                Set<String> admVentSet = new Set<String>();
                for(Admitted_Venture__c admVenObj : accList){
                    acctSet.add(admVenObj.Venture__c);
                    admVentSet.add(admVenObj.id);
                }
                Map<String ,FinancingEvent__c> mapToFinance= new Map<String ,FinancingEvent__c>();
                if(!admVentSet.isEmpty()){
                    for(FinancingEvent__c financeObj :[Select id,Amount_Currently_Committed__c,Status__c,Related_Admitted_Venture__c,Instrument_used__c,Terms_convertible_note__c,Venture_Name__c,Amount_raised__c from FinancingEvent__c where Status__c='Open' and Related_Admitted_Venture__c in :admVentSet and Venture_Name__c in :acctSet]){
                        mapToFinance.put(financeObj.Related_Admitted_Venture__c+'&&'+financeObj.Venture_Name__c,financeObj);
                    }
                }
                for(Admitted_Venture__c admVentObj : accList){
                    financeWrapper finwrapper = new financeWrapper();
                    finwrapper.admVentObj = admVentObj;
                    if(mapToFinance.containsKey(admVentObj.id+'&&'+admVentObj.Venture__c) && mapToFinance.get(admVentObj.id+'&&'+admVentObj.Venture__c)!=null){
                        finwrapper.financeEventsObj = mapToFinance.get(admVentObj.id+'&&'+admVentObj.Venture__c);
                    }else{
                        finwrapper.financeEventsObj = new FinancingEvent__c();
                    }
                    finwrapper.isSelected = false;
                    if(admVentObj.Committed_Investors__r.size()>0){
                        finwrapper.committInvList = admVentObj.Committed_Investors__r;
                    }else{
                        finwrapper.committInvList = new List<Committed_Investor__c>();
                    }
                    financeWrapList.add(finwrapper);
                }
            }
            System.debug(financeWrapList);
        }
        catch (Exception e){
            system.debug(e.getmessage());
              system.debug(e.getlinenumber());
        }
           return financeWrapList ;
    
    }
     public class financeWrapper{
         @AuraEnabled 
         public Admitted_Venture__c admVentObj;
          @AuraEnabled 
         public Boolean isSelected;
          @AuraEnabled 
         public FinancingEvent__c financeEventsObj;
         @AuraEnabled 
         public List<Committed_Investor__c> committInvList;
    }
     @AuraEnabled 
    public static void saveAdmit(string selAdmitVent){
        system.debug('selAdmitVent-' + selAdmitVent);
        List<financeWrapper> financeWrapList = new  List<financeWrapper>();
        List<Interested_Mentor__c> delIntMentList = new List<Interested_Mentor__c>();
        List<Interested_Mentor__c> intMentList = new List<Interested_Mentor__c>();
        Set<String> conidSet = new Set<String>();
        if(!string.isBlank(selAdmitVent)){
            financeWrapList = (List<financeWrapper>)System.JSON.deserialize(selAdmitVent,List<financeWrapper>.class);
            system.debug('financeWrapList-' + financeWrapList);
        
           List<User> userList = new List<User>();
       userList = [Select id ,Contactid from User where id=:UserInfo.getUserId() and Contactid!=null];
        Map<String,String> admitToMap = new Map<String,String>();
       for(financeWrapper admitVent: financeWrapList){
            Interested_Mentor__c intMent = new Interested_Mentor__c();
            intMent.Admitted_Venture__c = admitVent.admVentObj.id;
            intMent.Contact__c = userList[0].Contactid;
            intMent.Is_Match__c = true;
            intMentList.add(intMent);
            conidSet.add(intMent.Contact__c);
        }
        }
        if(!intMentList.isEmpty()){
            delIntMentList = [Select id from Interested_Mentor__c where Contact__c in :conidSet];
           delete delIntMentList;
            insert intMentList;
        }
    }

}