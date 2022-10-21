<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, java.text.*, acar.util.*, acar.cus_pre.*, acar.user_mng.*" %>

<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String from_page = request.getParameter("from_page")==null?"":request.getParameter("from_page");
	String acar_id = request.getParameter("acar_id")==null?"":request.getParameter("acar_id");
	String car_no = request.getParameter("car_no")==null?"":request.getParameter("car_no");
	String car_mng_id = request.getParameter("c_id")==null?"":request.getParameter("c_id");
	String rent_mng_id = request.getParameter("m_id")==null?"":request.getParameter("m_id");
	String rent_l_cd = request.getParameter("l_cd")==null?"":request.getParameter("l_cd");
	int count = 0;
	
	
	if(acar_id.equals("")){
		acar_id = ck_acar_id;
	}
	
	String user_id = ck_acar_id;
	
	CusPre_Database cp_db = CusPre_Database.getInstance();
	
	
	Vector cmls = cp_db.getCar_maintReList(car_mng_id);
		
%>
<html>
<head><title>FMS</title>
<script language='javascript'>

<!--
	
	//댓글 등록
function Comment_save(){
		var fm = document.AncDispForm;
		if(fm.comment.value == ''){ 	alert('특이사항을 입력하십시오'); return; }
		fm.action = './cus_pre_comment_a.jsp';
		fm.target = "i_no";
		fm.submit();
	}


//의견 삭제 
function deleteAncComment(bbs_id, bbs_comment_seq){	
	var str = confirm("댓글을 삭제하시겠습니까?");
	if(str == true){
	
		window.open("anc_comment_b.jsp?bbs_id="+bbs_id+"&bbs_comment_seq="+bbs_comment_seq, "SCAN", "left=10, top=10, width=620, height=250, scrollbars=yes, status=yes, resizable=yes");
	}else{
		return false;
	}
}



//-->
</script>
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<%@ include file="/acar/getNaviCookies.jsp" %>
<script language="JavaScript" src="/include/common.js"></script>
</head>
<body onLoad="javascript:self.focus()" id="body">
<form  name="AncDispForm" method="post">
	<input type="hidden" name="car_mng_id" value="<%=car_mng_id%>">
	<input type="hidden" name="user_id" value="<%=user_id%>">
  	<input type="hidden" name="cmd" value="">
  	<input type="hidden" name="rent_mng_id" value="<%=rent_mng_id%>">
  	<input type="hidden" name="rent_l_cd" value="<%=rent_l_cd%>">
   	<input type="hidden" name="car_no" value="<%=car_no%>">
<center>
<table border="0" cellspacing="0" cellpadding="0" width="650">
	<tr> 
        <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2><%=car_no%> 차량 검사의뢰 특이사항</span></td>
    </tr>
	<tr>
		<td class=h ></td>
	</tr>

  <tr>
        <td class=line2></td>
    </tr>
	<tr>
	  <td class="line"><table border="0" cellspacing="1" cellpadding="0" width=100%>
        <tr>
          <td width="15%" class="title">작성자</td>
          <td class="title">특이사항</td>
          <td width="15%" class="title">등록일</td>       
        </tr>
        

<%if(cmls.size() >0){%>
	
  
		<%	for(int i = 0 ; i < cmls.size() ; i++){
	     		Hashtable cml = (Hashtable)cmls.elementAt(i); 
	     		
				String cont = AddUtil.replace(String.valueOf(cml.get("CONTENT")),"\\","&#92;&#92;");
		
				cont = AddUtil.replace(cont,"\"","&#34;");
				cont = Util.htmlR(cont);				
			
		%>

	        <tr>			
	          <td align="center"><%=cml.get("USER_NM")%></td>
	          <td>&nbsp;<%=cont%></td>
	          <td align="center"><%=AddUtil.ChangeDate2(String.valueOf(cml.get("REG_DT")))%></td>
	       
	       </tr>
		<%}%>
	<%}%>
	   </table></td>
    </tr>
	
	<tr>
		<td></td>
	</tr>

	<tr>
		<td></td>
	</tr>


	<tr>
		<td class=h></td>
	</tr>
    <tr>
		<td class=line2></td>
	</tr>
	<tr>
	  <td class="line">
		  <table border="0" cellspacing="1" cellpadding="0" width='100%'>
			<tr>
			  <td width="200" class="title">특이사항</td>
			  <td width="350" align="center">
				<textarea name="comment" id="comment" cols="80" rows="2" class="text"></textarea></td>
			  <td width="80" align="center"><a href="javascript:Comment_save()"><img src="/acar/images/center/button_reg.gif" align=absmiddle border=0></a></td>
			</tr>
		  </table>
	  </td>
    </tr>


	<tr>
		<td></td>
	</tr>

</table>
</center>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/2.1.4/jquery.min.js"></script>
<script>
	//특수문자 ' " 제한 2018.02.06
	var regex = /['"]/gi;
	var comment;
	$("#comment").bind("keyup",function(){comment = $("#comment").val();if(regex.test(comment)){$("#comment").val(comment.replace(regex,""));}});
</script>
<iframe src="about:blank" name="i_no" width="100" height="100" cellpadding="0" cellspacing="0" border="1" frameborder="0" noresize>
</form>		
</body>
</html>