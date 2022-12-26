import { LightningElement } from 'lwc';
import noHeader from '@salesforce/resourceUrl/NoHeader';
import { loadStyle } from 'lightning/platformResourceLoader';

export default class OrgHandler extends LightningElement {
    connectedCallback() {
        loadStyle(this, noHeader)
            .then(result => {});
    }
}