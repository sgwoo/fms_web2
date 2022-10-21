<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.ma.*"%>
<jsp:useBean id="CodeDb" class="acar.ma.CodeDatabase" scope="page"/>
<jsp:useBean id="ScResDb" class="acar.sc.ScResDatabase" scope="page"/>
<jsp:useBean id="ScResBn" class="acar.beans.ScResBean" scope="page"/>
<%@ include file="/acar/cookies_base.jsp" %>
<% 
	Vector ScResList = ScResDb.getResCarList();
%>

<html>
<head><title>자동차 조회</title>
<script language='javascript' src='/include/common.js'></script>
<script language='javascript'>
<!--
function setResCar(c_id, c_no, c_nm){
	var pfm = opener.document.form1;
	pfm.car_mng_id.value = c_id;
	pfm.car_no.value = c_no;
	pfm.car_name.value = c_nm;
	opener.document.inner.location.href = "../<%= m_st %>/<%= m_st %><%=m_st2%>/<%= m_st %><%=m_st2%><%=m_cd%>/<%= m_st+m_st2+m_cd %>_res_list.jsp?car_mng_id="+c_id;
	//달력조회
	//opener.document.inner_s.location.href = "../<%= m_st %>/<%= m_st %><%=m_st2%>/<%= m_st %><%=m_st2%><%=m_cd%>/calendar.jsp?c_id="+c_id;
	//opener.document.inner_e.location.href = "../<%= m_st %>/<%= m_st %><%=m_st2%>/<%= m_st %><%=m_st2%><%=m_cd%>/calendar.jsp?c_id="+c_id;
	
	this.close();	
}
//-->
</script>
</head>
<link rel=stylesheet type="text/css" href="../include/table.css">
<body leftmargin="15" topmargin="10">
<form name='form1' action='' method='post'>
  <input type='hidden' name="m_st"  value='<%=m_st%>'>
  <input type='hidden' name="m_st2" value='<%=m_st2%>'>
  <input type='hidden' name="m_cd"  value='<%=m_cd%>'>      
  <input type='hidden' name='h_com' value=''>
  <input type='hidden' name='com_nm' value=''>
  <input type='hidden' name='com_id' value=''>
  <input type='hidden' name='car_cd' value=''>
  <input type='hidden' name='car_nm' value=''>
  <input type='hidden' name='car_name' value=''>
  <table border="0" cellspacing="0" cellpadding="0" width=100%>
    <tr> 
      <td align='left' height="21" colspan="2"><font color="#666600">- 자동차 조회 
        -</font></td>
    </tr>
    <tr> 
      <td align='left' colspan="2"> 영업소: 
        <jsp:include page="/acar/code/get_branch.jsp" flush="true">
	  	  <jsp:param name="f_nm" value="s_br" />
	  	  <jsp:param name="value" value="<%=s_br%>" />
	  	  <jsp:param name="onChange" value="" />
	    </jsp:include>
        검색: 
        <select name="s_kd">
          <option value="2" selected>차량번호</option>
          <option value="1">차명</option>
        </select>
        <input type='text' class='text' name='t_wd' size='15'>
        예약기간: 
        <input type='text' class='text' name='t_res_start_dt' size='11'>
        ~ 
        <input type='text' class='text' name='t_res_start_dt' size='11'>
        <a href="#" target="d_content"><img src="../images/bbs/but_search.gif" width="50" height="18" aligh="absmiddle" border="0" alt="목록"></a> 
      </td>
    </tr>
    <tr> 
      <td class='line' colspan="2"> 
        <table border="0" cellspacing="1" cellpadding="0" width=100%>
          <tr> 
            <td class='title' width="5%" rowspan="2">연번</td>
            <td class='title' width="10%" rowspan="2">영업소</td>
            <td class='title' width="12%" rowspan="2">차량번호</td>
            <td class='title' width="18%" rowspan="2">차명</td>
            <td class='title' width="30%" colspan="3">최근 대여(예약)</td>
            <td class='title' width="5%" rowspan="2">상태</td>
          </tr>
          <tr> 
            <td class='title' width="30%">기간</td>
            <td class='title' width="10%">구분</td>
            <td class='title' width="20%">고객</td>
          </tr>
          <% if(ScResList.size()>0){
		  		for(int i=0; i<ScResList.size(); i++){
					Hashtable ht = (Hashtable)ScResList.elementAt(i); %>
          <tr align="center"> 
            <td><%= i+1 %></td>
            <td><%= ht.get("BR_ID") %></td>
            <td><a href="javascript:setResCar('<%= ht.get("CAR_MNG_ID") %>','<%= ht.get("CAR_NO") %>','<%= ht.get("CAR_NM") %>');"><%= ht.get("CAR_NO") %></a></td>
            <td><%= ht.get("CAR_NM") %></td>
            <td>~</td>
            <td></td>
            <td></td>
            <td><font color="#FF0000">&nbsp;</font></td>
          </tr>
          <% }
		  }else{ %>
          <tr align="center"> 
            <td colspan="8">해당 보유차가 없습니다.<font color="#FF0000">&nbsp;</font></td>
          </tr>
          <% } %>
        </table>
      </td>
    </tr>
    <tr> 
      <td><font color="#999999">* 차량번호를 선택하십시오.</font></td>
      <td align='right'><a href="javascript:window.close()"><img src="../images/bbs/but_close.gif" width="50" height="18" aligh="absmiddle" border="0" alt="목록"></a></td>
    </tr>
    <tr> 
      <td align="center" colspan="2"><a href="../02/0201/020101/020101_i_d.jsp?m_st=<%=m_st%>&m_st2=<%=m_st2%>&m_cd=<%=m_cd%>">대기자등록</a></td>
    </tr>
  </table>
</form>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>
</body>
</html>
