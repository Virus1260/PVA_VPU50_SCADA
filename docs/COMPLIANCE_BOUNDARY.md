# 21 CFR Part 11 & GAMP 5 Compliance Boundary

## FDA 21 CFR Part 11 Mapping Matrix

| Regulation Section | Requirement | PVA VPU-50 SCADA Implementation |
|---|---|---|
| **11.10(a)** | Validation of systems to ensure accuracy, reliability, consistent performance | Automated test suite in `tests/test_core.py`, formal validation plan in `docs/VALIDATION_PLAN.md` |
| **11.10(b)** | Ability to generate accurate, complete copies of records | Electronic Batch Records (EBR) generated via Screen 7 with cryptographic checksums |
| **11.10(c)** | Protection of records to enable accurate retrieval | Tamper-evident SQLite historian storing time-series samples and batch runs |
| **11.10(d)** | Limiting system access to authorized individuals | 4-tier Role-Based Access Control (`role_catalog.json`) enforced by `SecurityManager` |
| **11.10(e)** | Secure, computer-generated, time-stamped audit trails | Append-only HMAC SHA-256 hash-chained audit log capturing actor, timestamp, action, old/new value, reason |
| **11.10(f)** | Operational system checks to enforce sequence of steps | Recipe execution engine enforcing sequential phases, interlocks, and manual confirmation stops |
| **11.10(g)** | Authority checks to ensure only authorized individuals execute actions | Hard permission validation before setpoint changes, alarm acknowledgments, or recipe execution |
| **11.10(h)** | Input parameter range checks | Tag limits (`tag_catalog.json`) hard-validated before dispatching to PLC or simulator |
| **11.50** | Signature manifestations | Signer name, UTC timestamp, signature meaning (Author, Reviewer, Approver) embedded in EBR |
