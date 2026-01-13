#!/bin/bash

# Build script for n8n-line-ai-agent codelab
# This script builds the codelab from markdown to HTML using claat

# Colors for output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m' # No Color
source ~/.zshrc
echo -e "${BLUE}Building n8n-line-ai-agent codelab...${NC}"

# Add Go bin to PATH if it exists and not already in PATH
GO_BIN_PATH="$HOME/go/bin"
if [ -d "$GO_BIN_PATH" ] && [[ ":$PATH:" != *":$GO_BIN_PATH:"* ]]; then
    export PATH="$PATH:$GO_BIN_PATH"
fi

# Check if claat is installed (check both in PATH and in go/bin)
if ! command -v claat &> /dev/null && [ ! -f "$GO_BIN_PATH/claat" ]; then
    echo -e "${RED}Error: claat is not installed${NC}"
    echo -e "${BLUE}Attempting to install claat...${NC}"
    
    # Check if go is installed
    if ! command -v go &> /dev/null
    then
        echo -e "${RED}Error: Go is not installed${NC}"
        echo "Please install Go first:"
        echo "  macOS: brew install go"
        echo "  Linux: sudo apt-get install golang-go"
        echo "  Or visit: https://golang.org/dl/"
        exit 1
    fi
    
    # Install claat
    echo "Installing claat..."
    go install github.com/googlecodelabs/tools/claat@latest
    
    # Check if installation was successful
    if [ $? -eq 0 ]; then
        echo -e "${GREEN}✓ claat installed successfully!${NC}"
        
        # Add Go bin to PATH permanently in .zshrc
        if [ -f "$HOME/.zshrc" ] && ! grep -q "export PATH.*go/bin" "$HOME/.zshrc"; then
            echo "" >> "$HOME/.zshrc"
            echo "# Add Go bin to PATH" >> "$HOME/.zshrc"
            echo 'export PATH="$PATH:$HOME/go/bin"' >> "$HOME/.zshrc"
            echo -e "${GREEN}✓ Added $GO_BIN_PATH to PATH in ~/.zshrc${NC}"
            echo -e "${BLUE}Run: source ~/.zshrc (or restart terminal) to apply changes${NC}"
        fi
        
        # Add to current session PATH
        export PATH="$PATH:$GO_BIN_PATH"
    else
        echo -e "${RED}✗ Failed to install claat${NC}"
        echo "Please install manually:"
        echo "  go install github.com/googlecodelabs/tools/claat@latest"
        exit 1
    fi
elif [ -f "$GO_BIN_PATH/claat" ] && ! command -v claat &> /dev/null; then
    # claat exists but not in PATH, add it for this session
    export PATH="$PATH:$GO_BIN_PATH"
    echo -e "${BLUE}Found claat in $GO_BIN_PATH, added to PATH for this session${NC}"
    
    # Also add to .zshrc if not already there
    if [ -f "$HOME/.zshrc" ] && ! grep -q "export PATH.*go/bin" "$HOME/.zshrc"; then
        echo "" >> "$HOME/.zshrc"
        echo "# Add Go bin to PATH" >> "$HOME/.zshrc"
        echo 'export PATH="$PATH:$HOME/go/bin"' >> "$HOME/.zshrc"
        echo -e "${GREEN}✓ Added $GO_BIN_PATH to PATH in ~/.zshrc permanently${NC}"
        echo -e "${BLUE}Run: source ~/.zshrc (or restart terminal) to apply changes${NC}"
    fi
fi

# Export the codelab
echo -e "${BLUE}Exporting codelab from markdown...${NC}"
claat export n8n-line-ai-agent.md

# Check if export was successful
if [ $? -eq 0 ]; then
    # Rename output folder to codelab
    if [ -d "n8n-line-ai-agent" ]; then
        if [ -d "codelab" ]; then
            echo -e "${BLUE}Removing existing codelab folder...${NC}"
            rm -rf codelab
        fi
        mv n8n-line-ai-agent codelab
        echo -e "${GREEN}✓ Codelab built successfully!${NC}"
        echo -e "${GREEN}Output: codelab/index.html${NC}"
    else
        echo -e "${RED}✗ Build folder not found!${NC}"
        exit 1
    fi
else
    echo -e "${RED}✗ Build failed!${NC}"
    exit 1
fi

