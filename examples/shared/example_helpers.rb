# frozen_string_literal: true

##################################
# Helper methods for use in examples
# ##################################

def print_error(response:)
  error = response.error
  puts 'Request was not successful.'
  puts "Status: #{error.status}"
  puts "Title: #{error.title}"
  puts "Type: #{error.type}"
  puts "Detail: #{error.detail}"
  puts "Errors: #{error.errors}"
end
