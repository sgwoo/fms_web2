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
	
	Vector vt = d_db.getFeeImStatList(s_kd, t_wd, gubun1);
	int vt_size = vt.size();
%>

<html>
<head><title>FMS</title>
<script language='javascript'>
<!--
	/* Title ���� */
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
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<body onLoad="javascript:init()">
  <table border="0" cellspacing="0" cellpadding="0" width='1020'>
    <tr>
        <td colspan="2" class=line2></td>
    </tr>  
	<tr id='tr_title' style='position:relative;z-index:1'>
		<td class='line' width='400' id='td_title' style='position:relative;'>
			<table border="0" cellspacing="1" cellpadding="0" width='100%'>
				<tr>
				    <td width='30' class='title' style='height:51'>����</td>
		            <td width='60' class='title'>����</td>					
		            <td width='100' class='title'>����ȣ</td>
		            <td width="120" class='title'>��</td>
        		    <td width='90' class='title'>������ȣ</td>
				</tr>
			</table>
		</td>
		<td class='line' width='620'>
			<table border="0" cellspacing="1" cellpadding="0" width='100%'>
				<tr>
		          <td width='100' rowspan="2" class='title'>����</td>
				  <td colspan="3" class='title'>����</td>					
				  <td colspan="2" class='title'>���ǿ���</td>
		          <td width='140' rowspan="2" class='title'>���</td>				  
				</tr>
				<tr>
				  <td width='70' class='title'>�������</td>				
				  <td width='60' class='title'>�����</td>
				  <td width='60' class='title'>��������</td>
			      <!--<td width='70' class='title'>ȸ����</td>-->
				  <td width='50' class='title'>ȸ��</td>				  		  				  
				  <td width='140' class='title'>�뿩�Ⱓ</td>			  
			  </tr>
			</table>
		</td>
	</tr>
<%
	if(vt_size > 0)
	{
%>
	<tr>
		<td class='line' width='400' id='td_con' style='position:relative;'>
			<table border="0" cellspacing="1" cellpadding="0" width='100%'>
<%
		for(int i = 0 ; i < vt_size ; i++)
		{
			Hashtable ht = (Hashtable)vt.elementAt(i);
%>
				<tr>
					<td  width='30' align='center'><%=i+1%></td>
					<td  width='60' align='center'><%=ht.get("FEE_ST")%>
					<%if(String.valueOf(ht.get("CLS_DT")).equals("")){%>					
					<%		if(String.valueOf(ht.get("FEE_ST")).equals("����")){%>
					
					<%		}else{%>
					<%			if(AddUtil.parseInt(String.valueOf(ht.get("D_DAYS"))) >0 ){%>					
					<font color=red>���</font>
					<%			}else{%>
					����
					<%			}%>
					<%		}%>					
					<%}else{%>
					����
					<%}%>		
					</td>								
					<td  width='100' align='center'><%=ht.get("RENT_L_CD")%><a href="javascript:parent.view_client('<%=ht.get("RENT_MNG_ID")%>', '<%=ht.get("RENT_L_CD")%>', '<%=ht.get("RENT_ST")%>')" onMouseOver="window.status=''; return true"></a></td>
					<td  width='120'>&nbsp;<span title='<%=ht.get("FIRM_NM")%>'><%=Util.subData(String.valueOf(ht.get("FIRM_NM")), 7)%></span></td>
					<td  width='90' align='center'><%=ht.get("CAR_NO")%></td>
				</tr>
<%
		}
%>
			</table>
		</td>
		<td class='line' width='620'>
			<table border="0" cellspacing="1" cellpadding="0" width='100%'>
<%
		for(int i = 0 ; i < vt_size ; i++)
		{
			Hashtable ht = (Hashtable)vt.elementAt(i);
%>			
				<tr>
					<td  width='100'>&nbsp;<span title='<%=ht.get("CAR_NM")%>'><%=Util.subData(String.valueOf(ht.get("CAR_NM")), 8)%></span></td>				
                    <td width='70' align='center'><%=AddUtil.ChangeDate2(String.valueOf(ht.get("REG_DT")))%></td>					
					<td  width='60' align='center'>
					  <!--�����-->
					 <a href="javascript:parent.doc_action('1', '<%=ht.get("RENT_MNG_ID")%>', '<%=ht.get("RENT_L_CD")%>','<%=ht.get("DOC_NO")%>');"><%=ht.get("USER_NM1")%></a>
					  </td>
					<td  width='60' align='center'>
					  <!--��������-->
					  <%if(String.valueOf(ht.get("USER_DT2")).equals("")){%>
					  <%	if(String.valueOf(ht.get("USER_ID3")).equals(user_id) || nm_db.getWorkAuthUser("������",user_id) || nm_db.getWorkAuthUser("������",user_id) ){%>
					  <a href="javascript:parent.doc_action('2', '<%=ht.get("RENT_MNG_ID")%>', '<%=ht.get("RENT_L_CD")%>','<%=ht.get("DOC_NO")%>');" onMouseOver="window.status=''; return true"><img src="/acar/images/center/button_in_gj.gif" align="absmiddle" border="0"></a>
					  <%	}else{%>-<%}%>
					  <%}else{%><a href="javascript:parent.doc_action('2', '<%=ht.get("RENT_MNG_ID")%>', '<%=ht.get("RENT_L_CD")%>','<%=ht.get("DOC_NO")%>');"><%=ht.get("USER_NM2")%></a>
					  <%}%>
					  </td>
					  <!--
					<td  width='70' align='center'>-->
					  <!--(�����ٺ���)ȸ������-->
					  <!--
					  <%if(String.valueOf(ht.get("USER_DT3")).equals("")){%>
					  <%	if(String.valueOf(ht.get("USER_ID3")).equals(user_id) || nm_db.getWorkAuthUser("������",user_id) || nm_db.getWorkAuthUser("�����ⳳ",user_id) ){%>
					  <a href="javascript:parent.doc_action('3', '<%=ht.get("RENT_MNG_ID")%>', '<%=ht.get("RENT_L_CD")%>','<%=ht.get("DOC_NO")%>');" onMouseOver="window.status=''; return true"><img src="/acar/images/center/button_in_gj.gif" align="absmiddle" border="0"></a>
					  <%	}else{%>-<%}%>
					  <%}else{%><a href="javascript:parent.doc_action('3', '<%=ht.get("RENT_MNG_ID")%>', '<%=ht.get("RENT_L_CD")%>','<%=ht.get("DOC_NO")%>');"><%=ht.get("USER_NM3")%></a>
					  <%}%></td>									
					  -->
					<td  width='50' align='center'><%=ht.get("ADD_TM")%>ȸ��</td>					
					<td  width='140' align='center'><%=AddUtil.ChangeDate2(String.valueOf(ht.get("RENT_START_DT")))%>~<%=AddUtil.ChangeDate2(String.valueOf(ht.get("RENT_END_DT")))%></td>
		
					<td  width='140' align='center'>
					<%if(String.valueOf(ht.get("CLS_DT")).equals("")){%>
					<%		if(String.valueOf(ht.get("FEE_ST")).equals("����")){%>
					<%=ht.get("FEE_ST")%> <%=ht.get("FEE_RENT_DT")%>
					<%		}else{%>
					<%			if(AddUtil.parseInt(String.valueOf(ht.get("D_DAYS"))) >0 ){%>					
					<font color=red><%=ht.get("D_DAYS")%>�� ���</font>
					<%			}else{%>
					
					<%			}%>					
					<%		}%>
					<%}else{%>
					<%=ht.get("CLS_ST")%> <%=ht.get("CLS_DT")%>
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
		<td class='line' width='400' id='td_con' style='position:relative;'>
			<table border="0" cellspacing="1" cellpadding="0" width='100%'>
				<tr>
					<td align='center'>
					<%if(t_wd.equals("")){%>�˻�� �Է��Ͻʽÿ�.
					<%}else{%>��ϵ� ����Ÿ�� �����ϴ�<%}%></td>
				</tr>
			</table>
		</td>
		<td class='line' width='620'>
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
