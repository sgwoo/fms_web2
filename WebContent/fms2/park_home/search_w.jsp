<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.parking.*"%>
<jsp:useBean id="pk_db" scope="page" class="acar.parking.ParkIODatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");//권한
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");//사용자 관리번호
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");//사용자 소속영업소
	String rent_st = request.getParameter("rent_st")==null?"":request.getParameter("rent_st");
	String gubun = request.getParameter("gubun")==null?"":request.getParameter("gubun");
	String go_url = request.getParameter("go_url")==null?"":request.getParameter("go_url");
	
	String s_gubun1 = request.getParameter("s_gubun1")==null?"":request.getParameter("s_gubun1");//사고구분
	String s_kd = request.getParameter("s_kd")==null?"2":request.getParameter("s_kd");//검색조건
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");//검색어
	
	String rent_mng_id = request.getParameter("rent_mng_id")==null?"":request.getParameter("rent_mng_id");
	String rent_l_cd = request.getParameter("rent_l_cd")==null?"":request.getParameter("rent_l_cd");
	String car_mng_id = request.getParameter("car_mng_id")==null?"":request.getParameter("car_mng_id"); //차량관리번호
	String car_no = request.getParameter("car_no")==null?"":request.getParameter("car_no");//차량번호
	String car_nm = request.getParameter("car_nm")==null?"":request.getParameter("car_nm");//차량명
	String mng_id = request.getParameter("mng_id")==null?"":request.getParameter("mng_id");//
	
	String m_id = "";
	String l_cd = "";
	String c_id = "";
	String c_no = "";
	String c_nm = "";
	String mng_nm = "";

	
	String f_pl = "";
	String f_co = "";
	String d_nm = "";
	
	String from_place = request.getParameter("from_place")==null?"":request.getParameter("from_place");
	String from_comp = request.getParameter("from_comp")==null?"":request.getParameter("from_comp");
	String driver_nm = request.getParameter("driver_nm")==null?"":request.getParameter("driver_nm");		
		
	Vector vt = pk_db.getParkSearch("", "", "", "", s_kd, t_wd);
	int s_size = vt.size();
	
%> 

<html> <head> <title>FMS</title> <meta http-equiv="Content-Type" 
content="text/html; charset=euc-kr "> <link rel=stylesheet type="text/css" 
href="../../include/table_t.css"> <script language='JavaScript' 
src='/include/common.js'></script> <script language='javascript'> 
<!--
//검색하기

	 function search(){ 
	 	var fm = document.form1;
	 	if(fm.t_wd.value == ''){ 
		alert('검색어를 입력하십시오.'); fm.t_wd.focus(); return; }	fm.submit(); 
	} 
	
	
	function enter() {
		var keyValue = event.keyCode; if (keyValue =='13') search(); 
	}
	
	//계약선택
	function Disp(m_id, l_cd, c_id, c_no, c_nm, c_st, mng_id,  mng_nm, user_m_tel, firm_nm, park_id) {
		
		var fm = opener.document.form1;
		fm.rent_mng_id.value = m_id;
		fm.rent_l_cd.value = l_cd;
		fm.car_mng_id.value = c_id;
		fm.car_no.value = c_no;
		fm.car_nm.value = c_nm;
		fm.car_st.value = c_st;
		fm.mng_id.value = mng_id;
		fm.users_comp.value = mng_nm;
		fm.user_m_tel.value = user_m_tel;
		fm.firm_nm.value = firm_nm;
		
		if (park_id != "1") {
			if(!confirm('현위치가 영남주차장이 아닙니다. 등록 하시겠습니까?')){
				return;
			} else {
				fm.action = "park_w_i.jsp";
				self.close();
			}
		} else {
			fm.action = "park_w_i.jsp";
			self.close();
		} 
	}	
	
	
//-->
</script>
</head>

<body>
<form name='form1' method='post' action='search_w.jsp'>
<input type='hidden' name="auth_rw" value='<%=auth_rw%>'>
<input type='hidden' name="user_id" value='<%=user_id%>'>
<input type='hidden' name="br_id" value='<%=br_id%>'>
<input type='hidden' name="s_gubun1" value='<%=s_gubun1%>'>
<input type='hidden' name="rent_st" value='<%=rent_st%>'>
<input type='hidden' name="gubun" value='<%=gubun%>'>
<input type='hidden' name="go_url" value='<%=go_url%>'>
  <table width="450" border="0" cellspacing="0" cellpadding="0">
    
     <tr> 
      <td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<img src="/acar/images/center/arrow_gsjg.gif"  border="0" align=absmiddle></a>&nbsp;		
        <select name='s_kd'>       
          <option value='2' <%if(s_kd.equals("2"))%>selected<%%>>차량번호</option>
          <%-- <option value='4' <%if(s_kd.equals("4"))%>selected<%%>>차대번호</option> --%>
    <!--      <option value='3' <%if(s_kd.equals("3"))%>selected<%%>>계출번호</option>	-->	  
        </select>
        <input type="text" name="t_wd" value="<%=t_wd%>" size="25" class=text onKeyDown="javasript:enter()" style='IME-MODE: active'>
		<a href="javascript:window.search();"><img src="/acar/images/center/button_search.gif"  border="0" align=absmiddle></a>		
      </td>
    </tr>
      
    <tr> 
      <td>&nbsp;</td>
    </tr>
    <tr> 
      <td class=line> 
        <table border="0" cellspacing="1" width=640>
          <tr> 
            <td class=title width="30">연번</td>
            <td class=title width="100">계약번호</td>
            <td class=title width="150">상호</td>
            <td class=title width="100">차량번호</td>
			<td class=title width="100">차명</td>
            <td class=title width="80">대여개시일</td>
            <td class=title width="80">담당자</td>
            <td class=title width="20"></td>
          </tr>
          <%  for (int i = 0 ; i < s_size ; i++){
          	 	Hashtable ht = (Hashtable)vt.elementAt(i);	%>
          <tr align="center"> 
            <td><%=i+1%></td>
         	
            <td><a href="javascript:Disp('<%=ht.get("RENT_MNG_ID")%>', '<%=ht.get("RENT_L_CD")%>', '<%=ht.get("CAR_MNG_ID")%>',
            							 '<%=ht.get("CAR_NO")%>','<%=ht.get("CAR_NM")%>' ,'<%=ht.get("CAR_ST")%>' ,'<%=ht.get("MNG_ID")%>','<%=ht.get("MNG_NM")%>', '<%=ht.get("USER_M_TEL")%>', '<%=ht.get("FIRM_NM")%>', '<%=ht.get("PARK_ID")%>')" onMouseOver="window.status=''; return true"><%=ht.get("RENT_L_CD")%></a></td>
            <td><%=ht.get("FIRM_NM")%></td>
            <td><%=ht.get("CAR_NO")%></td>
			<td><%=ht.get("CAR_NM")%></td>
            <td><%=ht.get("RENT_START_DT")%></td>
            <td><%=ht.get("MNG_NM")%></td>
            <td><%=ht.get("USE_YN")%></td>
          </tr>
          <% } %>
        </table>
      </td>
    </tr>
    <tr> 
      <td align="right"><a href='javascript:window.close()' onMouseOver="window.status=''; return true" onFocus="this.blur()"><img src="/acar/images/center/button_close.gif" align="absmiddle" border="0"></a></td>
    </tr>
  </table>
</form>
</body>
</html>
