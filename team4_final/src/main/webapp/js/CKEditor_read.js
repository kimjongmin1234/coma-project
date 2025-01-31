//editorConfig.js에서 CKEditor 설정 정보 불러오기
import { editorConfig, setContentsLength, setTextLength, setImgLength } from 'editorConfig';
import { ClassicEditor } from 'CKEditor';

//CKEditor 생성
console.log('CKEditor 생성');
ClassicEditor.create(document.querySelector('#readEditor'), editorConfig)
.then( editor => {
	window.editor = editor;
	console.log('CKEditor 전송 정보 : ' + editor);
	
	// editor가 변경되면 현재 글자수와 이미지 개수를 출력해줍니다.
	editor.model.document.on('change:data', function () {
		//CKEditor에 작성된 정보를 가져옵니다.
		var str = editor.getData();
	    setTextLength(str);
		setImgLength(str);
	});
	
	//editor 의 id 값을 넣어줍니다.
	var editorStatus = false;
	// 폼을 제출할 때 이벤트 리스너 추가
	const form = document.querySelector('form'); // 폼 선택
	form.addEventListener('submit', function(event) {
		//CKEditor에 작성된 정보를 가져옵니다.
		var str = editor.getData();
		editorStatus = setContentsLength(str, 2, 255);
		console.log("form.addEventListener 실행 : " + editorStatus);
		if (!editorStatus) {
			console.log("if (!editorStatus) 실행 : " + editorStatus);
			event.preventDefault(); // 폼 제출 방지
		}
	});
	
	//게시글 받아오기
	editor.setData(contentData);
})
.catch(err => {
	console.log('발생 오류 : '+err);
});
