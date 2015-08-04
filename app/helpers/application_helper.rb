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

  def indefinite_articlerize(params_word)
    %w(a e i o u).include?(params_word[0].downcase) ? "an #{params_word}" : "a #{params_word}"
  end

  def error_messages_for(model)
    render partial: "/layouts/error_messages", locals: { error_model: model }
  end
end
