{include file="orderforms/standard_cart/common.tpl"}

<div id="order-standard_cart">

    <div class="row">
        <div class="cart-sidebar">
            {include file="orderforms/standard_cart/sidebar-categories.tpl"}
        </div>
        <div class="cart-body">
            <div class="header-lined">
                <h1 class="font-size-36">{$LANG.orderconfirmation}</h1>
            </div>
            {include file="orderforms/standard_cart/sidebar-categories-collapsed.tpl"}

            <p>{$LANG.orderreceived}</p>

            <div class="row">
                <div class="col-sm-8 col-sm-offset-2 offset-sm-2">
                    <div class="alert alert-info order-confirmation">
                        {$LANG.ordernumberis} <span>{$ordernumber}</span>
                    </div>
                </div>
            </div>

            <p>{$LANG.orderfinalinstructions}</p>

            {if $expressCheckoutInfo}
                <div class="alert alert-info text-center">
                    {$expressCheckoutInfo}
                </div>
            {elseif $expressCheckoutError}
                <div class="alert alert-danger text-center">
                    {$expressCheckoutError}
                </div>
            {elseif $invoiceid && !$ispaid}
                <div class="alert alert-warning text-center">
                    {$LANG.ordercompletebutnotpaid}
                    <br /><br />
                    <a href="{$WEB_ROOT}/viewinvoice.php?id={$invoiceid}" target="_blank" class="alert-link">
                        {$LANG.invoicenumber}{$invoiceid}
                    </a>
                </div>
            {/if}

            {foreach $addons_html as $addon_html}
                <div class="order-confirmation-addon-output">
                    {$addon_html}
                </div>
            {/foreach}

            {if $ispaid}
                <!-- GTM/GA4 Enhanced Ecommerce Purchase Tracking -->
                <script>
                    // GA4 Purchase Event
                    window.dataLayer = window.dataLayer || [];
                    dataLayer.push({
                        event: 'purchase',
                        ecommerce: {
                            transaction_id: '{$orderid}',
                            value: parseFloat('{$total|replace:",":""}'),
                            currency: '{$currency.code|default:"USD"}',
                            coupon: '{if $promocode}{$promocode}{/if}',
                            items: [
                                {foreach from=$products item=prod name=loop}
                                {
                                    item_id: '{$prod.id}',
                                    item_name: '{$prod.name|escape:"javascript"}',
                                    item_category: '{$prod.groupname|escape:"javascript"}',
                                    item_brand: 'MassiveGRID',
                                    price: parseFloat('{$prod.price|replace:",":""}'),
                                    quantity: {$prod.quantity|default:1}
                                }{if !$smarty.foreach.loop.last},{/if}
                                {/foreach}
                                {if $domainname}
                                ,{
                                    item_id: 'domain',
                                    item_name: '{$domainname|escape:"javascript"}',
                                    item_category: 'Domain',
                                    item_brand: 'MassiveGRID',
                                    price: parseFloat('{$domainfirstpaymentamount|replace:",":""}'),
                                    quantity: 1
                                }
                                {/if}
                            ]
                        }
                    });

                    // Also send to Google Analytics (legacy)
                    if (typeof gtag !== 'undefined') {
                        gtag('event', 'purchase', {
                            transaction_id: '{$orderid}',
                            value: parseFloat('{$total|replace:",":""}'),
                            currency: '{$currency.code|default:"USD"}',
                            items: [
                                {foreach from=$products item=prod name=loop}
                                {
                                    item_id: '{$prod.id}',
                                    item_name: '{$prod.name|escape:"javascript"}',
                                    item_category: '{$prod.groupname|escape:"javascript"}',
                                    price: parseFloat('{$prod.price|replace:",":""}'),
                                    quantity: {$prod.quantity|default:1}
                                }{if !$smarty.foreach.loop.last},{/if}
                                {/foreach}
                            ]
                        });
                    }
                </script>
            {/if}

            <div class="text-center">
                <a href="{$WEB_ROOT}/clientarea.php" class="btn btn-default">
                    {$LANG.orderForm.continueToClientArea}
                    &nbsp;<i class="fas fa-arrow-circle-right"></i>
                </a>
            </div>

            {if $hasRecommendations}
                {include file="orderforms/standard_cart/includes/product-recommendations.tpl"}
            {/if}
        </div>
    </div>
</div>
