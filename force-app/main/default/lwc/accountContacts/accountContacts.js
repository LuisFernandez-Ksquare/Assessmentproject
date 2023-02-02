import { LightningElement, track } from 'lwc';
import searchContacts from '@salesforce/apex/ContactController.searchContacts';
import createContact from '@salesforce/apex/ContactController.createContact';

const PAGE_SIZE = 5;

export default class ContactSearchComponent extends LightningElement {
  @track searchKey = '';
  @track contacts = [];
  @track fields = ['Name', 'Email', 'Phone'];
  @track createNewContact = false;
  @track pageNumber = 1;
  @track totalPages;
  columns = [
    { label: 'Name', fieldName: 'Name' },
    { label: 'Email', fieldName: 'Email', type: 'email' },
    { label: 'Phone', fieldName: 'Phone', type: 'phone' }
  ];

  handleSearchKeyChange(event) {
    this.searchKey = event.target.value;
  }

  searchContacts() {
    searchContacts({
      searchKey: this.searchKey,
      pageNumber: this.pageNumber,
      pageSize: PAGE_SIZE
    })
      .then(result => {
        this.contacts = result.contacts;
        this.totalPages = Math.ceil(result.totalNumberOfContacts / PAGE_SIZE);
      })
      .catch(error => {
        console.error(error);
      });
  }

  handleSuccess(event) {
    this.contacts.push(event.detail.fields);
    this.createNewcontact = false;
  }

  createContact() {
    this.createNewContact = true;
  }

  handleCancel(event) {
    this.createNewContact = false;
  }

  previousPage() {
    if (this.pageNumber > 1) {
      this.pageNumber--;
      this.searchContacts();
    }
  }

  nextPage() {
    if (this.pageNumber < this.totalPages) {
      this.pageNumber++;
      this.searchContacts();
    }
  }
}




