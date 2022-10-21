<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*,acar.util.*"%>
<jsp:useBean id="ln_db" scope="page" class="acar.alink.ALinkDatabase"/>

<%
	
	String rent_mng_id 	= request.getParameter("rent_mng_id")	== null ? ""	: request.getParameter("rent_mng_id");
	String rent_l_cd 		= request.getParameter("rent_l_cd")		== null ? ""	: request.getParameter("rent_l_cd");
	String rent_st	 		= request.getParameter("rent_st")			== null ? "1"	: request.getParameter("rent_st");
	String cms_type	 	= request.getParameter("cms_type")		== null ? "" 	: request.getParameter("cms_type");		// �ڵ���ü ���: card / cms
	String mail_code	 	= request.getParameter("mail_code")		== null ? "" 	: request.getParameter("mail_code");
	String doc_code	 	= request.getParameter("doc_code")		== null ? "" 	: request.getParameter("doc_code");
	
	Hashtable ht = ln_db.getRmRentLinkM(rent_l_cd, rent_st);
	
%>


<!DOCTYPE HTML PUBLIC -//W3C//DTD HTML 4.01 Transitional//EN
http://www.w3.org/TR/html4/loose.dtd>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<title>�ڵ����뿩�̿��༭</title>
<script src="https://code.jquery.com/jquery-1.11.3.min.js"></script>
</head>
<style type="text/css">
@import url(https://cdn.rawgit.com/hiun/NanumSquare/master/nanumsquare.css);
@import url(https://fonts.googleapis.com/earlyaccess/nanumgothic.css);
@import url(https://fonts.googleapis.com/earlyaccess/notosanskr.css);
/* * { font-family: Nanum Gothic; } */
body {
    font-family:'Nanum Gothic',sans-serif;
    color: #000000;
    letter-spacing:-0.05em;
}

body, table, tr, td, select, textarea{ 
	font-family:'Nanum Gothic';
	font-size: 12px;
	color: #000000;
}
table {
 border-collapse: collapse;
 border-spacing: 0;
}

.table_rmcar   {border:1px solid #949494; margin-bottom:2px; font-size:13px;}
.table_rmcar td{border:1px solid #949494; height:24px;}
.table_n td{border:0px;}

.doc_table{border:1px solid #000000; width:100%; margin-bottom:3px; font-size:0.85em; border-collapse: collapse; border-spacing: 0;}
.doc_table th {border:1px solid #000000; background-color:#e8e8e8; text-align:center;height:14px; padding:3px;}
.doc_table td {border:1px solid #000000; height:16px;}

.doc table {border:1px solid #000000; width:100%; margin-bottom:3px; font-size:0.85em !important;}
.doc table td {border:1px solid #000000; height:16px; font-size:0.85em !important;}
.doc table td.title {font-weight:bold; background-color:#e8e8e8;}
.doc table th {border:1px solid #000000; background-color:#e8e8e8; text-align:center;height:14px; padding:3px; font-size:0.85em !important;}

.terms_title{
	font-size: 12px;
	font-weight: bold;
	margin-bottom: 3px;
}
.terms_content{ font-size: 10px; }

.style1 { font-size:28px; font-weight:bold; }
.style2 { font-size:13px; font-weight:bold; }
.style3 { font-size:11px; }
.style4 { font-size:12px; }
.style5 { text-decoration:underline; color:#949494; }
.style6 { font-size:12px;font-weight:bold; }
.style7 { font-size:15px; font-weight:bold; }
.style8 { font-size:10px; }

.a4 { page: a4sheet; page-break-after: always }

input {	 color: black; font-size: 12px; font-family: Nanum Gothic; }

@media print {
	h1{
		page-break-before:always;
	}
}
</style>
<script language="JavaScript" type="text/JavaScript">
	function onSave(){
		var fm = document.form1;
		
		if( fm.c_cms_bank.value == '' ){
			alert('ī��縦 �Է��� �ּ���.');
			return;
		}
		
		<%if( !String.valueOf(ht.get("CLIENT_ST")).equals("����") ){ %>
		if( fm.c_enp_no.value == '' ){
			alert('����� ��ȣ�� �Է��� �ּ���.');
			return;
		} 
		<% } %>
		
		if( fm.c_cms_dep_nm.value == '' ){
			alert('ī���� ���θ��� �Է��� �ּ���.');
			return;
		}
		
		if( fm.c_cms_acc_no_1.value == '' || fm.c_cms_acc_no_2.value == '' || fm.c_cms_acc_no_3.value == '' || fm.c_cms_acc_no_4.value == '' ){
			alert('ī���ȣ�� ��Ȯ�� �Է��� �ּ���.');
			return;
		}
		
		if( fm.c_cms_dep_ssn.value == '' ){
			alert('ī���� ��������� �Է��� �ּ���.');
			return;
		}
		
		if( fm.c_mm.value == '' || fm.c_yyyy.value == '' ){
			alert('ī�� ��ȿ�Ⱓ�� Ȯ���� �ּ���.');
			return;
		}
		
		fm.c_cms_acc_no.value = fm.c_cms_acc_no_1.value + '' + fm.c_cms_acc_no_2.value + '' + fm.c_cms_acc_no_3.value + '' + fm.c_cms_acc_no_4.value;
		
		fm.submit();
		
	}
</script>
<body> 

<div align="center">

<div class='a4'>
<table width="680" border="0" cellspacing="0" cellpadding="0">
	<tr>
		<td>
			<div align="center">
				<span class=style1>
				�� �� �� �� �� �� �� �� �� ��
				<%if(!String.valueOf(ht.get("RENT_ST")).equals("1")){ %>
				(����)
				<%}%>
				</span>
			</div>
		</td>
	</tr>
	<tr>
		<td height=20></td>
	</tr>
  	<tr>
    	<td>
    		<table width="680" border="0" class="table_rmcar">
		      	<tr bgcolor="#FFFFFF" height="19">
			        <td width="13%" bgcolor="e8e8e8"><div align="center">����ȣ</div></td>
		        	<td width="16%" >
		        		<div align="left">&nbsp;
		        			<%=rent_l_cd%>
		        		</div>
		        	</td>
		        	<td width="12%" bgcolor="e8e8e8"><div align="center">������</div></td>
		        	<td width="12%">
		        		<div align="left">&nbsp;
		        			<%=ht.get("BR_NM") %>
		        		</div>
		        	</td>
		        	<td width="15%" bgcolor="e8e8e8"><div align="center">���������</div></td>
		        	<td width="32%">
		        		<div align="left">&nbsp;
		        			<%=ht.get("BUS_USER_NM") %> <%=ht.get("BUS_USER_POS") %> <%= ht.get("BUS_USER_M_TEL")%>
		        		</div>
			       	</td>
			    </tr>
				<tr bgcolor="#FFFFFF" height="35">
			        <td bgcolor="e8e8e8"><div align="center">������</div></td>
			        <td>
			        	<div align="left">&nbsp;
			        		<%=ht.get("CLIENT_ST") %>
			        	</div>
			        </td>
		        	<td bgcolor="e8e8e8"><div align="center">�뿩����</div></td>
		        	<td>
		        		<div align="left">
		        			&nbsp;����Ʈ
		        		</div>
		        	</td>
                    			
		        	<td bgcolor="e8e8e8"><div align="center">���������</div></td><!-- 2017. 10. 30 ���� ����� ���� -->
		        	<td>
		        		<div align="left">&nbsp;
		        			<%= ht.get("BUS2_USER_NM")%> <%= ht.get("BUS2_USER_POS")%>
		        			<%if(String.valueOf(ht.get("BUS2_USER_NM")).equals("�輺��")){ %>02-6263-6384<%}else{%><%= ht.get("BUS2_USER_M_TEL")%><%}%>
			        	     <br>&nbsp;����, ��࿬��, �ݳ�, �뿩��, ���ó�� ����
		        	   </div>
		        	</td>
		      	</tr>
    		</table>
    	</td>
    </tr>
   	<tr>
   		<td height=22px><div align="left"><img src=http://fms.amazoncar.co.kr/images/cardoc_arrow.gif> 
   		<span class=style2>������</span></div>
   		</td>
   	</tr>
   	<tr>
   		<td>
     		<table width="680" border="0"  class="table_rmcar">
		        <tr bgcolor="#FFFFFF" height="19">
		          	<td width="13%"><div align="center">����(��ǥ��)</div></td>
		          	<td width="34%" colspan="2">
		          		<div align="left">&nbsp;
		          			<%=ht.get("CLIENT_NM")%>
		          		</div>
		          	</td>
		          	<td width="18%">
		          		<div align="center">
		          			<%if(String.valueOf(ht.get("CLIENT_ST")).equals("����")){%>
		          				���ε�Ϲ�ȣ
		          			<%}else{%>
		          				�������
		          			<%}%>
		          		</div>
		          	</td>
		          	<td colspan="2">
		          		<div align="left">&nbsp;
		          			<%=ht.get("SSN") %>
		          		</div>
		          	</td>
		        </tr>
		        <tr bgcolor="#FFFFFF" height="19">
		          	<td><div align="center">��ȣ</div></td>
		         	 <td colspan="2">
		         	 	<div align="left">&nbsp;
		         	 		<%=ht.get("FIRM_NM")%>
		         	 	</div>
		         	 </td>
		          	<td><div align="center">����ڵ�Ϲ�ȣ</div></td>
		          	<td colspan="2">
		          		<div align="left">&nbsp;
		          		<%if(!String.valueOf(ht.get("CLIENT_ST")).equals("����")){%>
		          			<% 
		          				String enp_no = String.valueOf(ht.get("ENP_NO"));
		          				String enp_no1 = enp_no.substring(0, 3);
		          				String enp_no2 = enp_no.substring(3, 5);
		          				String enp_no3 = enp_no.substring(5);
		          			%>
		          			<%=enp_no1%>-<%=enp_no2%>-<%=enp_no3%>
		          		<%}%>
		          		</div></td>
		        </tr>
		        <tr bgcolor="#FFFFFF" height="19">
		          	<td><div align="center">�ּ�</div></td>
		          	<td colspan="5">
		          		<div align="left">&nbsp;
		          			<%=ht.get("O_ADDR")%>
		          		</div>
		          	</td>
		        </tr>
		        <tr bgcolor="#FFFFFF" height="19">
		          	<td><div align="center">���������ȣ</div></td>
		          	<td colspan="2">
			          	<div align="left">&nbsp;
			          		<%if(!String.valueOf(ht.get("CLIENT_ST")).equals("����") ){%>
			          			<%=ht.get("MGR_LIC_NO1")%>
			          		<%}%>
			          	</div>
		          	</td>
		         	<td rowspan="2"><div align="center">����ó</div></td>
		          	<td width="9%"><div align="center">��ȭ��ȣ </div></td>
		          	<td width="26%"><div align="left">&nbsp;<%=AddUtil.phoneFormat(String.valueOf(ht.get("O_TEL")))%></div></td>
		        </tr>
		        <tr bgcolor="#FFFFFF" height="19">
		          	<td><div align="center">���</div></td>
		          	<td colspan="2"><div align="left">&nbsp;</div></td>
		          	<td><div align="center">�޴���</div></td>
		          	<td><div align="left">&nbsp;<%=AddUtil.phoneFormat(String.valueOf(ht.get("M_TEL")))%></div></td>
		        </tr>
	    	</table>
		</td>
	</tr>
	<tr>
		<td height=2></td>
	</tr>
		<tr>
			<td>	
				<table width="680" border="0" class="table_rmcar">
			        <tr bgcolor="#FFFFFF" height="20">
			          	<td width="86" rowspan="4">
			          		<div align="center">
			          			<%if(!String.valueOf(ht.get("CLIENT_ST")).equals("����")){%>
			          				�߰�������
			          			<%}else{%>
			          				������
			          			<%}%>
			          		</div>
			          	</td>
			          	<td width="64"><div align="center">����</div></td>
			         	<td width="161">
			         		<div align="left">&nbsp;
			         			<%=ht.get("MGR_NM2")%>
			         		</div>
			         	</td>
			          	<td width="120"><div align="center">�������</div></td>
			          	<td width="235" colspan="2">
			          		<div align="left">&nbsp;
		          				<%=AddUtil.ChangeSsnBdt(String.valueOf(ht.get("MGR_SSN2")))%>
			          		</div>
			          	</td>
			        </tr>
			        <tr bgcolor="#FFFFFF" height="20">
			          	<td><div align="center">�ּ�</div></td>
			         	<td colspan="4">
			         		<div align="left">&nbsp;
			         			<%=ht.get("MGR_ADDR2")%>
			         		</div>
			         	</td>
			        </tr>
			        <tr bgcolor="#FFFFFF" height="19">
			          	<td><div align="center">��ȭ��ȣ</div></td>
			          	<td>
			          		<div align="left">&nbsp;
			          			<%=AddUtil.phoneFormat(String.valueOf(ht.get("MGR_M_TEL2")))%>
			          		</div>
			          	</td>
			          	<td><div align="center">���������ȣ</div></td>
			          	<td colspan="2">
			          		<div align="left">&nbsp;
			          			<%=ht.get("MGR_LIC_NO2")%>
			          		</div>
			          	</td>
			        </tr>
			        <tr bgcolor="#FFFFFF" height="19">
			          	<td>
				          	<div align="center">
			          			<%if(!String.valueOf(ht.get("CLIENT_ST")).equals("����")){%>
					          		��Ÿ
					          	<%}else{%>
					          		�߰�������
					          	<%}%>
				          	</div>
			          	</td>
			          	<td colspan="4" >
			          		<div align="left">&nbsp;
			          			<%=ht.get("MGR_ETC2") %>
			          		</div>
			          	</td>
			        </tr>
      			</table>
      		</td>
		</tr>
		<tr>
	    	<td height=22px><div align="left"><span class=style2><img src=http://fms.amazoncar.co.kr/images/cardoc_arrow.gif> �뿩���� �� �̿�Ⱓ</span></div></td>
	    </tr>
	    <tr>
			<td>
      		<table width="680" border="0" class="table_rmcar">
        		<tr bgcolor="e8e8e8" height="30">
		          	<td width="13%" ><div align="center">����</div></td>
		          	<td colspan="4"><div align="left">&nbsp;<%=ht.get("CAR_NM")%></div></td>
		          	<td width="13%"><div align="center">������ȣ</div></td>
		          	<td width="20%"><div align="left">&nbsp;<%=ht.get("CAR_NO")%></div></td>
       		 	</tr>
        		<tr bgcolor="e8e8e8" height="19">
		          	<td><div align="center">��������</div></td>
		          	<td colspan="2">
		          		<div align="left">&nbsp;
		          			<%=ht.get("FUEL_KD")%>
		          		</div>
		          	</td>
		          	<td width="13%"><div align="center">��������Ÿ�</div></td>
		          	<td width="20%">
			          	<div align="left">&nbsp;
			          		<%=AddUtil.parseDecimal(String.valueOf(ht.get("SH_KM")))%>km
			          	</div>
		          	</td>
		          	<td><div align="center">�߰��뿩ǰ��</div></td>
		          	<td>
		          		<div align="left">&nbsp;
		          			<%=ht.get("NAVI_YN") %>
		          		</div>
		          	</td>
        		</tr>
        		<tr bgcolor="e8e8e8" height="19">
		          	<td rowspan="3"><div align="center">�̿�Ⱓ</div></td>
		          	<td width="9%"><div align="center">�Ⱓ</div></td>
		          	<td colspan="2">
			          	<div align="left">&nbsp;
			          		<%=ht.get("CON_MON")%>����
			          		<%if(!String.valueOf(ht.get("CON_DAY")).equals("0") && !String.valueOf(ht.get("CON_DAY")).equals("")){ %>
				          		<%=ht.get("CON_DAY")%>��
				          	<%}%>
			          	</div>
		          	</td>
		          	<td><div align="center">�����̿�뵵</div></td>
		          	<td colspan="2">
			          	<div align="left">&nbsp;
			          		<%=ht.get("CAR_USE")%>
			          	</div>
		          	</td>
		        </tr>
		        <tr bgcolor="e8e8e8" height="19">
		          	<td><div align="center">��¥</div></td>
		          	<td colspan="5">
		          	<div align="left">&nbsp;
			          	<%if(String.valueOf(ht.get("RENT_START_DT")).equals("")){%>
			          		<%=AddUtil.ChangeDate2(String.valueOf(ht.get("DELI_PLAN_DT")))%>  ~ <%=AddUtil.ChangeDate2(String.valueOf(ht.get("RET_PLAN_DT")))%>
			          	<%}else{%>
			          		<%=AddUtil.ChangeDate2(String.valueOf(ht.get("RENT_START_DT")))%> ~ <%=AddUtil.ChangeDate2(String.valueOf(ht.get("RENT_END_DT")))%>
			          	<%}%>
		          	</div>
		          	</td>
		        </tr>
		        <tr bgcolor="e8e8e8" height="19">
		          	<td colspan="6">
			          	<div align="left">&nbsp;
			          		�뿩����� �������� �����ϸ�, 1���� �̸��� ���������Ͽ��� �� ��쿡�� 30���� 1������ ���ϴ�.
			          	</div>
		          	</td>
		        </tr>
      		</table>
      	</td>
	</tr>
	<tr>
    	<td height=22px><div align="left"><span class=style2><img src=http://fms.amazoncar.co.kr/images/cardoc_arrow.gif> ����/���� ��������</span></div></td>
    </tr>
	<tr>
		<td>
      		<table width="680" border="0" class="table_rmcar">
		        <tr bgcolor="#FFFFFF" height="19">
		          	<td width="13%" rowspan="2" bgcolor="e8e8e8"><div align="center">��/�����ð�<br>�� ���</div></td>
		        	<td width="7%"><div align="center">����</div></td>
		          	<td width="25%">
		          		<div align="left">&nbsp;
		          		<%=AddUtil.getDate3(String.valueOf(ht.get("DELI_PLAN_DT")))%>
		          		</div>
		          	</td>
		          	<td width="7%"><div align="center">����</div></td>
		        	<td width="45%">
		        		<div align="left">
		        			&nbsp;<span style="font-weight: bold;"><%=ht.get("RET_PLAN_DT")%></span>
		        			<br>�� ��, ������ �� ������� ���� 9~12�ñ��� �ݳ� ����
		        			<br>�� ��, �Ͽ���, ����(����1��1��) �� �߼����� �ݳ��Ұ� (���Ϲݳ�)
		        		</div>
		        	</td>
		        </tr>
		        <tr bgcolor="#FFFFFF" height="19">
		          	<td><div align="center">���</div></td>
		          	<td><div align="left">&nbsp;<%=ht.get("DELI_LOC")%></div></td>
		          	<td><div align="center">���</div></td>
		          	<td>
		          		<div align="left">&nbsp;<%=ht.get("RET_LOC")%>
				          	<%if(String.valueOf(ht.get("RET_LOC")).equals("����������")){%>
				          	(TEL.02-6263-6378)<br> &nbsp;���� �������� �������� 34�� 9
				          	<%}else if(String.valueOf(ht.get("RET_LOC")).equals("�������� ������")){%>
				          	(TEL.042-824-1770)<br> &nbsp;���� ����� ���ɱ�100, ����ī��ũ
				          	<%}else if(String.valueOf(ht.get("RET_LOC")).equals("�λ����� ������")){%>
				          	(TEL.051-851-0606)<br> &nbsp;�λ� ������ ����õ�� 270���� 5, �ΰ��ڵ�������
				          	<%}else if(String.valueOf(ht.get("RET_LOC")).equals("�������� ������")){%>
				          	(TEL.062-385-0133)<br> &nbsp;���� ���� �󹫴����� 131-1, ��1���ڵ���������
				          	<%}else if(String.valueOf(ht.get("RET_LOC")).equals("�뱸���� ������")){%>
				          	(TEL.053-582-2998)<br> &nbsp;�뱸 �޼��� �޼���� 109�� 58, ��������������
				          	<%}%>
			          	</div>
		          	</td>
		        </tr>
      		</table>
      	</td>
	</tr>
	<tr>
    	<td height=22px><div align="left"><span class=style2><img src=http://fms.amazoncar.co.kr/images/cardoc_arrow.gif> �뿩���</span></div></td>
    </tr>
	<tr>
		<td>
      		<table width="680" border="0" class="table_rmcar">
		        <tr>
		          	<td  width="13%" rowspan="2"  bgcolor="e8e8e8"><div align="center">����</div></td>
		          	<td colspan="4" bgcolor="e8e8e8" height="19"><div align="center">���뿩��</div></td>
		          	<td width="15%" rowspan="2" bgcolor="e8e8e8"><div align="center">��/������</div></td>
		          	<td width="15%" rowspan="2" bgcolor="e8e8e8"><div align="center">�հ�</div></td>
		        </tr>
		        <tr>
		          	<td height="21" width="14%" bgcolor="e8e8e8"><div align="center">����</div></td>
		          	<td width="14%" bgcolor="e8e8e8"><div align="center">������̼�</div></td>
		        	<td width="14%" bgcolor="e8e8e8"><div align="center">��Ÿ</div></td>
		          	<td width="14%" bgcolor="e8e8e8"><div align="center">�հ�</div></td>
		        </tr>
		        <tr>
		          	<td height="21" bgcolor="e8e8e8"><div align="center">���ް�</div></td>
		          	<td bgcolor="e8e8e8"><div align="right"><%=AddUtil.parseDecimal(String.valueOf(ht.get("INV_S_AMT")))%>&nbsp;</div></td>
		          	<td bgcolor="e8e8e8"><div align="right"><%=AddUtil.parseDecimal(String.valueOf(ht.get("NAVI_S_AMT")))%>&nbsp;</div></td>
		          	<td bgcolor="e8e8e8"><div align="right"><%=AddUtil.parseDecimal(String.valueOf(ht.get("ETC_S_AMT")))%>&nbsp;</div></td>
		          	<td bgcolor="e8e8e8"><div align="right"><%=AddUtil.parseDecimal(String.valueOf(ht.get("FEE_S_AMT")))%>&nbsp;</div></td>
		          	<td bgcolor="e8e8e8"><div align="right"><%=AddUtil.parseDecimal(String.valueOf(ht.get("CONS_S_AMT")))%>&nbsp;</div></td>
		          	<td bgcolor="e8e8e8"><div align="right"><%=AddUtil.parseDecimal(String.valueOf(ht.get("T_FEE_S_AMT")))%>&nbsp;</div></td>
		        </tr>
		        <tr>
		          	<td height="21" bgcolor="e8e8e8"><div align="center">�ΰ���</div></td>
		          	<td bgcolor="e8e8e8"><div align="right"><%=AddUtil.parseDecimal(String.valueOf(ht.get("INV_V_AMT")))%>&nbsp;</div></td>
		          	<td bgcolor="e8e8e8"><div align="right"><%=AddUtil.parseDecimal(String.valueOf(ht.get("NAVI_V_AMT")))%>&nbsp;</div></td>
		          	<td bgcolor="e8e8e8"><div align="right"><%=AddUtil.parseDecimal(String.valueOf(ht.get("ETC_V_AMT")))%>&nbsp;</div></td>
		          	<td bgcolor="e8e8e8"><div align="right"><%=AddUtil.parseDecimal(String.valueOf(ht.get("FEE_V_AMT")))%>&nbsp;</div></td>
		          	<td bgcolor="e8e8e8"><div align="right"><%=AddUtil.parseDecimal(String.valueOf(ht.get("CONS_V_AMT")))%>&nbsp;</div></td>
		          	<td bgcolor="e8e8e8"><div align="right"><%=AddUtil.parseDecimal(String.valueOf(ht.get("T_FEE_V_AMT")))%>&nbsp;</div></td>
		        </tr>
		        <tr>
		          	<td height="21" bgcolor="e8e8e8"><div align="center">�հ�</div></td>
		          	<td bgcolor="e8e8e8"><div align="right"><%=AddUtil.parseDecimal(String.valueOf(ht.get("INV_AMT")))%>&nbsp;</div></td>
		          	<td bgcolor="e8e8e8"><div align="right"><%=AddUtil.parseDecimal(String.valueOf(ht.get("NAVI_AMT")))%>&nbsp;</div></td>
		          	<td bgcolor="e8e8e8"><div align="right"><%=AddUtil.parseDecimal(String.valueOf(ht.get("ETC_AMT")))%>&nbsp;</div></td>
		          	<td bgcolor="e8e8e8"><div align="right"><%=AddUtil.parseDecimal(String.valueOf(ht.get("FEE_AMT")))%>&nbsp;</div></td>
		          	<td bgcolor="e8e8e8"><div align="right"><%=AddUtil.parseDecimal(String.valueOf(ht.get("CONS_AMT")))%>&nbsp;</div></td>
		          	<td bgcolor="e8e8e8"><div align="right"><%=AddUtil.parseDecimal(String.valueOf(ht.get("T_FEE_AMT")))%>&nbsp;</div></td>
		        </tr>
		        <tr>
		          	<td height="21" bgcolor="e8e8e8" ><div align="center">�������</div></td>
		          	<td colspan="6" bgcolor="e8e8e8" >
		          		<table width=100% border=0 cellspacing=0 cellpadding=0>
		          			<tr>
		          				<td style="border:0px;">
			          				<div align="left">&nbsp;
			          					<%=ht.get("F_PAID_WAY") %>
			          	  			</div>
		          	  			</td>
		          	  			<td style="border:0px;">
		          	  				<div align="right">��/������� �����Դϴ�&nbsp;</div>
		          	  			</td>
		          	  		</tr>
		          	  	</table>
		          	</td>
		        </tr>
		        <%if(String.valueOf(ht.get("RENT_ST")).equals("1")){%>
		        <tr>
		        	<td height="21" bgcolor="e8e8e8"><div align="center">���ʰ����ݾ�</div></td>
		        	<td colspan="6" bgcolor="e8e8e8">
			        	<div align="left">&nbsp;
			        		<%=AddUtil.parseDecimal(String.valueOf(ht.get("F_RENT_TOT_AMT")))%>��, <%=ht.get("F_PAID_WAY2") %>
			        	</div>
		        	</td>
		        </tr>
		        <%}%>
		        <tr>
		        	<td rowspan=2 bgcolor="e8e8e8"><div align="center">���</div></td>
		        	<td colspan="6" bgcolor="e8e8e8" height="50">
			        	<div align="left">&nbsp;
			        		<%=ht.get("FEE_CDT")%>
			        	</div>
		        	</td>
		        </tr>
		        <tr>
		          	<td colspan="7" bgcolor="e8e8e8" height="40"><div align="left">&nbsp;2ȸ�������� �뿩����� �ش� ȸ�� �뿩������ �Ϸ��� ���� �뿩��� �������� �˴ϴ�.</div></td>
		        </tr>
      		</table>
      	</td>
	</tr>
	<tr>
		<td height=2></td>
	</tr>
	<tr>
		<td>
			<table width="680" border="0" class="table_rmcar">
				<tr bgcolor="#FFFFFF">
          			<td width="13%" rowspan=2 bgcolor="e8e8e8">
          				<div align="center">�ڵ���ü<br>��û</div>
          			</td>
          			<td height="42" align=center>�ڵ���ü<br>���</td>
          			<td height="40">
          				<div align="center">
	          				<table width="100%" border="0" cellpadding="0" cellspacing="1">
	          					<tr>
	          						<td style="border:0px;">
		          						<div align="center">
		          							<input type="checkbox" name="checkbox" value="checkbox"
<%-- 		          								<%if(String.valueOf(ht.get("CMS_TYPE")).equals("card")){ %>checked<%}%> --%>
		          								<%if(cms_type.equals("card")){ %>checked<%}%>
		          							> �ſ�ī�� �ڵ����
		          						</div>
	          						</td>
	          						<td style="border:0px;">
		          						<div align="center">
		          							<input type="checkbox" name="checkbox" value="checkbox"
<%-- 		          								<%if(String.valueOf(ht.get("CMS_TYPE")).equals("cms") || String.valueOf(ht.get("CMS_TYPE")).equals("")){ %>checked<%}%>  --%>
		          								<%if(cms_type.equals("cms")){ %>checked<%}%>
		          							> CMS �ڵ���ü
		          						</div>
	          						</td>
	          					</tr>
	          					<tr>
	          						<td style="border:0px;"><div align="center">(������ �ſ�ī�� �ڵ���� �̿��û�� �ۼ�)</div></td>
	          						<td style="border:0px;"><div align="center">(���� CMS �����ü ��û�� �ۼ�)</div></td>
	          					</tr>
	          				</table>
          				</div>
          			</td>
        		</tr>
        		<tr bgcolor="#FFFFFF" height="40">
        			<td height="42" align=center>�ڵ���ü<br>���</td>
        			<td><div align="left"> &nbsp;2ȸ�������� �뿩���, ����뿩���, ��ü����, �ߵ����������, ��å��, ���·�, �ʰ�����뿩��</div></td>
        		</tr>
        	</table>
        </td>
    </tr>
	<tr>
    	<td height=5></td>
    </tr>
    <tr>
    	<td><div align="right">(����ȣ <%=rent_l_cd%> : Page 1/2)&nbsp;</div>
    </tr>
</table>
</div>

<div class='a4'>
<h1 style="margin-top: 8px;">
	<table width="680" border="0" cellspacing="0" cellpadding="0">
		<tr>
	    	<td height=22px>
	    		<div align="left"><span class=style2><img src=http://fms.amazoncar.co.kr/images/cardoc_arrow.gif> ������� �� ��å�ӻ���</span>&nbsp;
	    	        ( <%=ht.get("INS_COM_NM")%> ������� <%=ht.get("INS_COM_TEL")%>, ����⵿ ����Ÿ�ڵ������� 1588-6688 )    		
	    	    </div>
	    	</td>
	    </tr>
		<tr>
			<td>
	      		<table width="680" border="0" class="table_rmcar">
	        		<tr bgcolor="e8e8e8">
	          			<td width="33%" style="padding: 0; height: 17px;"><div align="center"><span class=style4>�����ڿ���</span></div></td>
	          			<td colspan="2" style="padding: 0; height: 17px;"><div align="center"><span class=style4>���谡�Գ���(�����ѵ�)</span></div></td>
	          			<td colspan="2" style="padding: 0; height: 17px;"><div align="center"><span class=style4>�ڱ��������� ����</span></div></td>
	        		</tr>
	        		<tr bgcolor="#FFFFFF">
	          			<td width="33%" rowspan="4" style="padding: 0;">
	          				<table width="100%" border=0 cellspacing=0 cellpadding=0 class="table_n">
	          					<tr>
	          						<td>
		          						<div align="center">
		          							<span class=style4>��26�� �̻�</span>
		          						</div>
	          						</td>
	          					</tr>
	          					<tr bgcolor="e8e8e8" style="border-top: 1px solid #949494; border-bottom: 1px solid #949494;">
	          						<td style="height: 20;">
	          							<div align="center">
	          								<span class=style4>�����ڹ���</span>
	          							</div>
	          						</td>
	          					</tr>
	          					<tr>
	          						<td>
	          							<div align="left">
	          								<span class=style4>
	          									(1)�����<br>
	          									(2)��༭�� ��õ� �߰�������<br>
	          									�� ����ڰ� ���� �� ���λ������ ��쿡�� �������� ���� ����(������ �������� Ư�� ����. ��, ���� �� 9�ν������� Ư�� �̰���)
	          								</span>
	          							</div>
	          						</td>
	          					</tr>
	          				</table>
	          			</td>
	          			<td width="10%" bgcolor="e8e8e8" height="30"><div align="center"><span class="style8">���ι��</span></div></td>
	          			<td width="13%" bgcolor="e8e8e8"><div align="center"><span class="style8">����<br>(���ι��,��)</span></div></td>
	          			<td width="32%" rowspan="4" valign=top>
	          				<table width=100% border=0 cellspacing=0 cellpadding=0 class="table_n">
								<tr>
									<td style="height:3px;"></td>
								</tr>
	          					<tr>
	          						<td style="padding:7px;">&nbsp; <span class=style4>����1. �ڱ��������� ��å��(��� �Ǵ�)<br>
				          			&nbsp;&nbsp;&nbsp;
				          			<input type="checkbox" name="checkbox" value="checkbox" <%if( String.valueOf(ht.get("CAR_JA")).equals("300000") )%>checked<%%>> 30���� / 
				          			<input type="checkbox" name="checkbox" value="checkbox" <%if( !String.valueOf(ht.get("CAR_JA")).equals("300000") )%>checked<%%>> ��Ÿ(<%if(!String.valueOf(ht.get("CAR_JA")).equals("300000") && Integer.parseInt(String.valueOf(ht.get("CAR_JA"))) >= 100000 ){%><%=Integer.parseInt(String.valueOf(ht.get("CAR_JA")))/10000%><%}else{%>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<%}%>)����</span><br>
				      				<span class=style3>(������ ��� �������ظ�å������ �ǰ� ����-������ ���պ��� ���Ժ���� ����� ����. ��,������� �߻��ÿ��� ����������ġ[=�������ݡ�(1-(���ɰ�������0.01))]�� 20% �ݾ��� ���� �δ���.)</span>
				      				</td>
				      			</tr>
				      		</table>
				      	</td>
	          			<td width="12%" rowspan="4" valign=top>
	          				<table width=100% border=0 cellspacing=0 cellpadding=0 class="table_n">
	          					<tr>
									<td style="height:10px;"></td>
								</tr>
	          					<tr>
	          						<td>
	          							<div align="left">&nbsp; 
	          								<span class=style3>����2.<br>&nbsp;&nbsp;�����Ⱓ ����<br>&nbsp; �� ���������<br>
	          									&nbsp; <input type="checkbox" name="checkbox" value="checkbox" <%if( String.valueOf(ht.get("MY_ACCID_YN")).equals("���δ�") ){ %>checked<%}%>> ���δ�<br>
		          								&nbsp; <input type="checkbox" name="checkbox" value="checkbox" <%if( !String.valueOf(ht.get("MY_ACCID_YN")).equals("���δ�") ){%>checked<%}%>> ����
		          							</span>
	          							</div>
	          						</td>
	          					</tr>
	          				</table>
	          			</td>
	        		</tr>
	        		<tr bgcolor="e8e8e8">
	          			<td height="20"><div align="center"><span class="style8">�빰���</span></div></td>
	          			<td><div align="center"><span class="style8">1���</span></div></td>
	        		</tr>
	        		<tr bgcolor="e8e8e8">
	          			<td height="30"><div align="center"><span class="style8">�ڱ��ü���</span></div></td>
	          			<td><div align="center"><span class="style8">���/���� 1���<br>�λ� 1500����</span></div></td>
	        		</tr>
	        		<tr bgcolor="e8e8e8">
	         	 		<td height="22"><div align="center"><span class="style8">������������</span></div></td>
	          			<td><div align="center"><span class="style8">2���</span></div></td>
	        		</tr>
	        		<tr bgcolor="#FFFFFF">
	          			<td height="34" colspan="6" style="padding:5px;">
	          				<div align="left">
	          					<span style="font-size: 11px;">�� �������� : ���� ��å������ ���� ��� �߻���, �뿩������ �����Ⱓ�� �ش��ϴ� �뿩���(�Ƹ���ī �ܱⷻƮ ���ǥ ����)�� 50%�� ���� �δ��ϼž� �մϴ�. (�ڵ����뿩 ǥ�ؾ�� ��19���� ����)</span>
	          				</div>
	          			</td>
	        		</tr>
	      		</table>
	      	</td>
		</tr>   
		<tr>
			<td height=2></td>
		</tr>
		<tr>
			<td>
	      		<table width="680" border="0" class="table_rmcar">
			        <tr bgcolor="#FFFFFF" height="20">
			          	<td rowspan="3" width="13%"><div align="center">�Ƹ���ī<br>�ܱⷻƮ<br>���</div></td>
			          	<td><div align="center">�뿩����</div></td>
			          	<td colspan="4"><div align="center">�뿩�Ⱓ�� 1�� ��� (�ΰ��� ����)</div></td>
			        </tr>
			        <tr bgcolor="#FFFFFF" height="20">
			          	<td rowspan="2"><div align="center"><%=ht.get("CARS")%></div></td>
			          	<td width="12%"><div align="center">1~2��</div></td>
			          	<td width="12%"><div align="center">3~4��</div></td>
			          	<td width="12%"><div align="center">5~6��</div></td>
			          	<td width="12%"><div align="center">7���̻�</div></td>
			        </tr>
			        <tr bgcolor="#FFFFFF" height="22">
			          	<td><div align="center"><%=AddUtil.parseDecimal(String.valueOf(ht.get("AMT_01D")))%>��</div></td>
			          	<td><div align="center"><%=AddUtil.parseDecimal(String.valueOf(ht.get("AMT_03D")))%>��</div></td>
			          	<td><div align="center"><%=AddUtil.parseDecimal(String.valueOf(ht.get("AMT_05D")))%>��</div></td>
			          	<td><div align="center"><%=AddUtil.parseDecimal(String.valueOf(ht.get("AMT_07D")))%>��</div></td>
			        </tr>
				</table>
			</td>
		</tr>
		<tr>
	    	<td height=22px>
	    		<div align="left">
	    			<span class=style2><img src=http://fms.amazoncar.co.kr/images/cardoc_arrow.gif> ��Ÿ�������</span>
	    		</div>
	    	</td>
	    </tr>
		<tr>
			<td>
	      		<table width="680" border="0" class="table_rmcar">
			        <tr bgcolor="#FFFFFF" height="35">
			          	<td bgcolor="e8e8e8"><div align="center">����<br>����Ÿ�</div></td>
			          	<td>
			          		<div align="left">&nbsp;
			          			<%=AddUtil.parseDecimal(String.valueOf(ht.get("AGREE_DIST")))%>km / 1����, �ʰ��� 1km�� 
			          			<%=AddUtil.parseDecimal(String.valueOf(ht.get("OVER_RUN_AMT")))%>��[�ΰ�������]�� �ʰ�����뿩�ᰡ �ΰ��˴ϴ�(�뿩�����)
			          		</div>
			          	</td>
			        </tr>
			        <tr bgcolor="e8e8e8" height="35">
			          	<td><div align="center">������<br>����</div></td>
			          	<td bgcolor="e8e8e8">
			          		<div align="left">&nbsp;
			          			<span class=style6>�� ����� ����Ʈ(�����)�� Ư���� ������ ������ ���� �ʽ��ϴ�.<br>
			      				&nbsp;�̿��ڲ����� ������ �����Ͻþ� �̿��Ͻñ� �ٶ��ϴ�.
			      				</span>
			      			</div>
			      		</td>
			        </tr>
			        <tr bgcolor="#FFFFFF" height="65">
			          	<td bgcolor="e8e8e8">
			          		<div align="center" style="line-height: 20px;letter-spacing: -1px;">���·�<br>��������<br>���߻���</div>
			          	</td>
			          	<td>
			          		<div align="left">
			          		<span class=style4>&nbsp;1) ������ �����Ⱓ �� �߻��Ǵ� ������ ���� �� ������� ���� ���·�� ��Ģ�� ���� ���� �δ��Ͽ��� �մϴ�.<br>
			      			&nbsp;2) ���� �̿� �� ����(�������, �������� ��ȯ ��)�� �ʿ��� ��� ���� �Ƹ���ī ��������ڿ��� �����Ͽ��� �ϸ�,<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
			      			 ���� ����� �Ƹ���ī ���������ü�� ���� �湮�� �ּž� �մϴ�. ������ �Ƹ���ī���� �����ϸ�,<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; ���κ������ ó���� ���ó���� �ȵ˴ϴ�.<br>
			      			&nbsp;3) ���� �̿� �� ��� �߻����� ��� ���� �Ƹ���ī ��������ڿ��� �����Ͽ��� �մϴ�.</span>
			      			</div>
			      		</td>
			        </tr>
			        <tr bgcolor="#FFFFFF" height="140">
			          	<td bgcolor="e8e8e8"><div align="center">��� ����</div></td>
			          	<td>
			          		<div align="left"><span class=style6>&nbsp;1) �������� �������� ���������� ���Ⱓ ���� �ǻ縦 ǥ���ϰ� �Ƹ���ī�� ������ �� ����뿩�ᰡ <br>
				          		&nbsp;&nbsp;&nbsp;&nbsp; �����Ǹ� Ȯ���˴ϴ�.</span><br>
								&nbsp;<span class=style4>2) �������� ��࿬���� ����� ���</span> <span class=style2>��ุ�� 7����(<%=AddUtil.ChangeDate2(String.valueOf(ht.get("END_DT7")))%>)����</span> <span class=style4>�Ƹ���ī�� ������ �ּž� �մϴ�.<br>
				      			&nbsp;3) ����뿩����� ����뿩������ �Ϸ����� �ſ�ī�� �ڵ���� �Ǵ� CMS �ڵ���ü�� �Ƹ���ī�� ����մϴ�.<br>
				      			&nbsp;&nbsp;&nbsp;&nbsp; ���� �뿩������ �Ϸ������� �뿩����� �������� ������ ��࿬���� �������� �ʽ��ϴ�.<br>
				      			&nbsp;4) ������ �������� �ؾ� ����Ⱓ ����� �߰� ���� ��û�� �����մϴ�.</span> <br>
				      			&nbsp;5) ���ڴ����� ������� ���� �뿩�� �������� ���Ұ���Ͽ� ����Ǹ�,����Ⱓ ����� �߰������� �Ұ����մϴ�.<br>
				      			&nbsp;<span class=style6>�� ��࿬�� ����� ���Բ��� ���� �Ƹ���ī�� �����ϼž� �ϸ�, ������ ������ ������ �������� <br>
				      			&nbsp;&nbsp;&nbsp;&nbsp; �ʴ� ������ �����մϴ�.(�Ƹ���ī ��࿬������ : <%=ht.get("BUS3_USER_NM")%> <%=ht.get("BUS3_USER_POS")%>
			      			    <%if(String.valueOf(ht.get("BUS3_USER_NM")).equals("�輺��")){%>
			      			    	02-6263-6384
				        	    <%}else{%>
				        	    	<%=ht.get("BUS3_USER_M_TEL") %>
				        	    <%}%>)
				        	    </span>
				        	</div>
				        </td><!-- 2017. 10. 30 ���� ����� ���� -->
			        </tr>
			        <tr bgcolor="e8e8e8" height="35">
			          	<td><div align="center">�뿩��<br>��ü��</div></td>
			          	<td bgcolor="e8e8e8">
			          		<div align="left">
			          			<span class=style4>
				          			&nbsp;1) �뿩�� ��ü�ÿ��� �Ӵ����� ��� ����� ������ �� ������, �� �� �������� ������ ��� �ݳ��Ͽ��� �մϴ�.<br>
		 	      					&nbsp;2) �뿩�� ��ü�� �⸮ 24%�� ��ü���ڰ� �ΰ��˴ϴ�.
		 	      				</span>
	 	      				</div>
	 	      			</td>
			        </tr>
			        <tr bgcolor="e8e8e8" height="35">
			          	<td><div align="center">�ߵ�������</div></td>
			          	<td bgcolor="e8e8e8">
			          		<div align="left">
				          		<span class=style4>
				          			&nbsp;1) ���̿�Ⱓ�� 
				          				<%if(String.valueOf(ht.get("DAY_CNT")).equals("30")){%>
				          					1����
				          				<%}else{%>
				          					<%=ht.get("DAY_CNT")%>��
				          				<%}%> �̻��� ��� : �ܿ��Ⱓ �뿩����� 10%�� ������� �ΰ��˴ϴ�.<br>
				      				&nbsp;2) ���̿�Ⱓ�� 
				      					<%if(String.valueOf(ht.get("DAY_CNT")).equals("30")){%>
				      						1����
				      					<%}else{%>
				      						<%=ht.get("DAY_CNT")%>��
				      					<%}%> �̸��� ��� : �Ʒ� ��õ� ������� ����� �����ϴ�.
				      			</span>
			      			</div>
			      		</td>
			        </tr>
			        <tr bgcolor="#FFFFFF">
			          	<td height="35" bgcolor="e8e8e8">
			          		<div align="center">��Ÿ<br>Ư�̻���</div>
			          	</td>
			          	<td>
				          	<div align="left">&nbsp;
				          		<%=ht.get("CON_ETC")%>
				          	</div>
			          	</td>
			        </tr>
	      		</table>
			</td>
		</tr>   
		<tr>
			<td><div align="left">&nbsp;<span class=style4>�� �� ��༭�� ������� ���� ������ "�ڵ��� �뿩 ǥ�ؾ��"�� ���մϴ�. (�Ƹ���ī ����Ʈ ���� Ȩ������ ����)</span></div></td>
	    </tr>
		<tr>
	    	<td height=22px>
	    		<div align="left">
	    			<span class=style2>
		    			<img src=http://fms.amazoncar.co.kr/images/cardoc_arrow.gif> 
		    			���̿�Ⱓ�� <%if(String.valueOf(ht.get("DAY_CNT")).equals("30")){%>1����<%}else{%><%=ht.get("DAY_CNT")%>��<%}%> �̸��� ����� �������
	    			</span>
	    			<span class=style4>(�Ʒ� ���ؿ� �ǰ� �̿��� �� ��ŭ�� �뿩�ᰡ ����˴ϴ�.)</span>
	    			&nbsp;&nbsp;<span class=style3>�� ����:��, %</span>
	    		</div>
	    	</td>
	    </tr>
		<tr>
			<td>
	      		<table width="680" border="0" class="table_rmcar">
	        		<tr bgcolor="#E8E8E8">
			          	<td width="107" height="22"><div align="center"><span class=style3>�̿��ϼ�</span></div></td>
			          	<td width="18"><div align="center"><span class=style3>1</span></div></td>
			          	<td width="18"><div align="center"><span class=style3>2</span></div></td>
			          	<td width="18"><div align="center"><span class=style3>3</span></div></td>
			          	<td width="18"><div align="center"><span class=style3>4</span></div></td>
			          	<td width="18"><div align="center"><span class=style3>5</span></div></td>
			          	<td width="18"><div align="center"><span class=style3>6</span></div></td>
			          	<td width="18"><div align="center"><span class=style3>7</span></div></td>
			          	<td width="18"><div align="center"><span class=style3>8</span></div></td>
			          	<td width="18"><div align="center"><span class=style3>9</span></div></td>
			          	<td width="18"><div align="center"><span class=style3>10</span></div></td>
			          	<td width="18"><div align="center"><span class=style3>11</span></div></td>
			          	<td width="18"><div align="center"><span class=style3>12</span></div></td>
			          	<td width="18"><div align="center"><span class=style3>13</span></div></td>
			          	<td width="18"><div align="center"><span class=style3>14</span></div></td>
			          	<td width="18"><div align="center"><span class=style3>15</span></div></td>
			          	<td width="18"><div align="center"><span class=style3>16</span></div></td>
			          	<td width="18"><div align="center"><span class=style3>17</span></div></td>
			          	<td width="18"><div align="center"><span class=style3>18</span></div></td>
			          	<td width="18"><div align="center"><span class=style3>19</span></div></td>
			          	<td width="18"><div align="center"><span class=style3>20</span></div></td>
			          	<td width="18"><div align="center"><span class=style3>21</span></div></td>
			          	<td width="18"><div align="center"><span class=style3>22</span></div></td>
			          	<td width="18"><div align="center"><span class=style3>23</span></div></td>
			          	<td width="18"><div align="center"><span class=style3>24</span></div></td>
			          	<td width="18"><div align="center"><span class=style3>25</span></div></td>
			          	<td width="18"><div align="center"><span class=style3>26</span></div></td>
			          	<td width="18"><div align="center"><span class=style3>27</span></div></td>
			          	<td width="18"><div align="center"><span class=style3>28</span></div></td>
			          	<td width="18"><div align="center"><span class=style3>29</span></div></td>
			          	<td width="19"><div align="center"><span class=style3>30</span></div></td>
	        		</tr>
	        		<tr bgcolor="#FFFFFF">
			          	<td height="24" bgcolor="e8e8e8"><div align="center"><span class=style3>���뿩��<br>���������</span></div></td>
			          	<%
			          		String day_per = "";
			          		for (int j = 1 ; j <= 30 ; j++){
			          			day_per = "DAY_PER" + String.valueOf(j);
			          	%>
			                <td bgcolor=#ffffff align=center>
			                	<span class=style4>
			                		<%if(Integer.parseInt(String.valueOf(ht.get(day_per))) > 0 ){ %>
			                			<%=ht.get(day_per)%>
			                		<%}%>
			                	</span>
			                </td>
		                <%}%>
	        		</tr>
	     		</table>
	     	</td>
		</tr>
		<tr>
			<td>
				<table width="680" border="0" class="table_rmcar">
					<tr>
						<td height=24 bgcolor="#FFFFFF" colspan=4>
							<div align="center">
								<span class=style6>����� &nbsp;&nbsp;: &nbsp;&nbsp;<%=AddUtil.getDate3(String.valueOf(ht.get("RENT_START_DT")))%></span>
							</div>
						</td>
					</tr>
			        <tr bgcolor="#FFFFFF">
			          	<td width="46%" height=90>
			          		<div align="left">
			          			&nbsp;&nbsp;<span class=style6>�뿩������ (�Ӵ���)</span><br>
			          			&nbsp;&nbsp;<span class=style4>����� �������� �ǻ���� 8, 802ȣ(���ǵ���, �������)</span>
			          			<br><br>
				      			<div style='position: relative;'>
					      			&nbsp;&nbsp;
					      			<span class=style4>(��)�Ƹ���ī ��ǥ�̻� &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;�� &nbsp;&nbsp;&nbsp;�� &nbsp;&nbsp;&nbsp;�� &nbsp;(��)</span>
				      				<img src="http://fms1.amazoncar.co.kr/acar/images/stamp.png" width="75" height="75" style='position:absolute; left: 180px; top: -25px;'>
				      			</div>
			      			</div>
			      		</td>
			          	<td colspan="3">
			          		<div align="left">
				          		&nbsp;&nbsp;&nbsp;<span class=style6>�뿩�̿��� (������)</span><br>
				      			&nbsp;&nbsp;&nbsp;<span class=style4>�� ����� ������ Ȯ���Ͽ� ����� ü���ϰ� ��༭ 1���� ���� ������.<br>
				      			&nbsp;&nbsp;&nbsp;�� �뿩�̿���</span><br>
				      			&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
				      			&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
				      			<span class=style5>
					      			&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
				      				&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
					      			&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;		      			
				      				<span style="color:#000000;">(��)</span>
				      			</span>
			      			</div>
			      		</td>
			        </tr>
			        <tr bgcolor="#FFFFFF">
			          	<td rowspan="3" style="padding:5px;">
				          	<div align="left">
				          		<span class=style3>�� �븮���� �� "�ڵ����뿩�̿���"�� ���Ͽ� �� ������ �����ϰ� �������� �븮�Ͽ� (��)�Ƹ���ī�� �� ����� ü���մϴ�.</span>
				          	</div>
						</td>
			          	<td width="9%" rowspan="3"><div align="center"><span class=style6>�븮��</span></div></td>
			          	<td width="13%"  height="22"><div align="center">�� ��</div></td>
			          	<td width="34%">
			          		<div align="left">&nbsp;
			          			<%if(String.valueOf("CLIENT_ST").equals("����")){%>
			          				<%=ht.get("MGR_TITLE3")%>
			          			<%}%>
			          		</div>
			          	</td>
			        </tr>
			        <tr bgcolor="#FFFFFF">
			          	<td height="22"><div align="center">�������</div></td>
			          	<td>
				          	<div align="left">&nbsp;
					          	<%if(String.valueOf("CLIENT_ST").equals("����")){%>
					          		<%=ht.get("MGR_SSN3")%>
					          	<%}%>
				          	</div>
			          	</td>
			        </tr>
			        <tr bgcolor="#FFFFFF">
			          	<td height="22"><div align="center">�� ��</div></td>
			          	<td>
				          	<div align="right">
					          	<%if(String.valueOf("CLIENT_ST").equals("����")){%>
					          		<%=ht.get("MGR_NM3")%>
					          	<%}%>
					          	(��)&nbsp;
				          	</div>
			          	</td>
			        </tr>
	     	 	</table>
			</td>
	  	</tr>  	
	    <tr>
	    	<td height=5></td>
	    </tr>   
	    <tr>
	    	<td>
	    		<table width=680 border=0 cellspacing=0 cellpadding=0>
	    			<tr>
	    				<td align=left>&nbsp;�ؾƸ���ī ����:�������� 140-004-023871 (��)�Ƹ���ī</td>
	    				<td align=right>(����ȣ <%=rent_l_cd%> : Page 2/2)&nbsp;</td>
	    			</tr>
	    		</table>
	    	</td>
	    </tr>  	
	</table>
</h1>
</div>

<!-- �ſ�ī�� �ڵ���� �̿��û�� -->
<%if(cms_type.equals("card")){ %>
<div class='a4'>
	<form action='card_cms_form_a.jsp' method='POST' name='form1'>
		<input type='hidden' name='rent_l_cd' value='<%=rent_l_cd%>' />
		<input type='hidden' name='rent_mng_id' value='<%=rent_mng_id%>' />
		<input type='hidden' name='rent_st' value='<%=rent_st%>' />
		<input type='hidden' name='cms_type' value='<%=cms_type%>' />
		<table width="680" border="0" cellspacing="0" cellpadding="0">
			<%@ include file="card_cms_form.jsp" %>
		</table>
	</form>
</div>
<%} %>

<!-- CMS �����ü ��û�� -->
<%if(cms_type.equals("cms")){ %>
<div class="a4">
	<table width="680" style="margin-top: 30px;">
		<%@ include file="cms_form.jsp" %>
	</table>
</div>
<%} %>

<!-- �������� ���Ǽ� -->
<div class="a4">
	<table width="680" style="margin-top: 30px;">
		<%@ include file="personal_info_form.jsp" %>
	</table>
</div>

<div class='a4'>
	<%@ include file="rmrent_terms.jsp" %>
</div>

</div>

</body>
</html>
