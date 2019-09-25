require 'test_helper'

class SiteLayoutTest < ActionDispatch::IntegrationTest
  test "layout links" do
    get root_path #疑似的にhttpリクエストを送る
    assert_template 'static_pages/home' #指定したテンプレートが選択されたか
    assert_select 'a[href=?]', root_path,count: 2 #指定したリンクへの'a[href=?]が実行されているか
    assert_select 'a[href=?]', help_path
    assert_select 'a[href=?]', about_path
    assert_select 'a[href=?]', contact_path
    get contact_path
    assert_select "title", full_title("Contact") #titleタグにContactを含むfull_titleヘルパーがあるか
  end
end
