class CreateAlertMessages < ActiveRecord::Migration
  def change
    create_table :alert_messages do |t|
      t.text :message
      t.boolean :active
    end
  end
end
