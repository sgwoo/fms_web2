<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.user_mng.*, acar.parking.*, java.*"%>
<jsp:useBean id="pk_db" scope="page" class="acar.parking.ParkIODatabase"/>
<%@ include file="/acar/cookies.jsp" %>
<%
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String br_id 	= request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String save_dt = request.getParameter("save_dt")==null?"":request.getParameter("save_dt");
	String brid 	= request.getParameter("brid")==null?"":request.getParameter("brid");
	int count =0;
	
	Vector vt = pk_db.Park_li_Magam(save_dt, t_wd, brid);
	int vt_size = vt.size();	
	
	String remarks = "";

%>

<html>
<head>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="../../include/table_t.css">
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--
	// Title ���� 
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
	function init() 
	{
		
		setupEvents();
	}
	

//-->
</script>

<style>

.listnum2 a:link {color:#ff0000; text-decoration:underline;} 
.listnum2 a:visited {color:#ff0000; text-decoration:underline;} 
.listnum2 a:hover {color:#ff0000; text-decoration:underline;} 

</style>

</head>
<!-- MeadCo ScriptX -->
<object id=factory style="display:none" classid="clsid:1663ed61-23eb-11d2-b92f-008048fdd814" codebase="/smsx.cab#Version=6,3,439,30"></object>

<body onLoad="javascript:init()">
<form name='form1' action='' method='post'>


<table border="0" cellspacing="0" cellpadding="0" width='100%'>
	<tr><td colspan="2" align="center"><h3><%if(brid.equals("1")){%>����<%}else if(brid.equals("3")){%>�λ�<%}else{%>����<%}%>������ ������Ȳ(�Ű���������)</h3></td></tr>
	<tr><td colspan="2" align="right">�ۼ��� : <%=AddUtil.ChangeDate2(save_dt)%></td></tr>
	<tr>
	<td class=h></td>
	</tr>
	<tr><td class=line2 colspan="2"></td></tr>
	<tr id='tr_title' style='position:relative;z-index:1'>
		<td class='line' id='td_title' style='position:relative;'>
			<table border="0" cellspacing="1" cellpadding="0" width='100%' height="43">
				<tr> 
					<td class='title' width="5%" >����</td>
					<td class='title' width="15%" >����</td>
					<td class='title' width="15%" >������ȣ</td>
					<td class='title' width="10%" >��Ű</td>
					<td class='title' width="5%" >��ġ</td>
					<td class='title' width="20%" >FMS</td>
					<td class='title' width="15%" >�޸�</td>
					<td class='title' width="15%" >���</td>
				
				</tr>
			</table>
		</td>
	</tr>
	<tr>
		<td class='line' id='td_con' style='position:relative;'>
			<table border="0" cellspacing="1" cellpadding="0" width='100%'>
<% 
    if ( vt_size > 0) { 		
		for(int i = 0 ; i < vt_size ; i++){
			Hashtable ht = (Hashtable)vt.elementAt(i);
			remarks = String.valueOf(ht.get("REMARKS")) ;

%>         
				<tr>
					<td align="center" width="5%"><%=i+1%></td>
					<td align="center" width="15%"><%=ht.get("CAR_NM")%></td>
					<td align="center" width="15%"><%=ht.get("CAR_NO")%></td>
					<td align="center" width="10%"><%if(ht.get("CAR_KEY").equals("X")){%>
							<%=ht.get("CAR_KEY_CAU")%>
						<%}else if(ht.get("CAR_KEY").equals("O")){%>
							O
						<%}%></td>
					<td align="center" width="5%"><%=ht.get("AREA")%></td>
					<td align="center" width="20%"><%if(!ht.get("FIRM_NM").equals("(��)�Ƹ���ī")){%><%=ht.get("FIRM_NM")%><%}else if(ht.get("RENT_ST_NM").equals("�Ű�Ȯ��")){%>�Ű�Ȯ��<%}%></td>
					<td align="center" width="15%">
													<%if(!ht.get("FIRM_NM").equals("(��)�Ƹ���ī") && !ht.get("CLS_ST").equals("")) {%>
														<%=ht.get("USER_NM")%>
													<%}else if(!ht.get("FIRM_NM").equals("(��)�Ƹ���ī") && ht.get("CLS_ST").equals("")){%>
														<%=ht.get("USER_NM")%>
													<%}%>
					</td>
					<td align="center" width="15%"><%if(ht.get("CAR_ST").equals("4")){%>����<%}else if(ht.get("RENT_START_DT").equals("") && ht.get("CAR_GU").equals("0")){%>�縮��<%}%><%if(!ht.get("IN_DT").equals("") && ht.get("CLS_ST").equals("")){%>�ӽ�ȸ��<%}%><%if(!ht.get("CLS_ST").equals("")){%>����ó����<%}%></td>
				
				</tr>
  
 <%  }
  }  else{	%>                    
			<tr>		
				<td class='line'>
					<table border="0" cellspacing="1" cellpadding="0" width='100%'>
						<tr> 
							<td align='center'>��ϵ� ����Ÿ�� �����ϴ�</td>
						</tr>
					</table>
				</td>
			</tr>
 <%	}	%>		
			</table>
		</td>
	</tr>
	
	<tr>
		<td class="h"></td>
	</tr>
		<tr>
		<td class="h">��Ư�̻���</td>
	</tr>	
		
	<tr>	
		<td align="center"><textarea rows='2' name='park_note' cols='125' style='IME-MODE: active' ><%=remarks%></textarea>
			
		</td>
	</tr>	
			
</table>
</form>
</body>
</html>

<script>
onprint();

function onprint(){
factory.printing.header = ""; //��������� �μ�
factory.printing.footer = ""; //�������ϴ� �μ�
factory.printing.portrait = true; //true-�����μ�, false-�����μ�    
factory.printing.leftMargin = 5.0; //��������   
factory.printing.topMargin = 40.0; //��ܿ���    
factory.printing.rightMargin = 5.0; //��������
factory.printing.bottomMargin = 5.0; //�ϴܿ���
factory.printing.Print(true, window);//arg1-��ȭ����ǥ�ÿ���(true or false), arg2-��ü������orƯ��������
}
</script>
