class OrderedJobs

  def initialize(jobs)
    @jobs = jobs
  end

  def process
    raise Exception.new("Job should not depend on itself.") if has_self_dependancy?
    raise Exception.new("Jobs should not have circular dependencies.") if has_circular_dependency?
    job_sequence.join
  end

  private

  def job_sequence
    jobs = job_hash.keys
    job_hash.each do |job, dependency|
      if jobs.include?(dependency)
        job_index = jobs.index(job)
        jobs.insert(job_index, dependency)
      end
    end
    jobs.uniq
  end

  def job_hash
    job_hash = {}
    job_ar = @jobs.split(",").map(&:lstrip)
    job_ar.each do |job|
      job_hash[job[0]] = job[-1]
    end
    job_hash
  end

  def has_self_dependancy?
    self_dependent = false
    job_hash.each do |job, dependency|
      self_dependent = true if job == dependency
    end
    self_dependent
  end

  def has_circular_dependency?
    circular_dependency = false
    job_hash.each do |job, dependency|
      unless dependency == " "
        return true if job_sequence.index(dependency) > job_sequence.index(job)
      end
    end
    circular_dependency
  end
end