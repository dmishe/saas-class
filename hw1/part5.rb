class Class
  def attr_accessor_with_history(attr_name)
    attr_name = attr_name.to_s  # make sure it's a string
    attr_reader attr_name
    attr_reader attr_name+"_history"
    class_eval %Q[
      def #{attr_name}=( new_value )
        @#{attr_name+"_history"} = Array[@#{attr_name}] unless @#{attr_name+"_history"}
        
        @#{attr_name} = new_value
        @#{attr_name+"_history"}.push(new_value)
      end      
    ]
  end
end


class Foo
  attr_accessor_with_history :bar
end
