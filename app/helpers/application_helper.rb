module ApplicationHelper
  include Pagy::Frontend

  # ページタイトルを切り替えるメソッド
  def page_title(page_title = '')
    base_title = 'OATMEAL-APP'

    page_title.empty? ? base_title : "#{page_title} | #{base_title}"
  end
end
