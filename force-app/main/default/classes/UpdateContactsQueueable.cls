/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 02-01-2023
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
public class UpdateContactsQueueable implements System.Queueable {
    List<Contact> contactsToUpdate;

    public UpdateContactsQueueable(List<Contact> contactsToUpdate) {
        this.contactsToUpdate = contactsToUpdate;
    }

    public void execute(System.QueueableContext context) {
        update contactsToUpdate;
    }
}
