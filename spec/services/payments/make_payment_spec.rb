require 'rails_helper'

module Payments
  RSpec.describe MakePayment do

    describe 'payment amount less than sponsor cashbox amount' do
      it 'make payment to destination cashbox' do
        sponsor_cashbox = Cashbox.create
        sponsorhsip_cashbox = Cashbox.create
        create(:payment, destination: sponsor_cashbox, amount: 1000)
        MakePayment.call(source: sponsor_cashbox,
                         destination: sponsorhsip_cashbox,
                         amount: 400)

        expect(sponsor_cashbox.total).to eq(600)
        expect(sponsorhsip_cashbox.total).to eq(400)

      end
    end

    describe 'payment amount more than sponsor cashbox amount' do
      it 'does not make payment to destination cashbox' do
        sponsor_cashbox = Cashbox.create
        sponsorhsip_cashbox = Cashbox.create
        create(:payment, destination: sponsor_cashbox, amount: 1000)
        res = MakePayment.call(source: sponsor_cashbox,
                         destination: sponsorhsip_cashbox,
                         amount: -1)

        expect(res[:errors]).to eq("Amount exceeds cashbox amount")

        expect(sponsor_cashbox.total).to eq(1000)
        expect(sponsorhsip_cashbox.total).to eq(0)
      end
    end
  end
end