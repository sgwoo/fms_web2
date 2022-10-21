<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*,acar.util.*, acar.user_mng.*, acar.insur.*"%>
<%@ include file="/acar/cookies.jsp" %>

<%
	MaMenuDatabase nm_db = MaMenuDatabase.getInstance();

	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");
	
	String gubun1 = request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String s_yy = request.getParameter("s_yy")==null?"":request.getParameter("s_yy");
	String s_mm = request.getParameter("s_mm")==null?"":request.getParameter("s_mm");
	String save_dt = request.getParameter("save_dt")==null?"":request.getParameter("save_dt");

	InsComDatabase ic_db = InsComDatabase.getInstance();
	
	Hashtable ht = ic_db.getInsRatioSelect(save_dt);
	
%>

<html>
<head><%@ include file="/acar/getNaviCookies.jsp" %>
<title>FMS</title>
<script language='javascript'>
<!--
	function update(){
		var modifyDt = $("#value02").val();
		$("#modify_dt").val(modifyDt);
		var fm = document.form1;
		fm.action = 'ins_ratio_i_a.jsp';
		fm.target = 'i_no';
		fm.submit();
	}
	
//-->
</script>
<style type=text/css>

<!-- 
.style1 {color: #666666}
.style2 {color: #515150; font-weight: bold;}
.style3 {color: #b3b3b3; font-size: 11px;}
.style4 {color: #737373; font-size: 11px;}
.style5 {color: #ef620c; font-weight: bold;}
.style6 {color: #4ca8c2; font-weight: bold;}
.style7 {color: #666666; font-size: 11px;}
-->

</style>
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css">
<script src="//ajax.googleapis.com/ajax/libs/jquery/1.11.1/jquery.min.js"></script>
<script src='//rawgit.com/tuupola/jquery_chained/master/jquery.chained.min.js'></script>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
</head>
<body leftmargin=15>
<form name='form1' action='' target='' method='post'>
  <input type='hidden' name='auth_rw' 	value='<%=auth_rw%>'>
  <input type='hidden' name='user_id' 	value='<%=user_id%>'>
  <input type='hidden' name='br_id' 	value='<%=br_id%>'>
  <input type='hidden' name='gubun1' 	value='<%=gubun1%>'>  
  <input type='hidden' name='s_yy' 	value='<%=s_yy%>'>  
  <input type='hidden' name='s_mm' 	value='<%=s_mm%>'>        
  <input type='hidden' name='save_dt'   value='<%=save_dt%>'> 
  <input type='hidden' name='modify_dt' id='modify_dt' value=''>

<div class="navigation">
	<span class=style1>경영정보 ></span><span class=style5>보험손해/사고율</span>
</div>
<center>
<table border="0" cellspacing="0" cellpadding="0" width='95%'>    
	<tr>
		<td class=line2></td>
	</tr>
	<tr>
		<td class='line'>
			<table border="0" cellspacing="1" cellpadding="0" width='100%'>
				<tr>
					<td colspan='2' class='title'>구분</td>
					<td width='50%' class='title'>값</td>
			  </tr>
				<tr>
					<td colspan='2'class='title'>보험사</td>
					<td>&nbsp;<select name="value01">
    			<option value="0038" selected>렌터카공제조합</option>
    		</select></td>
			  </tr>
				<tr>
					<td colspan='2'class='title'>년월</td>
					<%if(ht.get("SAVE_DT") != null){ %>
					<td>&nbsp;<input type='text'  id="value02" name="value02" value='<%=ht.get("SAVE_DT")%>' size="6"></td>
					<%}else{ %>
					<td>&nbsp;<input type='text' id="value02" name="value02" value='<%=AddUtil.getDate(1)%>-<%=AddUtil.getDate(2)%>' size="6"></td>
			  		<%} %>
			  </tr>
				<tr>
					<td width='25%' rowspan='2' class='title'>손해율</td>
					<td width='25%' class='title'>경과분담금</td>
					<%if(ht.get("AMT1") != null){ %>
					<td>&nbsp;<input type='text' name="value03" value='<%=ht.get("AMT1")%>' size="15"> 원</td>
					<%}else{ %>
					<td>&nbsp;<input type='text' name="value03" value='' size="15"> 원</td>
					<%} %>
			  </tr>
				<tr>
					<td class='title'>손해액</td>
					<%if(ht.get("AMT2") != null){ %>
					<td>&nbsp;<input type='text' name="value04" value='<%=ht.get("AMT2")%>' size="15"> 원</td>
					<%}else{ %>
					<td>&nbsp;<input type='text' name="value04" value='' size="15"> 원</td>
					<%} %>
			  </tr>
			  <tr>
					<td width='15%' rowspan='2' class='title'>* 분담금할증한정 특약 제외, 1억초과손해액/무과실사고 제외</td>
					<td width='25%' class='title'>경과분담금</td>
					<%if(ht.get("AMT1") != null){ %>
					<td>&nbsp;<input type='text' name="value07" value='<%=ht.get("AMT3")%>' size="15"> 원</td>
					<%}else{ %>
					<td>&nbsp;<input type='text' name="value07" value='' size="15"> 원</td>
					<%} %>
			  </tr>
				<tr>
					<td class='title'>손해액</td>
					<%if(ht.get("AMT2") != null){ %>
					<td>&nbsp;<input type='text' name="value08" value='<%=ht.get("AMT4")%>' size="15"> 원</td>
					<%}else{ %>
					<td>&nbsp;<input type='text' name="value08" value='' size="15"> 원</td>
					<%} %>
			  </tr>
				<tr>
				    <td rowspan='2' class='title'>사고율</td>
					<td class='title'>유효대수</td>
					<%if(ht.get("CNT1") != null){ %>
					<td>&nbsp;<input type='text' name="value05" value='<%=ht.get("CNT1")%>' size="6"> 건</td>
					<%}else{ %>
					<td>&nbsp;<input type='text' name="value05" value='' size="6"> 건</td>
					<%} %>
			  </tr>
				<tr>
					<td class='title'>사고건수</td>
					<%if(ht.get("CNT2") != null){ %>
					<td>&nbsp;<input type='text' name="value06" value='<%=ht.get("CNT2")%>' size="6"> 건</td>
					<%}else{ %>
					<td>&nbsp;<input type='text' name="value06" value='' size="6"> 건</td>
					<%} %>
			  </tr>
			</table>
		</td>
	</tr>
    <tr>
        <td class=h></td>
    </tr>
    <tr>
        <td align="right">		
		<%	if(nm_db.getWorkAuthUser("전산팀",user_id)||nm_db.getWorkAuthUser("보험업무",user_id)){%>
		<a href="javascript:update()" onMouseOver="window.status=''; return true"><img src=/acar/images/center/button_modify.gif align=absmiddle border=0></a>&nbsp;
		<%	}%>
		<a href="javascript:window.close()" onMouseOver="window.status=''; return true"><img src=/acar/images/center/button_close.gif align=absmiddle border=0></a></td>
    </tr>	
</table>
</center>
</form>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>
</body>
</html>
