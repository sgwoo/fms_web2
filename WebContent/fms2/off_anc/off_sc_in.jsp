<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.off_anc.*" %>
<jsp:useBean id="a_bean" class="acar.off_anc.AncBean" scope="page"/>

<%@ include file="/acar/cookies.jsp" %>


<%
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String br_id 	= request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	
	String gubun 	= request.getParameter("gubun")==null?"c_year":request.getParameter("gubun");
	String gubun1 	= request.getParameter("gubun1")==null?"9":request.getParameter("gubun1");
	String gubun_nm = request.getParameter("gubun_nm")==null?"":request.getParameter("gubun_nm");
	
	String comst 	= request.getParameter("comst") ==null?"":request.getParameter("comst");
	int count = 0;
		
	OffAncDatabase oad = OffAncDatabase.getInstance();
	//gubun_nm = java.net.URLDecoder.decode((String)request.getParameter("gubun_nm"),"utf-8"); 	
	AncBean a_r [] = oad.getOff_AncAll( gubun,  gubun_nm,  gubun1,  ck_acar_id);
%>

<html>
<head>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<title>FMS</title>
<link rel="stylesheet" type="text/css" href="/include/table_t.css">
<%@ include file="/acar/getNaviCookies.jsp" %>
<script language="JavaScript">
<!--
	function AncReg(){
		var SUBWIN="/acar/off_anc/anc_i.jsp";	
		window.open(SUBWIN, "AncReg", "left=100, top=100, width=1024, height=800, scrollbars=no");
	}

	function AncDisp(bbs_id){
		var SUBWIN="/acar/off_anc/anc_c.jsp?bbs_id=" + bbs_id;	
		window.open(SUBWIN, "AncDisp", "left=100, top=100, width=1024, height=800, scrollbars=yes");
	}
//-->
</script>
</head>
<body>

<table border=0 cellspacing=0 cellpadding=0 width=100%>
    <tr>
        <td class=line2>
            <table border=0 cellspacing=1 width=100%>
            
<%	
if(a_r.length > 0){
	
	    for(int i=0; i<a_r.length; i++){
    	    a_bean = a_r[i];
			String r_ch = a_bean.getRead_chk();
			String u_ch = a_bean.getUse_chk();
			
			if(ck_acar_id.equals(a_bean.getUser_id()) || ck_acar_id.equals("000003")){  // ???? ???????? ?? ?????? ?????? ???????? ?? ?????? ???? ????????.

%>
            	<tr>
					

            		<td <%if(u_ch.equals("N"))%>class='is2'<%%> width='6%' align="center"><%=i+1%></td>				
            		<td <%if(u_ch.equals("N"))%>class='is2'<%%> width='46%'>&nbsp;<a href="javascript:parent.AncDisp('<%=a_bean.getBbs_id()%>')" onMouseOver="window.status=''; return true"><%if(a_bean.getRead_yn().equals("Y")){%><img src="/images/n_icon.gif" border=0 align=absmiddle>&nbsp;<%}%>
					
					<%--//???????? ???? ???? ???? ????/????????/??????/????????????(??) ???????? ????%>
							<%if(a_bean.getBbs_st().equals("1")){%>
							<font color="#009c9c">[????????]</font>
							<%}else if(a_bean.getBbs_st().equals("2")){%>
							<font color="#009c9c">[????????]</font>
							<%}else if(a_bean.getBbs_st().equals("3")){%>
							<font color="#009c9c">[????????]</font>
							<%}else if(a_bean.getBbs_st().equals("4")){%>
							<font color="#009c9c">[????????]</font>
							<%}else if(a_bean.getBbs_st().equals("5")){%>
							<font color="#009c9c">[??????]</font>
							<%}else if(a_bean.getBbs_st().equals("6")){%>
							<font color="#009c9c">[??????????]</font>
							<%}--%>

					<%if(r_ch.equals("1")){%><font color="#303030" ><%}else{%><font color="blue" ><%}%>
					<%=a_bean.getTitle()%></font>
					<%if(a_bean.getReg_dt().equals(AddUtil.getDate())){ %>&nbsp;<font color="Fuchsia" size="1"><b>New</b></font><%}%></a></td>
            		<td <%if(u_ch.equals("N"))%>class='is2'<%%> width='10%' align="center"><%=a_bean.getUser_nm()%></td>
            		<td <%if(u_ch.equals("N"))%>class='is2'<%%> width='10%' align="center"><%=a_bean.getDept_nm()%></td>
            		<td <%if(u_ch.equals("N"))%>class='is2'<%%> width='11%' align="center"><%=a_bean.getReg_dt()%></td>
            		<td <%if(u_ch.equals("N"))%>class='is2'<%%> width='11%' align="center"><%=a_bean.getExp_dt()%></td>
            		<td <%if(u_ch.equals("N"))%>class='is2'<%%> width='6%' align="center"><%=a_bean.getComment_cnt()%></td>					
            	</tr>
<%}else{ 
	if(a_bean.getBbs_st().equals("6") && !a_bean.getComst().equals("Y"))
		continue;

%>
            	<tr>

            		<td <%if(u_ch.equals("N"))%>class='is2'<%%> width='6%' align="center"><%=i+1%></td>				
            		<td <%if(u_ch.equals("N"))%>class='is2'<%%> width='46%'>&nbsp;<a href="javascript:parent.AncDisp('<%=a_bean.getBbs_id()%>')" onMouseOver="window.status=''; return true"><%if(a_bean.getRead_yn().equals("Y")){%><img src="/images/n_icon.gif" border=0 align=absmiddle>&nbsp;<%}%><font color="#666666">   

					<%--//???????? ???? ???? ???? ????/????????/??????/????????????(??) ???????? ????%>
							<%if(a_bean.getBbs_st().equals("1")){%>
							<font color="#009c9c">[????????]</font>
							<%}else if(a_bean.getBbs_st().equals("2")){%>
							<font color="#009c9c">[????????]</font>
							<%}else if(a_bean.getBbs_st().equals("3")){%>
							<font color="#009c9c">[????????]</font>
							<%}else if(a_bean.getBbs_st().equals("4")){%>
							<font color="#009c9c">[????????]</font>
							<%}else if(a_bean.getBbs_st().equals("5")){%>
							<font color="#009c9c">[??????]</font>
							<%}else if(a_bean.getBbs_st().equals("6")){%>
							<font color="#009c9c">[??????????]</font>
							<%}--%>
					
					<%=a_bean.getTitle()%></font>
					<%if(a_bean.getReg_dt().equals(AddUtil.getDate())){ %>&nbsp;<font color="Fuchsia" size="1"><b>New</b></font><%}%></a></td>
            	<td <%if(u_ch.equals("N"))%>class='is2'<%%> width='10%' align="center"><%=a_bean.getUser_nm()%></td>
            		<td <%if(u_ch.equals("N"))%>class='is2'<%%> width='10%' align="center"><%=a_bean.getDept_nm()%></td>
            		<td <%if(u_ch.equals("N"))%>class='is2'<%%> width='11%' align="center"><%=a_bean.getReg_dt()%></td>
            		<td <%if(u_ch.equals("N"))%>class='is2'<%%> width='11%' align="center"><%=a_bean.getExp_dt()%></td>
            		<td <%if(u_ch.equals("N"))%>class='is2'<%%> width='6%' align="center"><%=a_bean.getComment_cnt()%></td>									
            	</tr>
<%}%>
				
<%  } } else {%>
 	
            <tr>
                <td colspan=10 align=center height=25>?????? ???????? ????????.</td>
            </tr>
<%}%>

            </table>
        </td>
    </tr>
</table>
</body>
</html>