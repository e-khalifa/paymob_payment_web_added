# paymob_payment

This package is a modified version of the [paymob_payment](https://github.com/AhmedAbogameel/paymob_payment) package to support web functionality. 

## Changes

- Added support for web using `url_launcher` instead of `webview_flutter`.
- Updated methods to handle web-based payment processing.

## Installation

Add the following to your `pubspec.yaml` file:

```yaml
dependencies:
  paymob_payment:
    git:
      url: https://github.com/e-khalifa/paymob_payment_web_added.git
