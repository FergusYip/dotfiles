#!/usr/bin/env python3
"""
Delete Git branches that have been merged via GitHub Pull Requests.

This script:
1. Lists all local Git branches
2. Checks if each branch has an associated merged PR
3. Prompts for confirmation before deleting merged branches
"""

import subprocess
import sys
import json
from typing import Optional, Dict, List


def run_command(cmd: List[str], check: bool = True) -> subprocess.CompletedProcess:
    """Run a shell command and return the result."""
    try:
        result = subprocess.run(
            cmd,
            capture_output=True,
            text=True,
            check=check
        )
        return result
    except subprocess.CalledProcessError as e:
        print(f"Error running command: {' '.join(cmd)}")
        print(f"Error: {e.stderr}")
        if check:
            sys.exit(1)
        return e


def get_local_branches() -> List[str]:
    """Get list of local Git branches, excluding the current branch."""
    result = run_command(["git", "branch"])
    branches = []
    
    for line in result.stdout.split('\n'):
        line = line.strip()
        if line and not line.startswith('*'):
            # Remove the leading spaces and * marker
            branch = line.lstrip('* ')
            branches.append(branch)
    
    return branches


def get_current_branch() -> str:
    """Get the current Git branch."""
    result = run_command(["git", "branch", "--show-current"])
    return result.stdout.strip()


def get_merged_prs() -> Dict[str, Dict]:
    """Get all merged PRs authored by current user."""
    print("Fetching merged PRs... (this may take a moment)")
    
    # Get merged PRs with a high limit to capture all
    result = run_command([
        "gh", "pr", "list",
        "-A", "@me",
        "--state", "merged",
        "--json", "number,headRefName,title,state,mergedAt",
        "--limit", "500"
    ])
    
    prs = json.loads(result.stdout)
    
    # Create a mapping of branch name to PR info
    pr_map = {}
    for pr in prs:
        branch = pr['headRefName']
        pr_map[branch] = pr
    
    return pr_map


def check_branch_pr_status(branch: str) -> Optional[Dict]:
    """Check if a specific branch has a merged PR."""
    result = run_command([
        "gh", "pr", "list",
        "--head", branch,
        "--json", "number,headRefName,title,state,mergedAt",
        "--limit", "1"
    ], check=False)
    
    if result.returncode != 0:
        return None
    
    prs = json.loads(result.stdout)
    if not prs:
        return None
    
    pr = prs[0]
    # Check if PR is merged
    if pr.get('mergedAt'):
        return pr
    
    return None


def delete_branch(branch: str) -> bool:
    """Delete a local Git branch."""
    result = run_command(["git", "branch", "-D", branch], check=False)
    return result.returncode == 0


def confirm_deletion(branch: str, pr_info: Dict) -> bool:
    """Ask user to confirm branch deletion."""
    print(f"\n{'='*70}")
    print(f"Branch: {branch}")
    print(f"PR #{pr_info['number']}: {pr_info['title']}")
    print(f"Merged at: {pr_info['mergedAt']}")
    print(f"{'='*70}")
    
    while True:
        response = input("Delete this branch? [y/n/q] (q to quit): ").lower().strip()
        if response in ['y', 'yes']:
            return True
        elif response in ['n', 'no']:
            return False
        elif response in ['q', 'quit']:
            print("Exiting...")
            sys.exit(0)
        else:
            print("Please enter 'y' for yes, 'n' for no, or 'q' to quit.")


def main():
    """Main function to orchestrate branch deletion."""
    print("🔍 Checking for merged branches...")
    
    # Check if we're in a git repository
    result = run_command(["git", "rev-parse", "--git-dir"], check=False)
    if result.returncode != 0:
        print("Error: Not in a Git repository!")
        sys.exit(1)
    
    # Check if gh CLI is available
    result = run_command(["gh", "--version"], check=False)
    if result.returncode != 0:
        print("Error: GitHub CLI (gh) is not installed or not in PATH!")
        sys.exit(1)
    
    # Get current branch (to avoid deleting it)
    current_branch = get_current_branch()
    print(f"Current branch: {current_branch}")
    
    # Get all local branches
    branches = get_local_branches()
    if not branches:
        print("No branches found (besides current branch).")
        return
    
    print(f"Found {len(branches)} local branches to check.\n")
    
    # Get merged PRs in bulk first
    merged_prs = get_merged_prs()
    print(f"Found {len(merged_prs)} merged PRs.\n")
    
    # Track statistics
    deleted_count = 0
    skipped_count = 0
    no_pr_count = 0
    
    # Check each branch
    for branch in branches:
        # Skip main/master branches as safety measure
        if branch in ['main', 'master', 'develop', 'development']:
            print(f"⏭️  Skipping protected branch: {branch}")
            skipped_count += 1
            continue
        
        # First check if branch is in the bulk PR list
        pr_info = merged_prs.get(branch)
        
        # If not found in bulk list, check individually
        if pr_info is None:
            print(f"🔎 Checking PR status for branch: {branch}")
            pr_info = check_branch_pr_status(branch)
        
        if pr_info:
            # Branch has a merged PR
            if confirm_deletion(branch, pr_info):
                if delete_branch(branch):
                    print(f"✅ Deleted branch: {branch}")
                    deleted_count += 1
                else:
                    print(f"❌ Failed to delete branch: {branch}")
                    skipped_count += 1
            else:
                print(f"⏭️  Skipped branch: {branch}")
                skipped_count += 1
        else:
            print(f"ℹ️  Branch '{branch}' has no merged PR - skipping")
            no_pr_count += 1
    
    # Print summary
    print(f"\n{'='*70}")
    print("Summary:")
    print(f"  ✅ Deleted: {deleted_count}")
    print(f"  ⏭️  Skipped: {skipped_count}")
    print(f"  ℹ️  No merged PR: {no_pr_count}")
    print(f"{'='*70}")


if __name__ == "__main__":
    try:
        main()
    except KeyboardInterrupt:
        print("\n\nInterrupted by user. Exiting...")
        sys.exit(0)

