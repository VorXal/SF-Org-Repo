import { LightningElement, api } from 'lwc';
import { deleteRecord } from 'lightning/uiRecordApi';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { NavigationMixin } from 'lightning/navigation';
import { refreshApex } from '@salesforce/apex';


export default class ToDoListItem extends LightningElement {
    @api todo;
    status;

    renderedCallback() {
        let styleList = this.template.querySelector(".slds-accordion__section").classList;

        switch (this.todo["Category__c"]) {
            case 'Today':
                styleList.add("red");
                break;
            case 'Tomorrow':
                styleList.add("yellow");
                break;
            case 'Later':
                styleList.add("green");
                break;
            default:
                break;
        }
    }

    showOrHideContent(e) {
        const sectionParent = e.currentTarget.parentNode.parentNode.parentNode;
        if (sectionParent.classList.contains("slds-is-open")) {
            sectionParent.classList.remove("slds-is-open")
        } else {
            sectionParent.classList.add("slds-is-open");
        }
    }

    handleEdit(event) {
        this.dispatchEvent(new CustomEvent('edit', {detail: this.todo.Id}));
    }

    async handleDelete(event) {
        try {
            await deleteRecord(this.todo.Id);
            this.dispatchEvent(new ShowToastEvent({
                title: 'Success',
                message: 'Record deleted',
                variant: 'success'
            }));
            this.dispatchEvent(new CustomEvent('delete'));
        } catch (error) {
            console.error(error);
        }
    }
}