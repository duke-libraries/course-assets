class IngestLocalFileJob
  attr_accessor :directory, :filename, :user_key, :generic_file_id

  def queue_name
    :ingest
  end

  def initialize(generic_file_id, directory, filename, user_key)
    self.generic_file_id = generic_file_id
    self.directory = directory
    self.filename = filename
    self.user_key = user_key
  end

  def run
    user = User.find_by_user_key(user_key)
    raise "Unable to find user for #{user_key}" unless user
    generic_file = GenericFile.find(generic_file_id)
    path = File.join(directory, filename)

    generic_file.label = File.basename(filename)
    generic_file.add_file(File.open(path), 'content', generic_file.label)
    generic_file.record_version_committer(user)
    generic_file.save!

    # FileUtils.rm(path)
    Sufia.queue.push(ContentDepositEventJob.new(generic_file.pid, user_key))
    # add message to user for downloaded file
    message = "The file (#{File.basename(filename)}) was successfully deposited."
    job_user.send_message(user, message, 'Local file ingest')
  rescue => error
    job_user.send_message(user, error.message, 'Local file ingest error')
  end

  def job_user
    User.batchuser
  end
end