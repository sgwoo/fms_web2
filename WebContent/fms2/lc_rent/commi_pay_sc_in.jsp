<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*"%>
<%@ page import="acar.util.*"%>
<jsp:useBean id="a_db" scope="page" class="acar.cont.AddContDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String br_id 	= request.getParameter("br_id")==null?"":request.getParameter("br_id");
	
	String s_kd 	= request.getParameter("s_kd")==null? "3":request.getParameter("s_kd");
	String t_wd 	= request.getParameter("t_wd")==null? "" :request.getParameter("t_wd");
	String andor 	= request.getParameter("andor")==null?"1":request.getParameter("andor");
	String gubun1 = request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String gubun2 = request.getParameter("gubun2")==null?"":request.getParameter("gubun2");
	String st_dt = request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt = request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	
	int sh_height = request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//��ܱ���
	
	int count =0;
	long total_amt1	= 0;
	
	
	
	Vector vt = a_db.getCommiPayList(s_kd, t_wd, gubun1, gubun2, st_dt, end_dt);
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
<table border="0" cellspacing="0" cellpadding="0" width='1090'>
    <tr>
        <td class=line2 colspan=2></td>
    </tr>
	<tr id='tr_title' style='position:relative;z-index:1'>
		<td class='line' width='440' id='td_title' style='position:relative;'>
			<table border="0" cellspacing="1" cellpadding="0" width='100%'>
			    <tr>
    		        <td width=50 class='title'>����</td>
    			    <td width=50 class='title'>����</td>
    		        <td width=100 class='title'>����ȣ</td>
            	    <td width=90 class='title'>�����</td>
    		        <td width=150 class='title'>��</td>
				</tr>
			</table>
		</td>
		<td class='line' width='650'>
			<table border="0" cellspacing="1" cellpadding="0" width='100%'>
				<tr>
					<td width=100 class='title'>���ޱݾ�</td>
					<td width=90  class='title'>��������</td>				
					<td width=100 class='title'>������ȣ</td>
					<td width=90 class='title'>�뿩������</td>
					<td width=100 class='title'>��������</td>
					<td width=100 class='title'>�ʱ⼱����</td>
					<td width=70 class='title'>�������</td>
					<!--
					<td width=12% class='title'>�ź���</td>
					<td width=12% class='title'>����</td>
					<td width='80' class='title'>���޿�û��</td>
					<td width='70'  class='title'>���޿�û��</td>
					-->
				</tr>
			</table>
		</td>
	</tr>
<%
	if(vt_size > 0)
	{
%>
	<tr>
		<td class='line' width='440' id='td_con' style='position:relative;'>
			<table border="0" cellspacing="1" cellpadding="0" width='100%'>
<%
		for(int i = 0 ; i < vt_size ; i++)
		{
			Hashtable ht = (Hashtable)vt.elementAt(i);

%>
				<tr>
					<td  width=50 align='center'><%=i+1%></td>
					<td  width=50 align='center'><%=ht.get("USE_ST")%></td>
					<td  width=100 align='center'><a href="javascript:parent.commi_doc('<%=ht.get("RENT_MNG_ID")%>', '<%=ht.get("RENT_L_CD")%>', '<%=ht.get("EMP_ID")%>', '<%=ht.get("DOC_NO")%>')" onMouseOver="window.status=''; return true"><%=ht.get("RENT_L_CD")%></a></td>
					<td  width=90 align='center'><%=AddUtil.ChangeDate2(String.valueOf(ht.get("RENT_DT")))%></td>
					<td  width=150>&nbsp;<span title='<%=ht.get("FIRM_NM")%>'><a href="javascript:parent.view_client('<%=ht.get("RENT_MNG_ID")%>', '<%=ht.get("RENT_L_CD")%>', '<%=ht.get("RENT_ST")%>')" onMouseOver="window.status=''; return true"><%=Util.subData(String.valueOf(ht.get("FIRM_NM")), 10)%></a></span></td>
					
				</tr>
<%
		}
%>
				<tr>											
				    <td class='title'>&nbsp;</td>
				    <td class='title'>&nbsp;</td>
				    <td class='title'>&nbsp;</td>
				    <td class='title'>&nbsp;</td>
				    <td class='title'>&nbsp;</td>
				</tr>

			</table>
		</td>
		<td class='line' width='650'>
			<table border="0" cellspacing="1" cellpadding="0" width='100%'>
<%
		for(int i = 0 ; i < vt_size ; i++)
		{
			Hashtable ht = (Hashtable)vt.elementAt(i);
			String rent_start_dt 	= String.valueOf(ht.get("RENT_START_DT"));
			String gi_st 			= String.valueOf(ht.get("GI_ST2"));
			String pp_st 			= String.valueOf(ht.get("PP_ST"));
			String file_name1		= String.valueOf(ht.get("FILE_NAME1"));
			String file_name2		= String.valueOf(ht.get("FILE_NAME2"));
			String req_dt			= String.valueOf(ht.get("REQ_DT"));
			String sup_dt			= String.valueOf(ht.get("SUP_DT"));
			int chk_cnt = 0;
%>			
				<tr>
					<td  width=100 align='right'><%=Util.parseDecimal(String.valueOf(ht.get("DIF_AMT")))%></td>
					<td  width=90 align='center'><%=AddUtil.ChangeDate2(sup_dt)%>
					  <%if(sup_dt.equals("")){					  		
							if(rent_start_dt.equals("")) 				chk_cnt++;
							if(gi_st.equals("�̰���")) 				chk_cnt++;
							if(pp_st.equals("�ܾ�") || pp_st.equals("���Ա�"))  	chk_cnt++;
					    }%>																	  	
					</td>				
					<td  width=100 align='center'><%=ht.get("CAR_NO")%></td>
					<td  width=90 align='center'><%=AddUtil.ChangeDate2(rent_start_dt)%></td>					
					<td  width=100 align='center'><%=gi_st%></td>
					<td  width=100 align='center'><span title='<%=Util.parseDecimal(String.valueOf(ht.get("JAN_AMT")))%>��'><%=pp_st%></span></td>
					<td  width=70 align='center'><a href="javascript:parent.view_emp('<%=ht.get("EMP_ID")%>')";><%=Util.subData(String.valueOf(ht.get("EMP_NM")), 5)%></a></td>
					<!-- 
					<td  width=12% align='center'><%=file_name1%></td>					
					<td  width=12% align='center'><%=file_name2%></td>
					 -->
				</tr>
<%			total_amt1 	= total_amt1 + AddUtil.parseLong(String.valueOf(ht.get("DIF_AMT")));
		}
%>
				<tr>											
					<td class='title' style='text-align:right'><%=Util.parseDecimal(total_amt1)%></td>
				    <td class='title'>&nbsp;</td>
				    <td class='title'>&nbsp;</td>					
				    <td class='title'>&nbsp;</td>
				    <td class='title'>&nbsp;</td>
				    <td class='title'>&nbsp;</td>
				    <td class='title'>&nbsp;</td>
				</tr>
			</table>
		</td>
<%	}                  
	else               
	{
%>                     
	<tr>
		<td class='line' width='440' id='td_con' style='position:relative;'>
			<table border="0" cellspacing="1" cellpadding="0" width='100%'>
				<tr>
					<td align='center'>
					<%if(t_wd.equals("")){%>�˻�� �Է��Ͻʽÿ�.
					<%}else{%>��ϵ� ����Ÿ�� �����ϴ�<%}%></td>
				</tr>
			</table>
		</td>
		<td class='line' width='650'>
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
<!--
<br>
<table>
  <tr>
    <td>* �������� ���� �������� *</td>
  </tr>
  <tr>
    <td>1. �����뿩���� (����������� ���� �뿩���ô� �ƴ�)</td>
  </tr>
  <tr>
    <td>2. �����ϰ� �� �������谡�� �ϰ�</td>
  </tr>
  <tr>
    <td>3. �ʱ⼱���� �Ա�</td>
  </tr>
  <tr>
    <td>4. ������ �ź���,���� �纻</td>
  </tr>
</table>
-->
<script language='javascript'>
<!--
	parent.document.form1.size.value = '<%=vt_size%>';
//-->
</script>
</body>
</html>
