#! /bin/bash

git fetch
git checkout next
git pull -ff

B=change-1
git branch -D $B
git checkout -b $B
echo "// $B" >> $B.js
git add $B.js
git commit -m 'fix: patch bump'
git push --force-with-lease origin $B
gh pr create -H $B -B next --title "fix: patch bump" -b ''
git checkout next

B=change-2
git branch -D $B
git checkout -b $B
echo "// $B" >> $B.js
git add $B.js
git commit -m 'feat: minor bump'
git push --force-with-lease origin $B
gh pr create -H $B -B next --title "feat: minor bump" -b ''
git checkout next

B=change-3
git branch -D $B
git checkout -b $B
echo "// $B" >> $B.js
git add $B.js
git commit -m 'feat!: breaking change'
git push --force-with-lease origin $B
gh pr create -H $B -B next --title "feat!: breaking change" -b ''
git checkout next
