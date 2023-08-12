# Release Flow
The main issue with using two separate branches instead of one is that you lose atomicity. In the default release-please process a release commit is merged to the same branch as everything else, so as soon as that PR is merged, all other open PRs should be updated. I'm not sure what exactly Github's behavior is with simultaneous PRs merging in case of conflicts. When we use release-please on next and want to merge to main, we have to wait for github actions to start running and in that window anything can happen on next. Thus, there can be conflicts and we'd need a conflict resolution strategy. Using 'ours' could delete changes that should have been kept, and If there are lots of automated PRs merging, this might be a common occurrence. 

In theory you can implement locking so no PRs can be merged to next while the PR to main is merging.
if you set up 2 repos, one for your change history and push that repo to the customer and they can release when they're ready

## Repo Setup
- You will need to enable Github Actions to create pull requests in this repo's settings in `/settings/actions``
- You will need to use squash and merge strategy when merging pull requests
- You will need to find-and-replace all occurrences of "my-package" with the name of your actual package throughout this repo. 

## Flow
Here we make PRs to next, with a running release-please release-pr job when commits are made to next.

When commits are made to main, we rebase next onto main. This may fail if commits are made / PRs are merged to next at the same time. 

`release.yml` and `draft-release.yml` use [concurrency](https://docs.github.com/en/actions/using-jobs/using-concurrency) set to the same value 'release' to ensure both sets of actions are run sequentially to make it easier to reason about the sequence of events. This just a starting point and you may wish to tweak this to take advantage of other features related to concurrency like [canceling in-progress jobs](https://docs.github.com/en/actions/using-jobs/using-concurrency#example-using-concurrency-to-cancel-any-in-progress-job-or-run). At the very least, the `release.yml` job should not run more than once at a time to preserve invariants about the state of the release branch and main branch. `draft-release.yml` should be able to run multiple at a time but you probably only want the latest one to run.

`pr.yml` checks for valid PR branches. A PR must be from any branch to next, or release-please--branches--next--components--my-package to main. This is separate from any other branch protection measures you might set up on your repo.