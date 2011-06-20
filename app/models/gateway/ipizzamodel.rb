class Gateway::Ipizzamodel < Gateway
  def provider_class
    self.class
  end

  def test?
    options[:test_mode] == true
  end

end
