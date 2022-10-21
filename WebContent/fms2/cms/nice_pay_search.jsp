<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, acar.util.*"%>
<jsp:useBean id="ai_db" scope="page" class="acar.incom.IncomDatabase"/>
<%@ include file="/acar/cookies.jsp" %>
<%@ include file="/acar/access_log.jsp" %>

<html>
<head><title>FMS</title>
<script language='JavaScript' src='../../include/common.js'></script>
<script language='javascript'>
<!--
	function search()
	{
		var fm = document.form1;
	
		fm.target = "inner";
			
		fm.action = "nice_pay_print.jsp";
					
		fm.submit();				
	}
	
	function enter() 
	{
		var keyValue = event.keyCode;
		if (keyValue =='13') search();
	}
//-->
</script>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">

<link rel=stylesheet type="text/css" href="/include/table_t.css">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css">
</head>
<body>
<%
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String br_id 	= request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String s_kd 	= request.getParameter("s_kd")==null?"":request.getParameter("s_kd");
	String t_wd 	= request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String asc 	= request.getParameter("asc")==null?"0":request.getParameter("asc");
	String gubun2 	= request.getParameter("gubun2")==null?"":request.getParameter("gubun2");
	
	String from_page = request.getParameter("from_page")==null?"":request.getParameter("from_page");  //popup 요청한 페이지
	String adate = request.getParameter("adate")==null?"":request.getParameter("adate");
		
	//height
	int sh_height = request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//상단길이

	
	int cnt = 2; //sc 출력라인수
	int height = AddUtil.parseInt(s_height)-emp_top_height-sh_height-(cnt*sc_line_height)-100;//현황 라인수만큼 제한 아이프레임 사이즈	
	
		//jip_cms 테이블에서 입금반영된 출금의뢰일 조회하기
	Vector vt2 = ai_db.getACardJipCmsDate();
	int vt_size2 = vt2.size();	
	
	//jip_cms 테이블 조회하기
	Vector vt = ai_db.getJipCmsDateList(adate, s_kd, t_wd);
	int vt_size = vt.size();
	

%>
<form name='form1' method='post'>
<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
<input type='hidden' name='user_id' value='<%=user_id%>'>
<input type='hidden' name='br_id' value='<%=br_id%>'>

<input type='hidden' name='no_cnt' >

<div class="navigation">
	<span class=style1>재무회계 > 카드CMS관리 ></span><span class=style5>카드 출금(NICE조회) </span>
</div>

<div class="search-area">
	<label><i class="fa fa-check-circle"></i> 조회일자 </label>
	 <select id='gubun2'  name='gubun2' class="select" style="width:100px;">
            <option value="1" <%if(gubun2.equals("1"))%>selected<%%>>신청일자</option>
     </select>	
     
      <select name="adate" style="width:100px;">
			    <option value="">===선택===</option>
<%		for(int i = 0 ; i < vt_size2 ; i++){
			Hashtable ht = (Hashtable)vt2.elementAt(i);%>
                <option value="<%=ht.get("ADATE")%>"  <% if(adate.equals(String.valueOf(ht.get("ADATE"))))%> selected<%%>><%=AddUtil.ChangeDate2(String.valueOf(ht.get("ADATE")))%></option>
<%		}%>
          </select>				
                
	&nbsp;&nbsp;
	
	<label><i class="fa fa-check-circle"></i> 검색조건 </label>
	<select id="s_kd" name="s_kd" class="select" style="width:100px;">
		     <option value='1' <%if(s_kd.equals("1")){%>selected<%}%>>상호 </option>
            <option value='2' <%if(s_kd.equals("2")){%>selected<%}%>>계약번호 </option>
          
	</select>
	&nbsp;
	<input type='text' name='t_wd' size='25' class='text' value='<%=t_wd%>' onKeyDown='javascript:enter()' style='IME-MODE: active'>
	&nbsp;&nbsp;
	<input type="button" class="button" value="검색" onclick="search()"/>
</div>

<table border="0" cellspacing="0" cellpadding="0" width=100%>
	 
  <tr> 
 	  <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>내역조회</span></td>
  </tr>  
 
 
  <tr>
	<td class='line'>
	  <table border="0" cellspacing="1" cellpadding="0" width=100%> 
		  <tr>
			<td>
			  <iframe src="nice_pay_print.jsp" name="inner" width="100%" height="<%=height%>" cellpadding="0" cellspacing="0" border="0" frameborder="0" noresize scrolling=yes, marginwidth=0, marginheight=0 ></iframe>
			</td>
		  </tr>
		</table>
	  </td>
  </tr>

</table>
</form>

<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>
</body>
</html>