require_relative "ownable"

class Wallet
  include Ownable
  #balanceは残高の意意
  attr_reader :balance


  def initialize(owner)
    self.owner = owner
    @balance = 0
  end

  def deposit(amount)
    @balance += amount.to_i
  end

  def withdraw(amount)
    return unless @balance >= amount
    @balance -= amount.to_i
    amount
  end

end