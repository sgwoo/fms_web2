<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*"%>
<%@ page import="acar.util.*, acar.call.*"%>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>
<jsp:useBean id="p_db" scope="page" class="acar.call.PollDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");
	
	String poll_id = request.getParameter("poll_id")==null?"":request.getParameter("poll_id");
	
	
	//로그인ID&영업소ID
	LoginBean login = LoginBean.getInstance();
	if(user_id.equals("")) 	user_id = login.getCookieValue(request, "acar_id");
	if(br_id.equals(""))	br_id = login.getCookieValue(request, "acar_br");
	if(auth_rw.equals(""))	auth_rw = rs_db.getAuthRw(user_id, "01", "03", "01");
	

	String poll_st = "";
	String poll_type = "";
	
	Hashtable basic = p_db.getSurvey_Basic(poll_id);
	
	poll_type = String.valueOf(basic.get("POLL_TYPE")).trim();
	poll_st = String.valueOf(basic.get("POLL_ST")).trim();
	
	Vector polls = p_db.getSurvey_viewAll(poll_id);
	int poll_size = polls.size();
	
	
	
	
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

function fnPopUp(el,url, id, seq, cmt) {
var question = $(el).prev().val(); 

 var qidx = $(el).parent().parent().find(".qidrownum").text();
question = '';
 //if(fm.question.value == ''){		alert('질문내용을 입력하십시오');	return;	}
 
 newwindow=window.open(url+'?qidx='+qidx+'&question='+question+'&poll_id='+id+'&poll_seq='+seq+'&cmd='+cmt,'question','height=700,width=700');
 if (window.focus) {newwindow.focus()}
 return false;
}





</script>

<script>

	
//리스트 가기	
function list_go()
{
	var fm = document.form1;
	location = "survey_list_frame.jsp?auth_rw=<%=auth_rw%>&br_id=<%=br_id%>&user_id=<%=user_id%>";
	
}

function use_yn_save()
	{
		if(confirm('기본정보를 수정 하시겠습니까?'))
		{
			var fm = document.form1;
			
			fm.cmd.value = 'yn_ch';
			fm.target='i_no';
//			fm.action='answer_a.jsp';
			fm.submit();
			
		}
	}
	
function use_yn_delete(){
	if(confirm('해당회차의 설문전체를 삭제 하시겠습니까?'))
		{
			var fm = document.form1;

			fm.cmd.value = 'a_del';
			fm.target='i_no';
			fm.submit();
			
		}
}	
</script>
<style>
textarea {
    width: 100%;
    height: 60px;
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
    padding: 6px 20px;
    margin: 8px 0;
    box-sizing: border-box;
    border: 1px solid ;
    border-radius: 4px;
	
}
input[name=start_dt], input[name=end_dt], input[name=poll_su]  {
    width: 40%;
    padding: 6px 20px;
    margin: 8px 0;
    box-sizing: border-box;
    border: 1px solid ;
    border-radius: 4px;
	
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
    padding: 6px 20px;
    margin: 4px 0;
    box-sizing: border-box;
    border: 1px none ;
    border-radius: 4px;
	color: red;
	font-size: 1.2em;
}

table.type07 {
	border-collapse: collapse;
	text-align: left;
	line-height: 1.5;
	border: 1px solid #ccc;
	margin: 20px 10px;
	font-size : 0.9em;
}
table.type07 thead {
	border-right: 1px solid #ccc;
	border-left: 1px solid #ccc;
	background: #fcf1f4;
}
table.type07 thead th {
	padding: 10px;
	font-weight: bold;
	vertical-align: top;
	color: #fff;
}
table.type07 tbody th {
	width: 150px;
	padding: 10px;
	font-weight: bold;
	vertical-align: top;
	border-bottom: 1px solid #ccc;
	background: #fcf1f4;
}
table.type07 td {
	width: 350px;
	padding: 10px;
	vertical-align: top;
	border-bottom: 1px solid #ccc;
}
</style>
</head>
<body>
<form name='form1' method='post' id="form1" action="answer_a.jsp">
<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
<input type='hidden' name='br_id' value='<%=br_id%>'>
<input type='hidden' name='user_id' value='<%=user_id%>'>
<input type='hidden' name='poll_id' value='<%=basic.get("POLL_ID")%>'>
<input type='hidden' name='cmd' value=''>

<div class="navigation">
	<span class=style1>콜센터 ></span><span class=style5>콜항목관리 수정</span>
</div>
<table border=0 cellspacing=0 cellpadding=0 width=100%>
	<tr>
		<td class=h></td>
	</tr>
	<tr>
		<td class=h></td>
	</tr>
	<tr>
		<td align="right" colspan="2">
			<input type="button" class="button button4" value="목록" onclick="list_go()"/>
		</td>
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
						<select id="poll_type" name="poll_type" >
							<option value = ""  <%if(poll_type.equals("")){out.print("selected");}%>> 선택 </option>
							<option value = "계약" <%if("계약".equals(poll_type)){out.print("selected");}%>>계약</option>
							<option value = "순회정비" <%if("순회정비".equals(poll_type)){out.print("selected");}%>>순회정비</option>
							<option value = "사고처리" <%if("사고처리".equals(poll_type)){out.print("selected");}%>>사고처리</option>
						</select>
					</td>
					<td align="center" height="35">
						<select id="poll_st" name="poll_st">
							<option value = ""  <%if(poll_st.equals("")){out.print("selected");}%>> 선택 </option>
							<option class="계약" value = "신규"  <%if(poll_st.equals("신규")){out.print("selected");}%>> 신규 </option>
							<option class="계약" value = "대차"  <%if(poll_st.equals("대차")){out.print("selected");}%>> 대차 </option>
							<option class="계약" value = "증차"  <%if(poll_st.equals("증차")){out.print("selected");}%>> 증차 </option>
							<option class="계약" value = "재리스"  <%if(poll_st.equals("재리스")){out.print("selected");}%>> 재리스 </option>
							<option class="계약" value = "월렌트"  <%if(poll_st.equals("월렌트")){out.print("selected");}%>> 월렌트 </option>
							<option class="순회정비" value = "순회정비"  <%if(poll_st.equals("순회정비")){out.print("selected");}%>> 순회정비 </option>
							<option class="사고처리" value = "사고처리"  <%if(poll_st.equals("사고처리")){out.print("selected");}%>> 사고처리 </option>
						</select>
					</td>
					<td align="center" height="35"><input type="text" name="poll_su" id="poll_su" value="<%=basic.get("POLL_SU")%>" style="align:center;"size="10" >&nbsp;회</td>
					<td align="center" height="35">
						<input type="text" name="start_dt" id="start_dt" title="YYYY-MM-DD" size="12" value="<%=AddUtil.ChangeDate2(String.valueOf(basic.get("START_DT")))%>" data-bind="kendoDatePicker: startDate">~<input type="text" name="end_dt" id="end_dt" title="YYYY-MM-DD" size="12" value="<%=AddUtil.ChangeDate2(String.valueOf(basic.get("END_DT")))%>" data-bind="kendoDatePicker: endDate">
					</td>
                    <td align="center" height="35">
						<select name='use_yn' id='use_yn'>
						<option value='Y' <%if(basic.get("USE_YN").equals("Y"))out.print("selected");%>>사용</option>
						<option value='N' <%if(basic.get("USE_YN").equals("N"))out.print("selected");%>>미사용</option>
						</select>
					</td>
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
					<td align="">&nbsp;&nbsp;<input type="text" name="poll_title" id="poll_title" size="100" value="<%=basic.get("POLL_TITLE")%>">&nbsp;&nbsp;( * 설문조사화면 상단에 보여주는 문구 입니다.)</td>
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
		<td align="right"></td>
	</tr>
	<tr>
		<td>&nbsp;&nbsp;<input type="button" class="button button4" value="질문추가" onclick="fnPopUp(this, 'answer_i.jsp','<%=basic.get("POLL_ID")%>','','p_save')"/>
		
		</td>
		<td align="right">
			&nbsp;&nbsp;<input type="button" class="button button4" value="저장" onclick="use_yn_save()"/>
		&nbsp;&nbsp;<input type="button" class="button button4" value="전체삭제" onclick="use_yn_delete()"/>
		</td>
	</tr>
	<tr>
		<td class=h></td>
	</tr>
	<tr>
		<td class=h></td>
	</tr>
	<tr>
		<td class=line colspan="2" align="center">
			
		</td>
	</tr>
	

</table>
<%if(poll_size > 0){
	for(int i = 0 ; i < poll_size ; i++){
		Hashtable poll = (Hashtable)polls.elementAt(i);
		
		Vector ans = p_db.getSurvey_answer((String)poll.get("POLL_ID"), (String)poll.get("POLL_SEQ"));
		int ans_size = ans.size();
		
		%>	
<table border="0" cellspacing="1" cellpadding="0" width=100% class="type07">
	<thead>	
		<tr> 
			<th scope="cols" width="15%" style="font-size:1.2em;height:10px;">질문 <%=poll.get("POLL_SEQ")%></th>
			<th scope="cols" style="text-align:left; color: red;font-size: 1.2em;"><%=poll.get("CONTENT")%><!--<input type="text" name="question" value="<%=poll.get("CONTENT")%>" >-->
			</th>	
			<th scope="cols" width="15%" style="vertical-align:middle;">
				<%if(poll.get("A_SEQ").equals("0")){%><input type="button" value="편집" class="button button4" onclick="fnPopUp(this, 'answer_u.jsp','<%=poll.get("POLL_ID")%>','<%=poll.get("POLL_SEQ")%>')"/><%}%>
			</th>
		</tr>
	</thead>
	<tbody>
		<tr> 
			<th scope="row" width="15%">답변 <%//=poll.get("POLL_SEQ")%></th>
			<td colspan="2">
			<%
			for(int j = 0 ; j < ans_size ; j++){
			Hashtable answ = (Hashtable)ans.elementAt(j);
			%>
		
					&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
					<%if(answ.get("MULTI_CHK").equals("Y")){%>
					<input type="checkbox" name="answer_chk<%=i+1%>"><%=answ.get("CONTENT")%><br/>
					<%}else{%>
					<input type="radio" name="answer<%=i+1%>"><%=answ.get("CONTENT")%><br/>
					<%}%>
					<%if(answ.get("CHK").equals("Y")){%>
					&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<textarea rows="1" style=" width: 50%;"></textarea><br/>
					<%}%>
			<%}%>
			</td>	
		</tr>
	</tbody>
</table>
	<%}	}%>
</form>	
</body>
</html>