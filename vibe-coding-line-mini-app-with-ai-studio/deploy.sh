#!/bin/bash

# Deploy vibe-coding codelab to Google Cloud Storage
# Usage: ./deploy.sh [--build]
#   --build   Run build.sh before uploading (optional)

set -euo pipefail

GREEN='\033[0;32m'
BLUE='\033[0;34m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m'

GCS_BUCKET="codelabs-beat-beat"
GCP_ACCOUNT="punsiri.boo@gmail.com"
CODELAB_ID="vibe-coding-line-mini-app"
CODELAB_DIR="codelab"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
MARKDOWN_FILE="vibe-coding-line-mini-app.md"

show_usage() {
    echo "Usage: $0 [--build]"
    echo ""
    echo "Upload ${CODELAB_DIR}/ to gs://${GCS_BUCKET}/${CODELAB_ID}/"
    echo ""
    echo "Account: ${GCP_ACCOUNT}"
    echo "Options:"
    echo "  --build   Build codelab from markdown before deploy"
    echo "  -h        Show this help"
    exit 1
}

RUN_BUILD=false
if [ "${1:-}" = "-h" ] || [ "${1:-}" = "--help" ]; then
    show_usage
elif [ "${1:-}" = "--build" ]; then
    RUN_BUILD=true
elif [ -n "${1:-}" ]; then
    echo -e "${RED}Error: Unknown option: $1${NC}"
    show_usage
fi

cd "$SCRIPT_DIR"

if [ "$RUN_BUILD" = true ]; then
    echo -e "${BLUE}Building codelab...${NC}"
    ./build.sh "$MARKDOWN_FILE" "$CODELAB_DIR"
fi

if [ ! -d "$CODELAB_DIR" ] || [ ! -f "$CODELAB_DIR/index.html" ]; then
    echo -e "${RED}Error: ${CODELAB_DIR}/index.html not found${NC}"
    echo "Run ./build.sh first, or use: $0 --build"
    exit 1
fi

if ! command -v gcloud &> /dev/null; then
    echo -e "${RED}Error: gcloud is not installed${NC}"
    echo "Install Google Cloud SDK: https://cloud.google.com/sdk/docs/install"
    exit 1
fi

if ! command -v gsutil &> /dev/null; then
    echo -e "${RED}Error: gsutil is not installed${NC}"
    echo "Install Google Cloud SDK: https://cloud.google.com/sdk/docs/install"
    exit 1
fi

CURRENT_ACCOUNT=$(gcloud config get-value account 2>/dev/null || true)
if [ "$CURRENT_ACCOUNT" != "$GCP_ACCOUNT" ]; then
    echo -e "${YELLOW}Switching gcloud account to ${GCP_ACCOUNT}...${NC}"
    gcloud config set account "$GCP_ACCOUNT"
fi

ACTIVE_ACCOUNT=$(gcloud config get-value account 2>/dev/null || true)
if [ "$ACTIVE_ACCOUNT" != "$GCP_ACCOUNT" ]; then
    echo -e "${RED}Error: Active account is '${ACTIVE_ACCOUNT}', expected '${GCP_ACCOUNT}'${NC}"
    echo "Run: gcloud auth login ${GCP_ACCOUNT}"
    exit 1
fi

echo -e "${BLUE}Using account: ${ACTIVE_ACCOUNT}${NC}"

JSON_ID=$(grep -m 1 '"id"' "$CODELAB_DIR/codelab.json" | sed 's/.*"id"[[:space:]]*:[[:space:]]*"//' | sed 's/".*//')
if [ -n "$JSON_ID" ] && [ "$JSON_ID" != "$CODELAB_ID" ]; then
    echo -e "${YELLOW}Warning: codelab.json id is '${JSON_ID}', deploying to '${CODELAB_ID}'${NC}"
fi

GCS_DEST="gs://${GCS_BUCKET}/${CODELAB_ID}"

echo -e "${BLUE}Deploying codelab to ${GCS_DEST}${NC}"
echo -e "${BLUE}Source: ${SCRIPT_DIR}/${CODELAB_DIR}/${NC}"

if gsutil ls "${GCS_DEST}/" &>/dev/null; then
    echo -e "${YELLOW}Removing existing files at ${GCS_DEST}...${NC}"
    gsutil -m rm -r "${GCS_DEST}/**"
fi

gsutil -m rsync -r -d "${CODELAB_DIR}/" "${GCS_DEST}/"

gsutil -m setmeta -h "Content-Type:text/html;charset=utf-8" \
    -h "Cache-Control:public, max-age=3600" \
    "${GCS_DEST}/index.html"

if [ -f "${CODELAB_DIR}/codelab.json" ]; then
    gsutil setmeta -h "Content-Type:application/json" "${GCS_DEST}/codelab.json"
fi

PUBLIC_URL="https://storage.googleapis.com/${GCS_BUCKET}/${CODELAB_ID}/index.html"

echo -e "${GREEN}✓ Deploy successful!${NC}"
echo -e "${GREEN}URL: ${PUBLIC_URL}${NC}"
