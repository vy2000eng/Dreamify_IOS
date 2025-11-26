//
//  Structs.swift
//  Dreamify
//
//  Created by Vladyslav Yatsuta on 9/20/25.
//

struct PlayPauseController{
    var dream:DreamViewModel?
    var isPlaying:Bool
    var indexThatIsCurrentlyPlaying:Int?

        
}
enum ControllerManagedByAudioPlayerClass:Int{
    
   case DreamViewController
   case  CalendarViewController
}



struct PrivacyPolicyTermsOfServiceStruct {
    
    let termsOfService = """
Terms of Service for Dreamify

Last Updated: November 2024

1. Acceptance of Terms

By accessing or using Dreamify, you agree to be bound by these Terms of Service. If you do not agree to these terms, please do not use our app.

2. Description of Service

Dreamify provides dream journaling and analysis services through our mobile application. We reserve the right to modify, suspend, or discontinue any part of our service at any time with or without notice.

3. Account Registration

To use Dreamify, you must create an account by providing accurate and complete information. You are responsible for maintaining the confidentiality of your account credentials and for all activities that occur under your account. You must be at least 13 years old to use our service. If you are under 18, you must have permission from a parent or guardian.

4. Acceptable Use

You agree to use Dreamify only for lawful purposes and in accordance with these Terms. You may not use our service to violate any applicable laws or regulations, transmit harmful or malicious content, attempt to gain unauthorized access to our systems, interfere with other users' use of the service, or use the service for any commercial purpose without our written permission.

5. Subscriptions and Payment

Dreamify offers both free and premium subscription services. Premium features require a paid subscription, which will be charged to your payment method on a recurring basis according to the subscription plan you select. Subscriptions automatically renew unless you cancel before the renewal date. You may cancel your subscription at any time through your account settings or through the app store where you purchased the subscription. Refunds are handled according to the app store's refund policy.

6. Intellectual Property

All content, features, and functionality of Dreamify, including but not limited to text, graphics, logos, and software, are owned by us or our licensors and are protected by copyright, trademark, and other intellectual property laws. You are granted a limited, non-exclusive, non-transferable license to use the app for personal, non-commercial purposes.

7. User Content

Any content you create or upload to Dreamify remains your property. However, by using our service, you grant us a worldwide, non-exclusive, royalty-free license to use, store, and process your content solely for the purpose of providing and improving our services.

8. Disclaimers

Dreamify is provided on an as-is and as-available basis. We make no warranties or representations about the accuracy, reliability, or availability of our service. To the maximum extent permitted by law, we disclaim all warranties, whether express or implied, including warranties of merchantability, fitness for a particular purpose, and non-infringement.

9. Limitation of Liability

In no event shall Dreamify, its officers, directors, employees, or agents be liable for any indirect, incidental, special, consequential, or punitive damages arising out of or relating to your use of the service. Our total liability to you for any claims arising from your use of the service shall not exceed the amount you paid us in the twelve months preceding the claim.

10. Indemnification

You agree to indemnify and hold harmless Dreamify and its affiliates from any claims, losses, damages, liabilities, and expenses arising out of your use of the service, your violation of these Terms, or your violation of any rights of another party.

11. Termination

We may terminate or suspend your account and access to Dreamify at any time, with or without cause or notice, for any reason including if we believe you have violated these Terms. Upon termination, your right to use the service will immediately cease, and we may delete your account and data.

12. Governing Law

These Terms shall be governed by and construed in accordance with the laws of the United States, without regard to its conflict of law provisions. Any disputes arising from these Terms or your use of Dreamify shall be resolved in the courts of the United States.

13. Changes to Terms

We may update these Terms of Service from time to time. We will notify you of any material changes by posting the new Terms in the app and updating the Last Updated date. Your continued use of Dreamify after changes are posted constitutes your acceptance of the updated Terms.

14. Contact Us

If you have any questions about these Terms of Service, please contact us at support@dreamify.app
"""
    
    let privacyPolicy = """
Privacy Policy for Dreamify

Last Updated: November 2024

Introduction

Dreamify respects your privacy and is committed to protecting your personal information. This Privacy Policy explains how we collect, use, and safeguard your data when you use our mobile application.

Information We Collect

We collect certain information when you use Dreamify. This includes your email address, username, and encrypted password when you create an account. We also collect your account creation date and subscription status.

Additionally, we may collect usage data such as app usage statistics, device information, and crash reports to help us improve the app. If you subscribe to premium features, we collect payment transaction details, which are processed securely through third-party payment processors.

How We Use Your Information

We use the information we collect to provide and maintain our services, process your subscription and payments, send you important updates and notifications, improve our app and user experience, respond to your support requests, and comply with legal obligations.

Data Storage and Security

Your data is stored on secure servers with industry-standard security measures. Passwords are encrypted and never stored in plain text. We use SSL/TLS encryption for all data transmission between your device and our servers.

Data Sharing

We do not sell your personal information to third parties. We may share your data with payment processors for subscription management, cloud service providers for secure data storage, analytics services using only anonymized data, and law enforcement when legally required.

Your Rights

You have the right to access your personal data, update or correct your information, delete your account and associated data, opt-out of marketing communications, and export your data at any time. To exercise these rights, please contact us at the email address provided below.

Data Retention

We retain your personal information for as long as your account is active or as needed to provide our services. You may request account deletion at any time, and we will remove your data from our active systems within a reasonable timeframe.

Children's Privacy

Our service is not intended for users under 13 years of age, and we do not knowingly collect personal information from children under 13. If we become aware that we have collected information from a child under 13, we will take steps to delete that information promptly.

Changes to This Policy

We may update this Privacy Policy from time to time to reflect changes in our practices or for legal or regulatory reasons. We will notify you of any significant changes by posting the new policy in the app and updating the Last Updated date. Your continued use of Dreamify after changes are posted constitutes your acceptance of the updated policy.

Contact Us

If you have questions about this Privacy Policy, please contact us at support@dreamify.app
"""
}
