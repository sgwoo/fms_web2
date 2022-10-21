<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*"%>
<%@ page import="acar.util.*"%>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");
	
	String s_kd = request.getParameter("s_kd")==null?"":request.getParameter("s_kd");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String asc = request.getParameter("asc")==null?"0":request.getParameter("asc");
	
	String question =  request.getParameter("question")==null?"":request.getParameter("question");
	String qidx =  request.getParameter("qidx")==null?"":request.getParameter("qidx");
	//로그인ID&영업소ID
	LoginBean login = LoginBean.getInstance();
	if(user_id.equals("")) 	user_id = login.getCookieValue(request, "acar_id");
	if(br_id.equals(""))	br_id = login.getCookieValue(request, "acar_br");
	if(auth_rw.equals(""))	auth_rw = rs_db.getAuthRw(user_id, "01", "03", "01");
%>


<!DOCTYPE html>
<html>
<head>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<title>fms</title>
<link rel="stylesheet" type="text/css" href="/include/table_t.css"></link>
<link rel="stylesheet" href="//code.jquery.com/ui/1.11.4/themes/smoothness/jquery-ui.css">
<script src="//code.jquery.com/jquery.min.js"></script>
<script src="//code.jquery.com/ui/1.11.4/jquery-ui.min.js"></script>
    <script type="text/javascript">
$(document).ready(function(){
 var rowTag = $("#addTb2 tbody").html();
 $("#addTb2").data("rowTag", rowTag); 
 //키값 rowTag로 테이블의 기본 row 값의 Html태그 저장
 
});
function fnAddRow(){
 var rowlen = $("#addTb2 tr").length-1;
 $("#addTb2 tbody").append($("#addTb2").data("rowTag"));
 
 fnSetRowNo();
}
function fnDelRow(obj){
 if($("#addTb2 tr").length < 3){
  alert("더이상 삭제할 수 없습니다.");
  return false;
 }else{
  $(obj).parent().parent().remove();
  
  fnSetRowNo();
 }
}
function fnSetRowNo(){
    var span = $("#addTb2 tbody tr td span");  
    var span_cnt = span.length; // tbody안의 tr안에 td안에 span 태그들의 갯수
    if(span_cnt == 1){ // span이 한개일경우 순번 붙이기
        $("span.#idrownum").text("A1")
    }else{ // span이 여러개일경우 순번 붙이기
        $.each(span,function(index){
			 index=index+1;
           $(this).text('A'+index);
		    $(this).closest("tr").attr("id",'A'+index); 
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
 
 
var savetomain = function(){

	var a_data = new Array();
	var questionId = $("input[name='question']").attr("id");
	var max = $('input[name="answer[]"]').length


	$($('input[name="answer[]"]').get().reverse()).each(function(i){
		a_data[i] = $(this).val();
		index = i ;

		$(opener.document).find("#"+questionId).after("<tr><td align='center'></td><td align='center'><input type='hidden' name='max' value='"+max+"'>   <input type='text' name='q_value' value='"+(max-index)+"^"+questionId+"' ><input type='text' name='ans<%=qidx%>' value='<%=qidx%>'> A"+(max-index)+" <input type='text' name='answer<%=qidx%>>' value='"+a_data[i]+"' style='width:80%;'><input type=checkbox name='answerrem<%=qidx%>' value=1 />별도설명허용</td><td align='center'><input type='button' value='답변삭제' onclick='fnDelRow(this)'/></td></tr>");

	});

	

	closeWin();
}
 
function closeWin() {
    self.opener = self;
	window.close();
}
</script>
</head>
<body>
<form name='form1' method='post' action=''>
<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
<input type='hidden' name='br_id' value='<%=br_id%>'>
<input type='hidden' name='user_id' value='<%=user_id%>'>


<table border=0 cellspacing=0 cellpadding=0 width=100%>
	<tr>
		<td class=h></td>
	</tr>
	<tr> 
		<td class=line>
			<table border="0" cellspacing="1" cellpadding="0" width=100%>
				<tr>
					<td class="title" height="35">질문내용</td>
				</tr>
				<tr>
					<td align="">&nbsp;&nbsp;<input type="text" id="<%=qidx%>" name="question" style="width:90%;" value="<%=qidx+" "%><%=question%>">&nbsp;&nbsp;</td>
				</tr>
			</table>
		</td>
	</tr>
	<tr>
		<td class=h></td>
	</tr>
	<tr>
		<td class=line2></td>
	</tr>
	<tr>
		<td><input type="button" value="답변추가" onclick="fnAddRow()"/></td>
	</tr>
	
	<tr>
		<td class=line>
			<table id="addTb2" border="0" cellspacing="1" cellpadding="0" width=100%>
				<thead>
					<tr>
						<th align="center">No.</th>
						<th align="center">답변관리</th>
						<th></th>
					</tr>
				</thead>
				<tbody>
					<tr class="tbltr"> 
						<td align="center">
							<span class="idrownum" id="idrownum">A1</span>
						</td>
						<td align="center">
							<input type="text" id="answer[]" name="answer[]" style="width:80%;" />
							<!--<input type='checkbox' name='answerrem' value="1" />별도설명허용-->
						</td>
						<td align="center">
							<input type="button" value="삭제" onclick="fnDelRow(this)"/>
						</td>
					</tr>
				</tbody>
			</table>
		</td>
	</tr>
</table>	

		
<input type="button" value="저장" onclick="savetomain()"/>
<input type="button" value="닫기" onclick="closeWin()"/>

</form>
</body>
</html>