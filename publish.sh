#!/bin/bash
# Quick publish script for sap-config-guard
# Usage: ./publish.sh YOUR_GITHUB_USERNAME

set -e

GITHUB_USERNAME=${1:-"yourusername"}

echo "🚀 Publishing sap-config-guard..."
echo ""

# Check if git is initialized
if [ ! -d .git ]; then
    echo "📦 Initializing Git repository..."
    git init
    echo "✅ Git initialized"
else
    echo "✅ Git already initialized"
fi

# Check if remote exists
if git remote | grep -q origin; then
    echo "⚠️  Remote 'origin' already exists"
    echo "Current remote: $(git remote get-url origin)"
    read -p "Do you want to update it? (y/n) " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        git remote set-url origin "https://github.com/${GITHUB_USERNAME}/sap-config-guard.git"
        echo "✅ Remote updated"
    fi
else
    echo "🔗 Adding GitHub remote..."
    git remote add origin "https://github.com/${GITHUB_USERNAME}/sap-config-guard.git"
    echo "✅ Remote added"
fi

# Update README with username
if [ "$GITHUB_USERNAME" != "yourusername" ]; then
    echo "📝 Updating README with your username..."
    if [[ "$OSTYPE" == "darwin"* ]]; then
        # macOS
        sed -i '' "s/yourusername/${GITHUB_USERNAME}/g" README.md
    else
        # Linux
        sed -i "s/yourusername/${GITHUB_USERNAME}/g" README.md
    fi
    echo "✅ README updated"
fi

# Add all files
echo "📁 Adding files to Git..."
git add .
echo "✅ Files added"

# Check if there are changes to commit
if git diff --staged --quiet; then
    echo "ℹ️  No changes to commit"
else
    echo "💾 Creating initial commit..."
    git commit -m "Initial commit: sap-config-guard v0.1.0

- Core validation engine
- Environment diff functionality  
- CLI interface
- Docker support
- Comprehensive tests and documentation"
    echo "✅ Commit created"
fi

# Push to GitHub
echo ""
echo "📤 Ready to push to GitHub!"
echo ""
echo "Run these commands:"
echo "  git branch -M main"
echo "  git push -u origin main"
echo ""
echo "Or if you want to push now, type 'y':"
read -p "Push now? (y/n) " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    git branch -M main
    git push -u origin main
    echo ""
    echo "✅ Pushed to GitHub!"
    echo ""
    echo "🎉 Next steps:"
    echo "1. Go to https://github.com/${GITHUB_USERNAME}/sap-config-guard"
    echo "2. Create a release (v0.1.0)"
    echo "3. Share with the SAP community!"
    echo ""
    echo "See NEXT_STEPS.md for detailed instructions."
else
    echo ""
    echo "📋 Manual steps:"
    echo "1. git branch -M main"
    echo "2. git push -u origin main"
    echo "3. Create GitHub repository if not exists"
    echo "4. See NEXT_STEPS.md for more details"
fi

