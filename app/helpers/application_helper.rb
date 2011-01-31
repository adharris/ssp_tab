module ApplicationHelper

  def format_phone(phone)
    "(#{phone[0..2]}) #{phone[3..5]}-#{phone[6..9]}"
  end
end
