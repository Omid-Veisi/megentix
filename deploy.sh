#!/bin/bash

# Magentix AI Website Deployment Script
# This script helps deploy the website to various platforms

set -e

echo "🚀 Magentix AI Website Deployment Script"
echo "========================================"

# Check if required files exist
required_files=("index.html" "styles.css" "script.js" "manifest.json" "sw.js" "robots.txt" "sitemap.xml")
for file in "${required_files[@]}"; do
    if [ ! -f "$file" ]; then
        echo "❌ Error: Required file $file not found!"
        exit 1
    fi
done

echo "✅ All required files found"

# Create deployment directory
DEPLOY_DIR="deploy"
rm -rf "$DEPLOY_DIR"
mkdir -p "$DEPLOY_DIR"

# Copy files to deployment directory
echo "📁 Copying files to deployment directory..."
cp index.html "$DEPLOY_DIR/"
cp styles.css "$DEPLOY_DIR/"
cp script.js "$DEPLOY_DIR/"
cp manifest.json "$DEPLOY_DIR/"
cp sw.js "$DEPLOY_DIR/"
cp robots.txt "$DEPLOY_DIR/"
cp sitemap.xml "$DEPLOY_DIR/"
cp README.md "$DEPLOY_DIR/"

# Create icons directory if it doesn't exist
mkdir -p "$DEPLOY_DIR/icons"

echo "✅ Files copied to $DEPLOY_DIR/"

# Check for deployment platform
if [ "$1" = "netlify" ]; then
    echo "🌐 Deploying to Netlify..."
    if command -v netlify &> /dev/null; then
        cd "$DEPLOY_DIR"
        netlify deploy --prod --dir=.
        echo "✅ Deployed to Netlify!"
    else
        echo "❌ Netlify CLI not found. Install with: npm install -g netlify-cli"
        exit 1
    fi
elif [ "$1" = "vercel" ]; then
    echo "🌐 Deploying to Vercel..."
    if command -v vercel &> /dev/null; then
        cd "$DEPLOY_DIR"
        vercel --prod
        echo "✅ Deployed to Vercel!"
    else
        echo "❌ Vercel CLI not found. Install with: npm install -g vercel"
        exit 1
    fi
elif [ "$1" = "github" ]; then
    echo "🌐 Preparing for GitHub Pages..."
    echo "📝 Instructions:"
    echo "1. Create a new GitHub repository"
    echo "2. Copy files from $DEPLOY_DIR/ to your repository"
    echo "3. Enable GitHub Pages in repository settings"
    echo "4. Set source to main branch"
elif [ "$1" = "local" ]; then
    echo "🌐 Starting local server..."
    cd "$DEPLOY_DIR"
    if command -v python3 &> /dev/null; then
        python3 -m http.server 8000
    elif command -v python &> /dev/null; then
        python -m SimpleHTTPServer 8000
    elif command -v php &> /dev/null; then
        php -S localhost:8000
    else
        echo "❌ No local server found. Install Python or PHP."
        exit 1
    fi
else
    echo "📋 Deployment Options:"
    echo ""
    echo "Usage: ./deploy.sh [platform]"
    echo ""
    echo "Platforms:"
    echo "  netlify  - Deploy to Netlify"
    echo "  vercel   - Deploy to Vercel"
    echo "  github   - Prepare for GitHub Pages"
    echo "  local    - Start local development server"
    echo ""
    echo "Files are ready in $DEPLOY_DIR/ directory"
    echo ""
    echo "Manual Deployment:"
    echo "1. Upload files from $DEPLOY_DIR/ to your web server"
    echo "2. Ensure HTTPS is enabled (required for PWA features)"
    echo "3. Configure your domain"
    echo ""
    echo "Next Steps:"
    echo "1. Update domain in manifest.json and sitemap.xml"
    echo "2. Add Google Analytics tracking code"
    echo "3. Create and add app icons to icons/ directory"
    echo "4. Test thoroughly on different devices"
fi

echo ""
echo "🎉 Deployment script completed!"
echo "📧 For support: omid.veisi.ov@gmail.com" 