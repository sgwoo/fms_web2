<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.common.*, acar.forfeit_mng.*, acar.user_mng.*, acar.estimate_mng.*"%>
<jsp:useBean id="FineDocDb" scope="page" class="acar.forfeit_mng.FineDocDatabase"/>
<jsp:useBean id="FineGovBn" 	scope="page" class="acar.forfeit_mng.FineGovBean"/>
<jsp:useBean id="FineDocBn" 	scope="page" class="acar.forfeit_mng.FineDocBean"/>
<jsp:useBean id="FineDocListBn" scope="page" class="acar.forfeit_mng.FineDocListBean"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");//�α���-ID
	String mode = request.getParameter("mode")==null?"":request.getParameter("mode");
	String doc_id = request.getParameter("doc_id")==null?"":request.getParameter("doc_id");
	String doc_dt 	= "";
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	UserMngDatabase u_db = UserMngDatabase.getInstance();
	MaMenuDatabase nm_db = MaMenuDatabase.getInstance();
	EstiDatabase e_db = EstiDatabase.getInstance();
	
	FineDocBn = FineDocDb.getFineDoc(doc_id);
	FineGovBn = FineDocDb.getFineGov(FineDocBn.getGov_id());
	
	doc_dt = FineDocBn.getDoc_dt();
	
	//���·Ḯ��Ʈ
	Vector FineList = FineDocDb.getFineDocLists(doc_id);
	
	if(FineDocBn.getH_mng_id().equals(""))		FineDocBn.setH_mng_id("000026");
	
	//���������
	UsersBean h_user = u_db.getUsersBean(FineDocBn.getH_mng_id());
	UsersBean b_user = u_db.getUsersBean(nm_db.getWorkAuthUser("���·�����"));
	
	Hashtable br1 = c_db.getBranch(b_user.getBr_id());
		
	//�μ⿩�� ����
	if(FineDocBn.getPrint_dt().equals("")){
		FineDocDb.changePrint_dt(doc_id, user_id);
	}
	
	//����
	String var3 = e_db.getEstiSikVarCase("1", "", "fine_app1");//÷�μ���1
	String var4 = e_db.getEstiSikVarCase("1", "", "fine_app2");//÷�μ���2
	String var5 = e_db.getEstiSikVarCase("1", "", "fine_app3");//÷�μ���3
	String var6 = e_db.getEstiSikVarCase("1", "", "fine_app4");//÷�μ���4
		
	int app_doc_h = 0;
	String app_doc_v = "";
	if(FineDocBn.getApp_doc1().equals("Y")){	
		app_doc_h += 20;
		app_doc_v += "1";
	}
	if(FineDocBn.getApp_doc2().equals("Y")){
		app_doc_h += 20;
		app_doc_v += "2";
	}
	/* if(FineDocBn.getApp_doc3().equals("Y")){
		app_doc_h += 20;
		app_doc_v += "3";
	} */
	if(FineDocBn.getApp_doc4().equals("Y")){
		if(!FineDocBn.getGov_st().equals("������")){	//�������� ����(20190910)
			app_doc_h += 20;
			app_doc_v += "4";
		}
	}
	int app_doc_size = app_doc_h/20;	
				
	//���� ���μ�
	int tot_size = FineList.size();
	
	//�Ѷ��δ� ����
	int line_h = 32;//20120104 �������ڿ��� �Ͻ÷� �ٲ� 32->48
	
	//������ ����	
	int page_h = 850;
	
	//�� ���̺� �⺻ ����
	int table1_h = 465+60;
	int table2_h = tot_size*line_h;	
	int table3_h = app_doc_h+140;
	
	//����������� ���ϱ�
	int page_cnt = ((table1_h+table2_h+table3_h)/page_h);
	if((table1_h+table2_h+table3_h)%page_h != 0) page_cnt = page_cnt + 1;
	
	//������ ���̺� ���� ���ϱ�
	int height = (page_h*page_cnt)-(table1_h+table2_h);	
	
	String chk = "1";
	if(FineList.size()>0){
		for(int i=0; i<FineList.size(); i++){ 
			FineDocListBn = (FineDocListBean)FineList.elementAt(i);
			if(FineDocListBn.getCar_no().indexOf("��") != -1) chk = "0";
		}
	}
	String exp = "N";
	if(chk.equals("1") && FineGovBn.getGov_nm().equals("�Ȼ�� �ܿ���û��")){
		exp = "Y";
	}
	
	double img_width 	= 690;
	double img_height 	= 1019;
	
	//ù��° ���·�ǿ� ���� ���·���� ���� �б�(20190621)
	String vio_st =	"";
	if(FineList.size()>0){
		FineDocListBn = (FineDocListBean)FineList.elementAt(0);
		vio_st = FineDocListBn.getVio_st(); 
	}
	
%>
<html>
<head><title>FMS</title>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--

//-->
</script>
<style>

@page a4sheet { size: 21.0cm 29.7cm }

.a4 { page: a4sheet; page-break-after: always }

</style>
</head>
<body leftmargin="15" topmargin="1" <%if(!mode.equals("fine")){%>onLoad="javascript:onprint()"<%}%>>
<object id=factory style="display:none" classid="clsid:1663ed61-23eb-11d2-b92f-008048fdd814" codebase="/smsx.cab#Version=6,3,439,30">
</object>

            <table width='<%=img_width%>' height="<%=table1_h%>" border="0" cellpadding="0" cellspacing="0">
            	<tr> 
            		<td colspan="2" height="40" align="center" style="font-size : 18pt;"><b><font face="����">Pick amazoncar! We'll pick you up.</font></b></td>
            	</tr>
            	<tr> 
            		<td colspan="2" height="5" align="center"></td>
            	</tr>
            	<tr bgcolor=""> 
            		<td colspan="2" align='center' height="1" class=line> 
            			<table width="100%" border="0" cellspacing="1" cellpadding="0">
            				<tr bgcolor=""> 
            					<td height="40" class=> 
            						<table width="100%" border="0" cellspacing="0" cellpadding="5">
            							<tr> 
						                  <td height="20" colspan="2" style="font-size : 9pt;"><font face="����"><%=br1.get("BR_POST")%>
						                    <%=br1.get("BR_ADDR")%></font></td>
						                  <td height="20" style="font-size : 9pt;" ><font face="����">Tel:02-392-4242(��ǥ��ȣ)</font></td>
						                </tr>
						                <tr>
						                	<td height="20" style="font-size : 9pt;"><font face="����"><%=h_user.getDept_nm()%>�� 
						                    <%=h_user.getUser_nm()%></font></td>
						                  	<td height="20" style="font-size : 9pt;"><font face="����">����� 
						                    <%=b_user.getUser_nm()%>(<%=b_user.getUser_email()%>)</font></td>
						                	<td colspan="2" height="20" style="font-size : 9pt;">&nbsp;&nbsp;&nbsp;&nbsp;<font face="����"><%=b_user.getHot_tel()%>(�����ȣ)</font></td>
						                </tr>
						                <tr>
						                  <td height="20" colspan="2" style="font-size : 9pt;"><font face="����">http://www.amazoncar.co.kr</font></td>
						                  <td height="20" style="font-size : 9pt;" ><font face="����">Fax:<%if(b_user.getDept_id().equals("0002")){%>02-3775-4243<%}else{%><%=br1.get("FAX")%><%}%></font></td>
						                </tr>
            						</table>
            					</td>
            				</tr>
            			</table>
            		</td>
            	</tr>
            	<tr> 
            		<td height="20" colspan="2" align='center'></td>
            	</tr>
            	<tr> 
            		<td height="125" colspan="2" align='center'> 
            			<table width="100%" border="0" cellspacing="0" cellpadding="0">
            				<tr> 
            					<td width="10%" height="25" style="font-size : 10pt;"><font face="����">������ȣ</font></td>
            					<td width="3%" height="25" style="font-size : 10pt;"><font face="����">:</font></td>
            					<td height="25" width="87%" style="font-size : 10pt;"><font face="����"><%=FineDocBn.getDoc_id()%></font></td>
            				</tr>
            				<tr> 
            					<td height="25" style="font-size : 10pt;"><font face="����">��������</font></td>
            					<td height="25" style="font-size : 10pt;"><font face="����">:</font></td>
            					<td height="25" style="font-size : 10pt;"><font face="����"><%=AddUtil.getDate3(FineDocBn.getDoc_dt())%></font></td>
            				</tr>
            				<tr> 
            					<td height="25" style="font-size : 10pt;"><font face="����">��&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; ��</font></td>
            					<td height="25" style="font-size : 10pt;"><font face="����">:</font></td>
            					<td height="25" style="font-size : 10pt;"><font face="����"><%=FineGovBn.getGov_nm()%></font></td>
            				</tr>
            				<tr> 
            					<td height="25" style="font-size : 10pt;"><font face="����">��&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; ��</font></td>
            					<td height="25" style="font-size : 10pt;"><font face="����">:</font></td>
            					<td height="25" style="font-size : 10pt;"><font face="����"><%=FineDocBn.getMng_dept()%> 
            						<%if(!FineDocBn.getMng_nm().equals("")){%>
            						&nbsp; ( <%=FineDocBn.getMng_pos()%> <%=FineDocBn.getMng_nm()%> 
            						) 
            						<%}%>
            						</font></td>
            				</tr>
            				<tr> 
            					<td height="25" style="font-size : 10pt;"><font face="����">��&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; ��</font></td>
            					<td height="25" style="font-size : 10pt;"><font face="����">:</font></td>
            					<td height="25" style="font-size : 10pt;"><font face="����">
            					<%if(vio_st.equals("2")){	//���ᵵ�ι�	%>
            						���ᵵ�ι����� ����� �ΰ� ó�п� ���� <%if(exp.equals("Y")){%>���� ���� (��ۻ���������� ���� ó�� ��û)<%}else{%>�ǰ� ���� (���·� �����ǹ��� ���� ��û)<%}%>
            					<%}else if(vio_st.equals("3")){	//������� %>
            						����������� ������� �ΰ� ó�п� ���� <%if(exp.equals("Y")){%>���� ���� (��ۻ���������� ���� ó�� ��û)<%}else{%>�ǰ� ���� (���·� �����ǹ��� ���� ��û)<%}%>
            					<%}else if(vio_st.equals("4")){ 	//�����������������%>
            						��������������������� ���·� �ΰ� ó�п� ���� <%if(exp.equals("Y")){%>���� ���� (��ۻ���������� ���� ó�� ��û)<%}else{%>�ǰ� ���� (���·� �����ǹ��� ���� ��û)<%}%>
            					<%}else if(vio_st.equals("5")){  //��⹰������%>
            						��⹰���������� ���·� �ΰ� ó�п� ���� <%if(exp.equals("Y")){%>���� ���� (��ۻ���������� ���� ó�� ��û)<%}else{%>�ǰ� ���� (���·� �����ǹ��� ���� ��û)<%}%>
            					<%}else{	//���α����%>
            						���α�������� ���·� �ΰ� ó�п� ���� <%if(exp.equals("Y")){%>���� ���� (��ۻ���������� ���� ó�� ��û)<%}else{%>�ǰ� ���� (���·� �����ǹ��� ���� ��û)<%}%>
            					<%} %>
            					</font></td>
            				</tr>
            			</table>
            		</td>
            	</tr>
            	<tr> 
            		<td height="20" colspan="2" align='center'></td>
            	</tr>
            	<tr bgcolor=""> 
            		<td colspan=2 align='center' height="3"><hr width=100%></td>
            	</tr>
            	<tr> 
            		<td height="20" colspan=2 align='center'>&nbsp;</td>
            	</tr>
            	<tr> 
            		<td align='center' height="30" width="0" style="font-size : 10pt;"><font face="����">&nbsp;</font></td>
            		<td width="*" height="30" style="font-size : 10pt;"><font face="����">
            			1. �� <%=FineDocBn.getGov_st()%>�� ������ ������ ����մϴ�.
            		</font></td>
            	</tr>
            	<tr> 
            		<td align='center' height="30" style="font-size : 10pt;"><font face="����">&nbsp;</font></td>
            		<td height="30" style="font-size : 10pt;"><font face="����">
            		<%if(vio_st.equals("2")){	//���ᵵ�ι�	%>
            			2. ��翡 �ΰ�(�ΰ�����)�� ���ᵵ�ι����� ����� ó�п� ���Ͽ� �Ʒ��� ����
  					<%}else if(vio_st.equals("3")){	//������� %>
  						2. ��翡 �ΰ�(�ΰ�����)�� ����������� ������� ó�п� ���Ͽ� �Ʒ��� ����
  					<%}else if(vio_st.equals("4")){ 	//�����������������%>
  						2. ��翡 �ΰ�(�ΰ�����)�� ��������������������� ���·� ó�п� ���Ͽ� �Ʒ��� ����
  					<%}else if(vio_st.equals("5")){  //��⹰������%>
  						2. ��翡 �ΰ�(�ΰ�����)�� ��⹰���������� ��Ģ�� �Ǵ� ���·� ó�п� ���Ͽ� �Ʒ��� ����
  					<%}else{	//���α����%>
            			2. ��翡 �ΰ�(�ΰ�����)�� ���α�������� ��Ģ�� �Ǵ� ���·� ó�п� ���Ͽ� �Ʒ��� ���� 
  					<%} %>	
            		</font></td>
            	</tr>
            	<tr>
            		<td height="30" colspan="2" style="font-size : 10pt;"><font face="����"> &nbsp;&nbsp;&nbsp;&nbsp;
            		<%if(vio_st.equals("2")){	//���ᵵ�ι�	%>
            			�ǰ��� �����Ͽ��� (���� ���� ���� ������ ��20��)
  					<%}else if(vio_st.equals("3")){	//������� %>
  						�ǰ��� �����Ͽ��� (������� ��9�� 1��, ���� ���� ���� ������ ��20��)
  					<%}else if(vio_st.equals("4")){ 	//�����������������%>
  						�ǰ��� �����Ͽ��� (���� ���� ���� ������ ��20��)
  					<%}else if(vio_st.equals("5")){  //��⹰������%>
  						�ǰ��� �����Ͽ��� (���ñٰ� ���� ���� ���� ������ ��20��)
  					<%}else{	//���α����%>
            			�ǰ��� �����Ͽ��� (���ñٰ� ���α���� ��160�� 4��)
  					<%} %>
            		</font></td>
            	</tr>
            	<tr> 
            		<td align='center' height="30" style="font-size : 10pt;"><font face="����">&nbsp;</font></td>
            		<td height="30" colspan="2" style="font-size : 10pt;"><font face="����">
            		<%if(vio_st.equals("2")){	//���ᵵ�ι�	%>
            			<%if(exp.equals("Y")){%>3. ������������������ ��21�� 1�� �� ��28���� �ٰ��Ͽ� ���ҹ����� �� ����� �뺸�Ͽ� ������ ó����<%}else{%>3. �����ǹ��ڸ� ��翡�� ���������� ���� ó���Ͽ� �ֽðų�, ���� ���� ���� ������ ��21�� 1�� �� ��28��<%}%>	
  					<%}else if(vio_st.equals("3")){	//������� %>
  						<%if(exp.equals("Y")){%>3. ������������������ ��21�� 1�� �� ��28���� �ٰ��Ͽ� ���ҹ����� �� ����� �뺸�Ͽ� ������ ó����<%}else{%>3. �����ǹ��ڸ� ��翡�� ���������� ���� ó���Ͽ� �ֽðų�, ���� ���� ���� ������ ��21�� 1�� �� ��28��<%}%>
  					<%}else if(vio_st.equals("4")){ 	//�����������������%>
  						<%if(exp.equals("Y")){%>3. ������������������ ��21�� 1�� �� ��28���� �ٰ��Ͽ� ���ҹ����� �� ����� �뺸�Ͽ� ������ ó����<%}else{%>3. �����ǹ��ڸ� ��翡�� ���������� ���� ó���Ͽ� �ֽðų�, ���� ���� ���� ������ ��21�� 1�� �� ��28��<%}%>
  					<%}else if(vio_st.equals("5")){  //��⹰������%>
  						<%if(exp.equals("Y")){%>3. ������������������ ��21�� 1�� �� ��28���� �ٰ��Ͽ� ���ҹ����� �� ����� �뺸�Ͽ� ������ ó����<%}else{%>3. �����ǹ��ڸ� ��翡�� ���������� ���� ó���Ͽ� �ֽðų�, ���� ���� ���� ������ ��21�� 1�� �� ��28��<%}%>
  					<%}else{	//���α����%>
	            		<%if(exp.equals("Y")){%>3. ������������������ ��21�� 1�� �� ��28���� �ٰ��Ͽ� ���ҹ����� �� ����� �뺸�Ͽ� ������ ó����<%}else{%>3. �����ǹ��ڸ� ��翡�� ���������� ���� ó���Ͽ� �ֽðų�, ������������������ ��16�� ��2�� 1�� �� ��28��<%}%>
  					<%} %> 
            		</font></td>
            	</tr>
            	<tr> 
            		<td height="30" colspan="2" style="font-size : 10pt;"><font face="����"> 
            		<%if(exp.equals("Y")){%>
            		&nbsp;&nbsp;&nbsp;&nbsp;�޵��� ó���Ͽ� �ֽʽÿ�.
            		<%}else{%> 
            		&nbsp;&nbsp;&nbsp;&nbsp;�� �ٰ��Ͽ� ���ҹ����� �� ����� �뺸�Ͽ� ������ ó���� �޵��� ó���Ͽ� �ֽʽÿ�.
            		<%}%>
            		</font></td>
            	</tr>    
            	<tr> 
            		<td colspan=2 align='center' height="50" style="font-size : 9pt;"><font size="2" face="����">== ��&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;�� ==</font></td>
            	</tr>
            	<tr bgcolor="#000000"> 
            		<td colspan="2" align='center' height="10" class=line> 
            			<table width="100%" border="0" cellspacing="1" cellpadding="0">
            				<tr bgcolor="#A6FFFF" align="center"> 
            					<td style="font-size : 10pt;" rowspan="2" width="4%" class=title><font face="����">����</font></td>
            					<td style="font-size : 10pt;" rowspan="2" width="14%" class=title><font face="����">�����Ͻ�</font></td>
            					<td style="font-size : 8pt;" rowspan="2" width="11%" class=title><font face="����">������ȣ</font></td>
            					<td style="font-size : 10pt;" colspan="4" height="25" class=title><font face="����">������</font></td>
            				</tr>
            				<tr bgcolor="#FFFFFF"> 
            					<td style="font-size : 8pt;" width="15%" height="25" align="center" bgcolor="#A6FFFF" class=title><font face="����">��ȣ/����</font></td>
            					<td style="font-size : 8pt;" width="18%" align="center" bgcolor="#A6FFFF" class=title><font face="����">�������<br>(���������ȣ)</font></td>
            					<td style="font-size : 8pt;" width="15%" align="center" bgcolor="#A6FFFF" class=title><font face="����">����ڵ�Ϲ�ȣ</font></td>
            					<td style="font-size : 8pt;" width="18%" align="center" bgcolor="#A6FFFF" class=title><font face="����">�Ӵ�Ⱓ</font></td>
            				</tr>
            			</table>
            		</td>
            	</tr>
            </table>
            <table width='<%=img_width%>' height="<%=table2_h%>" border="0" cellpadding="0" cellspacing="0">
            	<tr bgcolor="#000000">
            		<td width="100%" height="10" align='center' class=line>
            			<table width="100%" border="0" cellspacing="1" cellpadding="0">
            				<% if(FineList.size()>0){
            					for(int i=0; i<FineList.size(); i++){ 
            						FineDocListBn = (FineDocListBean)FineList.elementAt(i);
         					 	%>
            				<tr bgcolor="#FFFFFF" align="center">
            					<td width="4%" height="<%=line_h%>" bgcolor="#FFFFFF" style="font-size : 8pt;"><font face="����"><%=i+1%></font></td>
            					<td width="14%" style="font-size : 10pt;"><font face="����"><%=FineDocListBn.getPaid_no()%></font></td>
            					<td width="11%" style="font-size : 10pt;"><font face="����"><%=FineDocListBn.getCar_no()%></font></td>
            					<td width="15%" style="font-size : 8pt;"><font face="����"><%=FineDocListBn.getFirm_nm()%></font></td>
            					<td width="18%" style="font-size : 8pt;"><font face="����">
            						<%if(FineDocListBn.getClient_st().equals("1")){ //���λ����
           									if(!FineDocListBn.getSsn().equals("")){%>
		            							<%=FineDocListBn.getSsn() %>
       								<%	}else{ //���ι�ȣ���� ���λ������ ��� ��ǥ���� ���������ȣ ����(20191008)	%>
										<%if(!FineDocListBn.getLic_no().equals("")){ %>
											<%if(FineDocListBn.getLic_no().length()==12){ %>
								        		(<%=FineDocListBn.getLic_no().substring(0,4)%>-<%=FineDocListBn.getLic_no().substring(4,10)%>-<%=FineDocListBn.getLic_no().substring(10,12)%>)
								        	<%}else{ %>
								        		<%if(FineDocListBn.getLic_no().equals("0")){%><%}else{%>(<%=FineDocListBn.getLic_no()%>)<%}%>
								        	<%} %>
							        	<%} %>
       								<%	} %>
            						<%}else if(FineDocListBn.getClient_st().equals("6")){ //�����%>
            						(�����)
            						<%}else{ //����, ���λ����%>
			            				<%if(FineDocListBn.getSsn().equals("*******")){%><%}else{%><%=String.valueOf(FineDocListBn.getSsn()).substring(0,6) %><%}%><br>
			            				<%if(!FineDocListBn.getLic_no().equals("")){ %>
											<%if(FineDocListBn.getLic_no().length()==12){ %>
								        		(<%=FineDocListBn.getLic_no().substring(0,4)%>-<%=FineDocListBn.getLic_no().substring(4,10)%>-<%=FineDocListBn.getLic_no().substring(10,12)%>)
								        	<%}else{ %>
								        		<%if(FineDocListBn.getLic_no().equals("0")){%><%}else{%>(<%=FineDocListBn.getLic_no()%>)<%}%>
								        	<%} %>
							        	<%} %>
			            			<%} %>
            					</font></td>
            					<td width="15%" style="font-size : 8pt;"><font face="����"><%=AddUtil.ChangeEnt_no(FineDocListBn.getEnp_no())%></font></td>
            					<td width="18%" style="font-size : 8pt;"><font face="����"><input type="text" size='16' value="<%=AddUtil.ChangeDate2(FineDocListBn.getRent_start_dt())+" 00:00"%>~" class="whitetext">
            					  <br><input type="text" size='16' value="<%=AddUtil.ChangeDate2(FineDocListBn.getRent_end_dt())+" 24:00"%>" class="whitetext">
            					  </font></td>
            				</tr>
							<tr bgcolor="#FFFFFF" align="">
								<td colspan="7">&nbsp;&nbsp;&nbsp;������ �߼��ּ� : ( <%=FineDocListBn.getHo_zip()%> ) &nbsp;<%if(!FineDocListBn.getHo_addr().equals("")){%><%=FineDocListBn.getHo_addr()%><%}else{%>����ڵ���� Ȯ�ο��.<%}%></td>
							</tr>
            					<% 	}
            					} %>
            			</table>
            		</td>
            	</tr>
            </table>
			  <%-- <%if(tot_size > 3 ){%>--%>
				<%if((tot_size<7 && tot_size%5 ==1 && tot_size!=1)  || (tot_size-6 > 16 && (tot_size-6)%16 ==1) ){%>
				<p style='page-break-before:always'><br style="height:0; line-height:0"></P>
				<%}%> 
			  <table width='670' height="" border="0" cellpadding="0" cellspacing="0">
				<tr> 
				  <td colspan=2 align='right' height="20" style="font-size : 10pt;"><font face="����">- �� -</font></td>
				</tr>
				<tr> 
				  <td colspan=2 height="20"><font face="����">&nbsp;</font></td>
				</tr>
				<tr> 
				  <td colspan=2 height="20" style="font-size : 10pt;"><font face="����"># ÷&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 
					��</font></td>
				</tr>
				<%for(int i=0; i<app_doc_size; i++){%>
				<tr> 
				  <td width="13%" height="20" style="font-size : 10pt;"><font face="����">&nbsp;</font></td>
				  <td width="87%" height="20" style="font-size : 10pt;"><font face="����">
					<%if(app_doc_v.substring(i,i+1).equals("1")){%>
					1) <%=var3%> 
					<%}%>
					<%if(app_doc_v.substring(i,i+1).equals("2")){%>
					2) <%=var4%> 
					<%}%>
					<!-- �ź����纻 ����(20190910) -->
					<%-- <%if(app_doc_v.substring(i,i+1).equals("3")){%>
					&nbsp;&nbsp;&nbsp;&nbsp;<%=var5%> 
					<%}%> --%>
					<%if(app_doc_v.substring(i,i+1).equals("4")){%>
					3) <%=var6%> 
					<%}%>
					</font></td>
				</tr>
				<%}%>
				<tr> 
				  <td colspan="2"><font face="����">&nbsp;</font></td>
				</tr>
				<tr align="center"> 
				  <td height="140" colspan="2" style="font-size : 19pt;">
				  	<div style="position: relative;">
				  		<font face="����" style="z-index: 1;"><b>�ֽ�ȸ�� �Ƹ���ī ��ǥ�̻� ��&nbsp;&nbsp;��&nbsp;&nbsp;��</b></font>
				  		<img src="/acar/images/stamp.png" style="position:absolute; z-index: 2; left:545px; bottom: -20px; width: 77px;">
				  	</div>	
				  </td>
				</tr>
			  </table>
</form>
</body>
</html>
<script language="JavaScript" type="text/JavaScript">	
<%if(!mode.equals("fine")){%>
	function onprint(){
		factory.printing.header 	= ""; //��������� �μ�
		factory.printing.footer 	= ""; //�������ϴ� �μ�
		factory.printing.portrait 	= true; //true-�����μ�, false-�����μ�    
		factory.printing.leftMargin 	= 12.0; //��������   
		factory.printing.rightMargin 	= 12.0; //��������
		factory.printing.topMargin 	= 20.0; //��ܿ���    
		factory.printing.bottomMargin 	= 10.0; //�ϴܿ���
		<%if(FineDocBn.getPrint_dt().equals("")){%>
		factory.printing.Print(true, window);//arg1-��ȭ����ǥ�ÿ���(true or false), arg2-��ü������orƯ��������
		<%}%>
	}
<%}%>
</script>
