<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, acar.util.*"%>
<jsp:useBean id="ai_db" scope="page" class="acar.incom.IncomDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<html>
<head><title>FMS</title>
<script language='JavaScript' src='../../include/common.js'></script>
<script language='javascript'>
<!--
	//검색하기
	function search(){
		var fm = document.form1;
		
		//검색어 확인 
		fm.action = 'file11_cms_print.jsp';
		fm.target='_self';
		fm.submit();
	}
	
//-->
</script>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
</head>
<body>
<%

	String adate = request.getParameter("adate")==null?"":request.getParameter("adate");
	String s_kd = request.getParameter("s_kd")==null?"":request.getParameter("s_kd");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	
		
	int no_cnt = 0;
	
	
	//jip_cms 테이블 조회하기
	Vector vt = ai_db.getMemberCmsEb11List(s_kd, t_wd);
	int vt_size = vt.size();
	
	
%>
<form name='form1' method='post'  >

<input type='hidden' name='sh_height' value='74'>
<table border="0" cellspacing="0" cellpadding="0" width=100%>

  <tr>
	<td class='line'>
	  <table border="0" cellspacing="1" cellpadding="0" width=100%>
	  
	  	<tr>
		  <td width='160' class='title'>구분</td>
		  <td  colspan='11' >&nbsp;
              <select name="s_kd">                     
              <option value='2' <%if(s_kd.equals("2"))%>selected<%%>>차량번호</option>
              <option value='3' <%if(s_kd.equals("3"))%>selected<%%>>계약번호</option>            
              </select>	
              <input type="text" name="t_wd" value="<%=t_wd%>" size="20" class=text onKeyDown="javasript:enter()" style='IME-MODE: active'>	
			  &nbsp; <a href="javascript:search()"><img src="/acar/images/center/button_in_search.gif" align=absmiddle border="0"></a>	
			  &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;구분이 1인경우:신청완료, 그외: 해지완료 
		  </td>
	
		  	
	  </table>
	</td>
 </tr>  
<tr>
	<td class='line'>
	  <table border="0" cellspacing="1" cellpadding="0" width=100%>	    
	<tr>
		  <td width='40' class='title'>연번</td>
		  <td width='120' class='title'>상호</td>
		  <td width='80' class='title'>차량번호</td>
		  <td width='100' class='title'>계약번호</td>
		  <td width='90' class='title'>은행</td>
		  <td width='40' class='title'>코드</td>
		  <td width='90' class='title'>생년월일/사업자</td>
		  <td width='90' class='title'>계좌번호</td>
		 <td width='70' class='title'>기관코드</td>
		 <td width='60' class='title'>파일명</td>
		  <td width='40' class='title'>구분</td>	  
		  <td width='50' class='title'>등록일</td>
		   <td width='50' class='title'>최초영업자</td>
	 </tr>
<%		for(int i = 0 ; i < vt_size ; i++){
			Hashtable ht = (Hashtable)vt.elementAt(i);
		
			
			%>
		<tr>
		  <td  width='40' align="center" ><%=i+1%></td>
		  <td width='120' >&nbsp;<%=ht.get("FIRM_NM")%></td>
		  <td width='80' align="center" ><%=ht.get("CAR_NO")%></td>
		  <td width='100' align="center" ><%=ht.get("RENT_L_CD")%></td>		
		  <td width='90' align="center" ><%=ht.get("BNAME")%></td>
		  <td width='40' align="center" ><%=ht.get("BANK_CODE")%></td>
		  <td width='90' align="center" ><%=ht.get("ID_NO")%></td>
		  <td width='90' align="center" ><%=ht.get("ACCOUNT_NO")%></td>
		  <td width='70' align="center" ><%=ht.get("ORG_CODE")%></td>
		  <td width='60' align="center" ><%=ht.get("FILENAME")%></td>
		  <td width='40' align="center" ><%=ht.get("REG_KIND")%></td>
		  <td width='50' align="center" ><%=ht.get("ADATE")%></td>
		  <td width='50' align="center" ><%=ht.get("USER_NM")%></td>
		</tr>

<%}%>	
	  </table>
	</td>
  </tr>
   
</table>
</form>

	
<script language='javascript'>
<!--
	
//-->
</script>
</body>
</html>