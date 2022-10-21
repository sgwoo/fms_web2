<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.free_time.*, acar.user_mng.* " %>
<jsp:useBean id="ft_db" scope="page" class="acar.free_time.Free_timeDatabase"/>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>
<%@ include file="/acar/cookies.jsp" %>


<%
	LoginBean login = LoginBean.getInstance();
	
	String acar_id = login.getCookieValue(request, "acar_id");
	
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");
	
	String s_br_id = request.getParameter("s_br_id")==null?"":request.getParameter("s_br_id");
	String dept_id = request.getParameter("dept_id")==null?"":request.getParameter("dept_id");
	String user_nm = request.getParameter("user_nm")==null?"":request.getParameter("user_nm");

	int count = 0;
	
	if(user_id.equals("")) 	user_id = login.getCookieValue(request, "acar_id");
	if(br_id.equals(""))	br_id = login.getCookieValue(request, "acar_br");
	if(auth_rw.equals(""))	auth_rw = rs_db.getAuthRw(user_id, "10", "01", "01");
	
	
	String req_code  = Long.toString(System.currentTimeMillis());

	int s_year = request.getParameter("s_year")==null?AddUtil.getDate2(1):Integer.parseInt(request.getParameter("s_year"));	
	int s_month = request.getParameter("s_month")==null?AddUtil.getDate2(2):Integer.parseInt(request.getParameter("s_month"));	
	int s_day = request.getParameter("s_day")==null?AddUtil.getDate2(3):Integer.parseInt(request.getParameter("s_day"));		
	int year =AddUtil.getDate2(1);
	int seq = request.getParameter("seq")==null?1:Util.parseInt(request.getParameter("seq"));

	String dt = request.getParameter("dt")==null?"1":request.getParameter("dt");
	String st_year = request.getParameter("st_year")==null?"":request.getParameter("st_year");
	String st_mon = request.getParameter("st_mon")==null?"":request.getParameter("st_mon");
	
	Vector vt31 = ft_db.Free_TotList_Y(st_year, st_mon, dt, "31");
	int vt31_size = vt31.size();
	Vector vt32 = ft_db.Free_TotList_Y(st_year, st_mon, dt, "32");
	int vt32_size = vt32.size();
	Vector vt11 = ft_db.Free_TotList_Y(st_year, st_mon, dt, "11");
	int vt11_size = vt11.size();
	Vector vt12 = ft_db.Free_TotList_Y(st_year, st_mon, dt, "12");
	int vt12_size = vt12.size();
	Vector vt21 = ft_db.Free_TotList_Y(st_year, st_mon, dt, "21");
	int vt21_size = vt21.size();
	Vector vt22 = ft_db.Free_TotList_Y(st_year, st_mon, dt, "22");
	int vt22_size = vt22.size();
	Vector vt71 = ft_db.Free_TotList_Y(st_year, st_mon, dt, "71");
	int vt71_size = vt71.size();
	Vector vt72 = ft_db.Free_TotList_Y(st_year, st_mon, dt, "72");
	int vt72_size = vt72.size();
	Vector vt81 = ft_db.Free_TotList_Y(st_year, st_mon, dt, "81");
	int vt81_size = vt81.size();
	Vector vt82 = ft_db.Free_TotList_Y(st_year, st_mon, dt, "82");
	int vt82_size = vt82.size();
	
	Vector vt91 = ft_db.Free_TotList_Y(st_year, st_mon, dt, "91");
	int vt91_size = vt91.size();
	Vector vt92 = ft_db.Free_TotList_Y(st_year, st_mon, dt, "92");
	int vt92_size = vt92.size();
	
	Vector vt101 = ft_db.Free_TotList_Y(st_year, st_mon, dt, "101");
	int vt101_size = vt101.size();
	Vector vt102 = ft_db.Free_TotList_Y(st_year, st_mon, dt, "102");
	int vt102_size = vt102.size();
	
	Vector vt111 = ft_db.Free_TotList_Y(st_year, st_mon, dt, "111");
	int vt111_size = vt111.size();
	Vector vt112 = ft_db.Free_TotList_Y(st_year, st_mon, dt, "112");
	int vt112_size = vt112.size();
	
	Vector vt121 = ft_db.Free_TotList_Y(st_year, st_mon, dt, "121");
	int vt121_size = vt121.size();
	Vector vt122 = ft_db.Free_TotList_Y(st_year, st_mon, dt, "122");
	int vt122_size = vt122.size();
	
	Vector vt131 = ft_db.Free_TotList_Y(st_year, st_mon, dt, "131");
	int vt131_size = vt131.size();
	Vector vt132 = ft_db.Free_TotList_Y(st_year, st_mon, dt, "132");
	int vt132_size = vt132.size();
	
	Vector vt141 = ft_db.Free_TotList_Y(st_year, st_mon, dt, "141");
	int vt141_size = vt141.size();
	Vector vt142 = ft_db.Free_TotList_Y(st_year, st_mon, dt, "142");
	int vt142_size = vt142.size();
	
	Vector vt151 = ft_db.Free_TotList_Y(st_year, st_mon, dt, "151");
	int vt151_size = vt151.size();
	Vector vt152 = ft_db.Free_TotList_Y(st_year, st_mon, dt, "152");
	int vt152_size = vt152.size();
	
	Vector vt161 = ft_db.Free_TotList_Y(st_year, st_mon, dt, "161");
	int vt161_size = vt161.size();
	Vector vt162 = ft_db.Free_TotList_Y(st_year, st_mon, dt, "162");
	int vt162_size = vt162.size();
	
	Vector vt171 = ft_db.Free_TotList_Y(st_year, st_mon, dt, "171");
	int vt171_size = vt171.size();
	Vector vt172 = ft_db.Free_TotList_Y(st_year, st_mon, dt, "172");
	int vt172_size = vt172.size();
	
	Vector vt181 = ft_db.Free_TotList_Y(st_year, st_mon, dt, "181");
	int vt181_size = vt181.size();
	Vector vt182 = ft_db.Free_TotList_Y(st_year, st_mon, dt, "182");
	int vt182_size = vt182.size();
	
	Vector vt51 = ft_db.Free_TotList_Y(st_year, st_mon, dt, "51");
	int vt51_size = vt51.size();
	Vector vt52 = ft_db.Free_TotList_Y(st_year, st_mon, dt, "52");
	int vt52_size = vt52.size();
	
	int aa = 0;
	int cc = 0;
	int ee = 0;
	int dd = 0;
	int bb1 = 0;
	int bb2 = 0;
	
	int aa_b = 0;
	int cc_b = 0;
	int ee_b = 0;
	int dd_b = 0;
	int bb1_b = 0;
	int bb2_b = 0;
	
	Vector vt31n = ft_db.Free_TotList_N(st_year, st_mon, dt, "31");
	int vt31n_size = vt31n.size();
	Vector vt32n = ft_db.Free_TotList_N(st_year, st_mon, dt, "32");
	int vt32n_size = vt32n.size();
	Vector vt11n = ft_db.Free_TotList_N(st_year, st_mon, dt, "11");
	int vt11n_size = vt11n.size();
	Vector vt12n = ft_db.Free_TotList_N(st_year, st_mon, dt, "12");
	int vt12n_size = vt12n.size();
	Vector vt21n = ft_db.Free_TotList_N(st_year, st_mon, dt, "21");
	int vt21n_size = vt21n.size();
	Vector vt22n = ft_db.Free_TotList_N(st_year, st_mon, dt, "22");
	int vt22n_size = vt22n.size();
	Vector vt71n = ft_db.Free_TotList_N(st_year, st_mon, dt, "71");
	int vt71n_size = vt71n.size();
	Vector vt72n = ft_db.Free_TotList_N(st_year, st_mon, dt, "72");
	int vt72n_size = vt72n.size();
	Vector vt81n = ft_db.Free_TotList_N(st_year, st_mon, dt, "81");
	int vt81n_size = vt81n.size();
	Vector vt82n = ft_db.Free_TotList_N(st_year, st_mon, dt, "82");
	int vt82n_size = vt82n.size();
	
	Vector vt91n = ft_db.Free_TotList_N(st_year, st_mon, dt, "91");
	int vt91n_size = vt91n.size();
	Vector vt92n = ft_db.Free_TotList_N(st_year, st_mon, dt, "92");
	int vt92n_size = vt92n.size();
	
	Vector vt101n = ft_db.Free_TotList_N(st_year, st_mon, dt, "101");
	int vt101n_size = vt101n.size();
	Vector vt102n = ft_db.Free_TotList_N(st_year, st_mon, dt, "102");
	int vt102n_size = vt102n.size();
	
	Vector vt111n = ft_db.Free_TotList_N(st_year, st_mon, dt, "111");
	int vt111n_size = vt111n.size();
	Vector vt112n = ft_db.Free_TotList_N(st_year, st_mon, dt, "112");
	int vt112n_size = vt112n.size();
	
	Vector vt121n = ft_db.Free_TotList_N(st_year, st_mon, dt, "121");
	int vt121n_size = vt121n.size();
	Vector vt122n = ft_db.Free_TotList_N(st_year, st_mon, dt, "122");
	int vt122n_size = vt122n.size();
	
	Vector vt131n = ft_db.Free_TotList_N(st_year, st_mon, dt, "131");
	int vt131n_size = vt131n.size();
	Vector vt132n = ft_db.Free_TotList_N(st_year, st_mon, dt, "132");
	int vt132n_size = vt132n.size();
	
	Vector vt141n = ft_db.Free_TotList_N(st_year, st_mon, dt, "141");
	int vt141n_size = vt141n.size();
	Vector vt142n = ft_db.Free_TotList_N(st_year, st_mon, dt, "142");
	int vt142n_size = vt142n.size();
	
	Vector vt151n = ft_db.Free_TotList_N(st_year, st_mon, dt, "151");
	int vt151n_size = vt151n.size();
	Vector vt152n = ft_db.Free_TotList_N(st_year, st_mon, dt, "152");
	int vt152n_size = vt152n.size();
	
	Vector vt161n = ft_db.Free_TotList_N(st_year, st_mon, dt, "161");
	int vt161n_size = vt161n.size();
	Vector vt162n = ft_db.Free_TotList_N(st_year, st_mon, dt, "162");
	int vt162n_size = vt162n.size();
	
	Vector vt171n = ft_db.Free_TotList_N(st_year, st_mon, dt, "171");
	int vt171n_size = vt171n.size();
	Vector vt172n = ft_db.Free_TotList_N(st_year, st_mon, dt, "172");
	int vt172n_size = vt172n.size();
	
	Vector vt181n = ft_db.Free_TotList_N(st_year, st_mon, dt, "181");
	int vt181n_size = vt181.size();
	Vector vt182n = ft_db.Free_TotList_N(st_year, st_mon, dt, "182");
	int vt182n_size = vt182n.size();
	
	Vector vt51n = ft_db.Free_TotList_N(st_year, st_mon, dt, "51");
	int vt51n_size = vt51n.size();
	Vector vt52n = ft_db.Free_TotList_N(st_year, st_mon, dt, "52");
	int vt52n_size = vt52n.size();
	
	int aan = 0;
	int bb2n = 0;
	int bb3n = 0;
	int ffn = 0;
	
	int aa_bn = 0;
	int bb2_bn = 0;
	int bb3_bn = 0;
	int ff_bn = 0;
	
	int toty = 0;
	int tot_by = 0;
	int totn = 0;
	int tot_bn = 0;
%>

<html>
<head>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<title>FMS</title>
<link rel="stylesheet" type="text/css" href="/include/table_t.css">
<%@ include file="/acar/getNaviCookies.jsp" %>
<script language="JavaScript">
<!--

//연차신청 내용 보기
	function view_cont(dept_id, sch_chk, st_year, st_mon, gubun){
		var fm = document.form1;
			
		var url = "?dept=" + dept_id
			+ "&sch_chk=" + sch_chk		
			+ "&st_year=" + st_year
			+ "&st_mon=" + st_mon
			+ "&gubun=" + gubun
			+ "&dt="+'<%=dt%>';
			
		var SUBWIN="year_mon_list.jsp" + url;	
	
		window.open(SUBWIN, 'popwin_next','scrollbars=yes,status=no,resizable=no,width=900,height=400,top=200,left=200');
		
	}	
	
//-->
</script>
</head>
<body>
<form name='form1' action='' method='post'>
<input type='hidden' name='user_id' value=''>
<input type='hidden' name='dept' value=''>
<input type='hidden' name='sch_chk' value=''>
<input type='hidden' name='st_year' value=''>
<input type='hidden' name='st_mon' value=''>
<input type="hidden" name="gubun" value="">		
<TABLE border=0 cellSpacing=0 cellPadding=0 width='100%'>
	
	<tr>
		<td class='line2'></td>
	</tr>
	<tr>
		<td class='line'>
			<table border=0 cellspacing=1 cellpadding=0 width=100%>
				<TR>
					<TD rowSpan='2' class='title' width='16%'>구분</TD>
					<TD colSpan='7' rowspan='1'class='title'>유급휴가</TD>
					<TD colSpan='5' rowspan='1'class='title'>무급휴가</TD>
				</TR>
				<TR>
					<TD class='title' width='7%'>연차</TD>
					<TD class='title' width='7%'>경조휴가</TD>
					<TD class='title' width='7%'>포상휴가</TD>
					<TD class='title' width='7%'>공가</TD>
					<TD class='title' width='7%'>출산휴가</TD>
					<TD class='title' width='7%'>병가</TD>
					<TD class='title' width='7%'>합계</TD>
					<TD class='title' width='7%'>생리휴가</TD>
					<TD class='title' width='7%'>병가</TD>
					<TD class='title' width='7%'>무급휴가</TD>
					<TD class='title' width='7%'>휴직</TD>
					<TD class='title' width='7%'>합계</TD>
				</TR>
			
				
				<TR>
					<TD class='title' width='8%'>영업팀</TD>
	<% if(vt11.size()>0){ %>
	<%for(int i=0; i< vt11.size(); i++){
	Hashtable ht = (Hashtable)vt11.elementAt(i);
	aa+=AddUtil.parseLong(String.valueOf(ht.get("AA")));
	cc+=AddUtil.parseLong(String.valueOf(ht.get("CC")));
	ee+=AddUtil.parseLong(String.valueOf(ht.get("EE")));
	dd+=AddUtil.parseLong(String.valueOf(ht.get("DD")));
	bb1+=AddUtil.parseLong(String.valueOf(ht.get("BB1")));
	bb2+=AddUtil.parseLong(String.valueOf(ht.get("BB2")));
	%>						
					<TD align='center'><%if(!ht.get("AA").equals("0")){%><a href="javascript:view_cont('0001','3','<%=st_year%>','<%=st_mon%>','Y')" onMouseOver="window.status=''; return true"><%= ht.get("AA")%></a><%}%></TD>
					<TD align='center'><%if(!ht.get("CC").equals("0")){%><a href="javascript:view_cont('0001','6','<%=st_year%>','<%=st_mon%>','Y')" onMouseOver="window.status=''; return true"><%= ht.get("CC")%></a><%}%></TD>
					<TD align='center'><%if(!ht.get("EE").equals("0")){%><a href="javascript:view_cont('0001','9','<%=st_year%>','<%=st_mon%>','Y')" onMouseOver="window.status=''; return true"><%= ht.get("EE")%></a><%}%></TD>
					<TD align='center'><%if(!ht.get("DD").equals("0")){%><a href="javascript:view_cont('0001','7','<%=st_year%>','<%=st_mon%>','Y')" onMouseOver="window.status=''; return true"><%= ht.get("DD")%></a><%}%></TD>
					<TD align='center'><%if(!ht.get("BB1").equals("0")){%><a href="javascript:view_cont('0001','51','<%=st_year%>','<%=st_mon%>','Y')" onMouseOver="window.status=''; return true"><%= ht.get("BB1")%></a><%}%></TD>
					<TD align='center'><%if(!ht.get("BB2").equals("0")){%><a href="javascript:view_cont('0001','52','<%=st_year%>','<%=st_mon%>','Y')" onMouseOver="window.status=''; return true"><%= ht.get("BB2")%></a><%}%></TD>					
					<TD align='center'><%if(!ht.get("TOT").equals("0")){%><%= ht.get("TOT")%><%}%></TD>
<%}%>
<%}else{%>							
					<TD align='center'></TD>
					<TD align='center'></TD>
					<TD align='center'></TD>
					<TD align='center'></TD>
					<TD align='center'></TD>
					<TD align='center'></TD>
					<TD align='center'></TD>
<%}%>
<% if(vt11n.size()>0){ %>					
<%
	for(int i=0; i< vt11n.size(); i++){
	Hashtable ht = (Hashtable)vt11n.elementAt(i);
	aan+=AddUtil.parseLong(String.valueOf(ht.get("AA")));
	bb3n+=AddUtil.parseLong(String.valueOf(ht.get("BB3")));
	bb2n+=AddUtil.parseLong(String.valueOf(ht.get("BB2")));
	ffn+=AddUtil.parseLong(String.valueOf(ht.get("FF")));
	%>						
					<TD align='center'><%if(!ht.get("BB3").equals("0")){%><a href="javascript:view_cont('0001','53','<%=st_year%>','<%=st_mon%>','N')" onMouseOver="window.status=''; return true"><%= ht.get("BB3")%></a><%}%></TD>
					<TD align='center'><%if(!ht.get("BB2").equals("0")){%><a href="javascript:view_cont('0001','52','<%=st_year%>','<%=st_mon%>','N')" onMouseOver="window.status=''; return true"><%= ht.get("BB2")%></a><%}%></TD>
					<TD align='center'><%if(!ht.get("AA").equals("0")){%><a href="javascript:view_cont('0001','3','<%=st_year%>','<%=st_mon%>','N')" onMouseOver="window.status=''; return true"><%= ht.get("AA")%></a><%}%></TD>
					<TD align='center'><%if(!ht.get("FF").equals("0")){%><a href="javascript:view_cont('0001','8','<%=st_year%>','<%=st_mon%>','N')" onMouseOver="window.status=''; return true"><%= ht.get("FF")%></a><%}%></TD>
					<TD align='center'><%if(!ht.get("TOT").equals("0")){%><%= ht.get("TOT")%><%}%></TD>
<%}%>


<%}else{%>							
					<TD align='center'></TD>
					<TD align='center'></TD>
					<TD align='center'></TD>
					<TD align='center'></TD>
					<TD align='center'></TD>
<%}%>
				</TR>
				<TR>
					<TD class='title' width='8%'>고객지원팀</TD>
<% if(vt21.size()>0){%>
	<%for(int i=0; i< vt21.size(); i++){
	Hashtable ht = (Hashtable)vt21.elementAt(i);
	aa+=AddUtil.parseLong(String.valueOf(ht.get("AA")));
	cc+=AddUtil.parseLong(String.valueOf(ht.get("CC")));
	ee+=AddUtil.parseLong(String.valueOf(ht.get("EE")));
	dd+=AddUtil.parseLong(String.valueOf(ht.get("DD")));
	bb1+=AddUtil.parseLong(String.valueOf(ht.get("BB1")));
	bb2+=AddUtil.parseLong(String.valueOf(ht.get("BB2")));
	%>						
					<TD align='center'><%if(!ht.get("AA").equals("0")){%><a href="javascript:view_cont('0002','3','<%=st_year%>','<%=st_mon%>','Y')" onMouseOver="window.status=''; return true"><%= ht.get("AA")%></a><%}%></TD>
					<TD align='center'><%if(!ht.get("CC").equals("0")){%><a href="javascript:view_cont('0002','6','<%=st_year%>','<%=st_mon%>','Y')" onMouseOver="window.status=''; return true"><%= ht.get("CC")%></a><%}%></TD>
					<TD align='center'><%if(!ht.get("EE").equals("0")){%><a href="javascript:view_cont('0002','9','<%=st_year%>','<%=st_mon%>','Y')" onMouseOver="window.status=''; return true"><%= ht.get("EE")%></a><%}%></TD>
					<TD align='center'><%if(!ht.get("DD").equals("0")){%><a href="javascript:view_cont('0002','7','<%=st_year%>','<%=st_mon%>','Y')" onMouseOver="window.status=''; return true"><%= ht.get("DD")%></a><%}%></TD>
					<TD align='center'><%if(!ht.get("BB1").equals("0")){%><a href="javascript:view_cont('0002','51','<%=st_year%>','<%=st_mon%>','Y')" onMouseOver="window.status=''; return true"><%= ht.get("BB1")%></a><%}%></TD>
					<TD align='center'><%if(!ht.get("BB2").equals("0")){%><a href="javascript:view_cont('0002','52','<%=st_year%>','<%=st_mon%>','Y')" onMouseOver="window.status=''; return true"><%= ht.get("BB2")%></a><%}%></TD>
					<TD align='center'><%if(!ht.get("TOT").equals("0")){%><%= ht.get("TOT")%><%}%></TD>
<%}%>
<%}else{%>							
					<TD align='center'></TD>
					<TD align='center'></TD>
					<TD align='center'></TD>
					<TD align='center'></TD>
					<TD align='center'></TD>
					<TD align='center'></TD>
					<TD align='center'></TD>
<%}%>
<% if(vt21n.size()>0){ %>					
<%
	for(int i=0; i< vt21n.size(); i++){
	Hashtable ht = (Hashtable)vt21n.elementAt(i);
	aan+=AddUtil.parseLong(String.valueOf(ht.get("AA")));
	bb3n+=AddUtil.parseLong(String.valueOf(ht.get("BB3")));
	bb2n+=AddUtil.parseLong(String.valueOf(ht.get("BB2")));
	ffn+=AddUtil.parseLong(String.valueOf(ht.get("FF")));
	
	%>						
					<TD align='center'><%if(!ht.get("BB3").equals("0")){%><a href="javascript:view_cont('0002','53','<%=st_year%>','<%=st_mon%>','N')" onMouseOver="window.status=''; return true"><%= ht.get("BB3")%></a><%}%></TD>
					<TD align='center'><%if(!ht.get("BB2").equals("0")){%><a href="javascript:view_cont('0002','52','<%=st_year%>','<%=st_mon%>','N')" onMouseOver="window.status=''; return true"><%= ht.get("BB2")%></a><%}%></TD>
					<TD align='center'><%if(!ht.get("AA").equals("0")){%><a href="javascript:view_cont('0002','3','<%=st_year%>','<%=st_mon%>','N')" onMouseOver="window.status=''; return true"><%= ht.get("AA")%></a><%}%></TD>
					<TD align='center'><%if(!ht.get("FF").equals("0")){%><a href="javascript:view_cont('0002','8','<%=st_year%>','<%=st_mon%>','N')" onMouseOver="window.status=''; return true"><%= ht.get("FF")%></a><%}%></TD>
					<TD align='center'><%if(!ht.get("TOT").equals("0")){%><%= ht.get("TOT")%><%}%></TD>
<%}%>


<%}else{%>							
					<TD align='center'></TD>
					<TD align='center'></TD>
					<TD align='center'></TD>
					<TD align='center'></TD>
					<TD align='center'></TD>
<%}%>
				</TR>
				<TR>
					<TD class='title' width='8%' height='10%'>총무팀</TD>
	<% if(vt31.size()>0){ %>
<%	
	for(int i=0; i< vt31.size(); i++){
	Hashtable ht = (Hashtable)vt31.elementAt(i);
	aa+=AddUtil.parseLong(String.valueOf(ht.get("AA")));
	cc+=AddUtil.parseLong(String.valueOf(ht.get("CC")));
	ee+=AddUtil.parseLong(String.valueOf(ht.get("EE")));
	dd+=AddUtil.parseLong(String.valueOf(ht.get("DD")));
	bb1+=AddUtil.parseLong(String.valueOf(ht.get("BB1")));
	bb2+=AddUtil.parseLong(String.valueOf(ht.get("BB2")));
	
	%>						
					<TD align='center'><%if(!ht.get("AA").equals("0")){%><a href="javascript:view_cont('0003','3','<%=st_year%>','<%=st_mon%>','Y')" onMouseOver="window.status=''; return true"><%= ht.get("AA")%></a><%}%></TD>
					<TD align='center'><%if(!ht.get("CC").equals("0")){%><a href="javascript:view_cont('0003','6','<%=st_year%>','<%=st_mon%>','Y')" onMouseOver="window.status=''; return true"><%= ht.get("CC")%></a><%}%></TD>
					<TD align='center'><%if(!ht.get("EE").equals("0")){%><a href="javascript:view_cont('0003','9','<%=st_year%>','<%=st_mon%>','Y')" onMouseOver="window.status=''; return true"><%= ht.get("EE")%></a><%}%></TD>
					<TD align='center'><%if(!ht.get("DD").equals("0")){%><a href="javascript:view_cont('0003','7','<%=st_year%>','<%=st_mon%>','Y')" onMouseOver="window.status=''; return true"><%= ht.get("DD")%></a><%}%></TD>
					<TD align='center'><%if(!ht.get("BB1").equals("0")){%><a href="javascript:view_cont('0003','51','<%=st_year%>','<%=st_mon%>','Y')" onMouseOver="window.status=''; return true"><%= ht.get("BB1")%></a><%}%></TD>
					<TD align='center'><%if(!ht.get("BB2").equals("0")){%><a href="javascript:view_cont('0003','52','<%=st_year%>','<%=st_mon%>','Y')" onMouseOver="window.status=''; return true"><%= ht.get("BB2")%></a><%}%></TD>
					<TD align='center'><%if(!ht.get("TOT").equals("0")){%><%= ht.get("TOT")%><%}%></TD>
<%}%>					
<%}else{%>							
					<TD align='center'></TD>
					<TD align='center'></TD>
					<TD align='center'></TD>
					<TD align='center'></TD>
					<TD align='center'></TD>
					<TD align='center'></TD>
					<TD align='center'></TD>
<%}%>
<% if(vt31n.size()>0){ %>					
<%
	for(int i=0; i< vt31n.size(); i++){
	Hashtable ht = (Hashtable)vt31n.elementAt(i);
	aan+=AddUtil.parseLong(String.valueOf(ht.get("AA")));
	bb3n+=AddUtil.parseLong(String.valueOf(ht.get("BB3")));
	bb2n+=AddUtil.parseLong(String.valueOf(ht.get("BB2")));
	ffn+=AddUtil.parseLong(String.valueOf(ht.get("FF")));
	
	%>						
					<TD align='center'><%if(!ht.get("BB3").equals("0")){%><a href="javascript:view_cont('0003','53','<%=st_year%>','<%=st_mon%>','N')" onMouseOver="window.status=''; return true"><%= ht.get("BB3")%></a><%}%></TD>
					<TD align='center'><%if(!ht.get("BB2").equals("0")){%><a href="javascript:view_cont('0003','52','<%=st_year%>','<%=st_mon%>','N')" onMouseOver="window.status=''; return true"><%= ht.get("BB2")%></a><%}%></TD>
					<TD align='center'><%if(!ht.get("AA").equals("0")){%><a href="javascript:view_cont('0003','3','<%=st_year%>','<%=st_mon%>','N')" onMouseOver="window.status=''; return true"><%= ht.get("AA")%></a><%}%></TD>
					<TD align='center'><%if(!ht.get("FF").equals("0")){%><a href="javascript:view_cont('0003','8','<%=st_year%>','<%=st_mon%>','N')" onMouseOver="window.status=''; return true"><%= ht.get("FF")%></a><%}%></TD>
					<TD align='center'><%if(!ht.get("TOT").equals("0")){%><%= ht.get("TOT")%><%}%></TD>
<%}%>


<%}else{%>							
					<TD align='center'></TD>
					<TD align='center'></TD>
					<TD align='center'></TD>
					<TD align='center'></TD>
					<TD align='center'></TD>
<%}%>
				</TR>
				
				<TR>
					<TD class='title' width='8%'>IT마케팅팀</TD>
	<% if(vt51.size()>0){ %>
	<%for(int i=0; i< vt51.size(); i++){
	Hashtable ht = (Hashtable)vt51.elementAt(i);
	aa+=AddUtil.parseLong(String.valueOf(ht.get("AA")));
	cc+=AddUtil.parseLong(String.valueOf(ht.get("CC")));
	ee+=AddUtil.parseLong(String.valueOf(ht.get("EE")));
	dd+=AddUtil.parseLong(String.valueOf(ht.get("DD")));
	bb1+=AddUtil.parseLong(String.valueOf(ht.get("BB1")));
	bb2+=AddUtil.parseLong(String.valueOf(ht.get("BB2")));
	%>						
					<TD align='center'><%if(!ht.get("AA").equals("0")){%><a href="javascript:view_cont('0005','3','<%=st_year%>','<%=st_mon%>','Y')" onMouseOver="window.status=''; return true"><%= ht.get("AA")%></a><%}%></TD>
					<TD align='center'><%if(!ht.get("CC").equals("0")){%><a href="javascript:view_cont('0005','6','<%=st_year%>','<%=st_mon%>','Y')" onMouseOver="window.status=''; return true"><%= ht.get("CC")%></a><%}%></TD>
					<TD align='center'><%if(!ht.get("EE").equals("0")){%><a href="javascript:view_cont('0005','9','<%=st_year%>','<%=st_mon%>','Y')" onMouseOver="window.status=''; return true"><%= ht.get("EE")%></a><%}%></TD>
					<TD align='center'><%if(!ht.get("DD").equals("0")){%><a href="javascript:view_cont('0005','7','<%=st_year%>','<%=st_mon%>','Y')" onMouseOver="window.status=''; return true"><%= ht.get("DD")%></a><%}%></TD>
					<TD align='center'><%if(!ht.get("BB1").equals("0")){%><a href="javascript:view_cont('0005','51','<%=st_year%>','<%=st_mon%>','Y')" onMouseOver="window.status=''; return true"><%= ht.get("BB1")%></a><%}%></TD>
					<TD align='center'><%if(!ht.get("BB2").equals("0")){%><a href="javascript:view_cont('0005','52','<%=st_year%>','<%=st_mon%>','Y')" onMouseOver="window.status=''; return true"><%= ht.get("BB2")%></a><%}%></TD>					
					<TD align='center'><%if(!ht.get("TOT").equals("0")){%><%= ht.get("TOT")%><%}%></TD>
<%}%>
<%}else{%>							
					<TD align='center'></TD>
					<TD align='center'></TD>
					<TD align='center'></TD>
					<TD align='center'></TD>
					<TD align='center'></TD>
					<TD align='center'></TD>
					<TD align='center'></TD>
<%}%>
<% if(vt51n.size()>0){ %>					
<%
	for(int i=0; i< vt51n.size(); i++){
	Hashtable ht = (Hashtable)vt11n.elementAt(i);
	aan+=AddUtil.parseLong(String.valueOf(ht.get("AA")));
	bb3n+=AddUtil.parseLong(String.valueOf(ht.get("BB3")));
	bb2n+=AddUtil.parseLong(String.valueOf(ht.get("BB2")));
	ffn+=AddUtil.parseLong(String.valueOf(ht.get("FF")));
	%>						
					<TD align='center'><%if(!ht.get("BB3").equals("0")){%><a href="javascript:view_cont('0005','53','<%=st_year%>','<%=st_mon%>','N')" onMouseOver="window.status=''; return true"><%= ht.get("BB3")%></a><%}%></TD>
					<TD align='center'><%if(!ht.get("BB2").equals("0")){%><a href="javascript:view_cont('0005','52','<%=st_year%>','<%=st_mon%>','N')" onMouseOver="window.status=''; return true"><%= ht.get("BB2")%></a><%}%></TD>
					<TD align='center'><%if(!ht.get("AA").equals("0")){%><a href="javascript:view_cont('0005','3','<%=st_year%>','<%=st_mon%>','N')" onMouseOver="window.status=''; return true"><%= ht.get("AA")%></a><%}%></TD>
					<TD align='center'><%if(!ht.get("FF").equals("0")){%><a href="javascript:view_cont('0005','8','<%=st_year%>','<%=st_mon%>','N')" onMouseOver="window.status=''; return true"><%= ht.get("FF")%></a><%}%></TD>
					<TD align='center'><%if(!ht.get("TOT").equals("0")){%><%= ht.get("TOT")%><%}%></TD>
<%}%>


<%}else{%>							
					<TD align='center'></TD>
					<TD align='center'></TD>
					<TD align='center'></TD>
					<TD align='center'></TD>
					<TD align='center'></TD>
<%}%>
				</TR>
				<TR>
					<TD class='title' width='8%'>부산지점</TD>
	<% if(vt71.size()>0){%>
	<%for(int i=0; i< vt71.size(); i++){
	Hashtable ht = (Hashtable)vt71.elementAt(i);
	aa+=AddUtil.parseLong(String.valueOf(ht.get("AA")));
	cc+=AddUtil.parseLong(String.valueOf(ht.get("CC")));
	ee+=AddUtil.parseLong(String.valueOf(ht.get("EE")));
	dd+=AddUtil.parseLong(String.valueOf(ht.get("DD")));
	bb1+=AddUtil.parseLong(String.valueOf(ht.get("BB1")));
	bb2+=AddUtil.parseLong(String.valueOf(ht.get("BB2")));
	%>						
					<TD align='center'><%if(!ht.get("AA").equals("0")){%><a href="javascript:view_cont('0007','3','<%=st_year%>','<%=st_mon%>','Y')" onMouseOver="window.status=''; return true"><%= ht.get("AA")%></a><%}%></TD>
					<TD align='center'><%if(!ht.get("CC").equals("0")){%><a href="javascript:view_cont('0007','6','<%=st_year%>','<%=st_mon%>','Y')" onMouseOver="window.status=''; return true"><%= ht.get("CC")%></a><%}%></TD>
					<TD align='center'><%if(!ht.get("EE").equals("0")){%><a href="javascript:view_cont('0007','9','<%=st_year%>','<%=st_mon%>','Y')" onMouseOver="window.status=''; return true"><%= ht.get("EE")%></a><%}%></TD>
					<TD align='center'><%if(!ht.get("DD").equals("0")){%><a href="javascript:view_cont('0007','7','<%=st_year%>','<%=st_mon%>','Y')" onMouseOver="window.status=''; return true"><%= ht.get("DD")%></a><%}%></TD>
					<TD align='center'><%if(!ht.get("BB1").equals("0")){%><a href="javascript:view_cont('0007','51','<%=st_year%>','<%=st_mon%>','Y')" onMouseOver="window.status=''; return true"><%= ht.get("BB1")%></a><%}%></TD>
					<TD align='center'><%if(!ht.get("BB2").equals("0")){%><a href="javascript:view_cont('0007','52','<%=st_year%>','<%=st_mon%>','Y')" onMouseOver="window.status=''; return true"><%= ht.get("BB2")%></a><%}%></TD>					
					<TD align='center'><%if(!ht.get("TOT").equals("0")){%><%= ht.get("TOT")%><%}%></TD>
<%}%>
<%}else{%>							
					<TD align='center'></TD>
					<TD align='center'></TD>
					<TD align='center'></TD>
					<TD align='center'></TD>
					<TD align='center'></TD>
					<TD align='center'></TD>
					<TD align='center'></TD>
<%}%>
<% if(vt71n.size()>0){ %>					
<%
	for(int i=0; i< vt71n.size(); i++){
	Hashtable ht = (Hashtable)vt71n.elementAt(i);
	aan+=AddUtil.parseLong(String.valueOf(ht.get("AA")));
	bb3n+=AddUtil.parseLong(String.valueOf(ht.get("BB3")));
	bb2n+=AddUtil.parseLong(String.valueOf(ht.get("BB2")));
	ffn+=AddUtil.parseLong(String.valueOf(ht.get("FF")));
	
	%>						
					<TD align='center'><%if(!ht.get("BB3").equals("0")){%><a href="javascript:view_cont('0007','53','<%=st_year%>','<%=st_mon%>','N')" onMouseOver="window.status=''; return true"><%= ht.get("BB3")%></a><%}%></TD>
					<TD align='center'><%if(!ht.get("BB2").equals("0")){%><a href="javascript:view_cont('0007','52','<%=st_year%>','<%=st_mon%>','N')" onMouseOver="window.status=''; return true"><%= ht.get("BB2")%></a><%}%></TD>
					<TD align='center'><%if(!ht.get("AA").equals("0")){%><a href="javascript:view_cont('0007','3','<%=st_year%>','<%=st_mon%>','N')" onMouseOver="window.status=''; return true"><%= ht.get("AA")%></a><%}%></TD>
					<TD align='center'><%if(!ht.get("FF").equals("0")){%><a href="javascript:view_cont('0007','8','<%=st_year%>','<%=st_mon%>','N')" onMouseOver="window.status=''; return true"><%= ht.get("FF")%></a><%}%></TD>
					<TD align='center'><%if(!ht.get("TOT").equals("0")){%><%= ht.get("TOT")%><%}%></TD>
<%}%>


<%}else{%>							
					<TD align='center'></TD>
					<TD align='center'></TD>
					<TD align='center'></TD>
					<TD align='center'></TD>
					<TD align='center'></TD>
<%}%>
				</TR>

				<TR>
					<TD class='title' width='8%'>대전지점</TD>
	<% if(vt81.size()>0){%>
	<%for(int i=0; i< vt81.size(); i++){
	Hashtable ht = (Hashtable)vt81.elementAt(i);
	aa+=AddUtil.parseLong(String.valueOf(ht.get("AA")));
	cc+=AddUtil.parseLong(String.valueOf(ht.get("CC")));
	ee+=AddUtil.parseLong(String.valueOf(ht.get("EE")));
	dd+=AddUtil.parseLong(String.valueOf(ht.get("DD")));
	bb1+=AddUtil.parseLong(String.valueOf(ht.get("BB1")));
	bb2+=AddUtil.parseLong(String.valueOf(ht.get("BB2")));
	%>						
					<TD align='center'><%if(!ht.get("AA").equals("0")){%><a href="javascript:view_cont('0008','3','<%=st_year%>','<%=st_mon%>','Y')" onMouseOver="window.status=''; return true"><%= ht.get("AA")%></a><%}%></TD>
					<TD align='center'><%if(!ht.get("CC").equals("0")){%><a href="javascript:view_cont('0008','6','<%=st_year%>','<%=st_mon%>','Y')" onMouseOver="window.status=''; return true"><%= ht.get("CC")%></a><%}%></TD>
					<TD align='center'><%if(!ht.get("EE").equals("0")){%><a href="javascript:view_cont('0008','9','<%=st_year%>','<%=st_mon%>','Y')" onMouseOver="window.status=''; return true"><%= ht.get("EE")%></a><%}%></TD>
					<TD align='center'><%if(!ht.get("DD").equals("0")){%><a href="javascript:view_cont('0008','7','<%=st_year%>','<%=st_mon%>','Y')" onMouseOver="window.status=''; return true"><%= ht.get("DD")%></a><%}%></TD>
					<TD align='center'><%if(!ht.get("BB1").equals("0")){%><a href="javascript:view_cont('0008','51','<%=st_year%>','<%=st_mon%>','Y')" onMouseOver="window.status=''; return true"><%= ht.get("BB1")%></a><%}%></TD>
					<TD align='center'><%if(!ht.get("BB2").equals("0")){%><a href="javascript:view_cont('0008','52','<%=st_year%>','<%=st_mon%>','Y')" onMouseOver="window.status=''; return true"><%= ht.get("BB2")%></a><%}%></TD>
					<TD align='center'><%if(!ht.get("TOT").equals("0")){%><%= ht.get("TOT")%><%}%></TD>
<%}%>
<%}else{%>							
					<TD align='center'></TD>
					<TD align='center'></TD>
					<TD align='center'></TD>
					<TD align='center'></TD>
					<TD align='center'></TD>
					<TD align='center'></TD>
					<TD align='center'></TD>
<%}%>
<% if(vt81n.size()>0){ %>					
<%
	for(int i=0; i< vt81n.size(); i++){
	Hashtable ht = (Hashtable)vt81n.elementAt(i);
	aan+=AddUtil.parseLong(String.valueOf(ht.get("AA")));
	bb3n+=AddUtil.parseLong(String.valueOf(ht.get("BB3")));
	bb2n+=AddUtil.parseLong(String.valueOf(ht.get("BB2")));
	
	%>						
					<TD align='center'><%if(!ht.get("BB3").equals("0")){%><a href="javascript:view_cont('0008','53','<%=st_year%>','<%=st_mon%>','N')" onMouseOver="window.status=''; return true"><%= ht.get("BB3")%></a><%}%></TD>
					<TD align='center'><%if(!ht.get("BB2").equals("0")){%><a href="javascript:view_cont('0008','52','<%=st_year%>','<%=st_mon%>','N')" onMouseOver="window.status=''; return true"><%= ht.get("BB2")%></a><%}%></TD>
					<TD align='center'><%if(!ht.get("AA").equals("0")){%><a href="javascript:view_cont('0008','3','<%=st_year%>','<%=st_mon%>','N')" onMouseOver="window.status=''; return true"><%= ht.get("AA")%></a><%}%></TD>
					<TD align='center'><%if(!ht.get("FF").equals("0")){%><a href="javascript:view_cont('0008','8','<%=st_year%>','<%=st_mon%>','N')" onMouseOver="window.status=''; return true"><%= ht.get("FF")%></a><%}%></TD>
					<TD align='center'><%if(!ht.get("TOT").equals("0")){%><%= ht.get("TOT")%><%}%></TD>
<%}%>


<%}else{%>							
					<TD align='center'></TD>
					<TD align='center'></TD>
					<TD align='center'></TD>
					<TD align='center'></TD>
					<TD align='center'></TD>
<%}%>
				</TR>
				<TR>
					<TD class='title' width='8%'>강남영업소</TD>
	<% if(vt91.size()>0){ %>
	<%for(int i=0; i< vt91.size(); i++){
	Hashtable ht = (Hashtable)vt91.elementAt(i);
	aa+=AddUtil.parseLong(String.valueOf(ht.get("AA")));
	cc+=AddUtil.parseLong(String.valueOf(ht.get("CC")));
	ee+=AddUtil.parseLong(String.valueOf(ht.get("EE")));
	dd+=AddUtil.parseLong(String.valueOf(ht.get("DD")));
	bb1+=AddUtil.parseLong(String.valueOf(ht.get("BB1")));
	bb2+=AddUtil.parseLong(String.valueOf(ht.get("BB2")));
	%>						
					<TD align='center'><%if(!ht.get("AA").equals("0")){%><a href="javascript:view_cont('0009','3','<%=st_year%>','<%=st_mon%>','Y')" onMouseOver="window.status=''; return true"><%= ht.get("AA")%></a><%}%></TD>
					<TD align='center'><%if(!ht.get("CC").equals("0")){%><a href="javascript:view_cont('0009','6','<%=st_year%>','<%=st_mon%>','Y')" onMouseOver="window.status=''; return true"><%= ht.get("CC")%></a><%}%></TD>
					<TD align='center'><%if(!ht.get("EE").equals("0")){%><a href="javascript:view_cont('0009','9','<%=st_year%>','<%=st_mon%>','Y')" onMouseOver="window.status=''; return true"><%= ht.get("EE")%></a><%}%></TD>
					<TD align='center'><%if(!ht.get("DD").equals("0")){%><a href="javascript:view_cont('0009','7','<%=st_year%>','<%=st_mon%>','Y')" onMouseOver="window.status=''; return true"><%= ht.get("DD")%></a><%}%></TD>
					<TD align='center'><%if(!ht.get("BB1").equals("0")){%><a href="javascript:view_cont('0009','51','<%=st_year%>','<%=st_mon%>','Y')" onMouseOver="window.status=''; return true"><%= ht.get("BB1")%></a><%}%></TD>
					<TD align='center'><%if(!ht.get("BB2").equals("0")){%><a href="javascript:view_cont('0009','52','<%=st_year%>','<%=st_mon%>','Y')" onMouseOver="window.status=''; return true"><%= ht.get("BB2")%></a><%}%></TD>					
					<TD align='center'><%if(!ht.get("TOT").equals("0")){%><%= ht.get("TOT")%><%}%></TD>
<%}%>
<%}else{%>							
					<TD align='center'></TD>
					<TD align='center'></TD>
					<TD align='center'></TD>
					<TD align='center'></TD>
					<TD align='center'></TD>
					<TD align='center'></TD>
					<TD align='center'></TD>
<%}%>
<% if(vt91n.size()>0){ %>					
<%
	for(int i=0; i< vt91n.size(); i++){
	Hashtable ht = (Hashtable)vt91n.elementAt(i);
	aan+=AddUtil.parseLong(String.valueOf(ht.get("AA")));
	bb3n+=AddUtil.parseLong(String.valueOf(ht.get("BB3")));
	bb2n+=AddUtil.parseLong(String.valueOf(ht.get("BB2")));
	ffn+=AddUtil.parseLong(String.valueOf(ht.get("FF")));
	%>						
					<TD align='center'><%if(!ht.get("BB3").equals("0")){%><a href="javascript:view_cont('0009','53','<%=st_year%>','<%=st_mon%>','N')" onMouseOver="window.status=''; return true"><%= ht.get("BB3")%></a><%}%></TD>
					<TD align='center'><%if(!ht.get("BB2").equals("0")){%><a href="javascript:view_cont('0009','52','<%=st_year%>','<%=st_mon%>','N')" onMouseOver="window.status=''; return true"><%= ht.get("BB2")%></a><%}%></TD>
					<TD align='center'><%if(!ht.get("AA").equals("0")){%><a href="javascript:view_cont('0009','3','<%=st_year%>','<%=st_mon%>','N')" onMouseOver="window.status=''; return true"><%= ht.get("AA")%></a><%}%></TD>
					<TD align='center'><%if(!ht.get("FF").equals("0")){%><a href="javascript:view_cont('0009','8','<%=st_year%>','<%=st_mon%>','N')" onMouseOver="window.status=''; return true"><%= ht.get("FF")%></a><%}%></TD>
					<TD align='center'><%if(!ht.get("TOT").equals("0")){%><%= ht.get("TOT")%><%}%></TD>
<%}%>


<%}else{%>							
					<TD align='center'></TD>
					<TD align='center'></TD>
					<TD align='center'></TD>
					<TD align='center'></TD>
					<TD align='center'></TD>
<%}%>
				</TR>
				<TR>
					<TD class='title' width='8%'>광주지점</TD>
	<% if(vt101.size()>0){ %>
	<%for(int i=0; i< vt101.size(); i++){
	Hashtable ht = (Hashtable)vt101.elementAt(i);
	aa+=AddUtil.parseLong(String.valueOf(ht.get("AA")));
	cc+=AddUtil.parseLong(String.valueOf(ht.get("CC")));
	ee+=AddUtil.parseLong(String.valueOf(ht.get("EE")));
	dd+=AddUtil.parseLong(String.valueOf(ht.get("DD")));
	bb1+=AddUtil.parseLong(String.valueOf(ht.get("BB1")));
	bb2+=AddUtil.parseLong(String.valueOf(ht.get("BB2")));
	%>						
					<TD align='center'><%if(!ht.get("AA").equals("0")){%><a href="javascript:view_cont('0010','3','<%=st_year%>','<%=st_mon%>','Y')" onMouseOver="window.status=''; return true"><%= ht.get("AA")%></a><%}%></TD>
					<TD align='center'><%if(!ht.get("CC").equals("0")){%><a href="javascript:view_cont('0010','6','<%=st_year%>','<%=st_mon%>','Y')" onMouseOver="window.status=''; return true"><%= ht.get("CC")%></a><%}%></TD>
					<TD align='center'><%if(!ht.get("EE").equals("0")){%><a href="javascript:view_cont('0010','9','<%=st_year%>','<%=st_mon%>','Y')" onMouseOver="window.status=''; return true"><%= ht.get("EE")%></a><%}%></TD>
					<TD align='center'><%if(!ht.get("DD").equals("0")){%><a href="javascript:view_cont('0010','7','<%=st_year%>','<%=st_mon%>','Y')" onMouseOver="window.status=''; return true"><%= ht.get("DD")%></a><%}%></TD>
					<TD align='center'><%if(!ht.get("BB1").equals("0")){%><a href="javascript:view_cont('0010','51','<%=st_year%>','<%=st_mon%>','Y')" onMouseOver="window.status=''; return true"><%= ht.get("BB1")%></a><%}%></TD>
					<TD align='center'><%if(!ht.get("BB2").equals("0")){%><a href="javascript:view_cont('0010','52','<%=st_year%>','<%=st_mon%>','Y')" onMouseOver="window.status=''; return true"><%= ht.get("BB2")%></a><%}%></TD>					
					<TD align='center'><%if(!ht.get("TOT").equals("0")){%><%= ht.get("TOT")%><%}%></TD>
<%}%>
<%}else{%>							
					<TD align='center'></TD>
					<TD align='center'></TD>
					<TD align='center'></TD>
					<TD align='center'></TD>
					<TD align='center'></TD>
					<TD align='center'></TD>
					<TD align='center'></TD>
<%}%>
<% if(vt101n.size()>0){ %>					
<%
	for(int i=0; i< vt101n.size(); i++){
	Hashtable ht = (Hashtable)vt101n.elementAt(i);
	aan+=AddUtil.parseLong(String.valueOf(ht.get("AA")));
	bb3n+=AddUtil.parseLong(String.valueOf(ht.get("BB3")));
	bb2n+=AddUtil.parseLong(String.valueOf(ht.get("BB2")));
	ffn+=AddUtil.parseLong(String.valueOf(ht.get("FF")));
	%>						
					<TD align='center'><%if(!ht.get("BB3").equals("0")){%><a href="javascript:view_cont('0010','53','<%=st_year%>','<%=st_mon%>','N')" onMouseOver="window.status=''; return true"><%= ht.get("BB3")%></a><%}%></TD>
					<TD align='center'><%if(!ht.get("BB2").equals("0")){%><a href="javascript:view_cont('0010','52','<%=st_year%>','<%=st_mon%>','N')" onMouseOver="window.status=''; return true"><%= ht.get("BB2")%></a><%}%></TD>
					<TD align='center'><%if(!ht.get("AA").equals("0")){%><a href="javascript:view_cont('0010','3','<%=st_year%>','<%=st_mon%>','N')" onMouseOver="window.status=''; return true"><%= ht.get("AA")%></a><%}%></TD>
					<TD align='center'><%if(!ht.get("FF").equals("0")){%><a href="javascript:view_cont('0010','8','<%=st_year%>','<%=st_mon%>','N')" onMouseOver="window.status=''; return true"><%= ht.get("FF")%></a><%}%></TD>
					<TD align='center'><%if(!ht.get("TOT").equals("0")){%><%= ht.get("TOT")%><%}%></TD>
<%}%>


<%}else{%>							
					<TD align='center'></TD>
					<TD align='center'></TD>
					<TD align='center'></TD>
					<TD align='center'></TD>
					<TD align='center'></TD>
<%}%>
				</TR>
				<TR>
					<TD class='title' width='8%'>대구지점</TD>
	<% if(vt111.size()>0){ %>
	<%for(int i=0; i< vt111.size(); i++){
	Hashtable ht = (Hashtable)vt111.elementAt(i);
	aa+=AddUtil.parseLong(String.valueOf(ht.get("AA")));
	cc+=AddUtil.parseLong(String.valueOf(ht.get("CC")));
	ee+=AddUtil.parseLong(String.valueOf(ht.get("EE")));
	dd+=AddUtil.parseLong(String.valueOf(ht.get("DD")));
	bb1+=AddUtil.parseLong(String.valueOf(ht.get("BB1")));
	bb2+=AddUtil.parseLong(String.valueOf(ht.get("BB2")));
	%>						
					<TD align='center'><%if(!ht.get("AA").equals("0")){%><a href="javascript:view_cont('0011','3','<%=st_year%>','<%=st_mon%>','Y')" onMouseOver="window.status=''; return true"><%= ht.get("AA")%></a><%}%></TD>
					<TD align='center'><%if(!ht.get("CC").equals("0")){%><a href="javascript:view_cont('0011','6','<%=st_year%>','<%=st_mon%>','Y')" onMouseOver="window.status=''; return true"><%= ht.get("CC")%></a><%}%></TD>
					<TD align='center'><%if(!ht.get("EE").equals("0")){%><a href="javascript:view_cont('0011','9','<%=st_year%>','<%=st_mon%>','Y')" onMouseOver="window.status=''; return true"><%= ht.get("EE")%></a><%}%></TD>
					<TD align='center'><%if(!ht.get("DD").equals("0")){%><a href="javascript:view_cont('0011','7','<%=st_year%>','<%=st_mon%>','Y')" onMouseOver="window.status=''; return true"><%= ht.get("DD")%></a><%}%></TD>
					<TD align='center'><%if(!ht.get("BB1").equals("0")){%><a href="javascript:view_cont('0011','51','<%=st_year%>','<%=st_mon%>','Y')" onMouseOver="window.status=''; return true"><%= ht.get("BB1")%></a><%}%></TD>
					<TD align='center'><%if(!ht.get("BB2").equals("0")){%><a href="javascript:view_cont('0011','52','<%=st_year%>','<%=st_mon%>','Y')" onMouseOver="window.status=''; return true"><%= ht.get("BB2")%></a><%}%></TD>					
					<TD align='center'><%if(!ht.get("TOT").equals("0")){%><%= ht.get("TOT")%><%}%></TD>
<%}%>
<%}else{%>							
					<TD align='center'></TD>
					<TD align='center'></TD>
					<TD align='center'></TD>
					<TD align='center'></TD>
					<TD align='center'></TD>
					<TD align='center'></TD>
					<TD align='center'></TD>
<%}%>
<% if(vt111n.size()>0){ %>					
<%
	for(int i=0; i< vt111n.size(); i++){
	Hashtable ht = (Hashtable)vt111n.elementAt(i);
	aan+=AddUtil.parseLong(String.valueOf(ht.get("AA")));
	bb3n+=AddUtil.parseLong(String.valueOf(ht.get("BB3")));
	bb2n+=AddUtil.parseLong(String.valueOf(ht.get("BB2")));
	ffn+=AddUtil.parseLong(String.valueOf(ht.get("FF")));
	%>						
					<TD align='center'><%if(!ht.get("BB3").equals("0")){%><a href="javascript:view_cont('0011','53','<%=st_year%>','<%=st_mon%>','N')" onMouseOver="window.status=''; return true"><%= ht.get("BB3")%></a><%}%></TD>
					<TD align='center'><%if(!ht.get("BB2").equals("0")){%><a href="javascript:view_cont('0011','52','<%=st_year%>','<%=st_mon%>','N')" onMouseOver="window.status=''; return true"><%= ht.get("BB2")%></a><%}%></TD>
					<TD align='center'><%if(!ht.get("AA").equals("0")){%><a href="javascript:view_cont('0011','3','<%=st_year%>','<%=st_mon%>','N')" onMouseOver="window.status=''; return true"><%= ht.get("AA")%></a><%}%></TD>
					<TD align='center'><%if(!ht.get("FF").equals("0")){%><a href="javascript:view_cont('0011','8','<%=st_year%>','<%=st_mon%>','N')" onMouseOver="window.status=''; return true"><%= ht.get("FF")%></a><%}%></TD>
					<TD align='center'><%if(!ht.get("TOT").equals("0")){%><%= ht.get("TOT")%><%}%></TD>
<%}%>


<%}else{%>							
					<TD align='center'></TD>
					<TD align='center'></TD>
					<TD align='center'></TD>
					<TD align='center'></TD>
					<TD align='center'></TD>
<%}%>
				</TR>
				<TR>
					<TD class='title' width='8%'>인천지점</TD>
	<% if(vt121.size()>0){ %>
	<%for(int i=0; i< vt121.size(); i++){
	Hashtable ht = (Hashtable)vt121.elementAt(i);
	aa+=AddUtil.parseLong(String.valueOf(ht.get("AA")));
	cc+=AddUtil.parseLong(String.valueOf(ht.get("CC")));
	ee+=AddUtil.parseLong(String.valueOf(ht.get("EE")));
	dd+=AddUtil.parseLong(String.valueOf(ht.get("DD")));
	bb1+=AddUtil.parseLong(String.valueOf(ht.get("BB1")));
	bb2+=AddUtil.parseLong(String.valueOf(ht.get("BB2")));
	%>						
					<TD align='center'><%if(!ht.get("AA").equals("0")){%><a href="javascript:view_cont('0012','3','<%=st_year%>','<%=st_mon%>','Y')" onMouseOver="window.status=''; return true"><%= ht.get("AA")%></a><%}%></TD>
					<TD align='center'><%if(!ht.get("CC").equals("0")){%><a href="javascript:view_cont('0012','6','<%=st_year%>','<%=st_mon%>','Y')" onMouseOver="window.status=''; return true"><%= ht.get("CC")%></a><%}%></TD>
					<TD align='center'><%if(!ht.get("EE").equals("0")){%><a href="javascript:view_cont('0012','9','<%=st_year%>','<%=st_mon%>','Y')" onMouseOver="window.status=''; return true"><%= ht.get("EE")%></a><%}%></TD>
					<TD align='center'><%if(!ht.get("DD").equals("0")){%><a href="javascript:view_cont('0012','7','<%=st_year%>','<%=st_mon%>','Y')" onMouseOver="window.status=''; return true"><%= ht.get("DD")%></a><%}%></TD>
					<TD align='center'><%if(!ht.get("BB1").equals("0")){%><a href="javascript:view_cont('0012','51','<%=st_year%>','<%=st_mon%>','Y')" onMouseOver="window.status=''; return true"><%= ht.get("BB1")%></a><%}%></TD>
					<TD align='center'><%if(!ht.get("BB2").equals("0")){%><a href="javascript:view_cont('0012','52','<%=st_year%>','<%=st_mon%>','Y')" onMouseOver="window.status=''; return true"><%= ht.get("BB2")%></a><%}%></TD>					
					<TD align='center'><%if(!ht.get("TOT").equals("0")){%><%= ht.get("TOT")%><%}%></TD>
<%}%>
<%}else{%>							
					<TD align='center'></TD>
					<TD align='center'></TD>
					<TD align='center'></TD>
					<TD align='center'></TD>
					<TD align='center'></TD>
					<TD align='center'></TD>
					<TD align='center'></TD>
<%}%>
<% if(vt121n.size()>0){ %>					
<%
	for(int i=0; i< vt121n.size(); i++){
	Hashtable ht = (Hashtable)vt121n.elementAt(i);
	aan+=AddUtil.parseLong(String.valueOf(ht.get("AA")));
	bb3n+=AddUtil.parseLong(String.valueOf(ht.get("BB3")));
	bb2n+=AddUtil.parseLong(String.valueOf(ht.get("BB2")));
	ffn+=AddUtil.parseLong(String.valueOf(ht.get("FF")));
	%>						
					<TD align='center'><%if(!ht.get("BB3").equals("0")){%><a href="javascript:view_cont('0012','53','<%=st_year%>','<%=st_mon%>','N')" onMouseOver="window.status=''; return true"><%= ht.get("BB3")%></a><%}%></TD>
					<TD align='center'><%if(!ht.get("BB2").equals("0")){%><a href="javascript:view_cont('0012','52','<%=st_year%>','<%=st_mon%>','N')" onMouseOver="window.status=''; return true"><%= ht.get("BB2")%></a><%}%></TD>
					<TD align='center'><%if(!ht.get("AA").equals("0")){%><a href="javascript:view_cont('0012','3','<%=st_year%>','<%=st_mon%>','N')" onMouseOver="window.status=''; return true"><%= ht.get("AA")%></a><%}%></TD>
					<TD align='center'><%if(!ht.get("FF").equals("0")){%><a href="javascript:view_cont('0012','8','<%=st_year%>','<%=st_mon%>','N')" onMouseOver="window.status=''; return true"><%= ht.get("FF")%></a><%}%></TD>
					<TD align='center'><%if(!ht.get("TOT").equals("0")){%><%= ht.get("TOT")%><%}%></TD>
<%}%>


<%}else{%>							
					<TD align='center'></TD>
					<TD align='center'></TD>
					<TD align='center'></TD>
					<TD align='center'></TD>
					<TD align='center'></TD>
<%}%>
				</TR>
				<TR>
					<TD class='title' width='8%'>수원지점</TD>
	<% if(vt131.size()>0){ %>
	<%for(int i=0; i< vt131.size(); i++){
	Hashtable ht = (Hashtable)vt131.elementAt(i);
	aa+=AddUtil.parseLong(String.valueOf(ht.get("AA")));
	cc+=AddUtil.parseLong(String.valueOf(ht.get("CC")));
	ee+=AddUtil.parseLong(String.valueOf(ht.get("EE")));
	dd+=AddUtil.parseLong(String.valueOf(ht.get("DD")));
	bb1+=AddUtil.parseLong(String.valueOf(ht.get("BB1")));
	bb2+=AddUtil.parseLong(String.valueOf(ht.get("BB2")));
	%>						
					<TD align='center'><%if(!ht.get("AA").equals("0")){%><a href="javascript:view_cont('0013','3','<%=st_year%>','<%=st_mon%>','Y')" onMouseOver="window.status=''; return true"><%= ht.get("AA")%></a><%}%></TD>
					<TD align='center'><%if(!ht.get("CC").equals("0")){%><a href="javascript:view_cont('0013','6','<%=st_year%>','<%=st_mon%>','Y')" onMouseOver="window.status=''; return true"><%= ht.get("CC")%></a><%}%></TD>
					<TD align='center'><%if(!ht.get("EE").equals("0")){%><a href="javascript:view_cont('0013','9','<%=st_year%>','<%=st_mon%>','Y')" onMouseOver="window.status=''; return true"><%= ht.get("EE")%></a><%}%></TD>
					<TD align='center'><%if(!ht.get("DD").equals("0")){%><a href="javascript:view_cont('0013','7','<%=st_year%>','<%=st_mon%>','Y')" onMouseOver="window.status=''; return true"><%= ht.get("DD")%></a><%}%></TD>
					<TD align='center'><%if(!ht.get("BB1").equals("0")){%><a href="javascript:view_cont('0013','51','<%=st_year%>','<%=st_mon%>','Y')" onMouseOver="window.status=''; return true"><%= ht.get("BB1")%></a><%}%></TD>
					<TD align='center'><%if(!ht.get("BB2").equals("0")){%><a href="javascript:view_cont('0013','52','<%=st_year%>','<%=st_mon%>','Y')" onMouseOver="window.status=''; return true"><%= ht.get("BB2")%></a><%}%></TD>					
					<TD align='center'><%if(!ht.get("TOT").equals("0")){%><%= ht.get("TOT")%><%}%></TD>
<%}%>
<%}else{%>							
					<TD align='center'></TD>
					<TD align='center'></TD>
					<TD align='center'></TD>
					<TD align='center'></TD>
					<TD align='center'></TD>
					<TD align='center'></TD>
					<TD align='center'></TD>
<%}%>
<% if(vt131n.size()>0){ %>					
<%
	for(int i=0; i< vt131n.size(); i++){
	Hashtable ht = (Hashtable)vt131n.elementAt(i);
	aan+=AddUtil.parseLong(String.valueOf(ht.get("AA")));
	bb3n+=AddUtil.parseLong(String.valueOf(ht.get("BB3")));
	bb2n+=AddUtil.parseLong(String.valueOf(ht.get("BB2")));
	ffn+=AddUtil.parseLong(String.valueOf(ht.get("FF")));
	%>						
					<TD align='center'><%if(!ht.get("BB3").equals("0")){%><a href="javascript:view_cont('0013','53','<%=st_year%>','<%=st_mon%>','N')" onMouseOver="window.status=''; return true"><%= ht.get("BB3")%></a><%}%></TD>
					<TD align='center'><%if(!ht.get("BB2").equals("0")){%><a href="javascript:view_cont('0013','52','<%=st_year%>','<%=st_mon%>','N')" onMouseOver="window.status=''; return true"><%= ht.get("BB2")%></a><%}%></TD>
					<TD align='center'><%if(!ht.get("AA").equals("0")){%><a href="javascript:view_cont('0013','3','<%=st_year%>','<%=st_mon%>','N')" onMouseOver="window.status=''; return true"><%= ht.get("AA")%></a><%}%></TD>
					<TD align='center'><%if(!ht.get("FF").equals("0")){%><a href="javascript:view_cont('0013','8','<%=st_year%>','<%=st_mon%>','N')" onMouseOver="window.status=''; return true"><%= ht.get("FF")%></a><%}%></TD>
					<TD align='center'><%if(!ht.get("TOT").equals("0")){%><%= ht.get("TOT")%><%}%></TD>
<%}%>


<%}else{%>							
					<TD align='center'></TD>
					<TD align='center'></TD>
					<TD align='center'></TD>
					<TD align='center'></TD>
					<TD align='center'></TD>
<%}%>
				</TR>
				<TR>
					<TD class='title' width='8%'>강서지점</TD>
	<% if(vt141.size()>0){ %>
	<%for(int i=0; i< vt141.size(); i++){
	Hashtable ht = (Hashtable)vt141.elementAt(i);
	aa+=AddUtil.parseLong(String.valueOf(ht.get("AA")));
	cc+=AddUtil.parseLong(String.valueOf(ht.get("CC")));
	ee+=AddUtil.parseLong(String.valueOf(ht.get("EE")));
	dd+=AddUtil.parseLong(String.valueOf(ht.get("DD")));
	bb1+=AddUtil.parseLong(String.valueOf(ht.get("BB1")));
	bb2+=AddUtil.parseLong(String.valueOf(ht.get("BB2")));
	%>						
					<TD align='center'><%if(!ht.get("AA").equals("0")){%><a href="javascript:view_cont('0014','3','<%=st_year%>','<%=st_mon%>','Y')" onMouseOver="window.status=''; return true"><%= ht.get("AA")%></a><%}%></TD>
					<TD align='center'><%if(!ht.get("CC").equals("0")){%><a href="javascript:view_cont('0014','6','<%=st_year%>','<%=st_mon%>','Y')" onMouseOver="window.status=''; return true"><%= ht.get("CC")%></a><%}%></TD>
					<TD align='center'><%if(!ht.get("EE").equals("0")){%><a href="javascript:view_cont('0014','9','<%=st_year%>','<%=st_mon%>','Y')" onMouseOver="window.status=''; return true"><%= ht.get("EE")%></a><%}%></TD>
					<TD align='center'><%if(!ht.get("DD").equals("0")){%><a href="javascript:view_cont('0014','7','<%=st_year%>','<%=st_mon%>','Y')" onMouseOver="window.status=''; return true"><%= ht.get("DD")%></a><%}%></TD>
					<TD align='center'><%if(!ht.get("BB1").equals("0")){%><a href="javascript:view_cont('0014','51','<%=st_year%>','<%=st_mon%>','Y')" onMouseOver="window.status=''; return true"><%= ht.get("BB1")%></a><%}%></TD>
					<TD align='center'><%if(!ht.get("BB2").equals("0")){%><a href="javascript:view_cont('0014','52','<%=st_year%>','<%=st_mon%>','Y')" onMouseOver="window.status=''; return true"><%= ht.get("BB2")%></a><%}%></TD>					
					<TD align='center'><%if(!ht.get("TOT").equals("0")){%><%= ht.get("TOT")%><%}%></TD>
<%}%>
<%}else{%>							
					<TD align='center'></TD>
					<TD align='center'></TD>
					<TD align='center'></TD>
					<TD align='center'></TD>
					<TD align='center'></TD>
					<TD align='center'></TD>
					<TD align='center'></TD>
<%}%>
<% if(vt141n.size()>0){ %>					
<%
	for(int i=0; i< vt141n.size(); i++){
	Hashtable ht = (Hashtable)vt141n.elementAt(i);
	aan+=AddUtil.parseLong(String.valueOf(ht.get("AA")));
	bb3n+=AddUtil.parseLong(String.valueOf(ht.get("BB3")));
	bb2n+=AddUtil.parseLong(String.valueOf(ht.get("BB2")));
	ffn+=AddUtil.parseLong(String.valueOf(ht.get("FF")));
	%>						
					<TD align='center'><%if(!ht.get("BB3").equals("0")){%><a href="javascript:view_cont('0014','53','<%=st_year%>','<%=st_mon%>','N')" onMouseOver="window.status=''; return true"><%= ht.get("BB3")%></a><%}%></TD>
					<TD align='center'><%if(!ht.get("BB2").equals("0")){%><a href="javascript:view_cont('0014','52','<%=st_year%>','<%=st_mon%>','N')" onMouseOver="window.status=''; return true"><%= ht.get("BB2")%></a><%}%></TD>
					<TD align='center'><%if(!ht.get("AA").equals("0")){%><a href="javascript:view_cont('0014','3','<%=st_year%>','<%=st_mon%>','N')" onMouseOver="window.status=''; return true"><%= ht.get("AA")%></a><%}%></TD>
					<TD align='center'><%if(!ht.get("FF").equals("0")){%><a href="javascript:view_cont('0014','8','<%=st_year%>','<%=st_mon%>','N')" onMouseOver="window.status=''; return true"><%= ht.get("FF")%></a><%}%></TD>
					<TD align='center'><%if(!ht.get("TOT").equals("0")){%><%= ht.get("TOT")%><%}%></TD>
<%}%>


<%}else{%>							
					<TD align='center'></TD>
					<TD align='center'></TD>
					<TD align='center'></TD>
					<TD align='center'></TD>
					<TD align='center'></TD>
<%}%>
				</TR>
				<TR>
					<TD class='title' width='8%'>구로지점</TD>
	<% if(vt151.size()>0){ %>
	<%for(int i=0; i< vt151.size(); i++){
	Hashtable ht = (Hashtable)vt151.elementAt(i);
	aa+=AddUtil.parseLong(String.valueOf(ht.get("AA")));
	cc+=AddUtil.parseLong(String.valueOf(ht.get("CC")));
	ee+=AddUtil.parseLong(String.valueOf(ht.get("EE")));
	dd+=AddUtil.parseLong(String.valueOf(ht.get("DD")));
	bb1+=AddUtil.parseLong(String.valueOf(ht.get("BB1")));
	bb2+=AddUtil.parseLong(String.valueOf(ht.get("BB2")));
	%>						
					<TD align='center'><%if(!ht.get("AA").equals("0")){%><a href="javascript:view_cont('0015','3','<%=st_year%>','<%=st_mon%>','Y')" onMouseOver="window.status=''; return true"><%= ht.get("AA")%></a><%}%></TD>
					<TD align='center'><%if(!ht.get("CC").equals("0")){%><a href="javascript:view_cont('0015','6','<%=st_year%>','<%=st_mon%>','Y')" onMouseOver="window.status=''; return true"><%= ht.get("CC")%></a><%}%></TD>
					<TD align='center'><%if(!ht.get("EE").equals("0")){%><a href="javascript:view_cont('0015','9','<%=st_year%>','<%=st_mon%>','Y')" onMouseOver="window.status=''; return true"><%= ht.get("EE")%></a><%}%></TD>
					<TD align='center'><%if(!ht.get("DD").equals("0")){%><a href="javascript:view_cont('0015','7','<%=st_year%>','<%=st_mon%>','Y')" onMouseOver="window.status=''; return true"><%= ht.get("DD")%></a><%}%></TD>
					<TD align='center'><%if(!ht.get("BB1").equals("0")){%><a href="javascript:view_cont('0015','51','<%=st_year%>','<%=st_mon%>','Y')" onMouseOver="window.status=''; return true"><%= ht.get("BB1")%></a><%}%></TD>
					<TD align='center'><%if(!ht.get("BB2").equals("0")){%><a href="javascript:view_cont('0015','52','<%=st_year%>','<%=st_mon%>','Y')" onMouseOver="window.status=''; return true"><%= ht.get("BB2")%></a><%}%></TD>					
					<TD align='center'><%if(!ht.get("TOT").equals("0")){%><%= ht.get("TOT")%><%}%></TD>
<%}%>
<%}else{%>							
					<TD align='center'></TD>
					<TD align='center'></TD>
					<TD align='center'></TD>
					<TD align='center'></TD>
					<TD align='center'></TD>
					<TD align='center'></TD>
					<TD align='center'></TD>
<%}%>
<% if(vt151n.size()>0){ %>					
<%
	for(int i=0; i< vt151n.size(); i++){
	Hashtable ht = (Hashtable)vt151n.elementAt(i);
	aan+=AddUtil.parseLong(String.valueOf(ht.get("AA")));
	bb3n+=AddUtil.parseLong(String.valueOf(ht.get("BB3")));
	bb2n+=AddUtil.parseLong(String.valueOf(ht.get("BB2")));
	ffn+=AddUtil.parseLong(String.valueOf(ht.get("FF")));
	%>						
					<TD align='center'><%if(!ht.get("BB3").equals("0")){%><a href="javascript:view_cont('0015','53','<%=st_year%>','<%=st_mon%>','N')" onMouseOver="window.status=''; return true"><%= ht.get("BB3")%></a><%}%></TD>
					<TD align='center'><%if(!ht.get("BB2").equals("0")){%><a href="javascript:view_cont('0015','52','<%=st_year%>','<%=st_mon%>','N')" onMouseOver="window.status=''; return true"><%= ht.get("BB2")%></a><%}%></TD>
					<TD align='center'><%if(!ht.get("AA").equals("0")){%><a href="javascript:view_cont('0015','3','<%=st_year%>','<%=st_mon%>','N')" onMouseOver="window.status=''; return true"><%= ht.get("AA")%></a><%}%></TD>
					<TD align='center'><%if(!ht.get("FF").equals("0")){%><a href="javascript:view_cont('0015','8','<%=st_year%>','<%=st_mon%>','N')" onMouseOver="window.status=''; return true"><%= ht.get("FF")%></a><%}%></TD>
					<TD align='center'><%if(!ht.get("TOT").equals("0")){%><%= ht.get("TOT")%><%}%></TD>
<%}%>


<%}else{%>							
					<TD align='center'></TD>
					<TD align='center'></TD>
					<TD align='center'></TD>
					<TD align='center'></TD>
					<TD align='center'></TD>
<%}%>
				</TR>
				<TR>
					<TD class='title' width='8%'>광화문지점</TD>
	<% if(vt171.size()>0){ %>
	<%for(int i=0; i< vt171.size(); i++){
	Hashtable ht = (Hashtable)vt171.elementAt(i);
	aa+=AddUtil.parseLong(String.valueOf(ht.get("AA")));
	cc+=AddUtil.parseLong(String.valueOf(ht.get("CC")));
	ee+=AddUtil.parseLong(String.valueOf(ht.get("EE")));
	dd+=AddUtil.parseLong(String.valueOf(ht.get("DD")));
	bb1+=AddUtil.parseLong(String.valueOf(ht.get("BB1")));
	bb2+=AddUtil.parseLong(String.valueOf(ht.get("BB2")));
	%>						
					<TD align='center'><%if(!ht.get("AA").equals("0")){%><a href="javascript:view_cont('0017','3','<%=st_year%>','<%=st_mon%>','Y')" onMouseOver="window.status=''; return true"><%= ht.get("AA")%></a><%}%></TD>
					<TD align='center'><%if(!ht.get("CC").equals("0")){%><a href="javascript:view_cont('0017','6','<%=st_year%>','<%=st_mon%>','Y')" onMouseOver="window.status=''; return true"><%= ht.get("CC")%></a><%}%></TD>
					<TD align='center'><%if(!ht.get("EE").equals("0")){%><a href="javascript:view_cont('0017','9','<%=st_year%>','<%=st_mon%>','Y')" onMouseOver="window.status=''; return true"><%= ht.get("EE")%></a><%}%></TD>
					<TD align='center'><%if(!ht.get("DD").equals("0")){%><a href="javascript:view_cont('0017','7','<%=st_year%>','<%=st_mon%>','Y')" onMouseOver="window.status=''; return true"><%= ht.get("DD")%></a><%}%></TD>
					<TD align='center'><%if(!ht.get("BB1").equals("0")){%><a href="javascript:view_cont('0017','51','<%=st_year%>','<%=st_mon%>','Y')" onMouseOver="window.status=''; return true"><%= ht.get("BB1")%></a><%}%></TD>
					<TD align='center'><%if(!ht.get("BB2").equals("0")){%><a href="javascript:view_cont('0017','52','<%=st_year%>','<%=st_mon%>','Y')" onMouseOver="window.status=''; return true"><%= ht.get("BB2")%></a><%}%></TD>					
					<TD align='center'><%if(!ht.get("TOT").equals("0")){%><%= ht.get("TOT")%><%}%></TD>
<%}%>
<%}else{%>							
					<TD align='center'></TD>
					<TD align='center'></TD>
					<TD align='center'></TD>
					<TD align='center'></TD>
					<TD align='center'></TD>
					<TD align='center'></TD>
					<TD align='center'></TD>
<%}%>
<% if(vt171n.size()>0){ %>					
<%
	for(int i=0; i< vt171n.size(); i++){
	Hashtable ht = (Hashtable)vt171n.elementAt(i);
	aan+=AddUtil.parseLong(String.valueOf(ht.get("AA")));
	bb3n+=AddUtil.parseLong(String.valueOf(ht.get("BB3")));
	bb2n+=AddUtil.parseLong(String.valueOf(ht.get("BB2")));
	ffn+=AddUtil.parseLong(String.valueOf(ht.get("FF")));
	%>						
					<TD align='center'><%if(!ht.get("BB3").equals("0")){%><a href="javascript:view_cont('0017','53','<%=st_year%>','<%=st_mon%>','N')" onMouseOver="window.status=''; return true"><%= ht.get("BB3")%></a><%}%></TD>
					<TD align='center'><%if(!ht.get("BB2").equals("0")){%><a href="javascript:view_cont('0017','52','<%=st_year%>','<%=st_mon%>','N')" onMouseOver="window.status=''; return true"><%= ht.get("BB2")%></a><%}%></TD>
					<TD align='center'><%if(!ht.get("AA").equals("0")){%><a href="javascript:view_cont('0017','3','<%=st_year%>','<%=st_mon%>','N')" onMouseOver="window.status=''; return true"><%= ht.get("AA")%></a><%}%></TD>
					<TD align='center'><%if(!ht.get("FF").equals("0")){%><a href="javascript:view_cont('0017','8','<%=st_year%>','<%=st_mon%>','N')" onMouseOver="window.status=''; return true"><%= ht.get("FF")%></a><%}%></TD>
					<TD align='center'><%if(!ht.get("TOT").equals("0")){%><%= ht.get("TOT")%><%}%></TD>
<%}%>


<%}else{%>							
					<TD align='center'></TD>
					<TD align='center'></TD>
					<TD align='center'></TD>
					<TD align='center'></TD>
					<TD align='center'></TD>
<%}%>
				</TR>
				<TR>
					<TD class='title' width='8%'>송파지점</TD>
	<% if(vt181.size()>0){ %>
	<%for(int i=0; i< vt181.size(); i++){
	Hashtable ht = (Hashtable)vt181.elementAt(i);
	aa+=AddUtil.parseLong(String.valueOf(ht.get("AA")));
	cc+=AddUtil.parseLong(String.valueOf(ht.get("CC")));
	ee+=AddUtil.parseLong(String.valueOf(ht.get("EE")));
	dd+=AddUtil.parseLong(String.valueOf(ht.get("DD")));
	bb1+=AddUtil.parseLong(String.valueOf(ht.get("BB1")));
	bb2+=AddUtil.parseLong(String.valueOf(ht.get("BB2")));
	%>						
					<TD align='center'><%if(!ht.get("AA").equals("0")){%><a href="javascript:view_cont('0018','3','<%=st_year%>','<%=st_mon%>','Y')" onMouseOver="window.status=''; return true"><%= ht.get("AA")%></a><%}%></TD>
					<TD align='center'><%if(!ht.get("CC").equals("0")){%><a href="javascript:view_cont('0018','6','<%=st_year%>','<%=st_mon%>','Y')" onMouseOver="window.status=''; return true"><%= ht.get("CC")%></a><%}%></TD>
					<TD align='center'><%if(!ht.get("EE").equals("0")){%><a href="javascript:view_cont('0018','9','<%=st_year%>','<%=st_mon%>','Y')" onMouseOver="window.status=''; return true"><%= ht.get("EE")%></a><%}%></TD>
					<TD align='center'><%if(!ht.get("DD").equals("0")){%><a href="javascript:view_cont('0018','7','<%=st_year%>','<%=st_mon%>','Y')" onMouseOver="window.status=''; return true"><%= ht.get("DD")%></a><%}%></TD>
					<TD align='center'><%if(!ht.get("BB1").equals("0")){%><a href="javascript:view_cont('0018','51','<%=st_year%>','<%=st_mon%>','Y')" onMouseOver="window.status=''; return true"><%= ht.get("BB1")%></a><%}%></TD>
					<TD align='center'><%if(!ht.get("BB2").equals("0")){%><a href="javascript:view_cont('0018','52','<%=st_year%>','<%=st_mon%>','Y')" onMouseOver="window.status=''; return true"><%= ht.get("BB2")%></a><%}%></TD>					
					<TD align='center'><%if(!ht.get("TOT").equals("0")){%><%= ht.get("TOT")%><%}%></TD>
<%}%>
<%}else{%>							
					<TD align='center'></TD>
					<TD align='center'></TD>
					<TD align='center'></TD>
					<TD align='center'></TD>
					<TD align='center'></TD>
					<TD align='center'></TD>
					<TD align='center'></TD>
<%}%>
<% if(vt181n.size()>0){ %>					
<%
	for(int i=0; i< vt181n.size(); i++){
	Hashtable ht = (Hashtable)vt181n.elementAt(i);
	aan+=AddUtil.parseLong(String.valueOf(ht.get("AA")));
	bb3n+=AddUtil.parseLong(String.valueOf(ht.get("BB3")));
	bb2n+=AddUtil.parseLong(String.valueOf(ht.get("BB2")));
	ffn+=AddUtil.parseLong(String.valueOf(ht.get("FF")));
	%>						
					<TD align='center'><%if(!ht.get("BB3").equals("0")){%><a href="javascript:view_cont('0018','53','<%=st_year%>','<%=st_mon%>','N')" onMouseOver="window.status=''; return true"><%= ht.get("BB3")%></a><%}%></TD>
					<TD align='center'><%if(!ht.get("BB2").equals("0")){%><a href="javascript:view_cont('0018','52','<%=st_year%>','<%=st_mon%>','N')" onMouseOver="window.status=''; return true"><%= ht.get("BB2")%></a><%}%></TD>
					<TD align='center'><%if(!ht.get("AA").equals("0")){%><a href="javascript:view_cont('0018','3','<%=st_year%>','<%=st_mon%>','N')" onMouseOver="window.status=''; return true"><%= ht.get("AA")%></a><%}%></TD>
					<TD align='center'><%if(!ht.get("FF").equals("0")){%><a href="javascript:view_cont('0018','8','<%=st_year%>','<%=st_mon%>','N')" onMouseOver="window.status=''; return true"><%= ht.get("FF")%></a><%}%></TD>
					<TD align='center'><%if(!ht.get("TOT").equals("0")){%><%= ht.get("TOT")%><%}%></TD>
<%}%>


<%}else{%>							
					<TD align='center'></TD>
					<TD align='center'></TD>
					<TD align='center'></TD>
					<TD align='center'></TD>
					<TD align='center'></TD>
<%}%>
				</TR>
<%
	toty = aa+cc+ee+dd+bb1+bb2;
	totn = aan+bb2n+bb3n+ffn;
%>				
				<TR>
					<TD class='title' width='8%'>합계</TD>
					<TD align='center'><%=aa%></TD>
					<TD align='center'><%=cc%></TD>
					<TD align='center'><%=ee%></TD>
					<TD align='center'><%=dd%></TD>
					<TD align='center'><%=bb1%></TD>
					<TD align='center'><%=bb2%></TD>
					<TD align='center'><%=toty%></TD>
					<TD align='center'><%=bb3n%></TD>
					<TD align='center'><%=bb2n%></TD>
					<TD align='center'><%=aan%></TD>
					<TD align='center'><%=ffn%></TD>
					<TD align='center'><%=totn%></TD>
				</TR>
			</table>
		</td>
	</tr>
</TABLE>	
</form>
<iframe src="about:blank" name="i_no" width="0" height="0" cellpadding="0" cellspacing="0" border="1" frameborder="0" noresize ></iframe>
</body>
</html>

