<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, card.*"%>
<jsp:useBean id="a_db" scope="page" class="acar.cont.AddContDatabase"/>
<%@ include file="/acar/cookies.jsp" %> 

<%
	String s_kd 		= request.getParameter("s_kd")==null?"1":request.getParameter("s_kd");
	String t_wd 		= request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String from_page 	= request.getParameter("from_page")==null?"":request.getParameter("from_page");
	String rent_l_cd 	= request.getParameter("rent_l_cd")==null?"":request.getParameter("rent_l_cd");
	String rent_dt	 	= request.getParameter("rent_dt")==null?"":request.getParameter("rent_dt");
	String idx 			= request.getParameter("idx")==null?"":request.getParameter("idx");
	
	Vector vt = a_db.getContGrtSucList(s_kd, t_wd, rent_l_cd, rent_dt);
	int vt_size = vt.size();
%> 

<html>
<head>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr ">
<link rel="stylesheet" type="text/css" href="/include/table_t.css"></link>
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
	
	function Disp(rent_mng_id, rent_l_cd, car_no, grt_amt){
		var fm = document.form1;
		opener.form1.grt_suc_m_id.value 	= rent_mng_id;		
		opener.form1.grt_suc_l_cd.value 	= rent_l_cd;
		opener.form1.grt_suc_c_no.value 	= car_no;
		opener.form1.grt_suc_o_amt.value	= grt_amt;
		opener.form1.grt_suc_r_amt.value	= grt_amt;		
		opener.form1.grt_suc_cha_amt.value	= 0;
		self.close();
	}
//-->
</script>
</head>

<body>
<form name='form1' method='post' action='s_grt_suc.jsp'>
  <input type='hidden' name='rent_l_cd' value='<%=rent_l_cd%>'>      
  <input type='hidden' name='rent_dt' value='<%=rent_dt%>'>        
  <input type='hidden' name='from_page' value='<%=from_page%>'> 
  <input type="hidden" name="idx" value="<%=idx%>">

  <table width="100%" border="0" cellspacing="0" cellpadding="0">
    <tr> 
      <td>
	    <select name='s_kd'>
          <option value='1' <%if(s_kd.equals("1")){%>selected<%}%>>고객관리번호 </option>
          <option value='2' <%if(s_kd.equals("2")){%>selected<%}%>>상호 </option>
          <option value='3' <%if(s_kd.equals("3")){%>selected<%}%>>차량번호 </option>
        </select>
        &nbsp;&nbsp;&nbsp;
        <input type='text' name='t_wd' size='25' class='text' value='<%=t_wd%>' onKeyDown='javascript:enter()' style='IME-MODE: active'>
		<input type="button" name="b_ms2" value="검색" onClick="javascript:search();" class="btn">
      </td>
    </tr>		
    <tr> 
      <td class=line>
	    <table border="0" cellspacing="1" width=100%>
        <tr>
          <td class=title width="5%">연번</td>
          <td class=title width="25%">상호</td>		  
          <td class=title width="15%">계약번호</td>
          <td class=title width="12%">차량번호</td>
          <td class=title width="19%">차명</td>		  
          <td class=title width="12%">보증금</td>		  
          <td class=title width="12%">해지일자</td>		  		  
        </tr>
        <%for (int i = 0 ; i < vt_size ; i++){
				Hashtable ht = (Hashtable)vt.elementAt(i);%>
        <tr>
          <td align="center"><%=i+1%></td>
          <td align="center"><%=ht.get("FIRM_NM")%></td>		  
          <td align="center"><a href="javascript:Disp('<%=ht.get("RENT_MNG_ID")%>','<%=ht.get("RENT_L_CD")%>','<%=ht.get("CAR_NO")%>','<%=AddUtil.parseDecimal(String.valueOf(ht.get("GRT_AMT_S")))%>')" onMouseOver="window.status=''; return true"><%=ht.get("RENT_L_CD")%></a></td>
          <td align="center"><%=ht.get("CAR_NO")%></td>
          <td align="center"><%=ht.get("CAR_NM")%></td>		  
          <td align="right"><%=AddUtil.parseDecimal(String.valueOf(ht.get("GRT_AMT_S")))%>원</td>		  
          <td align="center"><%=ht.get("CLS_DT")%></td>		  
        </tr>
        <%		}%>
      </table>
	  </td>
    </tr>	
    <tr> 
      <td align="center"><input type="button" name="b_ms2" value="닫기" onClick="javascript:window.close();" class="btn"></td>
    </tr>
  </table>
</form>
</body>
</html>