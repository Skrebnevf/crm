# frozen_string_literal: true

class RenameTwitterToTelegramAndFacebookToWhatsapp < ActiveRecord::Migration[7.0]
  def change
    rename_column :leads, :twitter, :telegram
    rename_column :leads, :facebook, :whatsapp
    rename_column :contacts, :twitter, :telegram
    rename_column :contacts, :facebook, :whatsapp
  end
end
