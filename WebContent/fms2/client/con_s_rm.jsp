<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*"%>
<%@ page import="acar.cont.*"%>
<%@ page import="acar.util.*"%>
<jsp:useBean id="l_db" scope="page" class="acar.client.ClientDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<html>
<head><title>FMS</title>
<script language='javascript'>
<!--
	//계약서 내용 보기
	function view_cont(c_id, s_cd, use_st){
	
		var fm = document.form2;
		
		fm.mode.value = 'c';
		fm.s_cd.value = s_cd;
		fm.c_id.value = c_id;
				
		if(use_st == '예약'){ 	
			fm.action = '/acar/res_stat/res_rent_u.jsp';
		}else if(use_st == '배차'){ 	
			fm.action = '/acar/rent_mng/res_rent_u.jsp';
		}else if(use_st == '반차'){ 
			fm.action = '/acar/rent_end/rent_settle_u.jsp';
		}else if(use_st == '정산'){ 	
			fm.action = '/acar/rent_end/rent_settle_u.jsp';
		}else if(use_st == '취소'){ 	
			fm.action = '/acar/res_stat/res_rent_u.jsp';
		}
		
		fm.target = 'd_content';
		fm.submit();
	}
	
	
	//스캔관리 보기
	function view_scan(c_id, s_cd)
	{		
		window.open("/acar/res_stat/scan_view.jsp?c_id="+c_id+"&s_cd="+s_cd, "VIEW_SCAN", "left=100, top=100, width=720, height=800, scrollbars=yes");				
	}	
//-->
</script>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
</head>
<body>
<%
	String client_id = request.getParameter("client_id")==null?"":request.getParameter("client_id");
	Vector conts = l_db.getRMContList(client_id);
	int cont_size = conts.size();
	int valid_cont_cnt = 0;
	
	//아마존카는 제외
	if(client_id.equals("000228")) return;
%>
<form name='form2' method='post'>
  <input type='hidden' name='s_cd' value=''>
  <input type='hidden' name='c_id' value=''>  
  <input type='hidden' name='mode' value=''>  
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
					<td <%if(String.valueOf(cont.get("USE_ST")).equals("취소")||String.valueOf(cont.get("USE_ST")).equals("정산")){%>class=is<%}%> align='center' width='3%'><%=i+1%></td>
					<td <%if(String.valueOf(cont.get("USE_ST")).equals("취소")||String.valueOf(cont.get("USE_ST")).equals("정산")){%>class=is<%}%> align='center' width='10%'><a href="javascript:view_cont('<%=cont.get("CAR_MNG_ID")%>', '<%=cont.get("RENT_S_CD")%>', '<%=cont.get("USE_ST")%>')" onMouseOver="window.status=''; return true" title='계약관리 이동'><%=cont.get("RENT_S_CD")%></a></td>
					<td <%if(String.valueOf(cont.get("USE_ST")).equals("취소")||String.valueOf(cont.get("USE_ST")).equals("정산")){%>class=is<%}%> align='center' width='7%'><%=cont.get("RENT_DT")%></td>
					<td <%if(String.valueOf(cont.get("USE_ST")).equals("취소")||String.valueOf(cont.get("USE_ST")).equals("정산")){%>class=is<%}%> align='center' width='8%'><%=cont.get("CAR_NO")%></td>
					<td <%if(String.valueOf(cont.get("USE_ST")).equals("취소")||String.valueOf(cont.get("USE_ST")).equals("정산")){%>class=is<%}%> align='center' width='15%'><%=cont.get("CAR_NM")%></td>
					<td <%if(String.valueOf(cont.get("USE_ST")).equals("취소")||String.valueOf(cont.get("USE_ST")).equals("정산")){%>class=is<%}%> align='center' width='18%'><%=cont.get("RENT_START_DT")%>&nbsp;~&nbsp;<%=cont.get("RENT_END_DT")%>&nbsp;(<%=cont.get("RENT_MONTHS")%>개월<%=cont.get("RENT_DAYS")%>일)</td>					
					<td <%if(String.valueOf(cont.get("USE_ST")).equals("취소")||String.valueOf(cont.get("USE_ST")).equals("정산")){%>class=is<%}%> align='center' width='6%'><%=cont.get("USER_NM")%></td>
					<td <%if(String.valueOf(cont.get("USE_ST")).equals("취소")||String.valueOf(cont.get("USE_ST")).equals("정산")){%>class=is<%}%> align='center' width='6%'><%=cont.get("USER_NM2")%></td>
					<td <%if(String.valueOf(cont.get("USE_ST")).equals("취소")||String.valueOf(cont.get("USE_ST")).equals("정산")){%>class=is<%}%> align='center' width='6%'><%=cont.get("USE_ST")%></td>		
					<td <%if(String.valueOf(cont.get("USE_ST")).equals("취소")||String.valueOf(cont.get("USE_ST")).equals("정산")){%>class=is<%}%> align='center' width='16%'><%=cont.get("ETC")%></td>
					<td <%if(String.valueOf(cont.get("USE_ST")).equals("취소")||String.valueOf(cont.get("USE_ST")).equals("정산")){%>class=is<%}%> align='center' width='5%'><a href="javascript:view_scan('<%=cont.get("CAR_MNG_ID")%>', '<%=cont.get("RENT_S_CD")%>')" onMouseOver="window.status=''; return true" title='스캔관리'><img src=/acar/images/center/button_in_see.gif align=absmiddle border=0></a></td>									
				</tr>
<%
			if(String.valueOf(cont.get("USE_ST")).equals("예약")||String.valueOf(cont.get("USE_ST")).equals("배차"))
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
	parent.form1.valid_s_cont_cnt.value = '<%=valid_cont_cnt%>';
//-->
</script>
</body>
</html>
