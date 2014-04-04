require 'acts_as_votable/helpers/words'

module ActsAsVotable
  class Vote < ::ActiveRecord::Base

    include Helpers::Words

    if ::ActiveRecord::VERSION::MAJOR < 4
      attr_accessible :votable_id, :votable_type,
        :voter_id, :voter_type,
        :votable, :voter,
        :vote_flag, :vote_scope
    end

    belongs_to :votable, :polymorphic => true
    belongs_to :voter, :polymorphic => true

    scope :up, lambda{ where(:vote_flag => true) }
    scope :down, lambda{ where(:vote_flag => false) }
    scope :for_type, lambda{ |klass| where(:votable_type => klass) }
    scope :by_type,  lambda{ |klass| where(:voter_type => klass) }

    validates_presence_of :votable_id
    validates_presence_of :voter_id

    def votable_type=(klass)
      super(klass.to_s.classify.constantize.base_class.to_s)
    end

    def voter_type=(klass)
      super(klass.to_s.classify.constantize.base_class.to_s)
    end
  end

end

