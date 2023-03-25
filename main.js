
const COLORS= ["#2f2bad","#ad2bad","#e42692","#f7db15","#5c65c0","#8c7c62"];

$(document).ready(() => {
    textFadeOut();
    
    $("#new-quote").on("click", textFadeOut);
})


// Get Random Quote from quotes.json
async function getQuote(){
    let promise= await fetch('./quotes.json');
    let quotes= await promise.json();
    let authors= Object.keys(quotes);
    let author = authors[Math.floor(Math.random() * authors.length)];
    let message= quotes[author];

    return [author, message];
}

// Set Quote in HTML
function setQuote(){
    console.log("on")

    const q= getQuote().then(quote => {
        $("#text").html('<i id="ico-quote" class="fa fa-quote-left"></i>'+quote[1]);
        $("#author").html('-- '+quote[0]);
        setNewColor();
        textFadeIn();
    });
}

function textFadeOut(){
    $("#text, #author").animate({opacity: 0},800).promise().then(setQuote);
}

function textFadeIn(){
    $("#text, #author").animate({opacity: 1},800);
}

function setNewColor(){
    let colorS= COLORS[Math.floor(Math.random() * COLORS.length)];
    $("#text, #author").animate({color: colorS}, 800);
    $(".all-button, body").animate({backgroundColor: colorS}, 800);
}