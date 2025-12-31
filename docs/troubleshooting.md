# Troubleshooting Guide

## Common Issues

### 1. Terraform command not found
- Solution: Added Terraform to system PATH and restarted terminal
### 2. AWS credential errors
- Solution: Installed AWS CLI and configured credentials
### 3. Incorrect Availability Zone
- Solution: Updated AZ to match the configured region
### 4. Nginx Syntax Error
- Solution: Sudo nginx -t which pointed to a syntax error on line 53. Upon inspection, I found an accidental typo (i}) caused by a vim keystroke error.
### 5. Availability Zone Mismatch
- Solution: Updated the availability_zone variable to me-central-1a to match the provider's region
