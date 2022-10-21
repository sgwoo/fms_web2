<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*"%>
<%@ page import="acar.common.*"%>
<%@ page import="acar.search.*"%>
<%@ page import="acar.util.*"%>

<html>
<head><title>FMS</title>
<script language='javascript'>
<!--
	function ServMove(rent_mng_id,rent_l_cd,car_mng_id){
		var Fm = parent.document.form1;
		Fm.m_id.value = rent_mng_id;
		Fm.l_cd.value = rent_l_cd;
		Fm.c_id.value = car_mng_id;
	}
-->
</script>

</head>
<link rel=stylesheet type="text/css" href="../../include/table.css">
<body>

<%
	//검색구분
	String s_rent_l_cd 	= request.getParameter("s_rent_l_cd")	==null?"":request.getParameter("s_rent_l_cd");
	String s_client_nm 	= request.getParameter("s_client_nm")	==null?"":request.getParameter("s_client_nm");
	String s_car_no 	= request.getParameter("s_car_no")		==null?"":request.getParameter("s_car_no");
	String s_rent_s_dt 	= request.getParameter("s_rent_s_dt")	==null?"":request.getParameter("s_rent_s_dt");
	String s_kd 		= request.getParameter("s_kd")			==null?"":request.getParameter("s_kd");
	String s_wd 		= request.getParameter("s_wd")			==null?"":request.getParameter("s_wd");
	String mode 		= request.getParameter("mode")			==null?"":request.getParameter("mode");
	
	CommonDataBase c_db = CommonDataBase.getInstance();


if(mode.equals("search")){
	SearchDatabase db = SearchDatabase.getInstance();
	Vector conts = null;

	//검색 리스트 조회
	conts = db.getSearchList(s_rent_l_cd, s_client_nm, s_car_no, s_rent_s_dt, s_kd, s_wd);
	int cont_size = conts.size();
%>
<form name="form1" method="post" action="">
  <table border="0" cellspacing="0" cellpadding="0" width='880'>
<%	
	if(cont_size > 0){	%>
	<tr>
		<td class='line' width='900' id='td_con' >
			
        <table border="0" cellspacing="1" cellpadding="0" width='880'>
          <%	for(int i = 0 ; i < cont_size ; i++){
			SearchListBean cont = (SearchListBean)conts.elementAt(i);	
%>
          <tr> 
            <td width='30' align='center'> 
              <input type="radio" name="ck" onClick="javascript:ServMove('<%=cont.getRent_mng_id()%>','<%=cont.getRent_l_cd()%>','<%=cont.getCar_mng_id()%>');">
            </td>
            <td width='30' align='center'><%=i+1%></td>
            <td width='96' align='center'><%=cont.getRent_l_cd()%></td>
            <td width='66' align='center'><%=cont.getRent_dt()%></td>
            <td width='150' align='center'><span title='<%=cont.getFirm_nm()%>'><%=Util.subData(cont.getFirm_nm(), 11)%></span></td>
            <td width='157' align='center'><span title='<%=cont.getCar_nm()%>'><%=Util.subData(cont.getCar_nm(), 15)%></span></td>
            <td width='80' align='center'><span title='<%=cont.getCar_no()%>'><%=cont.getCar_no()%></span></td>
            <td width='66' align='center'><%=cont.getRent_start_dt()%></td>
            <td width='75' align='right'><%=Util.parseDecimal(cont.getFee_s_amt()+cont.getFee_v_amt())%>원</td>
            <td width='65' align='center'><%=c_db.getNameById(cont.getBus_nm(), "USER")%></td>
            <td width='65' align='center'><%=c_db.getNameById(cont.getMng_nm(), "USER")%></td>
          </tr>
          <%	}
		
	}else{	%>
          <tr> 
            <td colspan="11" align='center'>등록된 데이타가 없습니다 </td>
          </tr>
          <%	}	%>
        </table>
		</td>                 
</table>
</form>
<% } %>
</body>
</html>
