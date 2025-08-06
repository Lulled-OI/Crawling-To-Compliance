# S3 Security Lab 🪣

Learning AWS S3 security through hands-on practice - making mistakes and fixing them.

## What This Lab Covers

- S3 security best practices
- Setting up secure bucket configurations
- Finding and fixing common misconfigurations
- Documenting security assessment processes

## Lab Setup

### The Three Test Buckets

| Bucket Name | Purpose | Security Level |
|-------------|---------|----------------|
| `grc-secure-baseline-[yourname]` | Properly configured reference | ✅ Secure |
| `grc-vulnerable-lab-[yourname]` | Intentionally broken for learning | ❌ Vulnerable |
| `grc-remediation-test-[yourname]` | Practice fixing things | 🔄 Variable |

## Step-by-Step Setup

### Before You Start
- [ ] AWS CLI installed and configured
- [ ] Right IAM permissions for S3 management
- [ ] Basic AWS knowledge

### Step 1: Create Secure Baseline Bucket
```bash
# Create bucket with secure defaults
aws s3 mb s3://grc-secure-baseline-[yourname] --region us-east-1

# Apply security configurations
# (See bucket-configs/secure-baseline.json)
```

### Step 2: Create Vulnerable Lab Bucket
```bash
# Create intentionally vulnerable bucket
aws s3 mb s3://grc-vulnerable-lab-[yourname] --region us-east-1

# Apply vulnerable configurations for learning
# ⚠️ NEVER put real data in this bucket!
```

### Step 3: Create Remediation Test Bucket
```bash
# Create bucket for practice remediation
aws s3 mb s3://grc-remediation-test-[yourname] --region us-east-1

# Start with vulnerable config, then practice fixing
```

## Security Configurations

### Secure Setup Checklist
- [x] Block all public access
- [x] Enable server-side encryption (SSE-S3 or SSE-KMS)
- [x] Enable access logging
- [x] Enable versioning
- [x] Set up lifecycle policies
- [x] Configure MFA delete protection
- [x] Use least-privilege IAM policies
- [x] Enable CloudTrail logging

### Vulnerable Config Examples (For Learning)
- [x] Public read access enabled
- [x] Public write access enabled
- [x] No encryption configured
- [x] No access logging
- [x] Overly permissive bucket policies
- [x] Missing CORS restrictions
- [x] No versioning enabled

## Files and Folders
```
s3-security/
├── README.md (this file)
├── bucket-configs/
│   ├── secure-baseline.json
│   ├── vulnerable-examples.json
│   └── remediation-steps.json
├── policies/
│   ├── secure-bucket-policy.json
│   ├── iam-s3-access-policy.json
│   └── vulnerable-policies.json
├── scripts/
│   ├── create-buckets.sh
│   ├── security-scan.py
│   └── remediation-script.sh
└── documentation/
    ├── security-assessment-template.md
    ├── findings-log.md
    └── lessons-learned.md
```

## Learning Exercises

### Exercise 1: Security Assessment
1. Scan all three buckets for security issues
2. Document findings using the assessment template
3. Rank risks by severity

### Exercise 2: Policy Analysis
1. Compare bucket policies between secure and vulnerable buckets
2. Find specific policy weaknesses
3. Document what each weakness could lead to

### Exercise 3: Remediation Practice
1. Start with vulnerable configuration on remediation bucket
2. Fix issues step-by-step
3. Test each fix with security scanning
4. Document the whole process

### Exercise 4: Compliance Mapping
1. Map bucket configurations to compliance frameworks
2. Figure out which controls each setting addresses
3. Create documentation for auditors

## Safety Rules

### DO:
- Use test data only (lorem ipsum, fake files)
- Monitor AWS costs regularly
- Document all configurations and changes
- Follow principle of least privilege

### DON'T:
- Upload real or sensitive data to any bucket
- Leave vulnerable configurations running longer than needed
- Share access keys or credentials anywhere
- Use vulnerable configs in production accounts

## Progress Tracking

Mark off what you've completed:
- [ ] Successfully created all three test buckets
- [ ] Documented security differences between configurations
- [ ] Completed at least one full security assessment
- [ ] Fixed at least 3 different vulnerabilities
- [ ] Mapped configurations to compliance frameworks

## Resources

- [AWS S3 Security Best Practices](https://docs.aws.amazon.com/AmazonS3/latest/userguide/security-best-practices.html)
- [S3 Bucket Policy Examples](https://docs.aws.amazon.com/AmazonS3/latest/userguide/example-bucket-policies.html)
- [CIS Amazon Web Services Benchmarks](https://www.cisecurity.org/cis-benchmarks/)

## What's Next

After finishing the S3 security labs:
1. Move to IAM policy management
2. Set up CloudTrail logging
3. Set up automated security scanning
4. Document lessons learned for audit purposes

---

**Current Status**: Setting up test buckets
**Last Updated**: [Date]