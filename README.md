# JWT Security Analyzer

Verification pipeline for detecting common JWT security vulnerabilities using industry-standard tools.

## Tools Used

1. jwt_tool - Comprehensive vulnerability testing
2. jwt-hack - Quick security scan
3. jwt-cracker - Weak secret detection (10s timeout)

## Usage

```bash
# Build
docker build -t jwt-analyzer .

# Basic usage
docker run --rm jwt-analyzer <JWT_TOKEN>

# Custom timeout for secret cracking (default: 10s)
docker run --rm -e CRACK_TIMEOUT=30 jwt-analyzer <JWT_TOKEN>
```

## Test Tokens

### Weak Secret (HS256)
Token signed with weak secret "secret":
```bash
docker run --rm jwt-analyzer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIxMjM0NTY3ODkwIiwibmFtZSI6IkpvaG4gRG9lIiwiaWF0IjoxNTE2MjM5MDIyfQ.SflKxwRJSMeKKF2QT4fwpMeJf36POk6yJV_adQssw5c
```
Expected: jwt-hack will attempt to crack the secret using the wordlist

### None Algorithm (CVE-2015-9235)
Token with algorithm set to "none":
```bash
docker run --rm jwt-analyzer eyJhbGciOiJub25lIiwidHlwIjoiSldUIn0.eyJzdWIiOiIxMjM0NTY3ODkwIiwibmFtZSI6IkpvaG4gRG9lIiwiaWF0IjoxNTE2MjM5MDIyfQ.
```
Expected: Tools will decode and show the "none" algorithm vulnerability

## References

- [JWT mistakes & breaches](https://em360tech.com/tech-articles/jwt-just-wait-til-it-breaks-common-token-mistakes-and-how-avoid-them)
- [JWT critical flaws](https://medium.com/@cyb3rzee/my-week-2-lab-deep-dive-into-jwt-security-5-critical-flaws-you-should-never-ignore-cf1c2ddc34e2)
- [Real world JWT vulnerabilities](https://www.redsecuretech.co.uk/blog/post/breaking-and-fixing-jwts-real-world-vulnerabilities-and-fixes/491)
- [CVE-2015-9235](https://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2015-9235) - Algorithm confusion vulnerability
