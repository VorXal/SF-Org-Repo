import { LightningElement, track, wire } from 'lwc';
import searchToDos from '@salesforce/apex/ToDoController.searchToDos';
import { refreshApex } from '@salesforce/apex';

export default class TodoList extends LightningElement {

    length;
    error;
    showCreateModal = false;
    showEditModal = false;
    recordId;
    searchTerm = '';

	@wire(searchToDos, {searchTerm: '$searchTerm'})
	todos;

    handleSearchTermChange(event) {
		window.clearTimeout(this.delayTimeout);
		const searchTerm = event.target.value;
		this.delayTimeout = setTimeout(() => {
			this.searchTerm = searchTerm;
		}, 300);
	}

    updateData(){
        refreshApex(this.todos);
    }

    reload(){
        this.updateData();
    }

    showCreateModalWindow(){
        this.showCreateModal = true;
    }

    closeCreateModalWindow(){
        this.showCreateModal = false;
        this.updateData();
    }

    closeEditModalWindow(){
        this.showEditModal = false;
        this.updateData();
    }

    editRecord(event){
        this.recordId = event.detail;
        this.showEditModal = true;
    }
}