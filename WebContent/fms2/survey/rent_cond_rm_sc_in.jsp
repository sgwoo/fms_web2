<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*"%>
<%@ page import="acar.util.*, acar.user_mng.*, acar.call.*"%>
<jsp:useBean id="d_db" scope="page" class="acar.doc_settle.DocSettleDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	PollDatabase p_db = PollDatabase.getInstance();

	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String br_id 	= request.getParameter("br_id")==null?"":request.getParameter("br_id");
	
	String s_kd 	= request.getParameter("s_kd")==null? "5":request.getParameter("s_kd");
	
	String andor 	= request.getParameter("andor")==null?"14":request.getParameter("andor");
	String gubun1 	= request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	
	String dt 	= request.getParameter("dt")==null? "2" :request.getParameter("dt");
	String ref_dt1 	= request.getParameter("ref_dt1")==null? "" :request.getParameter("ref_dt1");
	String ref_dt2 	= request.getParameter("ref_dt2")==null? "" :request.getParameter("ref_dt2");
	String st_nm 	= request.getParameter("st_nm")==null? "" :request.getParameter("st_nm");
	
	int sh_height = request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//상단길이
	
	int count =0;
	
	Vector vt = p_db.getClsDocList(dt, ref_dt1, ref_dt2, s_kd, st_nm, gubun1, andor, "3", user_id);
	int vt_size = vt.size();
%>

<html>
<head><title>FMS</title>
<script language='javascript'>
<!--

//-->
</script>
</head>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<body>
<table border="0" cellspacing="0" cellpadding="0" width='100%'>
    <tr>
		<td class=line2 colspan="2"></td>
	</tr>
	<tr>
		<td class='line'>
			<table border="0" cellspacing="1" cellpadding="0" width='100%'>
				<tr>
					<td width='5%'  class='title'>연번</td>
					<td width='5%' class=title>선택</td>
		            <td width='15%' class='title'>계약번호</td>
        		    <td width='10%' class='title'>계약일</td>
		            <td width="20%" class='title'>고객</td>
				    <td width='10%' class='title'>차량번호</td>		
				    <td width='15%' class='title'>차명</td>	
				    <td width='10%' class='title'>해지일</td>				  		  				  
				    <td width='10%' class='title'>구분</td>
				</tr>
			</table>
		</td>
    </tr>
<%	if(vt_size > 0){ %>
	<tr>
		<td class='line'>
			<table border="0" cellspacing="1" cellpadding="0" width='100%'>
<%	for(int i = 0 ; i < vt_size ; i++){
			Hashtable ht = (Hashtable)vt.elementAt(i);
%>
				<tr>
					<td width='5%'  align='center'><%=i+1%></td>
					<td align="center" width='5%'>
						<%  if (String.valueOf(ht.get("GUBUN")).equals("9") ) {  %>   
						&nbsp;
						<%} else if (String.valueOf(ht.get("GUBUN")).equals("1") ) {  %>      
						&nbsp;
						<%} else { %>  
						<input type="checkbox" name="ch_all" value="<%=ht.get("RENT_MNG_ID")%>^<%=ht.get("RENT_L_CD")%>" > 
						<% } %>
					</td>
					<%  if (String.valueOf(ht.get("GUBUN")).equals("9") ) {  %>           
					<td align="center" width='15%'>&nbsp;<%=ht.get("RENT_L_CD") %> </td>    	
					<%} else if (String.valueOf(ht.get("GUBUN")).equals("1") ) {  %>           
					<td align="center" width='15%'><font color="red">&nbsp;<%=ht.get("RENT_L_CD") %> </font></td>    		   
					<%} else { %> 
					<td align="center" width='15%'><a href="javascript:parent.view_cont('<%=ht.get("RENT_MNG_ID")%>','<%=ht.get("RENT_L_CD")%>','월렌트','<%=AddUtil.ChangeDate2(String.valueOf(ht.get("CLS_DT")))%>')">&nbsp;<%=ht.get("RENT_L_CD")%></a></td>   
					<% } %>  					 
					<td width='10%' align='center'><%=AddUtil.ChangeDate2(String.valueOf(ht.get("RENT_DT")))%></td>
					<td width="20%" align='center'><%=ht.get("FIRM_NM")%></span></td>
					<td width='10%' align='center'><%=ht.get("CAR_NO")%></td>		
					<td width='15%' align='center'><%=ht.get("CAR_NM")%></td>		
					<td width='10%' align='center'><%=AddUtil.ChangeDate2(String.valueOf(ht.get("CLS_DT")))%></td>										
					<td width='10%' align='center'><%=ht.get("CLS_ST_NM")%></td>
				</tr>
<%}%>
			</table>
		</td>
	</tr>
	<tr>
        <td class=h></td>
    </tr>
<% }else{%>                     
	<tr>
		<td class='line'>
			<table border="0" cellspacing="1" cellpadding="0" width='100%'>
				<tr>
					<td align='center'>
					<%if(st_nm.equals("")){%>검색어를 입력하십시오.
					<%}else{%>등록된 데이타가 없습니다<%}%></td>
				</tr>
			</table>
		</td>
	</tr>
<% } %>
</table>
<script language='javascript'>
<!--
	parent.document.form1.size.value = '<%=vt_size%>';
//-->
</script>
</body>
</html>
