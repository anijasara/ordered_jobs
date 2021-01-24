load File.expand_path('../../../lib/ordered_jobs.rb', __FILE__)

describe OrderedJobs do

  describe '#process' do
    it 'should return an empty string when input is an empty string' do
      ordered_jobs = OrderedJobs.new("")
      expect(ordered_jobs.process).to eq ""
    end

    it 'should return a single job when when input is a single job' do
      ordered_jobs = OrderedJobs.new("a => ")
      expect(ordered_jobs.process).to eq "a"
    end

    it 'should return all jobs in no significant order when jobs are given without dependencies' do
      ordered_jobs = OrderedJobs.new("a => , b => , c => ")
      expect(ordered_jobs.process).to eq "abc"
    end

    it 'should return all jobs in significant order when jobs are given with dependencies' do
      ordered_jobs = OrderedJobs.new("a => , b => c, c => ")
      expect(ordered_jobs.process).to eq "acb"
    end

    it 'should return a list of jobs in significant order when multiple dependencies are given' do
      ordered_jobs = OrderedJobs.new("a => , b => c, c => f, d => a, e => b, f => ")
      expect(ordered_jobs.process).to eq "afcbde"
    end

    it 'should return a list of jobs in significant order when multiple dependencies are given eg:2' do
      ordered_jobs = OrderedJobs.new("a => b, b => c, c => d, d => e, e => ")
      expect(ordered_jobs.process).to eq "edcba"
    end

    it 'should return an error when a self dependant job included in the sequence' do
      ordered_jobs = OrderedJobs.new("a => , b => , c => c")
      expect { ordered_jobs.process }.to raise_error "Job should not depend on itself."
    end

    it 'should return an error when a self dependant job included in the sequence eg:2' do
      ordered_jobs = OrderedJobs.new("a => b, b => b, c => ")
      expect { ordered_jobs.process }.to raise_error "Job should not depend on itself."
    end

    it 'should return an error when a job that has circular dependency is present in the sequence' do
      ordered_jobs = OrderedJobs.new("a => , b => c, c => f, d => a, e => , f => b")
      expect { ordered_jobs.process }.to raise_error "Jobs should not have circular dependencies."
    end

    it 'should return an error when a job that has circular dependency is present in the sequence eg:2' do
      ordered_jobs = OrderedJobs.new("a => b, b => c, c => a")
      expect { ordered_jobs.process }.to raise_error "Jobs should not have circular dependencies."
    end
  end
end

