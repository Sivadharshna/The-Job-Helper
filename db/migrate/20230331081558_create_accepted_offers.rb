class CreateAcceptedOffers < ActiveRecord::Migration[6.1]
  def change
    create_table :accepted_offers do |t|
      t.datetime :schedule
      t.references :approval, polymorphic: true, index: true

      t.timestamps
    end
  end
end
