// Load cart from localStorage
let cart = JSON.parse(localStorage.getItem("cart")) || [];

// Add Product To Cart
function addToCart(name, price, image)
{
    let cart = JSON.parse(localStorage.getItem("cart")) || [];

    cart.push({
        name: name,
        price: price,
        image: image
    });

    localStorage.setItem(
        "cart",
        JSON.stringify(cart)
    );

    updateCartCount();

    alert(name + " added to cart!");
}

// Update Cart Count in Navbar
function updateCartCount()
{
    let cart = JSON.parse(localStorage.getItem("cart")) || [];

    let countElement =
    document.getElementById("cart-count");

    if(countElement)
    {
        countElement.innerText = cart.length;
    }
}

// Display Cart Items
function loadCart()
{
    let cart =
    JSON.parse(localStorage.getItem("cart"))
    || [];

    let cartContainer =
    document.getElementById("cart-items");

    let totalElement =
    document.getElementById("total");

    if(!cartContainer)
    {
        return;
    }

    let output = "";
    let total = 0;

    cart.forEach(function(item,index){

        total += item.price;

        output += `
        <div class="cart-card">

            <img
                src="${item.image}"
                alt="${item.name}"
                class="cart-image"
            >

            <div class="cart-info">

                <h3>${item.name}</h3>

                <p class="price">
                    ₹${item.price}
                </p>

            </div>

            <button
                class="remove-btn"
                onclick="removeItem(${index})"
            >
                Remove
            </button>

        </div>
        `;
    });

    cartContainer.innerHTML = output;
    if(cart.length === 0)
{
    document.getElementById("cart-items").innerHTML =
    `
    <div class="empty-cart">
        <h2>Your Cart Is Empty</h2>
        <p>Add products from the Products Page</p>
    </div>
    `;

    document.getElementById("total").innerHTML =
    "Total: ₹0";

    return;
}

    if(totalElement)
    {
        totalElement.innerHTML =
        "Total: ₹" + total;
    }

    updateCartCount();
}

// Remove Single Item
function removeItem(index)
{
    let cart =
    JSON.parse(localStorage.getItem("cart"))
    || [];

    cart.splice(index,1);

    localStorage.setItem(
        "cart",
        JSON.stringify(cart)
    );

    loadCart();
}

// Clear Entire Cart
function clearCart()
{
    localStorage.removeItem("cart");

    document.getElementById("cart-items").innerHTML = "";

    document.getElementById("total").innerHTML =
    "Total: ₹0";

    updateCartCount();
}

// Run Automatically When Page Loads
window.onload = function()
{
    updateCartCount();
    loadCart();
};