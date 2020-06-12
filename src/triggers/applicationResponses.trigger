trigger applicationResponses on Application__c(before insert, after insert,after update)
{
  if (Trigger.IsInsert && Trigger.isAfter){
    List<Lead> leadsToUpdate = new List<Lead>();
    map<String,String> mapToApp = new map<String,String>();
    SET<Id> accIds = new Set<Id>();
    for(Application__c app : Trigger.NEW){
        if(app.Venture__c!=null){
            accIds.add(app.Venture__c);
            mapToApp.put(app.Venture__c, app.id);
        }
    }
    if(!accIds.isEmpty()){
        for(Lead lead : [Select Company,Matching_Account__c,Application__c from Lead 
                         where status != 'Disqualified' and Matching_Account__c in : accIds]){
             if(mapToApp.containsKey(lead.Matching_Account__c)){
                 lead.Application__c = mapToApp.get(lead.Matching_Account__c);
                 leadsToUpdate.add(lead);
             }      
        }
         if(! leadsToUpdate.isEmpty()){
            update leadsToUpdate;
        } 
    }
  }
  
  for (Application__c app : Trigger.NEW)
  {
    try
    {
      if (Trigger.IsInsert && Trigger.isBefore)
      {
        app.Verification_Code__c = cdlUtilities.generateRandomString(6);
        //if (app.Tech_Specialization__c == null) { app.Tech_Specialization__c = 'Prime'; }
        //if (!app.Tech_Specialization__c.contains('Prime')) { app.Tech_Specialization__c = ';Prime'; }
      } else if (Trigger.oldMap == null || Trigger.oldMap.get(app.Id).Tech_Specialization__c == null ||
                                           Trigger.oldMap.get(app.Id).Tech_Specialization__c == '')
      {
        String techSpec = app.Tech_Specialization__c;
        //if (!techSpec.contains('Prime')) { techSpec += ';Prime'; }
        String[] techSpecializationArray = techSpec.split(';');
        System.debug('techSpecializationArray: ' + techSpecializationArray);
        Set<Id> questionSet = new Set<Id>();
        List<Stream_Question__c> questionList = new List<Stream_Question__c>();
        for (String techSpecialization : techSpecializationArray)
        {
          //if (techSpecialization == 'Artificial Intelligence')
          //{ techSpecialization = 'Artificial Intelligence/Data Science'; }
          questionList
            = [select Question__c from Stream_Question__c where Stream_Name__c =: techSpecialization];
          for (Stream_Question__c question : questionList)
          {
            questionSet.add(question.Question__c);
          }
        }
        Map<Id,Decimal> questionMap = new Map<Id,Decimal>();
        for (Id questionId : questionSet)
        {
          questionMap.put
            (questionId,
              [select Question_Sequence__c from Stream_Question__c where Question__c =: questionId
               and Stream_Name__c in: techSpecializationArray limit 1].Question_Sequence__c);
        }
        System.debug('questionSet: ' + questionSet);
        List<Response__c> responseList = new List<Response__c>();
        for (Id questionId : questionMap.keySet())
        {
          Response__c response = new Response__c();
          response.Application__c = app.Id;
          response.Order__c = questionMap.get(questionId);
          response.Question__c = questionId;
          responseList.add(response);
        }
        System.debug('responseList: ' + responseList);
        insert responseList;
      }
    } catch (Exception e) { System.debug(e.getStackTraceString()); }
  }
}