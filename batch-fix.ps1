# Batch fix all HTML files in wellfood-pizza
$files = Get-ChildItem -Path "." -Filter "*.html" -File

# Personalization Script to add
$personalizationScript = @'
<!-- Personalization Script -->
<script>
(function(){
    var params = new URLSearchParams(window.location.search);
    var get = function(keys) {
        for (var i = 0; i < keys.length; i++) {
            var v = params.get(keys[i]);
            if (v) return decodeURIComponent(v);
        }
        return null;
    };
    
    var data = {
        businessName: get(['bn', 'businessName']) || 'Cynix Inc Digital Solutions',
        phone: get(['p', 'phone']) || '+94722558244',
        address: get(['a', 'address']) || '267, Jampettah Street, Colombo 13',
        email: get(['e', 'email']) || 'info.cynixinc@gmail.com',
        tagline: get(['t', 'tagline']) || 'Delicious Food Near Your Town'
    };
    
    // Replace text content
    document.querySelectorAll('[data-pb]').forEach(function(el) {
        var key = el.getAttribute('data-pb');
        if (data[key] && el.textContent) {
            el.textContent = data[key];
        }
    });
    
    // Replace href for phone
    document.querySelectorAll('[data-ph-phone]').forEach(function(el) {
        if (data.phone) el.href = 'tel:' + data.phone.replace(/\s/g, '');
    });
    
    // Replace href for email
    document.querySelectorAll('[data-ph-email]').forEach(function(el) {
        if (data.email) el.href = 'mailto:' + data.email;
    });
    
    // Update meta description
    var metaDesc = document.querySelector('meta[name="description"]');
    if (metaDesc && data.businessName !== 'Cynix Inc Digital Solutions') {
        metaDesc.setAttribute('content', data.businessName + ' - ' + data.tagline);
    }
    
    // Update page title
    var title = document.querySelector('title');
    if (title && data.businessName !== 'Cynix Inc Digital Solutions') {
        title.textContent = data.businessName + ' - Pizza';
    }
})();
</script>
'@

# Navigation fix - replace all broken home links
$navOld = @'
        <li><a href="/">Home Restauran</a></li>
        <li><a href="/">Home Pizza</a></li>
        <li><a href="/">Home Burger</a></li>
        <li><a href="/">Home Chiken</a></li>
        <li><a href="/">Juice & Drinks</a></li>
        <li><a href="/">Home Grill</a></li>
'@

$navNew = @'
        <li><a href="/">Home Restaurant</a></li>
        <li><a href="/index2">Home Pizza</a></li>
        <li><a href="/index3">Home Burger</a></li>
        <li><a href="/index4">Home Chicken</a></li>
        <li><a href="/index5">Juice & Drinks</a></li>
        <li><a href="/index6">Home Grill</a></li>
'@

# Header number phone fix
$phoneOld = '<div class="header-number">'
$phoneNew = '<div class="header-number">'

foreach ($file in $files) {
    Write-Host "Processing: $($file.Name)"
    $content = Get-Content $file.FullName -Raw
    
    # Check if file needs updating
    $needsUpdate = $false
    
    # Fix navigation links
    if ($content -match '<li><a href="/">Home Restauran</a></li>') {
        $content = $content -replace [regex]::Escape($navOld), $navNew
        $needsUpdate = $true
    }
    
    # Fix Menu Grill typo
    if ($content -match '<a href="/menu-grill">Menu Gril</a>') {
        $content = $content -replace '<a href="/menu-grill">Menu Gril</a>', '<a href="/menu-grill">Menu Grill</a>'
        $needsUpdate = $true
    }
    
    # Add data-pb attributes to business name if not present
    if ($content -match '<span class="logo-text"' -and $content -notmatch 'data-pb="businessName"') {
        $content = $content -replace '<span class="logo-text"([^>]*)>', '<span class="logo-text"$1 data-pb="businessName">'
        $needsUpdate = $true
    }
    
    # Add data-ph-phone to header phone
    if ($content -match '<a href="tel:' -and $content -notmatch 'data-ph-phone') {
        $content = $content -replace '(<a href="tel:[^"]+")([^>]*>)', '$1 data-ph-phone$2'
        $content = $content -replace '(<a href="tel:[^>]*>)(\+94722558244)', '$1 data-pb="phone">$2'
        $needsUpdate = $true
    }
    
    # Add personalization script before </head>
    if ($content -notmatch 'Personalization Script' -and $content -match '</head>') {
        $content = $content -replace '</head>', "$personalizationScript`n</head>"
        $needsUpdate = $true
    }
    
    if ($needsUpdate) {
        Set-Content -Path $file.FullName -Value $content -NoNewline
        Write-Host "  Updated: $($file.Name)"
    } else {
        Write-Host "  No changes: $($file.Name)"
    }
}

Write-Host "`nBatch update complete!"
