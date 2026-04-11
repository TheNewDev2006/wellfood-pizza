# Download images for wellfood-pizza
$baseUrl = "https://wellfood.starplatethemes.com/assets/images"
$imageUrls = @(
    # Background images
    "/background/footer-bg.png",
    "/background/hero-two.jpg",
    "/background/form-bg.png",
    "/background/booking-table.jpg",
    "/background/special-pizza-bg.png",
    
    # Hero images
    "/hero/pizza.png",
    "/hero/letter-shape.png",
    "/hero/letter-shape-two.png",
    "/hero/hero-two.png",
    
    # Testimonials
    "/testimonials/testimonials-two-bg.png",
    "/testimonials/testimonials-two.jpg",
    
    # About
    "/about/why-choose-us.jpg",
    "/about/pizza.png",
    
    # Instagram
    "/instagram/instagram1.jpg",
    "/instagram/instagram2.jpg",
    "/instagram/instagram3.jpg",
    "/instagram/instagram4.jpg",
    "/instagram/instagram5.jpg",
    
    # Banner
    "/banner/category-banner1.jpg",
    "/banner/category-banner2.jpg",
    "/banner/category-banner3.jpg",
    "/banner/category-banner4.jpg",
    
    # Blog
    "/blog/blog4.jpg",
    "/blog/blog5.jpg",
    "/blog/blog6.jpg",
    
    # Pizza products
    "/pizza/pizza1.png",
    "/pizza/pizza2.png",
    "/pizza/pizza3.png",
    "/pizza/pizza4.png",
    
    # Dishes
    "/dishes/special-pizza.png",
    "/dishes/pizza-menu1.png",
    
    # Category
    "/category/category1.png",
    "/category/category2.png",
    "/category/category3.png",
    "/category/category4.png",
    "/category/category5.png",
    "/category/category-badge.png",
    "/category/category-badge2.png",
    
    # Shapes
    "/shapes/tomato.png",
    "/shapes/chillies.png",
    "/shapes/hero-shape2.png",
    "/shapes/hero-shape3.png",
    "/shapes/hero-shape5.png",
    "/shapes/why-choose1.png",
    "/shapes/why-choose2.png",
    "/shapes/about-star.png",
    "/shapes/about-star-yellow.png",
    "/shapes/special-pizza-shape.png",
    "/shapes/scroll-top-bg.png",
    "/shapes/pizza-badge-shape.png",
    "/shapes/newsletter-pizza-shape.png",
    "/shapes/pizza-two.png",
    
    # Logos
    "/logos/logo.png",
    "/logos/logo-black.png",
    "/logos/favicon.png"
)

$targetDir = "assets/images"

foreach ($url in $imageUrls) {
    $fullUrl = $baseUrl + $url
    $localPath = $targetDir + $url
    $localDir = Split-Path $localPath -Parent
    
    if (!(Test-Path $localDir)) {
        New-Item -ItemType Directory -Path $localDir -Force | Out-Null
    }
    
    if (!(Test-Path $localPath)) {
        try {
            Write-Host "Downloading: $url"
            Invoke-WebRequest -Uri $fullUrl -OutFile $localPath -UserAgent "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36"
        } catch {
            Write-Host "Failed: $url - $_"
        }
    } else {
        Write-Host "Exists: $url"
    }
}

Write-Host "Download complete!"
