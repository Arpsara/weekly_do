class AddReceiveInvoiceToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :receive_invoice, :boolean, default: false
  end
end
