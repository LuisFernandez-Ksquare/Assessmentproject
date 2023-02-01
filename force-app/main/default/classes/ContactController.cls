/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 02-01-2023
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
public with sharing class ContactController {
    @AuraEnabled(cacheable=true)
    public static SearchResult searchContacts(String searchKey, Integer pageNumber, Integer pageSize) {
        SearchResult result = new SearchResult();
        try {
            List<Contact> contacts = [
                SELECT Id, Name, Email, Phone
                FROM Contact
                WHERE Name LIKE :searchKey OR Email LIKE :searchKey OR Phone LIKE :searchKey
                ORDER BY Name
                LIMIT :pageSize
                OFFSET :pageSize * (pageNumber - 1)
            ];
            result.contacts = contacts;
            result.totalNumberOfContacts = [
                SELECT count()
                FROM Contact
                WHERE Name LIKE :searchKey OR Email LIKE :searchKey OR Phone LIKE :searchKey
            ];
        } catch (Exception e) {
            result.error = e.getMessage();
        }
        return result;
    }
    
    @AuraEnabled
    public static Contact createContact(Contact newContact) {
        insert newContact;
        return newContact;
    }
    
    public class SearchResult {
        @AuraEnabled public List<Contact> contacts;
        @AuraEnabled public Integer totalNumberOfContacts;
        @AuraEnabled public String error;
    }
}


  