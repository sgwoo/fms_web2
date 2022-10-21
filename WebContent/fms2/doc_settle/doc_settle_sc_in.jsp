<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*"%>
<%@ page import="acar.util.*, acar.user_mng.*"%>
<jsp:useBean id="d_db" scope="page" class="acar.doc_settle.DocSettleDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String br_id 	= request.getParameter("br_id")==null?"":request.getParameter("br_id");
	
	String s_kd 	= request.getParameter("s_kd")==null? "3":request.getParameter("s_kd");
	String t_wd 	= request.getParameter("t_wd")==null? "" :request.getParameter("t_wd");
	String andor 	= request.getParameter("andor")==null?"1":request.getParameter("andor");
	String gubun1 	= request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String gubun2 	= request.getParameter("gubun2")==null?"":request.getParameter("gubun2");
	String gubun3 	= request.getParameter("gubun3")==null?"":request.getParameter("gubun3");
	String start_dt = request.getParameter("start_dt")==null?"":request.getParameter("start_dt");
	String end_dt 	= request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	
	int sh_height = request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//상단길이
	
	int count =0;
	
	Vector vt = d_db.getDocSettleList(s_kd, t_wd, gubun1, gubun2, gubun3, start_dt, end_dt);
	int vt_size = vt.size();
	
	String valus = 	"?auth_rw="+auth_rw+"&user_id="+user_id+"&br_id="+br_id+
					"&s_kd="+s_kd+"&t_wd="+t_wd+"&andor="+andor+"&gubun1="+gubun1+"&gubun2="+gubun2+"&gubun3="+gubun3+"&start_dt="+start_dt+"&end_dt="+end_dt+
				   	"&sh_height="+sh_height+"";
				   	
	
%>

<html>
<head><title>FMS</title>
<script language='javascript'>
<!--
	/* Title 고정 */
	function setupEvents()
	{
			window.onscroll = moveTitle ;
			window.onresize = moveTitle ; 
	}
	
	function moveTitle()
	{
	    var X ;
	    document.all.tr_title.style.pixelTop = document.body.scrollTop ;
	    document.all.td_title.style.pixelLeft = document.body.scrollLeft ; 
	    document.all.td_con.style.pixelLeft	= document.body.scrollLeft ;   	    
	    
	}
	function init() {
		
		setupEvents();
	}
	
	//메신저발송
	function cool_msg_send(doc_no){
		var fm = document.form1;	
		var width 	= 600;
		var height 	= 400;		
		window.open("doc_cool_msg_send.jsp<%=valus%>&doc_no="+doc_no, "MSG_SEND", "left=10, top=10, width="+width+", height="+height+", scrollbars=yes, status=yes, resizable=yes");			
	}		
//-->
</script>
</head>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<body onLoad="javascript:init()">
<form action='' name="form1" method='post'>
  <input type='hidden' name='auth_rw' 	value='<%=auth_rw%>'>
  <input type='hidden' name='user_id' 	value='<%=user_id%>'>
  <input type='hidden' name='br_id' 	value='<%=br_id%>'>
  <input type='hidden' name='s_kd'  	value='<%=s_kd%>'>
  <input type='hidden' name='t_wd' 		value='<%=t_wd%>'>			
  <input type='hidden' name='andor'	 	value='<%=andor%>'>
  <input type='hidden' name='gubun1' 	value='<%=gubun1%>'>  
  <input type='hidden' name='gubun2' 	value='<%=gubun2%>'>    
  <input type='hidden' name='gubun3' 	value='<%=gubun3%>'>    
  <input type='hidden' name='start_dt' 	value='<%=start_dt%>'>    
  <input type='hidden' name='end_dt' 	value='<%=end_dt%>'>          
  <input type='hidden' name='sh_height' value='<%=sh_height%>'>
  <input type='hidden' name='doc_no' 	value=''>

<table border="0" cellspacing="0" cellpadding="0" width='1420'>
    <tr><td class=line2 colspan="2"></td></tr>
	<tr id='tr_title' style='position:relative;z-index:1'>
		<td class='line' width='520' id='td_title' style='position:relative;'>
			<table border="0" cellspacing="1" cellpadding="0" width='520'>
					<tr><td width='30' class='title'>연번</td>
		            <td width="30" class='title'>상태</td>
		            <td width="60" class='title'>메시지</td>					
		            <td width="100" class='title'>구분</td>					
					<td width='100' class='title'>문서번호</td>
        		    <td width='100' class='title'>고객</td>
        		    <td width='100' class='title'>차명</td>					
				</tr>
			</table>
		</td>
		<td class='line' width='900'>
			<table border="0" cellspacing="1" cellpadding="0" width='800'>
				<tr>
					<td width='900' class='title'>결재</td>					
				</tr>
			</table>
		</td>
	</tr>
<%
	if(vt_size > 0)
	{
%>
	<tr>
		<td class='line' width='520' id='td_con' style='position:relative;'>
			<table border="0" cellspacing="1" cellpadding="0" width='100%'>
<%
		for(int i = 0 ; i < vt_size ; i++)
		{
			Hashtable ht = (Hashtable)vt.elementAt(i);
%>
				<tr>
					<td  width='30' align='center'><%=i+1%></td>
					<td  width='30' align='center'>&nbsp;<br><%=ht.get("DOC_STEP_NM")%><br><br>&nbsp;</td>
					<td  width='60' align='center'><%if(String.valueOf(ht.get("DOC_STEP_NM")).equals("미결")){ %>
					<a href="javascript:cool_msg_send('<%=ht.get("DOC_NO")%>');"><img src="/acar/images/center/button_in_msg.gif" border="0" align=absmiddle></a>
					<%}%></td>					
					<td  width='100' align='center'>&nbsp;<br><%=ht.get("DOC_ST_NM")%><br><br>&nbsp;</td>
					<td  width='100' align='center'>					
					<% if(ht.get("DOC_ST").equals("8")){%>	
						<a href="javascript:parent.view_doc2('<%=ht.get("USER_ID1")%>','<%=ht.get("DOC_ID")%>','8')" onMouseOver="window.status=''; return true"><%=ht.get("DOC_NO")%></a>
					<%}else if(ht.get("DOC_ST").equals("9")) {%>	
						<a href="javascript:parent.view_doc2('<%=ht.get("USER_ID1")%>','<%=ht.get("DOC_ID")%>','9')" onMouseOver="window.status=''; return true"><%=ht.get("DOC_NO")%></a>	
					<%}else if(ht.get("DOC_ST").equals("21")) {%>	
						<a href="javascript:parent.view_doc2('<%=ht.get("USER_ID1")%>','<%=ht.get("DOC_ID")%>','21')" onMouseOver="window.status=''; return true"><%=ht.get("DOC_NO")%></a>
					<%}else if(ht.get("DOC_ST").equals("22")) {%>	
						<a href="javascript:parent.view_doc2('<%=ht.get("USER_ID1")%>','<%=ht.get("DOC_ID")%>','22')" onMouseOver="window.status=''; return true"><%=ht.get("DOC_NO")%></a>	
					<%}else{%>
						<a href="javascript:parent.view_doc('<%=ht.get("DOC_NO")%>','<%=ht.get("DOC_ST")%>','<%=ht.get("DOC_ID")%>','<%=ht.get("RENT_MNG_ID")%>','<%=ht.get("RENT_L_CD")%>','<%=ht.get("DOC_BIT")%>')" onMouseOver="window.status=''; return true"><%=ht.get("DOC_NO")%></a>
					<%}%>										
					</td>
					<td  width='100'>&nbsp;<span title='<%=ht.get("FIRM_NM")%>'><%=Util.subData(String.valueOf(ht.get("FIRM_NM")), 6)%></span></td>
					<td  width='100'>&nbsp;<span title='<%=ht.get("CAR_NM")%>'><%=Util.subData(String.valueOf(ht.get("CAR_NM")), 6)%></span>
					</td>					
				</tr>
<%
		}
%>
			</table>
		</td>
		<td class='line' width='900'>
			<table border="0" cellspacing="1" cellpadding="0" width='100%'>
<%
		for(int i = 0 ; i < vt_size ; i++)
		{
			Hashtable ht = (Hashtable)vt.elementAt(i);
%>			
				<tr>
					<td  width='90' align='center'><span style="text-decoration:underline"><%=ht.get("USER_NM1")%> </span><br><font color=green><%=ht.get("NM1")%></font> &nbsp;<br><%=ht.get("USER_DT1")%>&nbsp; <%if(String.valueOf(ht.get("USER_DT1")).equals("")){%><br>&nbsp;<%}%></td>
					<td  width='90' align='center'><span style="text-decoration:underline"><%=ht.get("USER_NM2")%> </span><br><font color=green><%=ht.get("NM2")%></font> &nbsp;<br><%=ht.get("USER_DT2")%>&nbsp; <%if(String.valueOf(ht.get("USER_DT2")).equals("")){%><br>&nbsp;<%}%></td>
					<td  width='90' align='center'><span style="text-decoration:underline"><%=ht.get("USER_NM3")%> </span><br><font color=green><%=ht.get("NM3")%></font> &nbsp;<br><%=ht.get("USER_DT3")%>&nbsp; <%if(String.valueOf(ht.get("USER_DT3")).equals("")){%><br>&nbsp;<%}%></td>
					<td  width='90' align='center'><span style="text-decoration:underline"><%=ht.get("USER_NM4")%> </span><br><font color=green><%=ht.get("NM4")%></font> &nbsp;<br><%=ht.get("USER_DT4")%>&nbsp; <%if(String.valueOf(ht.get("USER_DT4")).equals("")){%><br>&nbsp;<%}%></td>
					<td  width='90' align='center'><span style="text-decoration:underline"><%=ht.get("USER_NM5")%> </span><br><font color=green><%=ht.get("NM5")%></font> &nbsp;<br><%=ht.get("USER_DT5")%>&nbsp; <%if(String.valueOf(ht.get("USER_DT5")).equals("")){%><br>&nbsp;<%}%></td>
					<td  width='90' align='center'><span style="text-decoration:underline"><%=ht.get("USER_NM6")%> </span><br><font color=green><%=ht.get("NM6")%></font> &nbsp;<br><%=ht.get("USER_DT6")%>&nbsp; <%if(String.valueOf(ht.get("USER_DT6")).equals("")){%><br>&nbsp;<%}%></td>
					<td  width='90' align='center'><span style="text-decoration:underline"><%=ht.get("USER_NM7")%> </span><br><font color=green><%=ht.get("NM7")%></font> &nbsp;<br><%=ht.get("USER_DT7")%>&nbsp; <%if(String.valueOf(ht.get("USER_DT7")).equals("")){%><br>&nbsp;<%}%></td>
					<td  width='90' align='center'><span style="text-decoration:underline"><%=ht.get("USER_NM8")%> </span><br><font color=green><%=ht.get("NM8")%></font> &nbsp;<br><%=ht.get("USER_DT8")%>&nbsp; <%if(String.valueOf(ht.get("USER_DT8")).equals("")){%><br>&nbsp;<%}%></td>
					<td  width='90' align='center'><span style="text-decoration:underline"><%=ht.get("USER_NM9")%> </span><br><font color=green><%=ht.get("NM9")%></font> &nbsp;<br><%=ht.get("USER_DT9")%>&nbsp; <%if(String.valueOf(ht.get("USER_DT9")).equals("")){%><br>&nbsp;<%}%></td>
					<td  width='90' align='center'><span style="text-decoration:underline"><%=ht.get("USER_NM10")%></span><br><font color=green><%=ht.get("NM10")%></font>&nbsp;<br><%=ht.get("USER_DT10")%>&nbsp;<%if(String.valueOf(ht.get("USER_DT10")).equals("")){%><br>&nbsp;<%}%></td>
				</tr>
<%
		}
%>
			</table>
		</td>
<%	}                  
	else               
	{
%>                     
	<tr>
		<td class='line' width='37%' id='td_con' style='position:relative;'>
			<table border="0" cellspacing="1" cellpadding="0" width='100%'>
				<tr>
					<td align='center'>
					<%if(t_wd.equals("")){%>검색어를 입력하십시오.
					<%}else{%>등록된 데이타가 없습니다<%}%></td>
				</tr>
			</table>
		</td>
		<td class='line' width='63%'>
			<table border="0" cellspacing="1" cellpadding="0" width='100%'>
				<tr>
					<td>&nbsp;</td>
				</tr>
			</table>
		</td>
	</tr>
<%                     
	}                  
%>
</table>
<script language='javascript'>
<!--
	parent.document.form1.size.value = '<%=vt_size%>';
//-->
</script>
</body>
</html>
