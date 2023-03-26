
$(document).ready(() => {
    let editorVisible= true;
    let previewVisible= true;

    //Carriage returns
    marked.use({
        breaks: true
      })
    
    loadEditor();

    //Upload any change in editor
    $("#editor").bind("input propertychange", ()=> {
        console.log("change");
        loadEditor();
    });

    //Fullscreen editor
    $("#editor-full").click(()=> {
        previewVisible= !previewVisible;

        if (previewVisible){
            $("#window-preview").hide();
            $("#editor-full").attr("class","fa fa-minus");
            let newH= $("textarea")[0].scrollHeight
            $("#editor").css({resize: "none","overflow-y": "hidden", height: newH});

        }else {
            $("#window-preview").show();
            $("#editor-full").attr("class","fa fa-plus");
            $("#editor").css({resize: "vertical","overflow-y": "scroll", height: ''});
        }
        
    });

    //Fullscreen preview
    $("#preview-full").click(()=> {
        editorVisible= !editorVisible

        if (editorVisible){
            $("#window-editor").hide();
            $("#preview-full").attr("class","fa fa-minus");

        } else {
            $("#window-editor").show();
            $("#preview-full").attr("class","fa fa-plus");
        }
        
    });
});

//Set editor elements in preview
function loadEditor(){
    const elms= $("#editor").val();
    const htmlElms= marked.parse(elms);
    
    $("#preview").html(htmlElms);
    hljs.highlightAll()
}
