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
