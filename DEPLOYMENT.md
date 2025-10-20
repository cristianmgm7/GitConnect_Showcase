# GitConnect Showcase - Deployment Guide

## 🚀 Step-by-Step Deployment Process

This guide covers the complete process for building and deploying the GitConnect Flutter web app to GitHub Pages using local builds.

---

## 📋 Prerequisites

- ✅ Flutter SDK installed and configured
- ✅ Git repository with GitHub remote
- ✅ GitHub Pages enabled in repository settings
- ✅ Local development environment working

---

## 🔧 Initial Setup (One-time only)

### 1. Enable GitHub Pages
1. Go to your repository: `https://github.com/cristianmgm7/GitConnect_Showcase/settings/pages`
2. Under "Source", select **"Deploy from a branch"**
3. Choose **"gh-pages"** branch
4. Select **"/ (root)"** folder
5. Click **"Save"**

### 2. Verify gh-pages branch exists
```bash
git branch -a | grep gh-pages
```

---

## 🏗️ Development Workflow

### 1. Make Changes
- Work on your Flutter app in the `main` or `develop` branch
- Test locally with `flutter run -d chrome`

### 2. Commit Changes
```bash
git add .
git commit -m "Your commit message"
git push origin main  # or develop
```

---

## 🚀 Deployment Process

### Step 1: Build the Flutter Web App
```bash
# Navigate to project directory
cd /Users/cristian/Documents/GitConnect_Showcase

# Clean previous builds (optional but recommended)
flutter clean

# Get dependencies
flutter pub get

# Run code generation (if needed)
flutter pub run build_runner build --delete-conflicting-outputs

# Build for production
flutter build web --release
```

### Step 2: Switch to gh-pages Branch
```bash
# Switch to gh-pages branch
git checkout gh-pages

# Remove all existing files (except .git)
git rm -rf .
```

### Step 3: Copy Built Files
```bash
# Copy the built web files to current directory
cp -r build/web/* .

# Optional: Create a redirect index.html
cat > index.html << 'EOF'
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>GitConnect Showcase</title>
    <meta http-equiv="refresh" content="0; url=index.html">
</head>
<body>
    <p>Redirecting to GitConnect Showcase...</p>
    <p>If you are not redirected automatically, <a href="index.html">click here</a>.</p>
</body>
</html>
EOF
```

### Step 4: Commit and Push
```bash
# Add all files
git add .

# Commit with descriptive message
git commit -m "Deploy Flutter web app - $(date '+%Y-%m-%d %H:%M:%S')

- Built locally with flutter build web --release
- Updated static files for GitHub Pages
- Version: $(git log --oneline -1 --format='%h' main)"

# Push to GitHub Pages
git push origin gh-pages
```

### Step 5: Switch Back to Main Branch
```bash
# Return to main branch for continued development
git checkout main
```

---

## 🔄 Quick Deployment Script

Create a deployment script for faster deployments:

### Create `deploy.sh`
```bash
#!/bin/bash

# GitConnect Showcase - Quick Deploy Script
echo "🚀 Starting GitConnect deployment..."

# Step 1: Build
echo "📦 Building Flutter web app..."
flutter clean
flutter pub get
flutter pub run build_runner build --delete-conflicting-outputs
flutter build web --release

if [ $? -ne 0 ]; then
    echo "❌ Build failed! Exiting..."
    exit 1
fi

# Step 2: Switch to gh-pages
echo "🔄 Switching to gh-pages branch..."
git checkout gh-pages
git rm -rf .

# Step 3: Copy files
echo "📁 Copying built files..."
cp -r build/web/* .

# Step 4: Commit and push
echo "💾 Committing and pushing..."
git add .
git commit -m "Deploy Flutter web app - $(date '+%Y-%m-%d %H:%M:%S')"
git push origin gh-pages

# Step 5: Return to main
echo "🔙 Returning to main branch..."
git checkout main

echo "✅ Deployment complete!"
echo "🌐 Your app will be available at: https://cristianmgm7.github.io/GitConnect_Showcase/"
```

### Make it executable
```bash
chmod +x deploy.sh
```

### Run deployment
```bash
./deploy.sh
```

---

## 🐛 Troubleshooting

### Build Issues
```bash
# If build fails, try:
flutter clean
flutter pub get
flutter pub run build_runner build --delete-conflicting-outputs
flutter analyze
flutter build web --release
```

### Git Issues
```bash
# If gh-pages branch doesn't exist:
git checkout --orphan gh-pages
git rm -rf .
# Then follow deployment steps

# If you're on wrong branch:
git checkout main
# Then follow deployment steps
```

### GitHub Pages Issues
1. Check repository settings: `https://github.com/cristianmgm7/GitConnect_Showcase/settings/pages`
2. Verify gh-pages branch exists: `git branch -a | grep gh-pages`
3. Check deployment status in Actions tab
4. Wait 5-10 minutes for GitHub Pages to update

---

## 📊 Verification Steps

### 1. Check Build Output
```bash
# Verify build was successful
ls -la build/web/
```

### 2. Test Locally
```bash
# Serve the built files locally
cd build/web
python3 -m http.server 8000
# Visit http://localhost:8000
```

### 3. Check GitHub Pages
- Visit: `https://cristianmgm7.github.io/GitConnect_Showcase/`
- Test all functionality:
  - ✅ Search for GitHub users
  - ✅ View user profiles
  - ✅ Browse repositories
  - ✅ Load more repositories

---

## 🔄 Automated Deployment (Advanced)

### GitHub Actions Alternative
If you want to use GitHub Actions instead of local builds:

1. **Create `.github/workflows/deploy.yml`**:
```yaml
name: Deploy Flutter Web to GitHub Pages

on:
  push:
    branches: [ main ]

jobs:
  build-and-deploy:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      
      - uses: subosito/flutter-action@v2
        with:
          flutter-version: '3.24.0'
          
      - run: flutter pub get
      - run: flutter build web --release
      
      - uses: peaceiris/actions-gh-pages@v3
        with:
          github_token: ${{ secrets.GITHUB_TOKEN }}
          publish_dir: ./build/web
```

2. **Enable GitHub Pages** to use "GitHub Actions" as source

---

## 📝 Deployment Checklist

### Before Deployment
- [ ] Code changes committed to main branch
- [ ] Local testing completed
- [ ] No compilation errors (`flutter analyze`)
- [ ] Build successful (`flutter build web --release`)

### During Deployment
- [ ] Switched to gh-pages branch
- [ ] Removed old files
- [ ] Copied new build files
- [ ] Committed changes
- [ ] Pushed to GitHub
- [ ] Returned to main branch

### After Deployment
- [ ] Verified GitHub Pages deployment
- [ ] Tested live app functionality
- [ ] Checked all features work
- [ ] Updated documentation if needed

---

## 🎯 Best Practices

### 1. Version Control
- Always commit changes to main branch first
- Use descriptive commit messages
- Tag releases for important versions

### 2. Testing
- Test locally before deploying
- Verify all features work in production
- Check mobile responsiveness

### 3. Performance
- Monitor bundle size
- Optimize images and assets
- Use `flutter build web --release` for production

### 4. Security
- Never commit API keys to repository
- Use environment variables for sensitive data
- Keep dependencies updated

---

## 📞 Support

If you encounter issues:

1. **Check this guide** for troubleshooting steps
2. **Review Flutter web documentation**: https://docs.flutter.dev/platform-integration/web
3. **GitHub Pages documentation**: https://docs.github.com/en/pages
4. **Flutter community**: https://flutter.dev/community

---

## 🎉 Success!

Your GitConnect Showcase app should now be live at:
**https://cristianmgm7.github.io/GitConnect_Showcase/**

Happy coding! 🚀
