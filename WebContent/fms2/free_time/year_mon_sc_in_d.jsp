<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.free_time.* " %>
<jsp:useBean id="ft_db" scope="page" class="acar.free_time.Free_timeDatabase"/>
<%@ include file="/acar/cookies.jsp" %>


<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");

	String st_year = request.getParameter("st_year")==null?"":request.getParameter("st_year");	
	String st_mon = request.getParameter("st_mon")==null?"":request.getParameter("st_mon");	
	String dt = request.getParameter("dt")==null?"1":request.getParameter("dt");
	
	Vector vt = ft_db.getFreeTimeStat(dt, st_year, st_mon);
	int vt_size = vt.size();
	
	int[] t_cnt = new int[14*2];
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
	function view_cont(dept_id, gubun1, gubun2){
		var fm = document.form1;
		var url = "?dept_id="+dept_id+"&gubun1="+gubun1+"&gubun2="+gubun2+"&st_year=<%=st_year%>&st_mon=<%=st_mon%>&dt=<%=dt%>";
		var SUBWIN="year_mon_doc_list.jsp"+url;	
		window.open(SUBWIN, 'popwin_next','scrollbars=yes,status=yes,resizable=yes,width=900,height=600,top=200,left=200');
	}		
//-->
</script>
</head>
<body>
<form name='form1' action='' method='post'>
<TABLE border=0 cellSpacing=0 cellPadding=0 width='100%'>
	
	<tr>
		<td class='line2'></td>
	</tr>
	<tr>
		<td class='line'>
			<table border=0 cellspacing=1 cellpadding=0 width=100%>
				<TR>
					<TD rowSpan='2' colspan='2' class='title'>구분</TD>
					<TD colSpan='7' rowspan='1'class='title'>유급휴가</TD>
					<TD colSpan='5' rowspan='1'class='title'>무급휴가</TD>
					<TD rowSpan='2' class='title' width='6%'>재택근무</TD>
				</TR>
				<TR>
					<TD class='title' width='7%'>연차</TD>
					<TD class='title' width='7%'>경조휴가</TD>
					<TD class='title' width='7%'>포상휴가</TD>
					<TD class='title' width='7%'>공가</TD>
					<TD class='title' width='7%'>출산휴가</TD>
					<TD class='title' width='7%'>병가</TD>
					<TD class='title' width='7%'>합계</TD>
					<TD class='title' width='6%'>생리휴가</TD>
					<TD class='title' width='6%'>병가</TD>
					<TD class='title' width='6%'>무급휴가</TD>
					<TD class='title' width='6%'>휴직</TD>
					<TD class='title' width='6%'>합계</TD>
				</TR>
				<%if(vt_size>0){ %>
				<%	for(int i=0; i< vt_size; i++){
						Hashtable ht = (Hashtable)vt.elementAt(i);	
						
						for(int j=1; j<=13; j++){
							t_cnt[j] = t_cnt[j] + Util.parseInt(String.valueOf(ht.get("CNT"+j)));
						}	
						
						for(int j=1; j<=13; j++){
							t_cnt[13+j] = t_cnt[13+j] + Util.parseInt(String.valueOf(ht.get("CNT2_"+j)));
						}	
				%>
                <TR>
					<TD class='title' rowspan='2' width='10%'><%=ht.get("NM")%></TD>				
					<TD class='title' width='5%'>당일</TD>
					<TD align='center'><%if(!ht.get("CNT1").equals("0")){%><a href="javascript:view_cont('<%=ht.get("DEPT_ID")%>','1','1')" onMouseOver="window.status=''; return true"><%= ht.get("CNT1")%></a><%}%></TD>
					<TD align='center'><%if(!ht.get("CNT2").equals("0")){%><a href="javascript:view_cont('<%=ht.get("DEPT_ID")%>','1','2')" onMouseOver="window.status=''; return true"><%= ht.get("CNT2")%></a><%}%></TD>
					<TD align='center'><%if(!ht.get("CNT3").equals("0")){%><a href="javascript:view_cont('<%=ht.get("DEPT_ID")%>','1','3')" onMouseOver="window.status=''; return true"><%= ht.get("CNT3")%></a><%}%></TD>
					<TD align='center'><%if(!ht.get("CNT4").equals("0")){%><a href="javascript:view_cont('<%=ht.get("DEPT_ID")%>','1','4')" onMouseOver="window.status=''; return true"><%= ht.get("CNT4")%></a><%}%></TD>
					<TD align='center'><%if(!ht.get("CNT5").equals("0")){%><a href="javascript:view_cont('<%=ht.get("DEPT_ID")%>','1','5')" onMouseOver="window.status=''; return true"><%= ht.get("CNT5")%></a><%}%></TD>
					<TD align='center'><%if(!ht.get("CNT6").equals("0")){%><a href="javascript:view_cont('<%=ht.get("DEPT_ID")%>','1','6')" onMouseOver="window.status=''; return true"><%= ht.get("CNT6")%></a><%}%></TD>					
					<TD align='center'><%= ht.get("CNT7")%></TD>
					<TD align='center'><%if(!ht.get("CNT8").equals("0")){%><a href="javascript:view_cont('<%=ht.get("DEPT_ID")%>','1','8')" onMouseOver="window.status=''; return true"><%= ht.get("CNT8")%></a><%}%></TD>
					<TD align='center'><%if(!ht.get("CNT9").equals("0")){%><a href="javascript:view_cont('<%=ht.get("DEPT_ID")%>','1','9')" onMouseOver="window.status=''; return true"><%= ht.get("CNT9")%></a><%}%></TD>
					<TD align='center'><%if(!ht.get("CNT10").equals("0")){%><a href="javascript:view_cont('<%=ht.get("DEPT_ID")%>','1','10')" onMouseOver="window.status=''; return true"><%= ht.get("CNT10")%></a><%}%></TD>
					<TD align='center'><%if(!ht.get("CNT11").equals("0")){%><a href="javascript:view_cont('<%=ht.get("DEPT_ID")%>','1','11')" onMouseOver="window.status=''; return true"><%= ht.get("CNT11")%></a><%}%></TD>
					<TD align='center'><%= ht.get("CNT12")%></TD>					
					<TD align='center'><%= ht.get("CNT13")%></TD>
				</TR>	
                <TR>
					<TD class='title'>명일</TD>
					<TD align='center'><%if(!ht.get("CNT2_1").equals("0")){%><a href="javascript:view_cont('<%=ht.get("DEPT_ID")%>','2','1')" onMouseOver="window.status=''; return true"><%= ht.get("CNT2_1")%></a><%}%></TD>
					<TD align='center'><%if(!ht.get("CNT2_2").equals("0")){%><a href="javascript:view_cont('<%=ht.get("DEPT_ID")%>','2','2')" onMouseOver="window.status=''; return true"><%= ht.get("CNT2_2")%></a><%}%></TD>
					<TD align='center'><%if(!ht.get("CNT2_3").equals("0")){%><a href="javascript:view_cont('<%=ht.get("DEPT_ID")%>','2','3')" onMouseOver="window.status=''; return true"><%= ht.get("CNT2_3")%></a><%}%></TD>
					<TD align='center'><%if(!ht.get("CNT2_4").equals("0")){%><a href="javascript:view_cont('<%=ht.get("DEPT_ID")%>','2','4')" onMouseOver="window.status=''; return true"><%= ht.get("CNT2_4")%></a><%}%></TD>
					<TD align='center'><%if(!ht.get("CNT2_5").equals("0")){%><a href="javascript:view_cont('<%=ht.get("DEPT_ID")%>','2','5')" onMouseOver="window.status=''; return true"><%= ht.get("CNT2_5")%></a><%}%></TD>
					<TD align='center'><%if(!ht.get("CNT2_6").equals("0")){%><a href="javascript:view_cont('<%=ht.get("DEPT_ID")%>','2','6')" onMouseOver="window.status=''; return true"><%= ht.get("CNT2_6")%></a><%}%></TD>					
					<TD align='center'><%= ht.get("CNT2_7")%></TD>
					<TD align='center'><%if(!ht.get("CNT2_8").equals("0")){%><a href="javascript:view_cont('<%=ht.get("DEPT_ID")%>','2','8')" onMouseOver="window.status=''; return true"><%= ht.get("CNT2_8")%></a><%}%></TD>
					<TD align='center'><%if(!ht.get("CNT2_9").equals("0")){%><a href="javascript:view_cont('<%=ht.get("DEPT_ID")%>','2','9')" onMouseOver="window.status=''; return true"><%= ht.get("CNT2_9")%></a><%}%></TD>
					<TD align='center'><%if(!ht.get("CNT2_10").equals("0")){%><a href="javascript:view_cont('<%=ht.get("DEPT_ID")%>','2','10')" onMouseOver="window.status=''; return true"><%= ht.get("CNT2_10")%></a><%}%></TD>
					<TD align='center'><%if(!ht.get("CNT2_11").equals("0")){%><a href="javascript:view_cont('<%=ht.get("DEPT_ID")%>','2','11')" onMouseOver="window.status=''; return true"><%= ht.get("CNT2_11")%></a><%}%></TD>
					<TD align='center'><%= ht.get("CNT2_12")%></TD>					
					<TD align='center'><%= ht.get("CNT2_13")%></TD>
				</TR>							
				<%	}
				  }
				%>
                <TR>				
					<TD class='title' rowspan='2'>합계</TD>
					<TD class='title'>당일</TD>
					<%for(int j=1; j<=13; j++){%>						
					<TD align='center'><%=t_cnt[j]%></TD>
					<%}%>	
				</TR>	
                <TR>	
					<TD class='title'>명일</TD>
					<%for(int j=1; j<=13; j++){%>						
					<TD align='center'><%=t_cnt[13+j]%></TD>
					<%}%>					
				</TR>	
			</table>	
		</TD>				
	</TR>		
</TABLE>	
</form>
</body>
</html>