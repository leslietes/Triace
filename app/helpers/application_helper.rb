module ApplicationHelper
def display_date(date)
date.strftime("%B %d, %Y")
end
def display_amount(amount)
number_to_currency(amount,:unit =>'')
end
end
