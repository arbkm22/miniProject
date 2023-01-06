import { api, LightningElement } from 'lwc';

export default class ToggleButtonOutput extends LightningElement {
    @api checked = false;
    @api status;
    @api object;
    @api name;

    handleToggle(event) {
        const newEvent = CustomEvent('selectedrec', {
            composed: true,
            bubbles: true,
            cancelable: true,
            detail: {
                value: { 
                    name: this.name,
                    status: this.status, 
                    object: this.object,
                    // state: event.target.checked,
                }
            },
        });
        this.dispatchEvent(newEvent);
    }
}