<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.speedmate.*" %>
<jsp:useBean id="sm_db" scope="page" class="acar.speedmate.SpeedMateDatabase"/>
<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");
	
	String s_kd 	= request.getParameter("s_kd")==null?"":request.getParameter("s_kd");
	String t_wd 	= request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String andor 	= request.getParameter("andor")==null?"":request.getParameter("andor");
	String gubun1 	= request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String gubun2 	= request.getParameter("gubun2")==null?"":request.getParameter("gubun2");
	String gubun3 	= request.getParameter("gubun3")==null?"":request.getParameter("gubun3");
	String st_dt 	= request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt 	= request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	String sort 	= request.getParameter("sort")==null?"":request.getParameter("sort");
	
	String from_page = request.getParameter("from_page")==null?"":request.getParameter("from_page");  //popup 요청한 페이지
	
	//height
	int sh_height = request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//상단길이

	String jg_code = request.getParameter("jg_code")==null?"":request.getParameter("jg_code");

	Vector vt = sm_db.SpeedMateJBList(jg_code, gubun2, gubun3, st_dt, end_dt);
	int vt_size = vt.size();
%>
<html>
<head>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--
	
//-->
</script>
</head>

<body>
<center>
  <form name='form1' action='' method='post' enctype="multipart/form-data">
    <input type='hidden' name='user_id' value='<%=user_id%>'>
<table border="0" cellspacing="0" cellpadding="0" width='100%'>
	<tr><td class=line2 colspan="2"></td></tr>
	<tr id='tr_title' style='position:relative;z-index:1'>
		<td class='line' width='100%' id='td_title' style='position:relative;'>
			<table border="0" cellspacing="1" cellpadding="0" width='100%'>
				<tr>
				  <td width='4%' class='title'>연번</td>
		          <td width='22%' class='title'>교환항목</td>					
				  <td width='7%' class='title'>부품비</td>
				  <td width='7%' class='title'>공임비</td>
		          <td width='7%' class='title'>교환KM수</td>
				  <td width='8%' class='title'>기준일자</td>				  
				  <td width='25%' class='title'>차종코드</td>
				  <td width='20%' class='title'>비고</td>
				</tr>
			  </tr>
			</table>
		</td>
	</tr>
	
	<tr>
		<td class='line' width='100%' id='td_con' style='position:relative;'>
			<table border="0" cellspacing="1" cellpadding="0" width='100%'>
<%if(vt_size > 0 ){%>
	<%	for(int i = 0 ; i < vt_size ; i++){
				Hashtable ht = (Hashtable)vt.elementAt(i);	%>
				<tr>
					<td width='4%' align='center'><%=i+1%></td>
					<td width="22%" align='center' class=""><%=ht.get("ITEM")%></td>
					<td width="7%" align='right' class=""><%=AddUtil.parseDecimal(ht.get("PARTS_AMT"))%>&nbsp;</td>
					<td width="7%" align='right' class=""><%=AddUtil.parseDecimal(ht.get("WAGES_AMT"))%>&nbsp;</td>
					<td width="7%" align='right' class=""><%=ht.get("DIST")%>&nbsp;</td>		  
					<td width="8%" align='center' class=""><%=AddUtil.ChangeDate2(String.valueOf(ht.get("REG_DT")))%></td>
					<td width="25%" align='center' class=""><%=ht.get("CAR_CODE")%></td>
					<td width="20%" align='center' class=""><span title='<%=ht.get("RE_MARK")%>'><%=Util.subData(String.valueOf(ht.get("RE_MARK")),17)%></span></td>
				</tr>
	<%	}%>
<%}else{%>

				<tr>				  				  
					<td align='center' colspan=8 class=''>데이터가 없습니다.</td>
				</tr>
<%}%>
			</table>
		</td>
	</tr>
</table>
  </form>
  <script language='javascript'>
<!--
	parent.document.form1.size.value = '<%=vt_size%>';
//-->
</script>
</center>
</body>
</html>
