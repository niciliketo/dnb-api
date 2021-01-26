# Adding Endpoints

D&B have a lot of endpoints, so not all are covered here (yet).

Below are the basic steps to add a new endpoint

1. Add a method to client.rb. Use a name that is similar to the endpoint
2. Add the same method to real_client.rb
   1. Copy another method from that file
   2. Probably also need to add a constant to constants.rb to represent the API URL
3. Add a spec to test_real_client.rb
   1. Create the spec
   2. Use a new vcr_cassette with an appropriate name
   3. Temporarily replace the api credentials with real ones
   4. Run the spec
   5. Make sure the cassette has correct data in it (real results from the api)
   6. Edit the cassette to have dummy API credentials in it (so we dont commit them to the repo)
   7. Edit the vcr_cassette to amend secret keys
   8. Edit the test to have dummy API credentials in it (so we dont commit them to the repo)
   9. Edit the test to have an appropriate check
   10. Run the test again to make sure it works
   11. Temporarily add this code to the test (after the response is retrieved), replacing <method_name> with the method name you are testing

```ruby
        File.open('dummy_responses/<method_name>.json','w') do |f|
          f.write(result.to_json)
        end
```
  10. Check a copy of the response is saved in dummy responses and consider formatting it (we will use this for the dummy_client.rb spec)
  11. Remove the 3 lines above used to save a copy of the response
4. Add the same method to dummy_client.rb
   1. Reference the json you created above
5. Add a spec to test_dummy_client.rb
   1. Copy an existing test from test_dummy_client.rb
   2. Change the code to check the new API endpoint
   3. Change the check to check the same thing as the real client test
6. Run the test suite, make sure everything passes
7. Consider manually testing the new endpoint
8. Add an example to the README
9. Commit