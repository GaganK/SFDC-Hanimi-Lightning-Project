trigger ContentDocumentLinkTrigger on ContentDocumentLink (before insert, before update,after insert, after update) {
       if(trigger.isBefore) {
     for (ContentDocumentLink cd : Trigger.New) {
         cd.Visibility = 'AllUsers';
        }
        }
         /*if(trigger.isAfter) {
              for (ContentDocumentLink cd : Trigger.New) {
                 ContentDocumentLinkTriggerHandler.onAfterInsert(trigger.new[0].Id);
             }
          }*/
}