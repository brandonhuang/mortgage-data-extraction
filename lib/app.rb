require 'pry'
require_relative 'image_processors/tesseract_ocr'
require_relative 'text_extractors/pdf_reader'
require_relative 'extractor.rb'
require_relative 'converter.rb'

# training data
train_data = "ALT Mortgages MORTGAGE APPLICATION Sep-14-2015 19:25:25 PM EST Huang, Brandon ALTM-55 Page 1 of 2 APPLICANT Applicant Name: Mr. Brandon Huang Address: 1938 West 44th Avenue, BC V6M 2E7 Residential Status: Own Time at residence: 3 Years Work Phone: 250-555-1234 x0 Cell Phone: 250-555-1234 Home Phone: Fax Number: 250-555-1234 eMail: jsmith@jsmith.ca Marital Status: Married Date of Birth:ul-31-1998 Dependents: SIN: Current Employer: XYZ Manufacturing Time at job: 6 Years Occupation: Professional Job Title: Production Manager Employment Type: Full Time Self Employed: No Annual Income: $ 85,000.00 Other Income Type Description Period Amount Total: Financial Assets Description Value Savings BNS Account $ 10,000.00 RRSP RBC Mutual Fund $ 3,000.00 Vehicle 1967 Mustang $ 25,000.00 Stocks/Bonds/Mutual Apple $ 1,000.00 Household Goods Comic collection $ 3,000.00 Life Insurance Surrender Value $ 30,000.00 Total: $ 72,000.00 Liabilities Description Value Balance Monthly Payment Payoff Credit Card BNS Master Card $ 10,000.00 $ 1,200.00 $ 36.00 Totals $ 10,000.00 $ 1,200.00 $ 36.00 ALT Mortgages #Box 12103 - 1780 - 555 West Hastings Street Vancouver, British Columbia, V6B4W6 Agent : Jared Stanley Phone: , Fax:ALT Mortgages MORTGAGE APPLICATION Sep-14-2015 09:25:25 PM EST Smith, John ALTM-55 Page 2 of 2 FINANCING Requested Mortgage Lender: <Not Assigned> Product Name: Loan Type: Mortgage Purpose: Refinance - Refinance existing mortgage Mortgage Type: First Closing Date:Sep-30-15 Payment Frequency: Monthly Purchase/Value: $ 550,000.00 Insurance Premium: $ 0.00 Monthly Payment: $ 565.58 Total Mortgage Amount: $ 125,000.00 Net Rate:2.590% Term: 5 Years Amortization25 Years Repayment Type: Principal And Interest Down Payment Source Description Amount $ 0.00 Total $ 0.00 Refinance / Switch / ETO Mortgage Type: First Mortgage Balance: $ 125,000.00 Frequency Payment: $ 700.00 Payment Frequency:Monthly Maturity Date: Sep-30-17 Rate Type: Fixed Term Type: Closed Mtg Interest Rate: 3.000% Mortgage Holder: BNS Loan Type: Mortgage Original Mtg Amt: $ 140,000.00 Mortgage #: Blended Amortization:N Purpose: Refinance No Insured: Insurer: Insurance Account #: Original Purchase Price: Purchase Date: PROPERTY Property Address: 1234 Elm Street Vancouver, BC V5Y 0E8 Lot: Block: Concession/Township: Appraised Date: Occupancy: Owner-Occupied Age: 4 Years Heating Type: Forced Air Gas/Oil/Electric Living Space: 3000 Sq Ft Detached 1000 Sq Ft Lot Size: Dwelling Type: Dwelling Style:ne Storey Garage Size: Single Garage Type: Attached Taxation Year: 2014 Taxes Paid By: Borrower Environmental Hazard: No Purchase Price: Estimated Value: $ 550,000.00 Appraised Value: Heating Cost: $ 125.00 Condo Fees: $ 0.00 Annual Taxes: $ 2,500.00 Improvements: Value of Improvements: Rental Property Expense Monthly Rental Income: $ 0.00 Rental Offset Option: None Offset %: 0 Insurance: $ 0.00 Hydro: $ 0.00 Management Expenses: $ 0.00 Repairs: $ 0.00 Interest Charges: 0.00 General Expenses: $ 0.00 Total Expense: $ 333.33 ALT Mortgages #Box 12103 - 1780 - 555 West Hastings Street Vancouver, British Columbia, V6B4W6 Agent : Jared Stanley Phone: , Fax:"
train_hash = {
  name: "Mr. Brandon Huang",
  assets: "Savings BNS Account $ 10,000.00 RRSP RBC Mutual Fund $ 3,000.00 Vehicle 1967 Mustang $ 25,000.00 Stocks/Bonds/Mutual Apple $ 1,000.00 Household Goods Comic collection $ 3,000.00 Life Insurance Surrender Value $ 30,000.00 Total: $ 72,000.00",
  liabilities: "Credit Card BNS Master Card $ 10,000.00 $ 1,200.00 $ 36.00 Totals $ 10,000.00 $ 1,200.00 $ 36.00",
  existing_mortgage: "$ 140,000.00",
  requested_mortgage: "$ 125,000.00",
  propert_age: "4 Years",
  living_space: "1000 Sq Ft",
  lot_size: "3000 Sq Ft",
  dwelling_type: "Detached",
  garage_size: "Single",
  garage_type: "Attached"
}

# Initialize extractor and set key hash
extractor = Extractor.new(Dir.pwd + "/lib/extractor_keys/keys.json")

# convert to string
data = Converter.call(Dir.pwd + "/images/app.pdf")

# extract data
pp extractor.extract(data, {
  split_assets: :assets,
  split_liabilities: :liabilities
})

