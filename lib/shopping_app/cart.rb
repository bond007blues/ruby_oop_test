require_relative "ownable"
require_relative "item_manager"

class Cart
  include Ownable
  include ItemManager

  def initialize(owner)
    self.owner = owner
    @items = []
  end

  def items
    # Cartにとってのitemsは自身の@itemsとしたいため、ItemManagerのitemsメソッドをオーバーライドします。
    # CartインスタンスがItemインスタンスを持つときは、オーナー権限の移譲をさせることなく、自身の@itemsに格納(Cart#add)するだけだからです。
    @items
  end

  def add(item)
    @items << item
  end

  def total_amount
    @items.sum(&:price)
  end

  def check_out
    return if owner.wallet.balance < total_amount
  # ## 要件
  #   - カートの中身（Cart#items）のすべてのアイテムの購入金額が、カートのオーナーのウォレットからアイテムのオーナーのウォレットに移されること。
  #   - カートの中身（Cart#items）のすべてのアイテムのオーナー権限が、カートのオーナーに移されること。
  #   - カートの中身（Cart#items）が空になること。

  # ## ヒント
  #   - カートのオーナーのウォレット ==> self.owner.wallet
  #   - アイテムのオーナーのウォレット ==> item.owner.wallet
  #   - アイテムのオーナー権限がカートのオーナーに移されること ==> オーナーの書き換え(item.owner = ?)
  # カート内のアイテムを一つずつ処理
  @items.each do |item|
    # アイテムのオーナーのウォレットに合計金額を移動
    item_owner_wallet = item.owner.wallet
    owner_wallet = self.owner.wallet

    # カートのオーナーのウォレットからアイテムのオーナーのウォレットに金額を移動
    withdrawn_amount = owner_wallet.withdraw(item.price)
    item_owner_wallet.deposit(withdrawn_amount)

    # アイテムのオーナー権限をカートのオーナーに移す
    item.owner = self.owner
  end

  # カートの中身を空にする
  @items.clear
  end

end
