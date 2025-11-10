# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

## [1.5.0] - 2025-11-10

### Added

- Role-based approval policies: Approvers can now be assigned to specific permission sets, allowing different teams to approve different roles (e.g., DevOps team approves monitoring roles, Security team approves admin roles)
- Multiple eligibility policies per user/group: Same user/group can now have different policies for different accounts with varying approval requirements (e.g., no approval for test accounts, approval required for prod accounts)
- "Most restrictive wins" logic: When multiple eligibility policies match a request, approval is required if ANY matching policy requires it

### Changed

- Backend eligibility evaluation now scans for all policies per user/group instead of returning only one
- Frontend now allows creating multiple eligibility policies for the same user/group
- Approval policy matching now filters by permission sets when specified

## [1.0.0] - 2023-05-24

### Added

- Initial release
