// 전역변수들
const addBtn = document.getElementsByClassName('add-button')[0];
const loginBtn = document.getElementsByClassName('login-button')[0];
const ongoingTasks = document.getElementById('doing');
const finishedTasks = document.getElementById('finished');

let taskNum = 0;

/** to-do
 * 서버로 할 일/한 일 목록 전송
 * CRUD 작업시 -> 서버에 반영, 바뀐 점은 post로 서버로 전송
 */

/** finished
 * add랑 complete(modify작업 끝), 
 * finished, removed 버튼 눌렀을 때 작동하는 작업 html상에서 구현 완료 
 */

/**
 * 할 일 추가 버튼, task 블록 여기있음
 */
addBtn.addEventListener('click', ()=>{
    const tl = document.getElementsByClassName('task-list')[0];
    const screen = document.getElementsByClassName('screen')[0];
    const top = document.getElementsByClassName('top')[0];
    const bottom = document.getElementsByClassName('bottom')[0];


    // console.log(tl);
    taskNum++;
    tl.innerHTML = tl.innerHTML + `
    <div class="task" id=task-${taskNum}>
        <input type="checkbox" class="checkbox" name="task" onclick="completeTask(this.parentNode)">
        <input type="text" class="text" value="할 일 ${taskNum}" onchange="" disabled>
        
        <input type="button" value="modify" class="modify" onclick="modify(this.parentNode)">
        <input type="button" value="remove" class="remove" onclick="removeTask(this.parentNode)">
    </div>
    `;

    // screen.height = top.height + bottom.height;
    updateDateTime();
});
/**
 * 로그인 버튼
 */
loginBtn.addEventListener('click', ()=>{
    const tl = document.getElementsByClassName('task-list')[0];
    console.log(tl);
});

/**
 * 값 수정하는 function
 */
function modify(inputBlock){
    // console.log(inputBlock.parentNode.childNodes);
    const modifyBtn = inputBlock.childNodes[5];
    const textBox = inputBlock.childNodes[3];
    // console.log(inputBlock.childNodes);

    if(textBox.disabled){
        modifyBtn.value = 'complete';
    }else{  
        // 수정 완료
        modifyBtn.value = 'modify';
        updateDateTime();
    }
    textBox.disabled = !textBox.disabled;
    // console.log(task, task.childNodes, task.childNodes[3], task.childNodes[3].value, textBox.value);
    textBox.value = textBox.value;
}
/**
 * 할 일 끝냈을 때 함수
 */
const completeTask = function(task){
    // const text = task.childNodes[3].value;
    const isChecked = task.childNodes[1].checked;   // 누름 -> true, 다시누름 -> false
    const ongoingTasksList = ongoingTasks.childNodes[1];
    const finishedTasksList = finishedTasks.childNodes[1];

    if(isChecked){
        finishedTasksList.append(task);
    }else{
        ongoingTasksList.append(task);
    }
    updateDateTime();
}

/**
 * 할 일 제거 함수
 */
const removeTask = function(task){
    // todo : db에서 제거하기
    task.remove();
    updateDateTime();
}

/**
 * 최근 수정 시각 update 함수
 */
function updateDateTime(){
    const timeBox = document.getElementById('last-update');
    let date = new Date();
    let year = date.getFullYear();
    let month = ('0' + (date.getMonth() + 1)).slice(-2);
    let day = ('0' + date.getDate()).slice(-2);
    let dateString = year + '-' + month  + '-' + day;

    let hours = ('0' + date.getHours()).slice(-2); 
    let minutes = ('0' + date.getMinutes()).slice(-2);
    let seconds = ('0' + date.getSeconds()).slice(-2);
    let timeString = hours + ':' + minutes  + ':' + seconds;
    
    timeBox.innerText = `last update: ${dateString} ${timeString}`
}