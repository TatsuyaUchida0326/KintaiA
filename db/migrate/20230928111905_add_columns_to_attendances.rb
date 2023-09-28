class AddColumnsToAttendances < ActiveRecord::Migration[5.1]
  def change
    add_column :attendances, :indicater_reply, :string
    add_column :attendances, :indicater_check, :string
    add_column :attendances, :indicater_reply_edit, :string
    add_column :attendances, :indicater_check_edit, :string
    add_column :attendances, :indicater_reply_month, :string
  end
end
