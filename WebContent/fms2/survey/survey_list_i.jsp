<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*"%>
<%@ page import="acar.util.*, acar.call.*"%>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>
<jsp:useBean id="poll_db" scope="page" class="acar.call.PollDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");
	
	String s_kd = request.getParameter("s_kd")==null?"":request.getParameter("s_kd");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String asc = request.getParameter("asc")==null?"0":request.getParameter("asc");
	
	//로그인ID&영업소ID
	LoginBean login = LoginBean.getInstance();
	if(user_id.equals("")) 	user_id = login.getCookieValue(request, "acar_id");
	if(br_id.equals(""))	br_id = login.getCookieValue(request, "acar_br");
	if(auth_rw.equals(""))	auth_rw = rs_db.getAuthRw(user_id, "01", "03", "01");
	
	
	String poll_id = poll_db.getPollNextId();
%>


<!DOCTYPE html>
<html>
<head>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<title>fms</title>
<link rel="stylesheet" type="text/css" href="/include/table_t.css"></link>

<link rel="stylesheet" href="//code.jquery.com/ui/1.11.4/themes/smoothness/jquery-ui.css">
<script src="https://ajax.googleapis.com/ajax/libs/jquery/1.6.4/jquery.min.js" type="text/javascript"></script>
<script src="//code.jquery.com/jquery.min.js"></script>
<script src="//code.jquery.com/ui/1.11.4/jquery-ui.min.js"></script>

<script>
$(function() {
  $( "#start_dt" ).datepicker({
    dateFormat: 'yy-mm-dd',
    prevText: '이전 달',
    nextText: '다음 달',
    monthNames: ['1월','2월','3월','4월','5월','6월','7월','8월','9월','10월','11월','12월'],
    monthNamesShort: ['1월','2월','3월','4월','5월','6월','7월','8월','9월','10월','11월','12월'],
    dayNames: ['일','월','화','수','목','금','토'],
    dayNamesShort: ['일','월','화','수','목','금','토'],
    dayNamesMin: ['일','월','화','수','목','금','토'],
    showMonthAfterYear: true,
    yearSuffix: '년'
  });
});
$(function() {
  $( "#end_dt" ).datepicker({
    dateFormat: 'yy-mm-dd',
    prevText: '이전 달',
    nextText: '다음 달',
    monthNames: ['1월','2월','3월','4월','5월','6월','7월','8월','9월','10월','11월','12월'],
    monthNamesShort: ['1월','2월','3월','4월','5월','6월','7월','8월','9월','10월','11월','12월'],
    dayNames: ['일','월','화','수','목','금','토'],
    dayNamesShort: ['일','월','화','수','목','금','토'],
    dayNamesMin: ['일','월','화','수','목','금','토'],
    showMonthAfterYear: true,
    yearSuffix: '년'
  });
});

</script>
<script language='javascript'>
<!--
     var cnt = new Array();
     cnt[0] = new Array('선택');
     cnt[1] = new Array('선택','신규','대차','증차','재리스','월렌트');
     cnt[2] = new Array('선택','순회정비');
     cnt[3] = new Array('선택','사고처리');
   

     function change(plus) {
     var sel=document.form1.poll_st
       /* 옵션메뉴삭제 */
       for (i=sel.length-1; i>=0; i--){
         sel.options[i] = null
         }
       /* 옵션박스추가 */
       for (i=0; i < cnt[plus].length;i++){                     
         sel.options[i] = new Option(cnt[plus][i], cnt[plus][i]);
       }         
     }
//-->
</script>
<!-- 동적테이블 생성 부분, 질문추가버튼 클릭시 실행하는 스크립트 -->
<script type="text/javascript">
var rowIndex = 0;

$(document).ready(function(){
 var rowTag = $("#addTbl tbody").html();
 $("#addTbl").data("rowTag", rowTag); 
 //키값 rowTag로 테이블의 기본 row 값의 Html태그 저장
  
});

function fnAddRow(){
 var rowlen = $("#addTbl tr").length-1;
 //$("#addTbl tbody").append("<tr id='"+rowIndex+"'><td></td><td></td><td></td></tr>");
 
 //alert(rowlen);
 
 $("#addTbl tbody").append($("#addTbl").data("rowTag"));

 fnSetRowNo();
}

function fnDelRow(obj){
 if($("#addTbl tr").length < 3){
  alert("더이상 삭제할 수 없습니다.");
  return false;
 }else{
	if(confirm("항목을 삭제 하시겠습니까?")) {
		$(obj).parent().parent().remove();
	} else {
        return false;
        }	 
  
  
  fnSetRowNo();
 }
}
function fnSetRowNo(){
    var span = $("#addTbl tbody tr td span");  
//	var tr_id = $("#addTbl tbody tr#id").val();  
	//alert(tr_id);
    var span_cnt = span.length; // tbody안의 tr안에 td안에 span 태그들의 갯수
    if(span_cnt == 1){ // span이 한개일경우 순번 붙이기
        $("span.#qidrownum").text("Q1")
//		$("tr.#tr_q1").text("Q1")
    }else{ // span이 여러개일경우 순번 붙이기
        $.each(span,function(index){
			 index=index+1;
           $(this).text('Q'+index);
           $(this).closest("tr").attr("id",'Q'+index); 
        });
    } 
}
 
 function rowCheDel() {
  var $obj = $("input[name='chk']");
  var checkCount = $obj.size();
  for ( var i = 0; i < checkCount; i++) {
   if ($obj.eq(i).is(":checked")) {
    $obj.eq(i).parent().parent().remove();
   }
  }
 }
 
 
 $('td input').click(function(){
    $(this).parent().remove();
});
</script>

<script>

function fnPopUp(el, url, cmt) {
	var question = $(el).prev().val(); 
	var qidx = $(el).parent().parent().find(".qidrownum").text();
	question = '';
	
 if(document.form1.poll_type.value == ''){	alert('구분을 선택하세요.');	return;	}
 if(document.form1.poll_st.value == ''){	alert('계약타입을 선택하세요.');	return;	}
 if(document.form1.poll_su.value == ''){	alert('회차를 입력하세요.');	return;	}
 if(document.form1.start_dt.value == ''){	alert('설문시작일을 입력하세요.');	return;	}
   
 newwindow=window.open(url+'?qidx='+qidx+'&question='+question+'&poll_id='+<%=poll_id%>+'&cmd='+cmt,'question','height=700,width=800');
 if (window.focus) {newwindow.focus()}
 return false;
}
</script>

<script>
function save()
	{
		if(confirm('등록하시겠습니까?'))
		{
			var fm = document.form1;
		//	if(fm.question.value == ''){		alert('질문내용을 입력하십시오');	return;	}
		//	else if(fm.answer1.value == ''){	alert('대답1 입력하십시오');	return;	}
		//	else if(fm.answer2.value == ''){	alert('대답2 입력하십시오');	return;	}
		
		
			fm.target='i_no';
			fm.submit();
		}
	}
	
	
function Change (target,type) 
{  
       if ( target.value == target.defaultValue && type==0) target.value = ''; 
       if ( !target.value && type==1) target.value = target.defaultValue; 
} 	

 // TEXTAREA 최대값 체크

    function fn_TextAreaInputLimit() {

        var tempText = $("textarea[name='poll_title']");

        var tempChar = "";                                        // TextArea의 문자를 한글자씩 담는다

        var tempChar2 = "";                                        // 절삭된 문자들을 담기 위한 변수

        var countChar = 0;                                        // 한글자씩 담긴 문자를 카운트 한다

        var tempHangul = 0;                                        // 한글을 카운트 한다

        var maxSize = 250;                                        // 최대값

        

        // 글자수 바이트 체크를 위한 반복

        for(var i = 0 ; i < tempText.val().length; i++) {

            tempChar = tempText.val().charAt(i);

 

            // 한글일 경우 2 추가, 영문일 경우 1 추가

            if(escape(tempChar).length > 4) {

                countChar += 2;

                tempHangul++;

            } else {

                countChar++;

            }

        }

        

        // 카운트된 문자수가 MAX 값을 초과하게 되면 절삭 수치까지만 출력을 한다.(한글 입력 체크)

        // 내용에 한글이 입력되어 있는 경우 한글에 해당하는 카운트 만큼을 전체 카운트에서 뺀 숫자가 maxSize보다 크면 수행

        if((countChar-tempHangul) > maxSize) {

            alert("최대 글자수를 초과하였습니다.");

            

            tempChar2 = tempText.val().substr(0, maxSize-1);

            tempText.val(tempChar2);

        }

    }
	
	//리스트 가기	
function list_go()
{
	var fm = document.form1;
	location = "survey_list_frame.jsp?auth_rw=<%=auth_rw%>&br_id=<%=br_id%>&user_id=<%=user_id%>";
	
}
</script>
<style>
textarea {
    width: 100%;
    height: 100px;
    padding: 12px 20px;
    box-sizing: border-box;
    border: 2px solid #ccc;
    border-radius: 4px;
    background-color: #f8f8f8;
    font-size: 16px;
    resize: none;
}
input[name=poll_title] {
    width: 70%;
    padding: 4px 20px;
    margin: 8px 0;
    box-sizing: border-box;
    border: 1px solid #929292;
    border-radius: 2px;
	
}
input[name=start_dt], input[name=end_dt], input[name=poll_su]  {
    width: 40%;
    padding: 4px 10px;
    margin: 8px 0;
    box-sizing: border-box;
	border: 1px solid #929292;
    border-radius: 2px;
	
}
select {
    width: 40%;
    padding: 4px 8px;
    border: 1px solid ;
    border-radius: 4px;
    background-color: #ffff;
	font-size: 1em;
}

input[name=question] {
    width: 80%;
    padding: 4px 10px;
    margin: 4px 0;
    box-sizing: border-box;
    border: 1px none ;
    border-radius: 4px;
	color: red;
	font-size: 1.2em;
}


</style>
</head>
<body>
<form name='form1' method='post' action=''>
<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
<input type='hidden' name='br_id' value='<%=br_id%>'>
<input type='hidden' name='user_id' value='<%=user_id%>'>
<input type="hidden" name="poll_id" id="poll_id" value='<%=poll_id%>'>
<div class="navigation">
	<span class=style1>콜센터 ></span><span class=style5>콜항목관리</span>
</div>
<table border=0 cellspacing=0 cellpadding=0 width=100%>
	<tr>
		<td align="right" colspan="2"><input type="button" class="button button4" value="목록" onclick="list_go()"/></td>
	</tr>
	<tr>
		<td class=h><br/></td>
	</tr>
	<tr>
		<td class=line2></td>
	</tr>
	<tr> 
		<td class=line colspan="2">
			<table border="0" cellspacing="1" cellpadding="0" width=100%>
				<tr>
					<td class="title" width="20%" height="35">구분</td>
					<td class="title" width="20%" height="35">계약타입</td>
					<td class="title" width="20%" height="35">회차</td>
					<td class="title" width="20%" height="35">기간</td>
					<td class="title" width="20%" height="35">사용구분</td>
				</tr>
				<script src='//rawgit.com/tuupola/jquery_chained/master/jquery.chained.min.js'></script>
				<script>
				$(function() {
					$("#poll_st").chained("#poll_type");
				});
				</script>				
				<tr>
					<td align="center" height="35">
						<select id="poll_type" name="poll_type"  class="select">
							<option value = "" selected> 선택 </option>
							<option value = "계약">계약</option>
							<option value = "순회정비">순회정비</option>
							<option value = "사고처리">사고처리</option>
						</select>
					</td>
					<td align="center" height="35">
						<select id="poll_st" name="poll_st"  class="select">
							<option value = "" selected> 선택 </option>
							<option class="계약" value = "신규"> 신규 </option>
							<option class="계약" value = "대차"> 대차 </option>
							<option class="계약" value = "증차"> 증차 </option>
							<option class="계약" value = "재리스"> 재리스 </option>
							<option class="계약" value = "월렌트"> 월렌트 </option>
							<option class="순회정비" value = "순회정비"> 순회정비 </option>
							<option class="사고처리" value = "사고처리"> 사고처리 </option>
						</select>
					</td>
					<td align="center" height="35"><input type="text" name="poll_su" id="poll_su" value="<%//=poll_su%>" style="align:center;"size="10">회차</td>
					<td align="center" height="35">
						<input type="text" name="start_dt" id="start_dt" title="YYYY-MM-DD" size="12" data-bind="kendoDatePicker: startDate">~<input type="text" name="end_dt" id="end_dt" title="YYYY-MM-DD" size="12" data-bind="kendoDatePicker: endDate">
					</td>
                    <td align="center" height="35">
                      <select name='use_yn' id='use_yn'  class="select">
                        <option value='Y' selected >사용</option>
                        <option value='N'>미사용</option>
                      </select></td>

				</tr>
				
			</table>
		</td>
	</tr>
	
	<tr>
		<td class=h></td>
	</tr>
	<tr> 
		<td class=line colspan="2">
			<table border="0" cellspacing="1" cellpadding="0" width=100%>
				<tr>
					<td class="title"  width="20%" height="35">안내문구</td>
					<td align="">&nbsp;&nbsp;
					<input type="text" name="poll_title" id="poll_title" size="100" value="한글128자/ 영문+숫자 256 글자까지 입력할 수 있습니다." onFocus='Change(this,0)' onBlur='Change(this,1)' onkeyup="javascript:fn_TextAreaInputLimit();" style="color:#A9A9A9;">&nbsp;&nbsp;( * 설문조사화면 상단에 보여주는 문구 입니다.)</td>
				</tr>
			</table>
		</td>
	</tr>
	<tr>
		<td class=h></td>
	</tr>
	
	<tr>
		<td class=h colspan="2"><hr width="100%"></hr></td>
	</tr>
	<tr>
		<td class=h></td>
	</tr>
	<tr>
		<td class=line2></td>
	</tr>
	<tr>
		<td align="left"><input type="button" class="button button4" value="질문추가" onclick="fnPopUp(this, 'answer_i.jsp', 'n_save')"/></td>
		<td align="right"><input type="button" class="button button4" value="저장" onclick="use_yn_save()"/></td>
	</tr>

	<tr>
		<td class=h></td>
	</tr>
	
</table>	

		




</form>	
</body>
</html>