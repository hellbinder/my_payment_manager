module ApplicationHelper
  #retuns full title on a per page basis
  def full_title(page_title)
    base_title = "My Payment Manager"
    if page_title.empty?
      base_title
    else
      "#{base_title} | #{page_title}"
    end
  end

  def random_date_between(from, till)
    from = Date.parse(from) unless from.is_a? Date
    till = Date.parse(till) unless till.is_a? Date
    from + rand(till - from)
  end

end
