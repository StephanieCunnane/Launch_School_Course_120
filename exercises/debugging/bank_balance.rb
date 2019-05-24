# The way the code was originally written, the only way for a withdrawl to fail was if the withdrawn amount was negative. The success local variable was always being set to a truthy value (the amount that was just assigned to @balance) because the implicit return of our custom balance setter was always ignored.

# In Ruby, setter methods ALWAYS return the value that was just assigned. So even if you include a further implicit or explicit return, that will just be ignored.

# We can fix this problem by making the if condition in our BankAccount#withdraw method more specific and then simplifying our @balance setter (just using the standard one created by attr_accessor).

class BankAccount
  attr_accessor :balance

  def initialize(account_number, client)
    @account_number = account_number
    @client = client
    @balance = 0
  end

  def deposit(amount)
    if amount > 0
      self.balance += amount
      "$#{amount} deposited. Total balance is $#{balance}."
    else
      "Invalid. Enter a positive amount."
    end
  end

  def withdraw(amount)
    if amount > 0 && valid_transaction?(balance - amount)
      self.balance -= amount
      "$#{amount} withdrawn. Total balance is $#{balance}."
    else
      "Invalid. Enter positive amount less than or equal to current balance ($#{balance})."
    end
  end

  def valid_transaction?(new_balance)
    new_balance >= 0
  end
end

account = BankAccount.new('5538898', 'Genevieve')
p account.balance         # => 0
p account.deposit(50)     # => $50 deposited. Total balance is $50.
p account.balance         # => 50
p account.withdraw(80)    # => Invalid. Enter positive amount less than or equal to current balance ($50).
p account.balance         # => 50

# More straightforward implementation of the BankAccount class

class BankAccount
  attr_reader :balance

  def initialize(account_number, client)
    @account_number = account_number
    @client = client
    @balance = 0
  end

  def deposit(amount)
    if amount > 0
      self.balance += amount
      "$#{amount} deposited. Total balance is $#{balance}."
    else
      'Invalid. Enter a positive amount.'
    end
  end

  def withdraw(amount)
    if amount <= 0
      return "Invalid. Enter positive amount less than or equal to current balance ($#{balance})."
    end

    if @balance - amount > 0
      self.balance -= amount
      "$#{amount} withdrawn. Total balance is $#{balance}."
    else
      "Invalid. Enter positive amount less than or equal to current balance ($#{balance})."
    end
  end

  private

  attr_writer :balance
end
