require 'pathname'
require 'set'
root  =  Pathname(__FILE__).dirname.parent
require root.join('test/test_helper')
require root.join('lib/every')

class Fixnum
  def even?
    self % 2 == 0
  end
end

class EveryTest < Test::Unit::TestCase
  context "Every" do
    test "is a basic object" do
      whitelist = %w( __id__ __send__ method_missing )
      Every.instance_methods.to_set.should be(whitelist.to_set)
    end

    test "calls method on enumerable's items" do
      [1, 2, 3].all?.even?.should == false
      [1, 2, 3].any?.even?.should == true

      [1.4, 2.4, 3.4].collect.floor.should == [1, 2, 3]
      [1.4, 2.4, 3.4].map.floor.should     == [1, 2, 3]

      [1, 2, 3].detect.even?.should == 2
      [1, 2, 3].find.even?.should   == 2

      [1, 2, 3].find_all.even?.should  == [2]
      [1, 2, 3].select.even?.should    == [2]
      [1, 2, 3].reject.even?.should    == [1,3]
      [1, 2, 3].partition.even?.should == [[2], [1,3]]

      [8, 9, 10].sort_by.to_s.should == [10, 8, 9]
    end

    test "leaves default behaviour alone" do
      [1, 2, 3].all?{|x| x.even? }.should == false
      [1, 2, 3].any?{|x| x.even? }.should == true

      [1.4, 2.4, 3.4].collect{|x| x.floor }.should == [1, 2, 3]
      [1.4, 2.4, 3.4].map{|x| x.floor }.should     == [1, 2, 3]

      [1, 2, 3].detect{|x| x.even? }.should == 2
      [1, 2, 3].find{|x| x.even? }.should   == 2

      [1, 2, 3].find_all{|x| x.even? }.should  == [2]
      [1, 2, 3].select{|x| x.even? }.should    == [2]
      [1, 2, 3].reject{|x| x.even? }.should    == [1,3]
      [1, 2, 3].partition{|x| x.even? }.should == [[2], [1,3]]

      [8, 9, 10].sort_by{|x| x.to_s }.should == [10, 8, 9]
    end

    test "provides \#every as a synonym for \#map" do
      [1.4, 2.4, 3.4].every.floor.should == [1, 2, 3]
    end

    test "allows arguments" do
      %w( axb dxf ).map.gsub(/x/,'y').should be(%w( ayb dyf ))
    end

    test "allows blocks" do
      %w( axb dxf ).map.gsub(/x/) { 'y' }.should be(%w( ayb dyf ))
    end
  end
end
