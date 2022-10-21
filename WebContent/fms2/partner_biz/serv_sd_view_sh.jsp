<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.partner.*"%>
<%@ include file="/acar/cookies.jsp" %>
<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String off_type 	= request.getParameter("off_type")==null?"1":request.getParameter("off_type");
	String cmd 	= request.getParameter("cmd")==null?"":request.getParameter("cmd");
	String off_id 	= request.getParameter("off_id")==null?"":request.getParameter("off_id");
	
	//로그인사용자정보 가져오기
	LoginBean login = LoginBean.getInstance();
	String user_id = login.getCookieValue(request, "acar_id");
	
	Serv_EmpDatabase se_dt = Serv_EmpDatabase.getInstance();
	
	Vector vt = se_dt.getBCSD_List(off_id);
	int vt_size = vt.size();	
	
	Vector st = new Vector();
	int st_size = st.size();
%>
<html>
<head>

<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr" />
<link rel="stylesheet" type="text/css" href="/include/table_t.css"></link>
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css">
<script language='javascript' src='/include/common.js'></script>
<script src="//ajax.googleapis.com/ajax/libs/jquery/1.11.0/jquery.js"></script>
<script language="JavaScript">
<!--
	function kskbss_reg()	{
		var SUBWIN="sd_view_reg.jsp?off_id=<%=off_id%>&ck_acar_id=<%=ck_acar_id%>&s_width=<%=s_width%>&s_height=<%=s_height%>";	
		window.open(SUBWIN, "kskbss_reg", "left=100, top=50, width=650, height=350, scrollbars=yes");
	}
	
	function kskbss_go(off_id, serv_id){
		var fm = document.form1;
		fm.off_id.value = off_id;
		fm.serv_id.value = serv_id;
		fm.target = "c_foot";
		fm.action = "serv_sd_view_sc.jsp";
		fm.submit();
	}	
//-->
</script>
   
</head>
<body>
<div class="navigation">
	<span class=style1></span><span class=style5>상담현황</span>
</div>
<table border=0 cellspacing=0 cellpadding=0 width=100%>
    
	<tr>
        <td class=>○종결현황&nbsp;<input type="button" class="button" value="신규등록" onclick="kskbss_reg()"/></td>
    </tr>
    <tr>
        <td class=line2></td>
    </tr>
    <tr> 
        <td class=line> 
            <table border="0" cellspacing="1" width=100% >
				<tr>
					<td rowspan="2" width="7%" class="title">연번</td>
					<td rowspan="2" width="10%" class="title">구분</td>
					<td rowspan="2" width="13%" class="title">상담일자</td>
					<td colspan="2" width="30%" class="title">상담자</td>
					<td colspan="2" width="20%" class="title">상담내용</td>
					<td rowspan="2" width="20%" class="title">진행상황</td>
				</tr>
				<tr>
					<td width="15%" class="title">거래처</td>
					<td width="15%" class="title">당사</td>
					<td width="10%" class="title">금리</td>
					<td width="10%" class="title">한도</td>
				</tr>
				<% for(int i=0; i< vt_size; i++){
					Hashtable ht = (Hashtable)vt.elementAt(i);
				%>
				<tr>
					<td align="center"><%=i+1%></td>
					<td align="center">
					<%if(String.valueOf(ht.get("END_YN")).equals("Y")){%>
					종결
					<%}else{%>
				
					<%if(String.valueOf(ht.get("GUBUN")).equals("1")){%>방문
					<%}else if(String.valueOf(ht.get("GUBUN")).equals("2")){%>전화(수신)
					<%}else if(String.valueOf(ht.get("GUBUN")).equals("3")){%>전화(발신)
					<%}else if(String.valueOf(ht.get("GUBUN")).equals("4")){%>메일(수신)
					<%}else if(String.valueOf(ht.get("GUBUN")).equals("5")){%>메일(발신)
					<%}else if(String.valueOf(ht.get("GUBUN")).equals("6")){%>종결
					<%}%>
				
				<%}%>
					</td>
					<td align="center"><a href="javascript:kskbss_go('<%=ht.get("OFF_ID")%>','<%=ht.get("SERV_ID")%>')"><%=AddUtil.ChangeDate2(String.valueOf(ht.get("SD_DT")))%></a></td>
					<td align="center"><%=ht.get("G_SMNG1")%>
						<%if(!ht.get("G_SMNG2").equals("")){%>
						<br><%=ht.get("G_SMNG2")%>
						<%}else if(!ht.get("G_SMNG3").equals("")){%>
						<br><%=ht.get("G_SMNG3")%>
						<%}%>
					</td>
					<td align="center"><%=ht.get("D_SMNG1")%>
						<%if(!ht.get("D_SMNG2").equals("")){%>
						<br><%=ht.get("D_SMNG2")%>
						<%}else if(!ht.get("D_SMNG3").equals("")){%>
						<br><%=ht.get("D_SMNG3")%>
						<%}%>
					</td>
					<td align="center"><%=ht.get("ITEM1")%></td>
					<td align="center"><%=ht.get("ITEM2")%></td>
					<td align="center"><%=ht.get("NOTE")%></td>
				</tr>

				<%}%>
			</table>
		</td>
	</tr>
</table>

<form action="" name="form1" method="post" >
<input type="hidden" name="auth_rw" value="<%=auth_rw%>">
<input type="hidden" name="user_id" value="<%=user_id%>">
<input type="hidden" name="cmd" value="">
<input type='hidden' name='off_id' value=''> 
<input type='hidden' name='serv_id' value=''> 
</form>

<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize>
</iframe>
</body>
</html>