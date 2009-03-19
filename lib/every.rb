class Every
  instance_methods.each { |m| undef_method(m) unless m.match(/^__/) }

  def initialize(obj, method)
    @obj = obj
    @method = method
  end

  def method_missing(method, *args, &block)
    @obj.send(@method) {|o| o.__send__(method, *args, &block) }
  end
end

[Array, Enumerable].each do |m|
  %w(all? any? collect detect find find_all map partition reject select sort_by).each do |name|
    m.class_eval %{
      alias_method :old_#{name}, :#{name} # alias_method :old_map, :map

      def #{name}(&block)                 # def map(&block)
        if block                          #   if block
          old_#{name}(&block)             #     old_map(&block)
        else                              #   else
          Every.new(self, :#{name})       #     Every.new(self, :map)
        end                               #   end
      end                                 # end
    }
  end
end

module Enumerable
  def every
    map
  end
end

