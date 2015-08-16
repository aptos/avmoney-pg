FactoryGirl.define do

  factory :user do
    email "zoevollersen@gmail.com"
    name "zoe vollersen"
    auth_token "vn1MjpGnFLQ5dHtB"
  end

  factory :client do
    name "Fred Jones Residence"
    rate 135
    address "1 Aptos Creek Road\nAptos, CA 95003"
    deliveries "100 Soquel Rd\nAptos, CA 95003"
    contact "Fred Jones"
    email "fred@bedrock.com"
    phone "(831) 555-1212"
  end

  factory :invoice do
    invoice_number 3
    po_number "abc-1234"
    wo_number "987"
    hours_sum 1
    hours_amount 135
    expenses 100.00
    tax 10
    invoice_total 245.00
    open_date '2015-01-01'
    paid_date '2015-02-01'
    paid 245.00
  end
end