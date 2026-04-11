(function () {
    'use strict';

    if (window.CynixUrlParamsLoaded) {
        return;
    }

    window.CynixUrlParamsLoaded = true;

    var params = new URLSearchParams(window.location.search);
    var fallback = {
        businessName: 'Cynix Inc Digital Solutions',
        email: 'info.cynixinc@gmail.com',
        phone: '+94722558244',
        address: '267, Jampettah Street, Colombo 13',
        tagline: 'Delicious Food Near Your Town'
    };

    var normalized = {
        businessName: params.get('businessName') || params.get('bn') || fallback.businessName,
        email: params.get('email') || params.get('e') || fallback.email,
        phone: params.get('phone') || params.get('p') || fallback.phone,
        address: params.get('address') || params.get('a') || fallback.address,
        tagline: params.get('tagline') || params.get('t') || fallback.tagline,
        website: params.get('website') || params.get('w') || '',
        color: params.get('color') || params.get('c') || ''
    };

    window.CynixUrlParams = normalized;

    function get(key) {
        return normalized[key] || fallback[key] || '';
    }

    document.addEventListener('DOMContentLoaded', function () {
        // Replace text content for elements with data-pb attribute
        document.querySelectorAll('[data-pb]').forEach(function (el) {
            var key = el.getAttribute('data-pb');
            if (key && normalized[key]) {
                el.textContent = normalized[key];
            }
        });

        // Replace href for phone links
        document.querySelectorAll('[data-ph-phone]').forEach(function (el) {
            var phone = get('phone');
            if (phone) {
                el.href = 'tel:' + phone.replace(/\s/g, '');
            }
        });

        // Replace href for email links
        document.querySelectorAll('[data-ph-email]').forEach(function (el) {
            var email = get('email');
            if (email) {
                el.href = 'mailto:' + email;
            }
        });

        // Update meta description if business name is personalized
        if (normalized.businessName !== fallback.businessName) {
            var metaDesc = document.querySelector('meta[name="description"]');
            if (metaDesc) {
                var newDesc = normalized.businessName + ' - ' + normalized.tagline;
                metaDesc.setAttribute('content', newDesc);
            }
        }

        // Update page title if business name is personalized
        if (normalized.businessName !== fallback.businessName) {
            var title = document.querySelector('title');
            if (title) {
                title.textContent = normalized.businessName;
            }
        }
    });
})();
