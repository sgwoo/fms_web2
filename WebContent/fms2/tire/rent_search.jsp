<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.tire.*"%>
<jsp:useBean id="t_db" scope="page" class="acar.tire.TireDatabase"/>
<%@ include file="/tax/cookies_base.jsp" %>

<%
	String go_url 	= request.getParameter("go_url")==null?"":request.getParameter("go_url");
	
	Vector tire = new Vector();
	int tire_size = 0;
	
	if(!t_wd.equals("")){
		tire = t_db.getRentSearch("", "", "", "", "2", t_wd);
		tire_size = tire.size();
	}
%>

<html>
<head>
<title>FMS</title>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel="stylesheet" type="text/css" href="/include/table_t.css">
<script language="JavaScript" src="/include/common.js"></script>
<script language="JavaScript">
<!--
	function Search(){
		var fm = document.form1;
		fm.action="rent_search.jsp";
		fm.submit();
	}
	function enter() {
		var keyValue = event.keyCode;
		if (keyValue =='13') Search();
	}	
	
	function Disp(m_id, l_cd, c_id, c_no, c_nm, mng_id,  mng_nm) {
		var fm = document.form1;
	
		opener.form1.dtire_carnm.value 		= c_nm;	
		opener.form1.dtire_carno.value 		= c_no;	
		opener.form1.rent_l_cd.value 		= l_cd;	
		opener.form1.car_mng_id.value 		= c_id;
		opener.form1.req_nm.value 		= mng_id;

		window.close();	
	}
//-->
</script>


</head>
<body>
<form action="./rent_search.jsp" name="form1" method="POST">
  <input type='hidden' name="s_width" value="<%=s_width%>">   
  <input type='hidden' name="s_height" value="<%=s_height%>">     
  <input type='hidden' name="sh_height" value="<%=sh_height%>">   
  <input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
  <input type='hidden' name='user_id' value='<%=user_id%>'>  
  <input type="hidden" name="idx" value="<%=idx%>">
  <input type="hidden" name="s_kd" value="<%=s_kd%>">  
  <input type="hidden" name="go_url" value="<%=go_url%>">    
  <table border=0 cellspacing=0 cellpadding=0 width=100%>
    <tr> 
      <td>
        <input name="t_wd" type="text" class="text" value="<%=t_wd%>" size="50" onKeyDown="javasript:enter()" style='IME-MODE: active'>
        &nbsp;<a href="javascript:Search();" ><img src=/acar/images/center/button_search.gif border=0 align=absmiddle></a>
        </td>
    </tr>
    <tr>
        <td class=h></td>
    </tr>
    <tr>
        <td class=line2></td>
    </tr>
    <tr>
      <td class="line" >
		<table border="0" cellspacing="1" width=100%>
          <tr> 
            <td class=title width="30">연번</td>
            <td class=title width="100">계약번호</td>
            <td class=title width="150">상호</td>
            <td class=title width="100">차량번호</td>
            <td class=title width="80">대여개시일</td>
            <td class=title width="80">담당자</td>
            <td class=title width="20">구분</td>
          </tr>
          <%	if(tire_size > 0){
					for (int i = 0 ; i < tire_size ; i++){
						Hashtable ht = (Hashtable)tire.elementAt(i);%>
          <tr align="center"> 
            <td><%=i+1%></td>
         	
            <td><a href="javascript:Disp('<%=ht.get("RENT_MNG_ID")%>', '<%=ht.get("RENT_L_CD")%>', '<%=ht.get("CAR_MNG_ID")%>',
            							 '<%=ht.get("CAR_NO")%>','<%=ht.get("CAR_NM")%>' ,'<%=ht.get("MNG_ID")%>','<%=ht.get("MNG_NM")%>')" onMouseOver="window.status=''; return true"><%=ht.get("RENT_L_CD")%></a></td>
            <td><%=ht.get("FIRM_NM")%></td>
            <td><%=ht.get("CAR_NO")%></td>
            <td><%=ht.get("RENT_START_DT")%></td>
            <td><%=ht.get("MNG_NM")%></td>
            <td><%=ht.get("USE_YN")%></td>
          </tr>
          <% } %>
		  <%}else{%>
          <tr>		  
            <td colspan="7" align="center">등록된 데이타가 없습니다.</td>
          </tr>
		  <%}%>
        </table>
	</td>
  </tr>
    <tr>
      <td>&nbsp;<font color="#666666">* 구분 : Y 대여 / N 해지 / '' 미결</font>&nbsp;</td>
    </tr>
    <tr>
      <td align="right"><a href="javascript:window.close();"  ><img src=/acar/images/center/button_close.gif border=0 align=absmiddle></a></td>
    </tr>
  </table>
</form>
</body>
</html>

