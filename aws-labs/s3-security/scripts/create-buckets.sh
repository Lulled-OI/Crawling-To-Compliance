#!/bin/bash

# =============================================================================
# S3 Security Lab - Bucket Creation Script
# =============================================================================
# Purpose: Create three S3 buckets for GRC security learning
# 
# IMPORTANT: 
# - Replace [yourname] with your actual identifier
# - Make sure AWS CLI is configured
# - Keep an eye on costs - these will cost money
# =============================================================================

set -e  # Exit if anything fails

# Configuration Variables
REGION="us-east-1"
NAME_SUFFIX="[yourname]"  # REPLACE WITH YOUR IDENTIFIER
DATE_STAMP=$(date +%Y%m%d)

# Bucket Names
SECURE_BUCKET="grc-secure-baseline-${NAME_SUFFIX}"
VULNERABLE_BUCKET="grc-vulnerable-lab-${NAME_SUFFIX}"
REMEDIATION_BUCKET="grc-remediation-test-${NAME_SUFFIX}"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Functions
log_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

log_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

log_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

check_prerequisites() {
    log_info "Checking if everything's set up..."
    
    # Check if AWS CLI is installed
    if ! command -v aws &> /dev/null; then
        log_error "AWS CLI isn't installed. Install it first."
        exit 1
    fi
    
    # Check if AWS credentials are configured
    if ! aws sts get-caller-identity &> /dev/null; then
        log_error "AWS credentials aren't set up. Run 'aws configure' first."
        exit 1
    fi
    
    # Check if name suffix was replaced
    if [[ "$NAME_SUFFIX" == "[yourname]" ]]; then
        log_error "You need to replace [yourname] with your identifier in the script."
        exit 1
    fi
    
    log_success "Prerequisites look good!"
}

create_secure_bucket() {
    log_info "Creating secure baseline bucket: $SECURE_BUCKET"
    
    # Create bucket
    aws s3 mb "s3://$SECURE_BUCKET" --region "$REGION"
    
    # Block all public access
    aws s3api put-public-access-block \
        --bucket "$SECURE_BUCKET" \
        --public-access-block-configuration \
        "BlockPublicAcls=true,IgnorePublicAcls=true,BlockPublicPolicy=true,RestrictPublicBuckets=true"
    
    # Enable versioning
    aws s3api put-bucket-versioning \
        --bucket "$SECURE_BUCKET" \
        --versioning-configuration Status=Enabled
    
    # Enable server-side encryption
    aws s3api put-bucket-encryption \
        --bucket "$SECURE_BUCKET" \
        --server-side-encryption-configuration '{
            "Rules": [{
                "ApplyServerSideEncryptionByDefault": {
                    "SSEAlgorithm": "AES256"
                }
            }]
        }'
    
    # Add tags
    aws s3api put-bucket-tagging \
        --bucket "$SECURE_BUCKET" \
        --tagging 'TagSet=[
            {Key=Purpose,Value=GRC-Learning},
            {Key=Security-Level,Value=Secure-Baseline},
            {Key=Environment,Value=Lab},
            {Key=Created,Value='$DATE_STAMP'}
        ]'
    
    log_success "Secure baseline bucket created and configured!"
}

create_vulnerable_bucket() {
    log_warning "Creating vulnerable lab bucket: $VULNERABLE_BUCKET"
    log_warning "This bucket will be INTENTIONALLY INSECURE for learning"
    
    # Create bucket
    aws s3 mb "s3://$VULNERABLE_BUCKET" --region "$REGION"
    
    # Note: We'll configure vulnerabilities through AWS Console or separate scripts
    # to make the learning process more deliberate
    
    # Add tags (but mark as vulnerable)
    aws s3api put-bucket-tagging \
        --bucket "$VULNERABLE_BUCKET" \
        --tagging 'TagSet=[
            {Key=Purpose,Value=GRC-Learning},
            {Key=Security-Level,Value=Intentionally-Vulnerable},
            {Key=Environment,Value=Lab},
            {Key=Warning,Value=DO-NOT-USE-REAL-DATA},
            {Key=Created,Value='$DATE_STAMP'}
        ]'
    
    log_warning "Vulnerable lab bucket created!"
    log_warning "Remember: NEVER put real data in this bucket!"
}

create_remediation_bucket() {
    log_info "Creating remediation test bucket: $REMEDIATION_BUCKET"
    
    # Create bucket
    aws s3 mb "s3://$REMEDIATION_BUCKET" --region "$REGION"
    
    # Start with basic configuration - we'll modify this for practice
    aws s3api put-bucket-tagging \
        --bucket "$REMEDIATION_BUCKET" \
        --tagging 'TagSet=[
            {Key=Purpose,Value=GRC-Learning},
            {Key=Security-Level,Value=Remediation-Practice},
            {Key=Environment,Value=Lab},
            {Key=Created,Value='$DATE_STAMP'}
        ]'
    
    log_success "Remediation test bucket created!"
}

create_documentation() {
    log_info "Creating documentation files..."
    
    # Create a simple bucket inventory
    cat > "bucket-inventory-$DATE_STAMP.md" << EOF
# S3 Security Lab - Bucket Inventory

**Created**: $(date)
**Region**: $REGION

## Buckets Created

### 1. Secure Baseline Bucket
- **Name**: $SECURE_BUCKET
- **Purpose**: Reference for proper security setup
- **Security Level**: ✅ Secure
- **Features**: Public access blocked, encryption enabled, versioning on

### 2. Vulnerable Lab Bucket
- **Name**: $VULNERABLE_BUCKET  
- **Purpose**: Intentionally broken for learning
- **Security Level**: ❌ Vulnerable
- **⚠️ WARNING**: Never put real data in this bucket!

### 3. Remediation Test Bucket
- **Name**: $REMEDIATION_BUCKET
- **Purpose**: Practice fixing misconfigurations  
- **Security Level**: 🔄 Variable
- **Note**: Start broken, then practice fixing

## Next Steps
1. Configure vulnerable settings on lab bucket
2. Practice security assessments
3. Document what you find
4. Practice fixing stuff on test bucket

## Cost Monitoring
- Set up billing alerts
- Check usage regularly
- Clean up when done learning

## Safety Reminders
- Use test data only
- Never expose real sensitive information
- Document all changes
- Follow principle of least privilege
EOF

    log_success "Documentation created: bucket-inventory-$DATE_STAMP.md"
}

cleanup_on_error() {
    log_error "Script failed! Cleaning up any created resources..."
    
    # List of buckets to potentially clean up
    BUCKETS=("$SECURE_BUCKET" "$VULNERABLE_BUCKET" "$REMEDIATION_BUCKET")
    
    for bucket in "${BUCKETS[@]}"; do
        if aws s3api head-bucket --bucket "$bucket" 2>/dev/null; then
            log_warning "Cleaning up bucket: $bucket"
            aws s3 rm "s3://$bucket" --recursive 2>/dev/null || true
            aws s3 rb "s3://$bucket" 2>/dev/null || true
        fi
    done
}

# Main execution
main() {
    log_info "Starting S3 Security Lab Setup..."
    echo "================================="
    
    # Set up error handling
    trap cleanup_on_error ERR
    
    # Run setup steps
    check_prerequisites
    create_secure_bucket
    create_vulnerable_bucket  
    create_remediation_bucket
    create_documentation
    
    echo "================================="
    log_success "S3 Security Lab setup complete!"
    log_info "Next steps:"
    echo "  1. Look at the documentation that was created"
    echo "  2. Configure vulnerable settings on lab bucket"
    echo "  3. Start security assessment exercises"
    echo "  4. Document what you learn"
    echo ""
    log_warning "Remember to monitor AWS costs and clean up when done!"
}

# Execute main function
main "$@"