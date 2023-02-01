/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 02-01-2023
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
@isTest
public class UpdateContactsTest {
    static testMethod void testUpdateContacts_LessThan200Contacts() {
        Account account = new Account(PushToVendor__c = 'Yes');
        insert account;
        List<Contact> contacts = new List<Contact>();
        for(Integer i=0; i<200; i++) {
            contacts.add(new Contact(AccountId = account.Id));
        }
        insert contacts;
        account.PushToVendor__c = 'No';
        update account;
        contacts = [SELECT Id, Push_Date__c FROM Contact WHERE AccountId = :account.Id];
        for(Contact con : contacts) {
            System.assertEquals(null, con.Push_Date__c);
        }
    }
    
    static testMethod void testUpdateContacts_Between200And1000Contacts() {
        Account account = new Account(PushToVendor__c = 'Yes');
        insert account;
        List<Contact> contacts = new List<Contact>();
        for(Integer i=0; i<500; i++) {
            contacts.add(new Contact(AccountId = account.Id));
        }
        insert contacts;
        account.PushToVendor__c = 'No';
        update account;
        contacts = [SELECT Id, Push_Date__c FROM Contact WHERE AccountId = :account.Id];
        for(Contact con : contacts) {
            System.assertEquals(null, con.Push_Date__c);
        }
    }
    
    static testMethod void testUpdateContacts_MoreThan1000Contacts() {
        Account account = new Account(PushToVendor__c = 'Yes');
        insert account;
        List<Contact> contacts = new List<Contact>();
        for(Integer i=0; i<1500; i++) {
            contacts.add(new Contact(AccountId = account.Id));
        }
        insert contacts;
        account.PushToVendor__c = 'No';
        update account;
        contacts = [SELECT Id, Push_Date__c FROM Contact WHERE AccountId = :account.Id];
        for(Contact con : contacts) {
            System.assertEquals(null, con.Push_Date__c);
        }
    }
}

