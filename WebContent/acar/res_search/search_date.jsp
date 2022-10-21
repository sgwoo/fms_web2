<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.res_search.*, acar.util.*"%>
<%@ page import="java.sql.*, java.io.*, java.net.*, java.util.Date"%>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<html>
<head>
<title>FMS</title>
<style type="text/css">
<!--
	td,body {font-size:12px; font-family:굴림; text-decoration:none; color:black}
	th {font-size:12px; font-family:굴림; font-weight : bold; text-decoration:none; color:white}
	a:link {font-size:12px; font-family:굴림; text-decoration:none; color:black}
	a:visited {font-size:12px; font-family:굴림; text-decoration:none; color:black}
	a:hover {  font-size: 12px; text-decoration: blink; color:red}
//-->
</style>
<script language='JavaScript' src='/include/common.js'></script>
<script language="JavaScript">
<!--
	function reservation(){
		var fm = document.form1;
		if(fm.rent_start_dt.value == ''){ alert("대여개시일이 없습니다. 날짜를 선택하십시오."); return; }		
//		if(fm.rent_end_dt.value == '' && (fm.rent_st.value == '1' || fm.rent_st.value == '9')){ alert("대여만료일을 입력하십시오."); return; }
		if(fm.rent_end_dt.value != '' && fm.rent_start_dt.value > fm.rent_end_dt.value){ alert("대여만료일이 대여개시일 보다 작습니다. 확인하십시오."); return; }		
		var theForm = opener.parent.document.form1;
		theForm.c_id.value = fm.c_id.value;
		theForm.rent_st.value = fm.rent_st.value;
		theForm.rent_start_dt.value = fm.rent_start_dt.value;		
		theForm.rent_end_dt.value = fm.rent_end_dt.value;
		theForm.action = 'res_rent_i.jsp';
		theForm.submit();
		self.close();	
	}
//-->
</script>
</head>
<body onLoad="self.focus()">
<%
	//로그인ID&영업소ID&권한
	LoginBean login = LoginBean.getInstance();
	String user_id = login.getCookieValue(request, "acar_id");
	String br_id = login.getCookieValue(request, "acar_br");
	String auth_rw = rs_db.getAuthRw(user_id, "03", "01");
	
	String c_id = request.getParameter("c_id")==null?"":request.getParameter("c_id");
	String rent_st = request.getParameter("rent_st")==null?"":request.getParameter("rent_st");
	String rent_start_dt = request.getParameter("rent_start_dt")==null?"":request.getParameter("rent_start_dt");
	String rent_end_dt = request.getParameter("rent_end_dt")==null?"":request.getParameter("rent_end_dt");
	
	Hashtable reserv = rs_db.getCarInfo(c_id);
%>

<form name="form1" method="post" action="">
 <input type='hidden' name='c_id' value='<%=c_id%>'>    
 <input type='hidden' name='use_st' value='1'>     
  <table border=0 cellspacing=0 cellpadding=0 width=600>
    <tr> 
      <td colspan="2"><font color="navy">예약시스템 -> 영업지원 -> 예약관리 -> </font><font color="red">차량별 
        예약가능 날짜조회</font></td>
    </tr>
    <tr> 
      <td colspan="2">&nbsp;</td>
    </tr>
    <tr> 
      <td colspan="2" height="22"><img src="/acar/off_ls_hpg/img/icon_red.gif" width="7" height="7">&nbsp;<font color="navy">차량번호 
        : <%=reserv.get("CAR_NO")%></font></td>
    </tr>
    <tr> 
      <td colspan="2" height="22"><img src="/acar/off_ls_hpg/img/icon_red.gif" width="7" height="7">&nbsp;<font color="navy">차명 
        : <%=reserv.get("CAR_NM")%>&nbsp;<%=reserv.get("CAR_NAME")%></font></td>
    </tr>
    <tr> 
      <td align="center" width="300" height="24"> <iframe src="calendar_s.jsp?c_id=<%=c_id%>" name="inner_s" width="300" height="300" cellpadding="0" cellspacing="0" border="0" frameborder="0" noresize scrolling=yes, marginwidth=0, marginheight=0 > 
        </iframe></td>
      <td width="300" valign="bottom" height="24"> <iframe src="calendar_e.jsp?c_id=<%=c_id%>" name="inner_e" width="300" height="300" cellpadding="0" cellspacing="0" border="0" frameborder="0" noresize scrolling=yes, marginwidth=0, marginheight=0 > 
        </iframe></td>
    </tr>
    <tr> 
      <td align="center" colspan="2" height="24"> 
        <table bordercolor=#8f8f8f cellspacing=0 bordercolordark=white 
            cellpadding=5 width="600" bordercolorlight=#8f8f8f border=1 align="center">
          <tbody> 
          <tr align="center"> 
            <td width="50"> 
              <p>구분</p>
            </td>
            <td width="90"> 
              <select name="rent_st">
                <option value="1" <%if(rent_st.equals("1"))%>selected<%%>>단기대여</option>
                <option value="2" <%if(rent_st.equals("2"))%>selected<%%>>정비대차</option>
                <option value="3" <%if(rent_st.equals("3"))%>selected<%%>>사고대차</option>
                <option value="9" <%if(rent_st.equals("9"))%>selected<%%>>보험대차</option>
                <option value="10" <%if(rent_st.equals("10"))%>selected<%%>>지연대차</option>
                <option value="4" <%if(rent_st.equals("4"))%>selected<%%>>업무대여</option>
<!--                <option value="5" <%if(rent_st.equals("5"))%>selected<%%>>업무지원</option>-->
                <option value="6" <%if(rent_st.equals("6"))%>selected<%%>>차량정비</option>
<!--                <option value="7" <%if(rent_st.equals("7"))%>selected<%%>>차량점검</option>-->
                <option value="8" <%if(rent_st.equals("8"))%>selected<%%>>사고수리</option>
                <option value="11" <%if(rent_st.equals("11"))%>selected<%%>>장기대기</option>                		
              </select>
            </td>
            <td width="60">대여기간</td>
            <td> 
              <input type="text" name="rent_start_dt" size="10" readonly value="<%=rent_start_dt%>">
              ~
              <input type="text" name="rent_end_dt" size="10" readonly value="<%=rent_end_dt%>">
            </td>
            <td width="90">
		  <%if(auth_rw.equals("2") || auth_rw.equals("4") || auth_rw.equals("6")){%>			
			<a href="javascript:reservation();" onFocus="this.blur()"><img src="/images/reservation.gif" border=0 width="88" height="27"></a>
		  <%}else{%>&nbsp;<%}%>	
			</td>
          </tr>
          </tbody> 
        </table>
      </td>
    </tr>
    <tr> 
      <td colspan="2">&nbsp; </td>
    </tr>
    <tr> 
      <td align="right" colspan="2"><a href='javascript:self.close()' onMouseOver="window.status=''; return true"><img src="/images/close.gif" width="50" height="18" aligh="absmiddle" border="0"></a></td>
    </tr>
  </table>
</form>
</body>
</html>