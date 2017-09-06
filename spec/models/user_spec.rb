require "rails_helper"

RSpec.describe User, type: :model do
  describe "#validation" do
    it { is_expected.to have_many(:notifications) }
    it { is_expected.to have_many(:requests) }
    it { is_expected.to have_many(:reviews) }
    it { is_expected.to have_many(:traces) }
    it { is_expected.to have_many(:works) }
    it { is_expected.to have_many(:desired_worktimes) }
    it { is_expected.to have_one(:director) }
  end
end
