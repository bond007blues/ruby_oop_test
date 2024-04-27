require_relative "shopping_app/seller"
require_relative "shopping_app/item"
require_relative "shopping_app/customer"

#販売者インスタンスを生成しつつ、自信をオーナーとしたwalletインスタンスも生成される
seller = Seller.new("DICストア")
10.times{ Item.new(1, "CPU", 40830, seller) }
10.times{ Item.new(2, "メモリー", 13880, seller) }
10.times{ Item.new(3, "マザーボード", 28980, seller) }
10.times{ Item.new(4, "電源ユニット", 8980, seller) }
10.times{ Item.new(5, "PCケース", 8727, seller) }
10.times{ Item.new(6, "3.5インチHDD", 10980, seller) }
10.times{ Item.new(7, "2.5インチSSD", 13370, seller) }
10.times{ Item.new(8, "M.2 SSD", 12980, seller) }
10.times{ Item.new(9, "CPUクーラー", 13400, seller) }
10.times{ Item.new(10, "グラフィックボード", 23800, seller) }

#Customerインスタンスをローカル変数に代入
puts "🤖 あなたの名前を教えてください"
customer = Customer.new(gets.chomp)

#Customoer<User同時に生成されるclass Walletインスタンスのdepositメソッドに値を渡す
#すなわち@balanceにgets.chomp.to_iが入力される
puts "🏧 ウォレットにチャージする金額を入力にしてください"
customer.wallet.deposit(gets.chomp.to_i)

puts "🛍️ ショッピングを開始します"
end_shopping = false
while !end_shopping do
  puts "📜 商品リスト"
  seller.items_list

  puts "️️⛏ 商品番号を入力してください"
  number = gets.to_i

  puts "⛏ 商品数量を入力してください"
  quantity = gets.to_i

  # numberと対応した自身の所有するItemインスタンスを指定されたquantitiy分返します。
  items = seller.pick_items(number, quantity)

  items&.each{|item| customer.cart.add(item) }

  puts "🛒 カートの中身"
  # 自身の所有するItemインスタンスの在庫状況を、["番号", "商品名", "金額", "数量"]という列でテーブル形式にして出力します。
  customer.cart.items_list
  puts "🤑 合計金額: #{customer.cart.total_amount}"

  puts "😭 買い物を終了しますか？(yes/no)"
  end_shopping = gets.chomp == "yes"
end

#ここが課題で問われている部分。よってここが正しく処理されないといけない。
puts "💸 購入を確定しますか？(yes/no)"
customer.cart.check_out if gets.chomp == "yes"

puts "୨୧┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈結果┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈୨୧"
puts "️🛍️ ️#{customer.name}の所有物"
customer.items_list
puts "😱👛 #{customer.name}のウォレット残高: #{customer.wallet.balance}"

puts "📦 #{seller.name}の在庫状況"
seller.items_list
puts "😻👛 #{seller.name}のウォレット残高: #{seller.wallet.balance}"

puts "🛒 カートの中身"
customer.cart.items_list
puts "🌚 合計金額: #{customer.cart.total_amount}"

puts "🎉 終了"
