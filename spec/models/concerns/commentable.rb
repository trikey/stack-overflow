shared_examples_for 'commentable' do
  it { should have_many(:comments) }
end