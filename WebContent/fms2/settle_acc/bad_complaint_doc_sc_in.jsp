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
	
	int sh_height = request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//��ܱ���
	
	int count =0;
	
	
	MaMenuDatabase nm_db = MaMenuDatabase.getInstance();
	
	Vector vt = d_db.getBadComplaintDocList(s_kd, t_wd, gubun1);
	int vt_size = vt.size();
	

%>

<html>
<head><title>FMS</title>
<script language='javascript'>
<!--
// 	/* Title ���� */
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
				    <td width='30' class='title' style='height:45'>����</td>
				    <td width='50' class='title'>&nbsp;<br>����<br>&nbsp;</td>
		                    <td width="200" class='title'>����</td>
				</tr>
			</table>
		</td>
		<td class='line' width='1060'>
			<table border="0" cellspacing="1" cellpadding="0" width='100%'>
				<tr>
				  <td colspan="5" class='title'>����</td>					
				  <td colspan="7" class='title'>����������ó��</td>
				</tr>
				<tr>
				  <td width='80' class='title'>�������</td>				
				  <td width='70' class='title'>�����</td>
				  <td width='80' class='title'>������������</td>
				  <td width='70' class='title'>��������</td>
				  <td width='70' class='title'>�ѹ�����</td>				  
				  <td width='220' class='title'>��û����</td>	
				  <td width='80' class='title'>���౸��</td>		  
				  <td width='80' class='title'>ó������</td>
				  <td width='80' class='title'>��������</td>
				  <td width='80' class='title'>����ȸ��</td>				  
				  <td width='70' class='title'>���������</td>				  
				  <td width='80' class='title'>���Ѻκ����û</td>
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
					  <!--�����-->
					 <a href="javascript:parent.doc_action('1', '<%=ht.get("CLIENT_ID")%>', '<%=ht.get("SEQ")%>', '<%=ht.get("DOC_NO")%>', '<%=ht.get("REQ_MON")%>');"><%=ht.get("USER_NM1")%></a>
					  </td>
					<td  width='80' align='center'>
					  <!--������������-->
					  <%if(String.valueOf(ht.get("USER_DT4")).equals("")){%>
					  <%	if(String.valueOf(ht.get("USER_ID4")).equals(user_id) || nm_db.getWorkAuthUser("������",user_id) || nm_db.getWorkAuthUser("�����������",user_id) ){%>
					  <a href="javascript:parent.doc_action('4', '<%=ht.get("CLIENT_ID")%>', '<%=ht.get("SEQ")%>', '<%=ht.get("DOC_NO")%>', '<%=ht.get("REQ_MON")%>');" onMouseOver="window.status=''; return true"><img src="/acar/images/center/button_in_gj.gif" align="absmiddle" border="0"></a>
					  <%	}else{%>-<%}%>
					  <%}else{%><a href="javascript:parent.doc_action('4', '<%=ht.get("CLIENT_ID")%>', '<%=ht.get("SEQ")%>', '<%=ht.get("DOC_NO")%>', '<%=ht.get("REQ_MON")%>');"><%=ht.get("USER_NM4")%></a>
					  <%}%>
					</td>  
					<td  width='70' align='center'>
					  <!--ä�Ǵ��-->
					  <%if(String.valueOf(ht.get("USER_DT2")).equals("")){%>
					  <%	if(String.valueOf(ht.get("USER_ID2")).equals(user_id) || nm_db.getWorkAuthUser("������",user_id) || nm_db.getWorkAuthUser("������",user_id) ){%>
					  <a href="javascript:parent.doc_action('2', '<%=ht.get("CLIENT_ID")%>', '<%=ht.get("SEQ")%>', '<%=ht.get("DOC_NO")%>', '<%=ht.get("REQ_MON")%>');" onMouseOver="window.status=''; return true"><img src="/acar/images/center/button_in_gj.gif" align="absmiddle" border="0"></a>
					  <%	}else{%>-<%}%>
					  <%}else{%><a href="javascript:parent.doc_action('2', '<%=ht.get("CLIENT_ID")%>', '<%=ht.get("SEQ")%>', '<%=ht.get("DOC_NO")%>', '<%=ht.get("REQ_MON")%>');"><%=ht.get("USER_NM2")%></a>
					  <%}%>
					</td>
					<td  width='70' align='center'>
					  <!--��������-->
					  <%if(String.valueOf(ht.get("USER_DT3")).equals("")){%>
					  <%	if(String.valueOf(ht.get("USER_ID3")).equals(user_id) || nm_db.getWorkAuthUser("������",user_id) || nm_db.getWorkAuthUser("������",user_id) ){%>
					  <a href="javascript:parent.doc_action('3', '<%=ht.get("CLIENT_ID")%>', '<%=ht.get("SEQ")%>', '<%=ht.get("DOC_NO")%>', '<%=ht.get("REQ_MON")%>');" onMouseOver="window.status=''; return true"><img src="/acar/images/center/button_in_gj.gif" align="absmiddle" border="0"></a>
					  <%	}else{%>-<%}%>
					  <%}else{%><a href="javascript:parent.doc_action('3', '<%=ht.get("CLIENT_ID")%>', '<%=ht.get("SEQ")%>', '<%=ht.get("DOC_NO")%>', '<%=ht.get("REQ_MON")%>');"><%=ht.get("USER_NM3")%></a>
					  <%}%>
					</td>
					<td  width='220'>&nbsp;<span title='<%=ht.get("BAD_DEBT_CAU")%>'><%=Util.subData(String.valueOf(ht.get("BAD_CAU")), 17)%></span></td>
					<td  width='80' align='center'>
					<% if ( String.valueOf(ht.get("BAD_YN")).equals("N") ) { %>������ <%} else if ( String.valueOf(ht.get("BAD_YN")).equals("Y") ) {%>����<%}%></td>
					<td  width='80' align='center'><%=ht.get("BAD_ST_NM")%></td>
					<td  width='80' align='center'><%=AddUtil.ChangeDate2(String.valueOf(ht.get("REQ_DT")))%></td>
					<td  width='80' align='center'><%=ht.get("CAR_CALL_YN_NM")%></td>
					<td  width='70' align='center'><%=ht.get("REQ_MON")%>����</td>
					<td  width='80' align='center'><%=AddUtil.ChangeDate2(String.valueOf(ht.get("ID_CNG_REQ_DT")))%>
					  <%if(AddUtil.parseInt(String.valueOf(ht.get("REQ_MON"))) > 3 && String.valueOf(ht.get("ID_CNG_REQ_DT")).equals("")){%>
					  <a href="javascript:parent.doc_action('id_cng', '<%=ht.get("CLIENT_ID")%>', '<%=ht.get("SEQ")%>', '<%=ht.get("DOC_NO")%>', '<%=ht.get("REQ_MON")%>');">[��û]</a>
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
					<%if(t_wd.equals("")){%>�˻�� �Է��Ͻʽÿ�.
					<%}else{%>��ϵ� ����Ÿ�� �����ϴ�<%}%></td>
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