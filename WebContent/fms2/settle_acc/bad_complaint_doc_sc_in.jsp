<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*"%>
<%@ page import="acar.util.*, acar.user_mng.*, acar.inside_bank.*"%>
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
	
	int sh_height = request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//상단길이
	
	int count =0;
	
	
	MaMenuDatabase nm_db = MaMenuDatabase.getInstance();
	
	Vector vt = d_db.getBadComplaintDocList(s_kd, t_wd, gubun1);
	int vt_size = vt.size();
	

%>

<html>
<head><title>FMS</title>
<script language='javascript'>
<!--
// 	/* Title 고정 */
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
	
//-->
</script>
</head>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<%@ include file="/acar/getNaviCookies.jsp" %>
<body onLoad="javascript:init()">
  <table border="0" cellspacing="0" cellpadding="0" width='1340'>
    <tr>
        <td colspan="2" class=line2></td>
    </tr>  
	<tr id='tr_title' style='position:relative;z-index:1'>
		<td class='line' width='280' id='td_title' style='position:relative;'>
			<table border="0" cellspacing="1" cellpadding="0" width='100%'>
				<tr>
				    <td width='30' class='title' style='height:45'>연번</td>
				    <td width='50' class='title'>&nbsp;<br>구분<br>&nbsp;</td>
		                    <td width="200" class='title'>고객</td>
				</tr>
			</table>
		</td>
		<td class='line' width='1060'>
			<table border="0" cellspacing="1" cellpadding="0" width='100%'>
				<tr>
				  <td colspan="5" class='title'>결재</td>					
				  <td colspan="7" class='title'>고소장접수처리</td>
				</tr>
				<tr>
				  <td width='80' class='title'>기안일자</td>				
				  <td width='70' class='title'>기안자</td>
				  <td width='80' class='title'>고객지원팀장</td>
				  <td width='70' class='title'>고소장담당</td>
				  <td width='70' class='title'>총무팀장</td>				  
				  <td width='220' class='title'>요청사유</td>	
				  <td width='80' class='title'>진행구분</td>		  
				  <td width='80' class='title'>처리구분</td>
				  <td width='80' class='title'>접수일자</td>
				  <td width='80' class='title'>차량회수</td>				  
				  <td width='70' class='title'>접수경과월</td>				  
				  <td width='80' class='title'>기한부변경요청</td>
			        </tr>
			</table>
		</td>
	</tr>
<%
	if(vt_size > 0)
	{
%>
	<tr>
		<td class='line' width='280' id='td_con' style='position:relative;'>
			<table border="0" cellspacing="1" cellpadding="0" width='100%'>
<%
		for(int i = 0 ; i < vt_size ; i++)
		{
			Hashtable ht = (Hashtable)vt.elementAt(i);
%>
				<tr>
					<td  width='30' align='center'><%=i+1%></td>
					<td  width='50' align='center'><%=ht.get("BIT")%></td>					
					<td  width='200'>&nbsp;<span title='<%=ht.get("FIRM_NM")%>'><%=Util.subData(String.valueOf(ht.get("FIRM_NM")), 15)%></span></td>					
				</tr>
<%
		}
%>
			</table>
		</td>
		<td class='line' width='1060'>
			<table border="0" cellspacing="1" cellpadding="0" width='100%'>
<%
		for(int i = 0 ; i < vt_size ; i++)
		{
			Hashtable ht = (Hashtable)vt.elementAt(i);
%>			
				<tr>
                    <td width='80' align='center'><%=AddUtil.ChangeDate2(String.valueOf(ht.get("REG_DT")))%></td>					
					<td  width='70' align='center'>
					  <!--기안자-->
					 <a href="javascript:parent.doc_action('1', '<%=ht.get("CLIENT_ID")%>', '<%=ht.get("SEQ")%>', '<%=ht.get("DOC_NO")%>', '<%=ht.get("REQ_MON")%>');"><%=ht.get("USER_NM1")%></a>
					  </td>
					<td  width='80' align='center'>
					  <!--고객지원팀장-->
					  <%if(String.valueOf(ht.get("USER_DT4")).equals("")){%>
					  <%	if(String.valueOf(ht.get("USER_ID4")).equals(user_id) || nm_db.getWorkAuthUser("전산팀",user_id) || nm_db.getWorkAuthUser("본사관리팀장",user_id) ){%>
					  <a href="javascript:parent.doc_action('4', '<%=ht.get("CLIENT_ID")%>', '<%=ht.get("SEQ")%>', '<%=ht.get("DOC_NO")%>', '<%=ht.get("REQ_MON")%>');" onMouseOver="window.status=''; return true"><img src="/acar/images/center/button_in_gj.gif" align="absmiddle" border="0"></a>
					  <%	}else{%>-<%}%>
					  <%}else{%><a href="javascript:parent.doc_action('4', '<%=ht.get("CLIENT_ID")%>', '<%=ht.get("SEQ")%>', '<%=ht.get("DOC_NO")%>', '<%=ht.get("REQ_MON")%>');"><%=ht.get("USER_NM4")%></a>
					  <%}%>
					</td>  
					<td  width='70' align='center'>
					  <!--채권담당-->
					  <%if(String.valueOf(ht.get("USER_DT2")).equals("")){%>
					  <%	if(String.valueOf(ht.get("USER_ID2")).equals(user_id) || nm_db.getWorkAuthUser("전산팀",user_id) || nm_db.getWorkAuthUser("계약결재",user_id) ){%>
					  <a href="javascript:parent.doc_action('2', '<%=ht.get("CLIENT_ID")%>', '<%=ht.get("SEQ")%>', '<%=ht.get("DOC_NO")%>', '<%=ht.get("REQ_MON")%>');" onMouseOver="window.status=''; return true"><img src="/acar/images/center/button_in_gj.gif" align="absmiddle" border="0"></a>
					  <%	}else{%>-<%}%>
					  <%}else{%><a href="javascript:parent.doc_action('2', '<%=ht.get("CLIENT_ID")%>', '<%=ht.get("SEQ")%>', '<%=ht.get("DOC_NO")%>', '<%=ht.get("REQ_MON")%>');"><%=ht.get("USER_NM2")%></a>
					  <%}%>
					</td>
					<td  width='70' align='center'>
					  <!--관리팀장-->
					  <%if(String.valueOf(ht.get("USER_DT3")).equals("")){%>
					  <%	if(String.valueOf(ht.get("USER_ID3")).equals(user_id) || nm_db.getWorkAuthUser("전산팀",user_id) || nm_db.getWorkAuthUser("계약결재",user_id) ){%>
					  <a href="javascript:parent.doc_action('3', '<%=ht.get("CLIENT_ID")%>', '<%=ht.get("SEQ")%>', '<%=ht.get("DOC_NO")%>', '<%=ht.get("REQ_MON")%>');" onMouseOver="window.status=''; return true"><img src="/acar/images/center/button_in_gj.gif" align="absmiddle" border="0"></a>
					  <%	}else{%>-<%}%>
					  <%}else{%><a href="javascript:parent.doc_action('3', '<%=ht.get("CLIENT_ID")%>', '<%=ht.get("SEQ")%>', '<%=ht.get("DOC_NO")%>', '<%=ht.get("REQ_MON")%>');"><%=ht.get("USER_NM3")%></a>
					  <%}%>
					</td>
					<td  width='220'>&nbsp;<span title='<%=ht.get("BAD_DEBT_CAU")%>'><%=Util.subData(String.valueOf(ht.get("BAD_CAU")), 17)%></span></td>
					<td  width='80' align='center'>
					<% if ( String.valueOf(ht.get("BAD_YN")).equals("N") ) { %>미진행 <%} else if ( String.valueOf(ht.get("BAD_YN")).equals("Y") ) {%>진행<%}%></td>
					<td  width='80' align='center'><%=ht.get("BAD_ST_NM")%></td>
					<td  width='80' align='center'><%=AddUtil.ChangeDate2(String.valueOf(ht.get("REQ_DT")))%></td>
					<td  width='80' align='center'><%=ht.get("CAR_CALL_YN_NM")%></td>
					<td  width='70' align='center'><%=ht.get("REQ_MON")%>개월</td>
					<td  width='80' align='center'><%=AddUtil.ChangeDate2(String.valueOf(ht.get("ID_CNG_REQ_DT")))%>
					  <%if(AddUtil.parseInt(String.valueOf(ht.get("REQ_MON"))) > 3 && String.valueOf(ht.get("ID_CNG_REQ_DT")).equals("")){%>
					  <a href="javascript:parent.doc_action('id_cng', '<%=ht.get("CLIENT_ID")%>', '<%=ht.get("SEQ")%>', '<%=ht.get("DOC_NO")%>', '<%=ht.get("REQ_MON")%>');">[요청]</a>
					  <%}%>
					</td>
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
		<td class='line' width='280' id='td_con' style='position:relative;'>
			<table border="0" cellspacing="1" cellpadding="0" width='100%'>
				<tr>
					<td align='center'>
					<%if(t_wd.equals("")){%>검색어를 입력하십시오.
					<%}else{%>등록된 데이타가 없습니다<%}%></td>
				</tr>
			</table>
		</td>
		<td class='line' width='1060'>
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
