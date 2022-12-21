const calculator = document.getElementById('calculator')
const display_points=document.getElementById('points_display')
const display_bails = document.getElementById('bails_display')
const trick_points_total=document.getElementById('trick_points_total')
const major_bails=document.getElementById('major_bails')
const medium_bails=document.getElementById('medium_bails')
const minor_bails=document.getElementById('minor_bails')

let points_txt="points:"
let bails_txt="bails: "
let last_action=""

let points=new Array(0)
let bails= new Array(0,0,0)

let prev_points=[...points]
let prev_bails=[...bails]

display_points.value = points_txt
display_bails.value= bails_txt

calculator.addEventListener('click', e => {
 if (e.target.matches('button')) {
   const key = e.target
   const action = key.dataset.action
   const key_content = key.textContent
   let txt=key+"/"+action+"/"+key_content
   //alert(txt)
   

   
   if(action=="add"){
      prev_points=[...points]
      prev_bails=[...bails]
      points.push(parseFloat(key_content))
      last_action="add"
   }else if(action=="bail"){
      prev_points=[...points]
      prev_bails=[...bails]
      
      if(key_content=="-1")
         bails[0]+=1
      else if(key_content=="-2")
         bails[1]+=1
      else
         bails[2]+=1
      last_action="bail"
   }else if(action=="undo"){
      points=[...prev_points]
      bails=[...prev_bails]

   }else if(action=="reset"){
      let isExecuted = confirm("Are you sure you want to reset?")
      if(isExecuted){
         prev_points=[...points]
         prev_bails=[...bails]
         last_action="reset"
         points=new Array(0)
         bails=new Array(0,0,0)
      }
      
   }else if(action=="finalize"){
      prev_points=[...points]
      prev_bails=[...bails]
      
      // sum points
      let sum=0
      for (let i = 0; i < points.length; i++) {
         sum += points[i];
         
      }
      points=[]
      points.push(sum)
      
      last_action="finalize"

      //move it to the main form
      trick_points_total.value=sum
      major_bails.value=bails[2]
      medium_bails.value=bails[1]
      minor_bails.value=bails[0]

   }
      
   //refresh view
   points_txt="points:"+points
   bails_txt="bails:"+bails
   
   display_points.value = points_txt
   display_bails.value= bails_txt
 
 }
}
)