group :refactor, halt_on_fail: true do
  guard :minitest do
    # with Minitest::Unit
    watch(%r{^test/(.*)\/?test_(.*)\.rb$})
    watch(%r{^lib/(.*/)?([^/]+)\.rb$})     { |m| "test/#{m[1]}test_#{m[2]}.rb" }
    watch(%r{^test/test_helper\.rb$})      { 'test' }
  end

  guard :rubocop, all_on_start: false do
    watch(%r{.+\.rb$})
    watch(%r{(?:.+/)?\.rubocop\.yml$}) { |m| File.dirname(m[0]) }
  end

end