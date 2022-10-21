<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*"%>
<%@ page import="agent.cont.*"%>
<%@ page import="acar.util.*"%>
<jsp:useBean id="l_db" scope="page" class="agent.client.ClientDatabase"/>
<%@ include file="/agent/cookies.jsp" %>

<html>
<head><title>FMS</title>
<script language='javascript'>
<!--
 	//계약서 내용 보기
	function view_cont(m_id, l_cd, use_yn){
		var fm = document.form2;
		fm.rent_mng_id.value 	= m_id;
		fm.rent_l_cd.value 	= l_cd;				
		fm.target ='d_content';
		if(use_yn == '대기')		fm.action = '/agent/lc_rent/lc_b_u.jsp';
		else				fm.action = '/agent/lc_rent/lc_c_frame.jsp';

		fm.submit();
	}
	//계약정보 보기
	function view_client(m_id, l_cd, r_st)
	{
		window.open("/agent/con_fee/con_fee_client_s.jsp?m_id="+m_id+"&l_cd="+l_cd+"&r_st="+r_st, "VIEW_CLIENT", "left=100, top=100, width=820, height=700, resizable=yes, scrollbars=yes, status=yes");
	}
	//자동차등록정보 보기
	function view_car(m_id, l_cd, c_id)
	{
		window.open("/acar/car_register/car_view.jsp?rent_mng_id="+m_id+"&rent_l_cd="+l_cd+"&car_mng_id="+c_id+"&cmd=ud", "VIEW_CAR", "left=100, top=100, width=850, height=800, resizable=yes, scrollbars=yes, status=yes");
	}	
	
	//스캔관리 보기
	function view_scan(m_id, l_cd)
	{		
		window.open("/agent/lc_rent/scan_view.jsp?m_id="+m_id+"&l_cd="+l_cd, "VIEW_SCAN", "left=100, top=100, width=720, height=800, resizable=yes, scrollbars=yes, status=yes");				
	}	
//-->
</script>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
</head>
<body>
<%
	String client_id = request.getParameter("client_id")==null?"":request.getParameter("client_id");
	Vector conts = l_db.getContList(client_id);
	int cont_size = conts.size();
	int valid_cont_cnt = 0;
%>
<form name='form2' method='post'>
  <input type='hidden' name='rent_mng_id' value=''>
  <input type='hidden' name='rent_l_cd' value=''>
  <input type='hidden' name='c_st' value=''>  
 </form> 
<table border="0" cellspacing="0" cellpadding="0" width='100%'>
	<tr>
		<td class='line'>
			<table border="0" cellspacing="1" cellpadding="0" width='100%'>
<%
	if(cont_size > 0)
	{
		for(int i = 0 ; i < cont_size ; i++)
		{
			Hashtable cont = (Hashtable)conts.elementAt(i);
%>
				<tr>
					<td <%if(String.valueOf(cont.get("IS_RUN")).equals("해약")){%>class=is<%}%> align='center' width='3%'><%=i+1%></td>
					<!--
					<td align='center' width='10%'><a href="javascript:parent.view_car_mgr('<%=cont.get("RENT_MNG_ID")%>', '<%=cont.get("RENT_L_CD")%>')" onMouseOver="window.status=''; return true" title='차량관리자 보기'><%=cont.get("RENT_L_CD")%></a></td>
					-->
					<td <%if(String.valueOf(cont.get("IS_RUN")).equals("해약")){%>class=is<%}%> align='center' width='10%'><a href="javascript:view_cont('<%=cont.get("RENT_MNG_ID")%>', '<%=cont.get("RENT_L_CD")%>', '<%=cont.get("IS_RUN")%>')" onMouseOver="window.status=''; return true" title='계약관리 이동'><%=cont.get("RENT_L_CD")%></a></td>
					<td <%if(String.valueOf(cont.get("IS_RUN")).equals("해약")){%>class=is<%}%> align='center' width='7%'><a href="javascript:view_client('<%=cont.get("RENT_MNG_ID")%>', '<%=cont.get("RENT_L_CD")%>', '<%=cont.get("RENT_ST")%>')" onMouseOver="window.status=''; return true" title='계약약식내역'><%=cont.get("RENT_DT")%></a></td>
					<td <%if(String.valueOf(cont.get("IS_RUN")).equals("해약")){%>class=is<%}%> align='center' width='8%'><a href="javascript:view_car('<%=cont.get("RENT_MNG_ID")%>', '<%=cont.get("RENT_L_CD")%>', '<%=cont.get("CAR_MNG_ID")%>')" onMouseOver="window.status=''; return true" title='자동차등록내역'><%=cont.get("CAR_NO")%></a></td>
					<td <%if(String.valueOf(cont.get("IS_RUN")).equals("해약")){%>class=is<%}%> align='center' width='15%'><%=cont.get("CAR_NM")%></td>
					<td <%if(String.valueOf(cont.get("IS_RUN")).equals("해약")){%>class=is<%}%> align='center' width='15%'><%=cont.get("RENT_START_DT")%>&nbsp;~&nbsp;<%=cont.get("RENT_END_DT")%></td>
					<td <%if(String.valueOf(cont.get("IS_RUN")).equals("해약")){%>class=is<%}%> align='center' width='6%'><%=cont.get("RENT_WAY")%></td>
					<td <%if(String.valueOf(cont.get("IS_RUN")).equals("해약")){%>class=is<%}%> align='center' width='6%'><%=cont.get("USER_NM")%></td>
					<td <%if(String.valueOf(cont.get("IS_RUN")).equals("해약")){%>class=is<%}%> align='center' width='6%'><%=cont.get("USER_NM2")%></td>
					<td <%if(String.valueOf(cont.get("IS_RUN")).equals("해약")){%>class=is<%}%> align='center' width='6%'><%=cont.get("IS_RUN")%></td>		
					<td <%if(String.valueOf(cont.get("IS_RUN")).equals("해약")){%>class=is<%}%> align='center' width='13%'><%=cont.get("R_SITE")%></td>
					<td <%if(String.valueOf(cont.get("IS_RUN")).equals("해약")){%>class=is<%}%> align='center' width='5%'><a href="javascript:view_scan('<%=cont.get("RENT_MNG_ID")%>', '<%=cont.get("RENT_L_CD")%>')" onMouseOver="window.status=''; return true" title='스캔관리'><img src=/acar/images/center/button_in_see.gif align=absmiddle border=0></a></td>									
				</tr>
<%
			if((String.valueOf(cont.get("IS_RUN_NUM")).equals("0"))||(String.valueOf(cont.get("IS_RUN_NUM")).equals("1")))
				valid_cont_cnt += 1;
		}
%>
<%
	}else{
%>				<tr>
					<td>&nbsp;등록된 계약이 없습니다</td>
				</tr>
<%	}
%>
			</table>
		</td>
	</tr>
</table>
<script language='javascript'>
<!--
	parent.form1.valid_cont_cnt.value = '<%=valid_cont_cnt%>';
//-->
</script>
</body>
</html>
