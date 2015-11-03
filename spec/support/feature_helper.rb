module FeatureHelper
  def select_by_text(id, text)
    find(item).find(:xpath, "option[normalize-space(text())='#{text}']").select_option
  end

  def select_by_value
    find(item).find(:xpath, "option[value='#{text}']").click
  end
end