class Createconversation < ActiveRecord::Migration[6.0]
    def change
      create_table :conversations do |t|
        t.string :token
        t.timestamps
      end
    end
end
