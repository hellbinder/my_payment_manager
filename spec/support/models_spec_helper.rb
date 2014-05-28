module ModelsSpecHelper
  def responds_to(props)
    props.each do |s|
      it { is_expected.to respond_to(s) }
    end
  end
end