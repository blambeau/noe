require 'spec_helper'
module Noe
  describe "Hash#noe_merge" do
    
    subject{ left.noe_merge(right) }
    
    context 'on flat hashes' do
      
      let(:left){ {
        'only_on_left'     => 'only_on_left_value',
        'common'           => 'common_value',
        'a_common_boolean' => true,
        'a_common_integer' => 12,
        'a_common_array'   => [ 1, 2, 3 ]
      }}
    
      let(:right){ {
        'only_on_right'    => 'only_on_right_value',
        'common'           => 'common_value',
        'a_common_boolean' => false,
        'a_common_integer' => 14,
        'a_common_array'   => [ 1 ]
      }}
    
      it 'should be a simple Hash merge' do
        subject.should == left.merge(right)
      end
      
    end # on flat hashes
    
    context 'when hashes contain hashes' do
      let(:left){{
        'only_on_left' => 'only_on_left_value',
        'common_hash'  => {
          'sub_key_only_on_left' => 'sub_key_only_on_left_value',
          'common_sub_key'       => 'common_sub_key_on_left',
          'third_level' => { 'value' => 12 }
        }
      }}
      let(:right){{
        'only_on_right' => 'only_on_right_value',
        'common_hash'  => {
          'sub_key_only_on_right' => 'sub_key_only_on_right_value',
          'common_sub_key'        => 'common_sub_key_on_right',
          'third_level' => { 'value' => 13 }
        }
      }}
      let(:expected){{
        'only_on_left' => 'only_on_left_value',
        'only_on_right' => 'only_on_right_value',
        'common_hash'  => {
          'sub_key_only_on_left' => 'sub_key_only_on_left_value',
          'sub_key_only_on_right' => 'sub_key_only_on_right_value',
          'common_sub_key'       => 'common_sub_key_on_right',
          'third_level' => { 'value' => 13 }
        }
      }}
      
      it 'should override recursively' do
        subject.should == expected
      end
      
    end
    
  end # Hash#noe_merge
end # module Noe