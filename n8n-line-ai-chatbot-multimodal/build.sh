#!/bin/bash

# Build script for Google Codelabs
# Usage: ./build.sh [markdown_file] [output_dir]
#   markdown_file: Path to markdown file (default: auto-detect .md files in current directory)
#   output_dir: Output directory name (default: "codelab")

# Colors for output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Function to show usage
show_usage() {
    echo "Usage: $0 [markdown_file] [output_dir]"
    echo ""
    echo "Arguments:"
    echo "  markdown_file    Path to markdown file (optional, auto-detects if not provided)"
    echo "  output_dir       Output directory name (optional, default: 'codelab')"
    echo ""
    echo "Examples:"
    echo "  $0                                    # Auto-detect .md file, output to 'codelab'"
    echo "  $0 my-codelab.md                      # Build my-codelab.md, output to 'codelab'"
    echo "  $0 my-codelab.md output               # Build my-codelab.md, output to 'output'"
    exit 1
}

# Check for help flag
if [ "$1" = "-h" ] || [ "$1" = "--help" ]; then
    show_usage
fi

# Parse arguments
MARKDOWN_FILE="$1"
OUTPUT_DIR="${2:-codelab}"

# Auto-detect markdown file if not provided
if [ -z "$MARKDOWN_FILE" ]; then
    # Find first .md file in current directory
    MARKDOWN_FILE=$(find . -maxdepth 1 -name "*.md" -type f | head -n 1)
    if [ -z "$MARKDOWN_FILE" ]; then
        echo -e "${RED}Error: No markdown file found in current directory${NC}"
        echo "Please specify a markdown file: $0 <markdown_file> [output_dir]"
        exit 1
    fi
    echo -e "${BLUE}Auto-detected markdown file: $MARKDOWN_FILE${NC}"
fi

# Validate markdown file exists
if [ ! -f "$MARKDOWN_FILE" ]; then
    echo -e "${RED}Error: Markdown file not found: $MARKDOWN_FILE${NC}"
    show_usage
fi

# Extract codelab ID from markdown file
CODELAB_ID=$(grep -m 1 "^id:" "$MARKDOWN_FILE" | sed 's/^id:[[:space:]]*//' | tr -d '\r\n')
if [ -z "$CODELAB_ID" ]; then
    echo -e "${YELLOW}Warning: Could not find codelab ID in $MARKDOWN_FILE${NC}"
    echo -e "${YELLOW}Using filename as codelab ID${NC}"
    CODELAB_ID=$(basename "$MARKDOWN_FILE" .md)
fi

# Get codelab title for display
CODELAB_TITLE=$(grep -m 1 "^title:" "$MARKDOWN_FILE" | sed 's/^title:[[:space:]]*//' | tr -d '\r\n')
if [ -z "$CODELAB_TITLE" ]; then
    CODELAB_TITLE="$CODELAB_ID"
fi

source ~/.zshrc
echo -e "${BLUE}Building codelab: ${CODELAB_TITLE}${NC}"
echo -e "${BLUE}Markdown file: $MARKDOWN_FILE${NC}"
echo -e "${BLUE}Codelab ID: $CODELAB_ID${NC}"
echo -e "${BLUE}Output directory: $OUTPUT_DIR${NC}"

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
claat export "$MARKDOWN_FILE"

# Check if export was successful
if [ $? -eq 0 ]; then
    # Check if output folder was created with codelab ID
    if [ -d "$CODELAB_ID" ]; then
        # Remove existing output directory if it exists
        if [ -d "$OUTPUT_DIR" ]; then
            echo -e "${BLUE}Removing existing $OUTPUT_DIR folder...${NC}"
            rm -rf "$OUTPUT_DIR"
        fi
        # Rename to desired output directory
        mv "$CODELAB_ID" "$OUTPUT_DIR"
        echo -e "${GREEN}✓ Codelab built successfully!${NC}"
        echo -e "${GREEN}Output: $OUTPUT_DIR/index.html${NC}"
    elif [ -d "$OUTPUT_DIR" ]; then
        # Output directory already exists (claat might have created it directly)
        echo -e "${GREEN}✓ Codelab built successfully!${NC}"
        echo -e "${GREEN}Output: $OUTPUT_DIR/index.html${NC}"
    else
        echo -e "${RED}✗ Build folder not found!${NC}"
        echo -e "${YELLOW}Expected folder: $CODELAB_ID or $OUTPUT_DIR${NC}"
        exit 1
    fi
else
    echo -e "${RED}✗ Build failed!${NC}"
    exit 1
fi

