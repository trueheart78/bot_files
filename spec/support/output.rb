def capture_output
  new_stdout = StringIO.new
  old_stdout = $stdout
  $stdout = new_stdout
  yield
  $stdout.string
ensure
  $stdout = old_stdout
end
alias suppress_output capture_output
