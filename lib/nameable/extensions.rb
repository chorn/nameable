class Object
  def Nameable(name)
    Nameable::Latin.new.parse(name).to_s
  end
end
