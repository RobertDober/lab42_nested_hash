
def given_a_file named: required, with: required
  @files         ||= {}
  stub_file unless @orig_readable
  @files.update named => with
end
alias_method :and_given_a_file, :given_a_file

def erase_all_files
  @files = {}
  # Is it necessary to remove methods first?
  File.define_singleton_method :readable?, &@orig_readable
  File.define_singleton_method :read, &@orig_read
end

def stub_file
  @orig_readable = File.method :readable?
  @orig_read     = File.method :read
  files = @files
  File.define_singleton_method :readable? do | fn |
    !!files[ fn ]
  end
  File.define_singleton_method :read do | fn |
    files[ fn ]
  end
end
