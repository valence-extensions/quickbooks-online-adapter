/*
MIT License


Copyright (c) 2018 Valence Salesforce Integration Extensions

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
*/

/**
 * Open-source Valence Adapter (http://valencedata.com) designed to talk to the Quickbooks Online API.
 *
 * @see http://docs.valencedata.com
 * @see https://developer.intuit.com/app/developer/qbo/docs/get-started
 */
global with sharing class QuickbooksAdapter implements valence.NamedCredentialAdapter, valence.SchemaAdapter {

	private String namedCredentialName = null;

	// --------------------------------------------
	// ---- NamedCredentialAdapter methods --------
	// --------------------------------------------

	public void setNamedCredential(String namedCredentialName) {
		this.namedCredentialName = namedCredentialName;
	}

	// --------------------------------------------
	// ---- SchemaAdapter methods -----------------
	// --------------------------------------------

	/**
	 * We will interrogate your adapter and ask it what tables can be interacted with.
	 *
	 * @return A List of Table definitions that will be provided to Users.
	 */
	public List<valence.Table> getTables() {

		/*
		 * Quickbook Online doesn't seem to have any sort of discovery endpoint for the entities themselves, so we've hardcoded them here.
		 */
		return new List<valence.Table>{
			valence.Table.create('account').withLabel('Account').withDescription('').setCreateable(true).setUpdateable(true).build(),
			valence.Table.create('attachable').withLabel('Attachable').withDescription('').setCreateable(true).setUpdateable(true).build(),
			valence.Table.create('bill').withLabel('Bill').withDescription('').setCreateable(true).setUpdateable(true).build(),
			valence.Table.create('billpayment').withLabel('Bill Payment').withDescription('').setCreateable(true).setUpdateable(true).build(),
			valence.Table.create('budget').withLabel('Budget').withDescription('').setCreateable(false).setUpdateable(false).build(),
			valence.Table.create('class').withLabel('Class').withDescription('').setCreateable(true).setUpdateable(true).build(),
			valence.Table.create('companyinfo').withLabel('Company Info').withDescription('').setCreateable(false).setUpdateable(false).build(),
			valence.Table.create('creditmemo').withLabel('Credit Memo').withDescription('').setCreateable(true).setUpdateable(true).build(),
			valence.Table.create('customer').withLabel('Customer').withDescription('').setCreateable(true).setUpdateable(true).build(),
			valence.Table.create('department').withLabel('Department').withDescription('').setCreateable(true).setUpdateable(true).build(),
			valence.Table.create('deposit').withLabel('Deposit').withDescription('').setCreateable(true).setUpdateable(true).build(),
			valence.Table.create('employee').withLabel('Employee').withDescription('').setCreateable(true).setUpdateable(true).build(),
			valence.Table.create('estimate').withLabel('Estimate').withDescription('').setCreateable(true).setUpdateable(true).build(),
			valence.Table.create('invoice').withLabel('Invoice').withDescription('').setCreateable(true).setUpdateable(true).build(),
			valence.Table.create('item').withLabel('Item').withDescription('').setCreateable(true).setUpdateable(true).build(),
			valence.Table.create('journalentry').withLabel('Journal Entry').withDescription('').setCreateable(true).setUpdateable(true).build(),
			valence.Table.create('payment').withLabel('Payment').withDescription('').setCreateable(true).setUpdateable(true).build(),
			valence.Table.create('paymentmethod').withLabel('Payment Method').withDescription('').setCreateable(true).setUpdateable(true).build(),
			valence.Table.create('preferences').withLabel('Preferences').withDescription('').setCreateable(false).setUpdateable(true).build(),
			valence.Table.create('purchase').withLabel('Purchase').withDescription('').setCreateable(true).setUpdateable(true).build(),
			valence.Table.create('purchaseorder').withLabel('Purchase Order').withDescription('').setCreateable(true).setUpdateable(true).build(),
			valence.Table.create('refundreceipt').withLabel('Refund Receipt').withDescription('').setCreateable(true).setUpdateable(true).build(),
			valence.Table.create('salesreceipt').withLabel('Sales Receipt').withDescription('').setCreateable(true).setUpdateable(true).build(),
			valence.Table.create('taxagency').withLabel('Tax Agency').withDescription('').setCreateable(true).setUpdateable(false).build(),
			valence.Table.create('taxcode').withLabel('Tax Code').withDescription('').setCreateable(false).setUpdateable(false).build(),
			valence.Table.create('taxrate').withLabel('Tax Rate').withDescription('').setCreateable(false).setUpdateable(false).build(),
			valence.Table.create('term').withLabel('Term').withDescription('').setCreateable(true).setUpdateable(true).build(),
			valence.Table.create('timeactivity').withLabel('Time Activity').withDescription('').setCreateable(true).setUpdateable(true).build(),
			valence.Table.create('transfer').withLabel('Transfer').withDescription('').setCreateable(true).setUpdateable(true).build(),
			valence.Table.create('vendor').withLabel('Vendor').withDescription('').setCreateable(true).setUpdateable(true).build(),
			valence.Table.create('vendorcredit').withLabel('Vendor Credit').withDescription('').setCreateable(true).setUpdateable(true).build()
		};
	}

	/**
	 * A natural follow-on from getTables, we will interrogate your adapter to
	 * find out which fields can be interacted with on a table.
	 *
	 * @param tableApiName The specific table a User is interested in, comes from your list returned by getTables()
	 *
	 * @return A List of Field definitions that will be provided to Users for consideration.
	 */
	public List<valence.Field> getFields(String tableApiName) {

		// we have no way to dynamically inspect the schema of an individual table, we'll have to let Valence discover the schema based on real record flow
		return new List<valence.Field>();
	}
}