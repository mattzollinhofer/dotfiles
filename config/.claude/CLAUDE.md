**Key Principles:**
### Communication Style
- Assume senior developer context - be technical and direct
- Be terse over verbose - user will ask for details if needed
- Straightforward tone, not overly positive or optimistic
- Cut to the point, avoid fluff

### Important Details
- never introduce trailing whitespace
- prefer not to use regexes
- never add emoji to code
- use descriptive names over short ones
- maintain external project progress documents for handoff that contain:
   - description
   - strategy
   - todo lists
   - decisions made
   - next actions

### Git
- always read the commit skill and use it for ALL COMMITS, tell me if you can't
  find it.
- NEVER amend, reset, or rewrite git history. If you need to, ask the user first
- Always use autosquashable fixup commits instead, ex:
   - Fixup (code change targeting an existing commit):
  ```
  git commit -m "fixup! $(git log --format=%s -1 <sha>)" -m "Extra context about what changed"
  ```
   - Amend a commit message (no code change):
  ```
  git commit --allow-empty -m "amend! $(git log --format=%s -1 <sha>)" -m "Updated subject line" -m "Updated body text"
  ```

## Progress Tracking
Working notes are kept in `~/working-notes`

- keep project notes in `~/working-notes`
- regularly write progress notes, description, and todos to `~/working-notes`
   - you may create markdown files here for project/progress notes

## Context Window Tracking
- When asked, check context percentage: `cat /tmp/claude-context-pct-$PPID`




---------




Some high level notes:

- Always start any behavior change with a test. We use Test-Driven-Development
- You do not need to write tests when refactoring
- Uses structure.sql instead of schema.rb

## Code Quality Standards

### Testing

- Unit tests: exhaustive coverage of business logic
- Integration tests: simple smoke tests
- Test data should be minimal
- `assert_equal(expected, actual)` - note the argument order

#### Test Data Best Practices

- Use `build` instead of `create` when database persistence is not required
  (avoids unnecessary database writes)
- Use `subject` method with parameters to create test subjects with variable
  inputs
- Use `described_type` instead of hardcoding class names in tests

#### Test Organization and Focus

- Keep tests minimal - avoid redundant tests that test the same behavior
- Don't test framework behavior (e.g., ActiveModel presence validations)
- Test business logic, not framework features
- Combine related assertions into a single test when they verify the same
  behavior (e.g., verify all fields of a request body in one test, not separate
  tests for each field)
- One validation test per unique validation rule (not separate tests for nil vs
  empty string)

#### TDD Discipline and Avoiding Over-Testing

**The TDD Cycle:**
1. Write test first (test fails RED)
2. Write just enough code to make it pass (GREEN)
3. Need to add more code? First add to the test to make it fail (RED again)
4. Add code to make it pass (GREEN)
5. Repeat

**Check if you're over-testing:** Ask "would this test go RED without this code?"
- If YES → the behavior is tested, move on
- If NO → the test is redundant, don't write it

**When to add lower-level tests:**
- System test covers the happy path → done, no other tests needed
- Need to test validation edge cases → add form test
- Form test covers service logic → done, no service test needed
- Service has complex edge cases not in form test → add lib/service tests
- Controller has nuanced logic not in system test → add controller test

❌ **Over-testing (don't do this):**
- Separate controller test when system test covers the path
- Separate service class test when form test calls the service
- Model test for simple methods already exercised by system/form tests
- Multiple tests for the same behavior at different levels

#### WebMock and HTTP Testing

- Use existing WebMockHelper methods (e.g.,
  `WebMockHelper::MonkAPIWebMock.stub_send_email`) instead of creating custom
  stub helpers
- Use `assert_stub_requested` with a block for assertions, not lambda assertions
  in stub setup
- Assert on the full request body structure in one assertion when testing HTTP
  requests

#### System Tests

- **System tests use Experience classes - NO Capybara in test files**
- System test file only calls methods on Experience object
- All Capybara interactions go in Experience class methods
- Experience classes live in `test/support/` and inherit from `Experience`
- Pattern:
  ```ruby
  # In test/system - clean, readable workflow
  test "admin updates account settings" do
    user = create(:user)
    experience = Soccer::LeagueExperience.new(self, user)

    experience.create_league

    experience.assert_new_league
  end

  # In test/support - low-level details
  class LeagueExperience < Experience
    def update_account_settings
      set_current_user
      visit setup_league_path
      fill_in "Custom league title", with: "EPL"
      uncheck "Public league?"
      click_on "Create League"
    end

    def assert_new_league
      assert_text "Successfully created league"
      league = League.sole
      assert_not_predicate league, :public_league?
    end
  end
  ```

### Database and Performance

- Use `strict_loading` when eager loading to catch N+1 queries
- `null: false` for required columns
- For string column, always `null: false, default: ""`

### Conventions

- I18n for user-facing strings
- Use existing date/time formats from `config/locales/en.yml`
- Follow existing UI patterns (e.g., bootstrap, tables, etc)
- Use existing scopes (DRY)
- Queries should be aware of tenancy and scope by it

## Running tests

ALWAYS specify specific tests to run. Running the entire test suite takes too
long.

To run a specific test, run it by line number:

```
bin/rails test test/system/setup/account_settings_test.rb:13
```

Or by a string match (which can also be helpful for running a set of related
tests that are all in the same context block or otherwise have the same word in
their description):

```
bin/rails test test/system/setup/account_settings_test.rb -n /word/
```

## Other

- To understand a Ruby gem that you don't know, start by reading:

  ```
  cat "$(bundle show pundit)"/README.md
  ```
