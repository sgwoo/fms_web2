<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*"%>
<%@ page import="acar.cooperation.*"%>
<jsp:useBean id="cp_db" scope="page" class="acar.cooperation.CooperationDatabase"/>

<%
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String br_id 	= request.getParameter("br_id")==null?"":request.getParameter("br_id");
	
	String s_year 	= request.getParameter("s_year")==null?"":request.getParameter("s_year");
	String s_mon 	= request.getParameter("s_mon")==null?"":request.getParameter("s_mon");
	String s_kd 	= request.getParameter("s_kd")==null?"":request.getParameter("s_kd");
	String t_wd 	= request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String gubun1 	= request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String gubun2 	= request.getParameter("gubun2")==null?"":request.getParameter("gubun2");
	String gubun3 	= request.getParameter("gubun3")==null?"":request.getParameter("gubun3");
	String gubun4 	= request.getParameter("gubun4")==null?"":request.getParameter("gubun4");
	
	Vector vt = cp_db.CooperationN3List(s_year, s_mon, "", s_kd, t_wd, gubun1, gubun2, gubun3, gubun4);
	int vt_size = vt.size();
	
	
%>
<html>
<head>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<title>FMS</title>
<link rel='stylesheet' type='text/css' href='/include/table_t.css'>
<script language="JavaScript">
function addr_ask_appl_com(seq, in_id){
/* 	var fm = document.form1;	
	 window.open("" ,"form1", 
     "toolbar=no, width=800, height=930, directories=no, status=no,    scrollorbars=no, resizable=no"); 
	fm.action = "addr_ask_appl_com.jsp";
	//fm.target = "_blank";
	fm.target = "form1";
	fm.method="post";
	fm.submit();	 */
	
	var url = 'addr_ask_appl_com.jsp?seq='+seq+'&in_id='+in_id;
	var specs = "left=10,top=10,width=572,height=166";
	specs += ",toolbar=no,menubar=no,status=no,scrollbars=no,resizable=no";
	window.open(url, "popup", specs);

}	
function addr_ask_appl_del(seq, in_id){
	
	var url = 'addr_ask_appl_del.jsp?seq='+seq+'&in_id='+in_id;
	var specs = "left=10,top=10,width=572,height=166";
	specs += ",toolbar=no,menubar=no,status=no,scrollbars=no,resizable=no";
	window.open(url, "popup", specs);

}	
</script>
</head>

<body>
<form name='form1' action='' method="POST">

<table border=0 cellspacing=0 cellpadding=0 width='100%'>
    <tr>
        <td class=line2></td>
    </tr>
    <tr>
        <td class='line'>
            <table border=0 cellspacing=1 cellpadding=0 width='100%'>
				<tr>
					<td width='5%' class='title'> 연번 </td>
					<td width='10%' class='title'> 요청일자 </td>
					<td width='10%' class='title'> 요청자 </td>
					<td width='40%' class='title'> 제목 </td>
					<td width='10%' class='title'> 협조부서 팀장 </td>
					<td width='10%' class='title'> 처리담당자 </td>
					<td width='15%' class='title'> 처리일자 </td>
				</tr>
<% if(vt.size()>0){
	for(int i=0; i< vt.size(); i++){
	Hashtable ht = (Hashtable)vt.elementAt(i);
	%>
				<input type="hidden" name="seq" value="<%=ht.get("SEQ")%>" />
				<tr>
					<td width='5%'  align='center'><%=(i+1)%></td>
					<td width='10%' align='center'><%= AddUtil.ChangeDate2((String)ht.get("IN_DT")) %></td>
					<td width='10%' align='center'><%=ht.get("USER_NM")%></td>
					<td width='40%'>&nbsp;<a href="javascript:parent.view_content('<%=String.valueOf(ht.get("TITLE")).substring(11,25)%>','<%=String.valueOf(ht.get("SEQ"))%>')" onMouseOver="window.status=''; return true"><%=ht.get("TITLE")%></a></td>
					<td width='10%' align='center'><%if(ht.get("OUT_ID").equals("")){%>직접지정<%}else{%><%=ht.get("OUT_NM")%><%}%></td>
					<td width='10%' align='center'><%=ht.get("SUB_NM")%></td>
					<td width='15%' align='center'>
					<table width=100% border=0 cellspacing=0 cellpadding=5><tr><td align=center>
					<%if(ht.get("OUT_DT").equals("")){%>
						<a href="javascript:addr_ask_appl_com('<%=ht.get("SEQ")%>','<%=ht.get("IN_ID")%>')"><img src='/acar/images/center/button_in_reg.gif' border=0></a>
						<a href="javascript:addr_ask_appl_del('<%=ht.get("SEQ")%>','<%=ht.get("IN_ID")%>')"><img src='/acar/images/center/button_in_cp.gif' border=0></a>
					<%}else{%>
						<%if(ht.get("CLS_DT").equals("")){%>
							<%=ht.get("OUT_DT")%></td></tr>
						<%}else{%>
							[반려] <%=ht.get("CLS_DT")%></td></tr>						
						<%}%>
					<%}%>
					</table>
					</td>
				</tr>

			<%}
		}
	else
	{
%>
				<tr>
					<td colspan='8' align='center'>등록된 데이타가 없습니다</td>
				</tr>
<%
	}%>
            </table>
        </td>
    </tr>
    <tr>
        <td>* 미수금관리에서 [채권추심의뢰요청]을 하면 업무협조가 등록되어 미처리상태인 업무협조만 조회됩니다. 채권담당자는 영업담당자 변경후  처리완료일를 등록하여 주십시오.</td>
    </tr>	
</table>
</form>
</body>
</html>