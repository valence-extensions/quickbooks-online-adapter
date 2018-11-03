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
global with sharing class QuickbooksAdapter implements valence.NamedCredentialAdapter, valence.SchemaAdapter, valence.ConfigurableSourceAdapter, valence.SourceAdapterForPull {

	/** The expected datetime formatting that the API needs for Datetime literals (ISO 8601) */
	public final static String API_DATETIME_FORMAT = 'yyyy-MM-dd\'T\'HH:mm:ss.SSSZ';

	private String namedCredentialName = null;

	private Configuration config = null;

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
			valence.Table.create('Account').withLabel('Account').withDescription('').setCreateable(true).setUpdateable(true).build(),
			valence.Table.create('Attachable').withLabel('Attachable').withDescription('').setCreateable(true).setUpdateable(true).build(),
			valence.Table.create('Bill').withLabel('Bill').withDescription('').setCreateable(true).setUpdateable(true).build(),
			valence.Table.create('BillPayment').withLabel('Bill Payment').withDescription('').setCreateable(true).setUpdateable(true).build(),
			valence.Table.create('Budget').withLabel('Budget').withDescription('').setCreateable(false).setUpdateable(false).build(),
			valence.Table.create('Class').withLabel('Class').withDescription('').setCreateable(true).setUpdateable(true).build(),
			valence.Table.create('CompanyInfo').withLabel('Company Info').withDescription('').setCreateable(false).setUpdateable(false).build(),
			valence.Table.create('CreditMemo').withLabel('Credit Memo').withDescription('').setCreateable(true).setUpdateable(true).build(),
			valence.Table.create('Customer').withLabel('Customer').withDescription('').setCreateable(true).setUpdateable(true).build(),
			valence.Table.create('Department').withLabel('Department').withDescription('').setCreateable(true).setUpdateable(true).build(),
			valence.Table.create('Deposit').withLabel('Deposit').withDescription('').setCreateable(true).setUpdateable(true).build(),
			valence.Table.create('Employee').withLabel('Employee').withDescription('').setCreateable(true).setUpdateable(true).build(),
			valence.Table.create('Estimate').withLabel('Estimate').withDescription('').setCreateable(true).setUpdateable(true).build(),
			valence.Table.create('Invoice').withLabel('Invoice').withDescription('').setCreateable(true).setUpdateable(true).build(),
			valence.Table.create('Item').withLabel('Item').withDescription('').setCreateable(true).setUpdateable(true).build(),
			valence.Table.create('JournalEntry').withLabel('Journal Entry').withDescription('').setCreateable(true).setUpdateable(true).build(),
			valence.Table.create('Payment').withLabel('Payment').withDescription('').setCreateable(true).setUpdateable(true).build(),
			valence.Table.create('PaymentMethod').withLabel('Payment Method').withDescription('').setCreateable(true).setUpdateable(true).build(),
			valence.Table.create('Preferences').withLabel('Preferences').withDescription('').setCreateable(false).setUpdateable(true).build(),
			valence.Table.create('Purchase').withLabel('Purchase').withDescription('').setCreateable(true).setUpdateable(true).build(),
			valence.Table.create('PurchaseOrder').withLabel('Purchase Order').withDescription('').setCreateable(true).setUpdateable(true).build(),
			valence.Table.create('RefundReceipt').withLabel('Refund Receipt').withDescription('').setCreateable(true).setUpdateable(true).build(),
			valence.Table.create('SalesReceipt').withLabel('Sales Receipt').withDescription('').setCreateable(true).setUpdateable(true).build(),
			valence.Table.create('TaxAgency').withLabel('Tax Agency').withDescription('').setCreateable(true).setUpdateable(false).build(),
			valence.Table.create('TaxCode').withLabel('Tax Code').withDescription('').setCreateable(false).setUpdateable(false).build(),
			valence.Table.create('TaxRate').withLabel('Tax Rate').withDescription('').setCreateable(false).setUpdateable(false).build(),
			valence.Table.create('Term').withLabel('Term').withDescription('').setCreateable(true).setUpdateable(true).build(),
			valence.Table.create('TimeActivity').withLabel('Time Activity').withDescription('').setCreateable(true).setUpdateable(true).build(),
			valence.Table.create('Transfer').withLabel('Transfer').withDescription('').setCreateable(true).setUpdateable(true).build(),
			valence.Table.create('Vendor').withLabel('Vendor').withDescription('').setCreateable(true).setUpdateable(true).build(),
			valence.Table.create('VendorCredit').withLabel('Vendor Credit').withDescription('').setCreateable(true).setUpdateable(true).build()
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

	// --------------------------------------------
	// ---- ConfigurableSourceAdapter methods -----
	// --------------------------------------------

	/**
	 * You can use your own Lightning component to let Users build and edit your configuration. If you want to do this, return the fully qualified
	 * name of your component, which looks like this:
	 *
	 * valence:MyAwesomeAdapterConfigurator
	 *
	 * Make sure your component is set to global so that Valence can instantiate it.
	 *
	 * @param context Information about this Link
	 *
	 * @return The name of your Lightning component that will handle configuration, or null if you don't need your own component
	 */
	public String getSourceConfigurationLightningComponent(valence.LinkContext context) {
		return null;
	}

	/**
	 * If you don't need or don't want to use your own Lightning Component, you can simply describe your configuration shape and we will present
	 * the user with some basic input fields to populate values in your configuration.
	 *
	 * @param context Information about this Link
	 *
	 * @return A serialized JSON object describing your configuration data structure, or null if you use your own component
	 */
	public String getSourceConfigurationStructure(valence.LinkContext context) {
		return JSON.serialize(new Map<String, Object>{
			'description' => 'We need the Quickbooks Company Id value in order to talk to the API.',
			'fields' => new List <Map<String, Object>>{
				new Map<String, Object>{
					'name' => 'realmId',
					'attributes' => new Map<String, Object>{
						'label' => 'Company Id'
					}
				}
			}
		});
	}

	/**
	 * Given configuration data, return a user-friendly paragraph that explains how this specific configuration
	 * is going to be used by your class and what effect that will have on the Link being run.
	 *
	 * We show this in the user interface to help Users understand the impact of their configurations.
	 *
	 * @param context Information about this Link
	 * @param configuration The raw configuration
	 *
	 * @return A human-readable and friendly explanation that specifically reflects and explains the configuration passed.
	 */
	public String explainSourceConfiguration(valence.LinkContext context, String configurationData) {

		try {
			Configuration config = (QuickbooksAdapter.Configuration)JSON.deserialize(configurationData, QuickbooksAdapter.Configuration.class);
			if(String.isNotBlank(config.realmId)) {
				return 'This Link is currently configured to use the <span class="slds-text-color_weak">' + config.realmId + '</span> Company Id.';
			}
			else {
				return '<span class="slds-text-color_error">This Link has not had its Company Id set, and needs one in order to talk to Quickbooks.</span>';
			}
		}
		catch(Exception e) {
			return '<span class="slds-text-color_error">The current configuration is malformed and needs to be fixed before this Link will work.</span>';
		}
	}

	/**
	 * Sets configuration data for your Adapter. This is the first method called on your Adapter during Link execution.
	 *
	 * @param context Information about this Link and the current execution of it.
	 * @param configurationData Configuration data in JSON format, or in whatever format your custom configuration component gave us.
	 */
	public void setSourceConfiguration(valence.LinkContext context, String configurationData) {

		try {
			config = (QuickbooksAdapter.Configuration)JSON.deserialize(configurationData, QuickbooksAdapter.Configuration.class);
		}
		catch(Exception e) {
			throw new valence.AdapterException('Cannot parse the Quickbooks source adapter configuration: ' + configurationData);
		}
	}

	// --------------------------------------------
	// ---- SourceAdapterForPull methods ----------
	// --------------------------------------------

	/**
	 * This method helps you to scale seamlessly to fetch large numbers of records. We do this by splitting requests
	 * out into separate execution contexts, if need be.
	 *
	 * Valence will call planFetch() on your Adapter first, and then start calling fetchRecords(). The number of times
	 * fetchRecords() is called depends on what you return from planFetch(). Every call to fetchRecords() will be in
	 * its own execution context with a new instance of your Adapter, so you'll lose any state you have in your class.
	 *
	 * @param context Information about this Link and the current execution of it.
	 *
	 * @return
	 */
	public valence.FetchStrategy planFetch(valence.LinkContext context) {

		return valence.FetchStrategy.immediate();
	}

	/**
	 * Second, we will call this method sequentially with scopes you gave us in response to planPush(). We give you your
	 * scope back so you can use it as needed.
	 *
	 * If you need to mark errors as failed or warning, use the addError() and addWarning() methods on RecordInFlight.
	 *
	 * @param context Information about this Link and the current execution of it.
	 * @param scope A single scope instance from the List of scopes returned by planFetch()
	 *
	 * @return All of the records that have been updated since the timestamp passed inside LinkContext.
	 */
	public List<valence.RecordInFlight> fetchRecords(valence.LinkContext context, Object scope) {

		List<valence.RecordInFlight> records = new List<valence.RecordInFlight>();

		valence.JSONParse response = fetchRecords(context);

		System.debug(LoggingLevel.WARN, response.toStringPretty());

		for(valence.JSONParse item : response.get('QueryResponse.' + context.linkSourceName).asList()) {
			records.add(new valence.RecordInFlight((Map<String, Object>)item.getValue()));
		}

		return records;
	}

	// --------------------------------------------
	// ---- Helper methods ------------------------
	// --------------------------------------------

	private valence.JSONParse countRecords(valence.LinkContext context) {

		return queryAPI(context, true);
	}

	private valence.JSONParse fetchRecords(valence.LinkContext context) {

		return queryAPI(context, false);
	}

	private valence.JSONParse queryAPI(valence.LinkContext context, Boolean count) {

		HttpRequest req = new HttpRequest();
		req.setMethod('GET');
		req.setTimeout(120000);
		req.setHeader('Accept', 'application/json');
		req.setEndpoint('callout:' + namedCredentialName + '/v3/company/' + config.realmId + '/query?query=' + buildQuery(context.linkSourceName, context.lastSuccessfulSync, count));

		HttpResponse res = new Http().send(req);

		valence.JSONParse response = new valence.JSONParse(res.getBody());

		return response;
	}

	private static String buildQuery(String tableName, Datetime lastModified, Boolean count) {

		String query = 'SELECT ' + (count ? 'COUNT(*)' : '*') + ' FROM ' + tableName;

		if(lastModified != null)
			query += ' WHERE Metadata.LastUpdatedTime >= ' + lastModified.format(API_DATETIME_FORMAT);

		return EncodingUtil.urlEncode(query, 'UTF-8');
	}

	/**
	 * Simple class for holding the configuration needed for this filter.
	 */
	private class Configuration {
		private String realmId;
	}
}