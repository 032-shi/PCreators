document.addEventListener("turbolinks:load", function () { //1行目、ページ初回訪問時にjavascriptを動作させるため、追記
  $(function() {
    // プルダウンメニューを選択することでイベントが発生
    $("select[name=search_sort]").change(function() {

      // 選択したoptionタグのvalue属性を取得する
      var this_value = $(this).val();
      // value属性の値により、ページ遷移先の分岐
      if (this_value == "price_asc") {
        html = "&sort=price+asc"
      } else if (this_value == "price_desc") {
        html = "&sort=price+desc"
      } else {
        html = ""
      };
      // 現在の表示ページ
      var current_html = window.location.href;
      // ソート機能の重複防止
      if (location['href'].match(/&sort=*.+/) != null) {
        var remove = location['href'].match(/&sort=*.+/)[0]
        var current_html = current_html.replace(remove, '')
      };
      // ページ遷移
      window.location.href = current_html + html
    });
    // ページ遷移後の挙動
    $(function () {
      // 表示URLに"&sort="がある場合のみ実行
      if (location['href'].match(/&sort=*.+/) != null) {
        // 現在のoptionタグにselected属性が与えられている場合、削除する。
        if ($('select option[selected=selected]')) {
          $('select option:first').prop('selected', false);
        }
        // 表示ページURLの"/&sort="以下記述を取得して、replaceメソッドにより"/&sort="を無に返します。
        var selected_option = location['href'].match(/&sort=*.+/)[0].replace('&sort=', '');
        // 上記で取得した値により条件分岐する。
        if(selected_option == "price+asc") {
          var sort = 1
        } else if (selected_option == "price+desc") {
          var sort = 2
        }
        // selectタグ内のoptionタグをchildreメソッドで取得すると配列で返されるため、
        // 上記でif文で取得した値を、代入すると、選択したオプションタグを取得することができる。
        var add_selected = $('select[name=search_sort]').children()[sort]
        // 選択したオプションタグへpropメソッドにより、seletcted属性を付与する。
        $(add_selected).prop('selected', true)
      }
    });
  });
});