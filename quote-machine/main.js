
const COLORS= ["#2f2bad","#ad2bad","#e42692","#f7db15","#5c65c0","#8c7c62"];
const TIME_QUOTE= 800;

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
    const q= getQuote().then(quote => {
        $("#text").html('<i id="ico-quote" class="fa fa-quote-left"></i>'+quote[1]);
        $("#author").html('-- '+quote[0]);
        setNewColor();
        textFadeIn();
    });
}

function textFadeOut(){
    $("#text, #author").animate({opacity: 0},TIME_QUOTE).promise().then(setQuote);
}

function textFadeIn(){
    $("#text, #author").animate({opacity: 1},TIME_QUOTE);
}

function setNewColor(){
    let colorS= COLORS[Math.floor(Math.random() * COLORS.length)];
    $("#text, #author").animate({color: colorS}, TIME_QUOTE);
    $(".all-button, body").animate({backgroundColor: colorS}, TIME_QUOTE);
}
