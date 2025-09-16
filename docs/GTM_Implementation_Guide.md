# Google Tag Manager Implementation Guide for WHMCS MassiveGRID Templates

## Overview
This guide documents the Google Tag Manager (GTM) and Google Analytics 4 (GA4) implementation for the MassiveGRID WHMCS templates. The implementation includes enhanced ecommerce tracking for the complete customer journey.

## GTM Container Configuration
- **Container ID**: `GTM-P9DBTPGG-JWGC2T4HLP`
- **Environment**: Production
- **Platform**: Web

## Implemented Events

### 1. Purchase Event
**Location**: `orderforms/MassiveGRID_Cart/complete.tpl`
**Trigger**: When order is completed and payment is confirmed
**Event Name**: `purchase`

#### Parameters:
- `transaction_id`: WHMCS Order ID
- `value`: Total order value (converted to decimal)
- `currency`: Currency code (defaults to USD)
- `coupon`: Promo code if applied
- `items`: Array of purchased items

#### WHMCS Variables Used:
- `{$orderid}` - Order ID
- `{$total}` - Total amount
- `{$currency.code}` - Currency
- `{$promocode}` - Promotion code
- `{$products}` - Product array
- `{$domainname}` - Domain if purchased

### 2. Begin Checkout Event
**Location**: `orderforms/MassiveGRID_Cart/checkout.tpl`
**Trigger**: When checkout page loads
**Event Name**: `begin_checkout`

#### Parameters:
- `currency`: Currency code
- `value`: Cart total value
- `coupon`: Applied coupon code
- `items`: Array of cart items

### 3. View Cart Event
**Location**: `orderforms/MassiveGRID_Cart/viewcart.tpl`
**Trigger**: When cart page loads with items
**Event Name**: `view_cart`

#### Parameters:
- `currency`: Currency code
- `value`: Cart total value
- `items`: Array of cart items

### 4. View Item Event
**Location**: `orderforms/MassiveGRID_Cart/configureproduct.tpl`
**Trigger**: When product configuration page loads
**Event Name**: `view_item`

#### Parameters:
- `currency`: Currency code
- `value`: Product price
- `items`: Single product item

#### WHMCS Variables Used:
- `{$productinfo.id}` - Product ID
- `{$productinfo.name}` - Product name
- `{$productinfo.groupname}` - Product group/category
- `{$product.pricing.minprice.price}` - Product price

### 5. Add to Cart Event
**Location**: `orderforms/MassiveGRID_Cart/products.tpl`
**Trigger**: When "Order Now" button is clicked
**Event Name**: `add_to_cart`

#### Implementation:
- JavaScript event listener on `.btn-order-now` buttons
- Extracts product information from DOM elements
- Sends event before page navigation

### 6. Add Payment Info Event
**Location**: `orderforms/MassiveGRID_Cart/checkout.tpl`
**Trigger**: When payment method is selected
**Event Name**: `add_payment_info`

#### Parameters:
- `payment_type`: Type of payment method selected
- `currency`: Currency code
- `value`: Order total
- `items`: Cart items

### 7. Add Shipping Info Event
**Location**: `orderforms/MassiveGRID_Cart/checkout.tpl`
**Trigger**: When country or state is selected
**Event Name**: `add_shipping_info`

#### Parameters:
- `shipping_tier`: Always set to "Standard"
- `currency`: Currency code
- `value`: Order total
- `items`: Cart items

## GTM Setup Requirements

### Tags to Create in GTM

#### 1. GA4 Configuration Tag
- **Tag Type**: Google Analytics: GA4 Configuration
- **Measurement ID**: Your GA4 Measurement ID
- **Trigger**: All Pages

#### 2. GA4 Event Tags
Create separate tags for each event:

##### Purchase Event Tag
- **Tag Type**: Google Analytics: GA4 Event
- **Event Name**: `purchase`
- **Trigger**: Custom Event - purchase
- **Parameters**: 
  - transaction_id: `{{DLV - transaction_id}}`
  - value: `{{DLV - value}}`
  - currency: `{{DLV - currency}}`
  - items: `{{DLV - items}}`

##### Begin Checkout Event Tag
- **Tag Type**: Google Analytics: GA4 Event
- **Event Name**: `begin_checkout`
- **Trigger**: Custom Event - begin_checkout

##### View Cart Event Tag
- **Tag Type**: Google Analytics: GA4 Event
- **Event Name**: `view_cart`
- **Trigger**: Custom Event - view_cart

##### View Item Event Tag
- **Tag Type**: Google Analytics: GA4 Event
- **Event Name**: `view_item`
- **Trigger**: Custom Event - view_item

##### Add to Cart Event Tag
- **Tag Type**: Google Analytics: GA4 Event
- **Event Name**: `add_to_cart`
- **Trigger**: Custom Event - add_to_cart

##### Add Payment Info Event Tag
- **Tag Type**: Google Analytics: GA4 Event
- **Event Name**: `add_payment_info`
- **Trigger**: Custom Event - add_payment_info

##### Add Shipping Info Event Tag
- **Tag Type**: Google Analytics: GA4 Event
- **Event Name**: `add_shipping_info`
- **Trigger**: Custom Event - add_shipping_info

### Triggers to Create

#### 1. Purchase Trigger
- **Trigger Type**: Custom Event
- **Event Name**: `purchase`

#### 2. Begin Checkout Trigger
- **Trigger Type**: Custom Event
- **Event Name**: `begin_checkout`

#### 3. View Cart Trigger
- **Trigger Type**: Custom Event
- **Event Name**: `view_cart`

#### 4. View Item Trigger
- **Trigger Type**: Custom Event
- **Event Name**: `view_item`

#### 5. Add to Cart Trigger
- **Trigger Type**: Custom Event
- **Event Name**: `add_to_cart`

#### 6. Add Payment Info Trigger
- **Trigger Type**: Custom Event
- **Event Name**: `add_payment_info`

#### 7. Add Shipping Info Trigger
- **Trigger Type**: Custom Event
- **Event Name**: `add_shipping_info`

### Variables to Create

#### Data Layer Variables
Create these built-in Data Layer Variables:

1. `DLV - ecommerce.transaction_id`
2. `DLV - ecommerce.value`
3. `DLV - ecommerce.currency`
4. `DLV - ecommerce.items`
5. `DLV - ecommerce.coupon`
6. `DLV - ecommerce.payment_type`
7. `DLV - ecommerce.shipping_tier`

## Data Layer Structure

All events push data to the `dataLayer` with this structure:

```javascript
dataLayer.push({
    event: 'event_name',
    ecommerce: {
        transaction_id: 'order_id', // For purchase events
        value: 123.45,
        currency: 'USD',
        coupon: 'PROMO_CODE', // If applicable
        payment_type: 'Credit Card', // For payment info events
        shipping_tier: 'Standard', // For shipping info events
        items: [
            {
                item_id: 'product_id',
                item_name: 'Product Name',
                item_category: 'Product Category',
                item_brand: 'MassiveGRID',
                price: 99.99,
                quantity: 1
            }
        ]
    }
});
```

## Testing and Validation

### 1. GTM Preview Mode
- Use GTM Preview mode to test all events
- Verify events fire on correct triggers
- Check data layer values

### 2. GA4 DebugView
- Enable Debug mode in GA4
- Monitor real-time events
- Validate parameter values

### 3. Browser Developer Tools
- Check console for JavaScript errors
- Verify dataLayer pushes in console
- Monitor network requests to GTM

## WHMCS Variable Notes

### Price Formatting
Prices are cleaned using this pattern:
```smarty
parseFloat('{$price|replace:",":""}')
```

This removes commas from currency values (e.g., "1,000.99" becomes "1000.99") and converts to a proper numeric value for JavaScript processing. The decimal points are preserved for accurate monetary calculations.

### JavaScript Escaping
All text variables are escaped for JavaScript:
```smarty
'{$productname|escape:"javascript"}'
```

### Currency Handling
Currency code is accessed via:
```smarty
'{$currency.code|default:"USD"}'
```

## Troubleshooting

### Common Issues

1. **Events not firing**: Check JavaScript console for errors
2. **Wrong values**: Verify WHMCS variable availability in template context
3. **Missing items**: Ensure product arrays are properly formatted
4. **Currency issues**: Check currency variable structure in WHMCS version

### Debug Tips

1. Add console.log statements to track dataLayer pushes
2. Use GTM Preview mode extensively
3. Test with different product configurations
4. Verify with multiple currencies if applicable

## Maintenance

### Regular Checks
- Monitor GTM container version updates
- Verify events continue firing after WHMCS updates
- Check GA4 reports for data consistency
- Update documentation when template changes occur

### Version Compatibility
This implementation is compatible with:
- WHMCS 8.x+
- GTM Container Version 2+
- GA4 (Google Analytics 4)

## Contact Information
For technical support regarding this implementation, refer to the WHMCS template documentation or GTM support resources.