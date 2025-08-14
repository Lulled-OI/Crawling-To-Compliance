# AWS Setup Guide for S3 Security Lab

## Current Status ✅
- Project structure created
- Configuration files ready  
- Bucket creation script updated with identifier: `lulled-lab`

## Next Steps to Complete Setup

### 1. Install AWS CLI
Choose your operating system:

**macOS:**
```bash
# Option 1: Using Homebrew (if you have it)
brew install awscli

# Option 2: Direct download
curl "https://awscli.amazonaws.com/AWSCLIV2.pkg" -o "AWSCLIV2.pkg"
sudo installer -pkg AWSCLIV2.pkg -target /
```

**Windows:**
- Download: https://awscli.amazonaws.com/AWSCLIV2.msi
- Run the installer

**Linux:**
```bash
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install
```

### 2. Verify Installation
After installing, verify it works:
```bash
aws --version
# Should show something like: aws-cli/2.x.x
```

### 3. AWS Account Setup
You'll need an AWS account if you don't have one:
1. Go to https://aws.amazon.com/
2. Click "Create an AWS Account"
3. Follow the signup process
4. **Important**: Set up billing alerts to avoid unexpected charges!

### 4. Configure AWS Credentials
Once you have an account:
```bash
aws configure
```
You'll need:
- AWS Access Key ID
- AWS Secret Access Key  
- Default region: `us-east-1`
- Default output format: `json`

### 5. Test Your Setup
```bash
# Test that you're connected
aws sts get-caller-identity

# Should return your account info
```

### 6. Run the Lab Setup
Once AWS CLI is working:
```bash
cd /Users/james/Desktop/CODE/MCP\ Projects/Crawling-To-Compliance/aws-labs/s3-security/scripts
chmod +x create-buckets.sh
./create-buckets.sh
```

## Safety Reminders 🛡️
- **Cost Control**: Set up billing alerts in AWS console
- **Test Data Only**: Never put real/sensitive data in lab buckets
- **Clean Up**: Delete resources when done learning to avoid charges
- **Region**: Stick to `us-east-1` to keep things simple

## Your Bucket Names (Ready to Create)
- `grc-secure-baseline-lulled-lab`
- `grc-vulnerable-lab-lulled-lab`  
- `grc-remediation-test-lulled-lab`

## Estimated Costs
- S3 storage: ~$0.023 per GB per month
- For this lab: Should be under $1/month with test data
- **Set billing alerts at $5-10 to be safe!**

## Need Help?
If you get stuck with AWS CLI installation or configuration, let me know what error messages you see!