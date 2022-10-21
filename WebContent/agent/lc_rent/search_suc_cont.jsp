<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*"%>
<jsp:useBean id="a_db" scope="page" class="acar.cont.AddContDatabase"/>
<%@ include file="/agent/cookies.jsp" %> 

<%
	String s_kd 		= request.getParameter("s_kd")==null?"2":request.getParameter("s_kd");
	String t_wd 		= request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String from_page 	= request.getParameter("from_page")==null?"":request.getParameter("from_page");
	String rent_l_cd 	= request.getParameter("rent_l_cd")==null?"":request.getParameter("rent_l_cd");
	String rent_dt	 	= request.getParameter("rent_dt")==null?"":request.getParameter("rent_dt");
	String idx 		= request.getParameter("idx")==null?"":request.getParameter("idx");
	
	Vector vt = new Vector();
	if(!t_wd.equals("")){
		vt = a_db.getContSucBaseList(s_kd, t_wd, ck_acar_id);
	}
	int vt_size = vt.size();
%> 

<html>
<head>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr ">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--
	//검색하기
	function search(){
		var fm = document.form1;	
		if(fm.t_wd.value == ''){ alert('검색어를 입력하십시오.'); fm.t_wd.focus(); return; }	
		fm.submit();
	}
	function enter() {
		var keyValue = event.keyCode;
		if (keyValue =='13') search();
	}
	
	function Disp(rent_mng_id, rent_l_cd, car_no){
		var fm = document.form1;
		opener.form1.grt_suc_m_id.value 	= rent_mng_id;		
		opener.form1.grt_suc_l_cd.value 	= rent_l_cd;
		opener.form1.grt_suc_c_no.value 	= car_no;
		self.close();
	}
//-->
</script>
</head>

<body onload="javascript:document.form1.t_wd.focus();">
<form name='form1' method='post' action='search_suc_cont.jsp'>
  <input type='hidden' name='rent_l_cd' value='<%=rent_l_cd%>'>      
  <input type='hidden' name='rent_dt' value='<%=rent_dt%>'>        
  <input type='hidden' name='from_page' value='<%=from_page%>'> 
  <input type="hidden" name="idx" value="<%=idx%>">

  <table width="100%" border="0" cellspacing="0" cellpadding="0">
    <tr> 
      <td>
	  <img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>검색조건</span> :  <select name='s_kd'>
          <option value='2' <%if(s_kd.equals("2")){%>selected<%}%>>상호 </option>
          <option value='3' <%if(s_kd.equals("3")){%>selected<%}%>>차량번호 </option>
        </select>
        &nbsp;&nbsp;&nbsp;
        <input type='text' name='t_wd' size='25' class='text' value='<%=t_wd%>' onKeyDown='javascript:enter()' style='IME-MODE: active'>
		<a href="javascript:search();"><img src=/acar/images/center/button_search.gif align=absmiddle border=0></a>
      </td>
    </tr>		
    <tr> 
      <td class=line>
	    <table border="0" cellspacing="1" width=100%>
        <tr>
          <td class=title width="5%">연번</td>
          <td class=title width="25%">상호</td>		  
          <td class=title width="13%">계약번호</td>
          <td class=title width="12%">차량번호</td>
          <td class=title width="20%">차명</td>		  
          <td class=title width="15%">대여기간</td>		  
          <td class=title width="10%">해지일자</td>		  		  
        </tr>
        <%for (int i = 0 ; i < vt_size ; i++){
				Hashtable ht = (Hashtable)vt.elementAt(i);%>
        <tr>
          <td align="center"><%=i+1%></td>
          <td align="center"><%=ht.get("FIRM_NM")%></td>		  
          <td align="center"><a href="javascript:Disp('<%=ht.get("RENT_MNG_ID")%>','<%=ht.get("RENT_L_CD")%>','<%=ht.get("CAR_NO")%>')" onMouseOver="window.status=''; return true"><%=ht.get("RENT_L_CD")%></a></td>
          <td align="center"><%=ht.get("CAR_NO")%></td>
          <td align="center"><%=ht.get("CAR_NM")%></td>		  
          <td align="center"><%=ht.get("RENT_START_DT")%>~<%=ht.get("RENT_END_DT")%></td>		  
          <td align="center"><%=ht.get("CLS_DT")%></td>		  
        </tr>
        <%		}%>
      </table>
	  </td>
    </tr>
    <tr>
        <td class=h></td>
    </tr>    	
    <tr> 
      <td align="center"><a href="javascript:self.close();"><img src=/acar/images/center/button_close.gif align=absmiddle border=0></a></td>
    </tr>
  </table>
</form>
</body>
</html>