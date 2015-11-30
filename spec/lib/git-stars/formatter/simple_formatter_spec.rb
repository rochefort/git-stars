require 'spec_helper'

RSpec.describe GitStars::SimpleFormatter do
  describe '#output' do
    context 'result count is 0' do
      before { @formatter = GitStars::SimpleFormatter.new({}) }
      it { expect { @formatter.output([]) }.to raise_error(GitStars::NoResultError) }
    end
  end
end
