//Vars

  //Buttons IDs
const Q_BTN= ["bt-q", "Heater 1"];
const W_BTN= ["bt-w", "Heater 2"];
const E_BTN= ["bt-e", "Heater 3"];
const A_BTN= ["bt-a", "Heater 4"];
const S_BTN= ["bt-s", "Clap"];
const D_BTN= ["bt-d", "Open HH"];
const Z_BTN= ["bt-z", "Kick n' Hat"];
const X_BTN= ["bt-x", "Kick"];
const C_BTN= ["bt-c", "Closed"];

const SOUNDS_BUTTONS= {
  "KeyQ": Q_BTN, "KeyW": W_BTN, "KeyE": E_BTN, 
  "KeyA": A_BTN, "KeyS": S_BTN, "KeyD": D_BTN, 
  "KeyZ": Z_BTN, "KeyX": X_BTN, "KeyC": C_BTN
}

// Events

document.addEventListener("DOMContentLoaded", () => {
  document.getElementById("volume").value= 100;

  const soundsButtKeys= Object.keys(SOUNDS_BUTTONS);

  //Click 
  for (let i=0; i< soundsButtKeys.length; i++){
    document.getElementById(SOUNDS_BUTTONS[soundsButtKeys[i]][0]).addEventListener("click", () => 
      playSound(SOUNDS_BUTTONS[soundsButtKeys[i]]));    
  }

  //Keyup 
  document.addEventListener("keyup", (e) => {
    if (SOUNDS_BUTTONS[e.code] !== undefined) {
      let button= document.getElementById(SOUNDS_BUTTONS[e.code][0])
      button.click();
      
      //Show effect active button
      button.classList.add("active");
      //Hide effect active button
      setTimeout(function(){
        button.classList.remove("active");
      },100);
    }
  });

  //Volume
  document.getElementById("volume").addEventListener("change", ()=> {
    let audios= Array.from(document.getElementsByTagName("audio"));

    audios.map((audio)=> {
      audio.volume= document.getElementById("volume").value / 100;
    }); 

    
  });

  //Power
  document.getElementById("power").addEventListener("click", ()=>{
    let powerState= document.getElementById("power").checked;
    let elementsInteract= Array.from(document.getElementsByClassName("interact-element"));

    //Enable elements
    if (powerState) {
      elementsInteract.map((elementI) =>{
        elementI.removeAttribute("disabled");
      });
    
    //Disable elements
    }else {
      elementsInteract.map((elementI) =>{
        elementI.setAttribute("disabled",true);
      });
      document.getElementById("display-text").innerHTML="";
    }

  });

});


// Functions

function playSound(buttonData){
    document.getElementById(buttonData[0]).getElementsByTagName("audio")[0].play();
    document.getElementById("display-text").innerHTML= buttonData[1];
}
