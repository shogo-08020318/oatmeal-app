require 'rails_helper'

RSpec.describe "StaticPages", type: :system do
  describe "トップページ" do
    it "トップページの表示が正常" do
      visit root_path
      expect(page).to have_content('oatmeal-app')
    end
  end
end
