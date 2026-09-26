# Public URLs and release decisions

## Public legal and support URLs

| Requirement | Placeholder | Notes |
| --- | --- | --- |
| Privacy Policy URL | https://benattech.me/fieldproof360/privacy | Required by App Store Connect and Google Play. It should match the policy shown in the app. |
| Terms of Use URL | https://benattech.me/fieldproof360/terms | Link it from the public Privacy Policy page and use it in the app/store listing where available. |
| Support URL | https://benattech.me/fieldproof360/support | Use for customer support and Google Play deletion requests concerning RevenueCat subscription data. |
| Support email | wamono.benjamin@gmail.com | Use as the support contact in both stores. |

## Decisions still required from the product owner

1. Use Apple’s Standard Licensed Application End User License Agreement for V1.
2. Set the monthly and yearly subscription prices, territories, introductory offers, and subscription group display order in App Store Connect and Google Play Console.
3. Confirm that the RevenueCat dashboard has no third-party integrations, no custom app user IDs, and no subscriber attributes. If any are enabled, update both privacy declarations before submission.
4. Review the final generated Android and iOS release manifests/privacy reports after dependency resolution. Store declarations must match the shipped binaries.

## Confirm before publishing

- Ensure the hosted Privacy Policy and Terms match the in-app text.
- Configure the `fieldproof_pro_monthly` and `fieldproof_pro_yearly` subscriptions in both stores and connect them to RevenueCat’s current offering.
