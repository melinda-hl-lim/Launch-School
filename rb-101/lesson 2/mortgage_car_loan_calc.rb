require 'pry'

def prompt(message)
  Kernel.puts("=> #{message}")
end

def month_loan_duration(loan_duration)
  (loan_duration * 12)
end

def monthly_interest_rate(apr)
  (apr.to_f / 100) / 12
end

def monthly_payment(loan_amount, yearly_loan_duration, apr)
  j = monthly_interest_rate(apr)
  n = month_loan_duration(yearly_loan_duration)

  (loan_amount * (j / (1 - (1 + j)**(-n)))).round(2)
end

########################
# Calc mortgage script #
########################

prompt("Welcome to the Mortgage/Car Loan Calculator!")
prompt("At the end we will tell you your monthly payment due.")

loan_amount = ''
loop do
  prompt("Please enter your total loan amount:")
  loan_amount = gets().chomp().to_f

  if loan_amount <= 0
    prompt("That loan amount doesn't look right.")
  else
    break
  end
end

yearly_loan_duration = ''
loop do
  prompt("Please enter your loan duration in years:")
  yearly_loan_duration = gets().chomp().to_f

  if yearly_loan_duration <= 0
    prompt("That loan duration doesn't look right.")
  else
    break
  end
end

apr = ''
loop do
  prompt("Please enter your annual percentage rate (APR): ")
  prompt("Ex: enter 5 for a 5\% APR")
  apr = gets().chomp().to_f

  if apr.to_i <= 0
    prompt("That APR doesn't look right.")
  else
    break
  end
end

result = monthly_payment(loan_amount, yearly_loan_duration, apr).to_s

prompt("Your monthly payment amount is: #{result}.")
