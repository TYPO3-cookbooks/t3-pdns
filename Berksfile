source "http://chef.typo3.org:26200"
source "https://supermarket.chef.io"

metadata

def fixture(name)
  cookbook name, path: "test/fixtures/cookbooks/#{name}"
end

group :integration do
  cookbook 'apt'
  fixture 't3-pdns_test'
end
