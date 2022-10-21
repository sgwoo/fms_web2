<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.common.*, acar.forfeit_mng.*, acar.user_mng.*, acar.estimate_mng.*"%>
<jsp:useBean id="FineDocDb" scope="page" class="acar.forfeit_mng.FineDocDatabase"/>
<jsp:useBean id="FineGovBn" 	scope="page" class="acar.forfeit_mng.FineGovBean"/>
<jsp:useBean id="FineDocBn" 	scope="page" class="acar.forfeit_mng.FineDocBean"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");//�α���-ID
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");//�α���-������
	String gubun1 = request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String gubun2 = request.getParameter("gubun2")==null?"":request.getParameter("gubun2");
	String gubun3 = request.getParameter("gubun3")==null?"":request.getParameter("gubun3");
	String gubun4 = request.getParameter("gubun4")==null?"":request.getParameter("gubun4");
	String st_dt = request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt = request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	String s_kd = request.getParameter("s_kd")==null?"":request.getParameter("s_kd");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String sort = request.getParameter("sort")==null?"":request.getParameter("sort");
	String asc = request.getParameter("asc")==null?"":request.getParameter("asc");
	
	String doc_id = request.getParameter("doc_id")==null?"":request.getParameter("doc_id");
	String gov_id = request.getParameter("gov_id")==null?"":request.getParameter("gov_id");
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	MaMenuDatabase nm_db = MaMenuDatabase.getInstance();
	
	FineDocBn = FineDocDb.getFineDoc(doc_id);
	FineGovBn = FineDocDb.getFineGov(FineDocBn.getGov_id());
	
	//����Ʈ
	Vector FineList = FineDocDb.getFineDocListsCar_exp(doc_id);
	int fine_size = FineList.size();
	
	if(FineDocBn.getH_mng_id().equals(""))		FineDocBn.setH_mng_id(nm_db.getWorkAuthUser("�����������"));
	if(FineDocBn.getB_mng_id().equals(""))		FineDocBn.setB_mng_id("000155");
//System.out.println("id: "+user_id);	
	//���������
	UserMngDatabase u_db = UserMngDatabase.getInstance();		
	UsersBean h_user = u_db.getUsersBean(FineDocBn.getH_mng_id());
	UsersBean b_user = u_db.getUsersBean(user_id);//FineDocBn.getB_mng_id()
	
	Hashtable br1 = c_db.getBranch(b_user.getBr_id());
		
	//�μ⿩�� ����
	if(FineDocBn.getPrint_dt().equals("")){
		FineDocDb.changePrint_dt(doc_id, user_id);
	}

	EstiDatabase e_db = EstiDatabase.getInstance();
	//����
	String var1 = e_db.getEstiSikVarCase("1", "", "fine1");//���μ���
	String var2 = e_db.getEstiSikVarCase("1", "", "fine2");	//�����	
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
	if(FineDocBn.getApp_doc3().equals("Y")){
		app_doc_h += 20;
		app_doc_v += "3";
	}
	if(FineDocBn.getApp_doc4().equals("Y")){
		app_doc_h += 20;
		app_doc_v += "4";
	}
	int app_doc_size = app_doc_h/20;	
				
	//���� ���μ�
	int tot_size = FineList.size();
	
	//�Ѷ��δ� ����
	int line_h = 48;//20120104 �������ڿ��� �Ͻ÷� �ٲ� 32->48
	
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
	
	
	double img_width 	= 690;
	double img_height 	= 1019;
	
%>

<html>
<head><title>FMS</title>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--

//-->
</script>
</head>
<body leftmargin="15" topmargin="1" onLoad="javascript:onprint()" >
<object id=factory style="display:none" classid="clsid:1663ed61-23eb-11d2-b92f-008048fdd814" codebase="/smsx.cab#Version=6,3,439,30">
</object>
<form action="" name="form1" method="POST" >
  <table width='670' height="<%//=table1_h%>" border="0" cellpadding="0" cellspacing="0">
    <tr> 
      <td colspan="2" height="40" align="center" style="font-size : 18pt;"><b><font face="����">Pick 
        amazoncar! We'll pick you up.</font></b></td>
    </tr>
    <tr> 
      <td colspan="2" height="5" align="center"></td>
    </tr>
    <tr bgcolor="#000000"> 
      <td colspan="2" align='center' height="10"> <table width="100%" border="0" cellspacing="1" cellpadding="0">
          <tr bgcolor="#FFFFFF"> 
            <td height="40"> <table width="100%" border="0" cellspacing="0" cellpadding="5">
                <tr> 
                  <td height="20" colspan="2" style="font-size : 9pt;"><font face="����"><%=br1.get("BR_POST")%>
                    <%=br1.get("BR_ADDR")%></font></td>
                  <td height="20" style="font-size : 9pt;" ><font face="����">Tel:<%=b_user.getHot_tel()%></font></td>
                  <td height="20" style="font-size : 9pt;" ><font face="����">Fax:<%if(b_user.getDept_id().equals("0002")){%>02-3775-4243<%}else{%><%=br1.get("FAX")%><%}%></font></td>
                </tr>
                <tr> 
                  <td height="20" style="font-size : 9pt;"><font face="����"><%=h_user.getDept_nm()%>�� 
                    <%=h_user.getUser_nm()%></font></td>
                  <td height="20" style="font-size : 9pt;"><font face="����">����� 
                    <%=b_user.getUser_nm()%>(tax200@amazoncar.co.kr<%//=b_user.getUser_email()%>)</font></td>
                  <td height="20" colspan="2" style="font-size : 9pt;"><font face="����">http://www.amazoncar.co.kr</font></td>
                </tr>
              </table></td>
          </tr>
        </table></td>
    </tr>
    <tr> 
      <td height="20" colspan="2" align='center'></td>
    </tr>
    <tr> 
      <td height="125" colspan="2" align='center'> <table width="100%" border="0" cellspacing="0" cellpadding="0">
          <tr> 
            <td width="10%" height="25" style="font-size : 10pt;"><font face="����">������ȣ</font></td>
            <td width="3%" height="25" style="font-size : 10pt;"><font face="����">:</font></td>
            <td height="25" width="87%" style="font-size : 10pt;"><font face="����"><%=FineDocBn.getDoc_id()%> 
              </font></td>
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
            <td height="25" style="font-size : 10pt;"><font face="����">�ڵ����� �������� �����</font></td>
          </tr>
          <tr> 
            <td height="25" style="font-size : 10pt;"><font face="����">��&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; ��</font></td>
            <td height="25" style="font-size : 10pt;"><font face="����">:</font></td>
            <td height="25" style="font-size : 10pt;"><font face="����"> �ڵ����� ȯ�޽�û��</td>
          </tr>
        </table></td>
    </tr>
    <tr> 
      <td height="20" colspan="2" align='center'></td>
    </tr>
    <tr bgcolor="#999999"> 
      <td colspan=2 align='center' height="3" bgcolor="#333333"></td>
    </tr>
    <tr> 
      <td height="20" colspan=2 align='center'>&nbsp;</td>
    </tr>
    <tr> 
      <td align='center' height="30" width="13%" style="font-size : 10pt;"><font face="����">&nbsp;</font></td>
      <td width="87%" height="30" style="font-size : 10pt;"><font face="����">1. �� <%=FineDocBn.getGov_st()%>�� 
        ������ ������ ����մϴ�.</font></td>
    </tr>
    <tr> 
      <td align='center' height="30" style="font-size : 10pt;"><font face="����">&nbsp;</font></td>
      <td height="30" style="font-size : 10pt;"><font face="����">2. ��� ������ �Ʒ��� ���� �Ű� �Ǵ� �뵵���� �Ǿ������� �ⳳ����
        </font></td>
    </tr>
    <tr> 
      <td height="30" colspan="2" style="font-size : 10pt;"><font face="����">  �ڵ������� ���Ͽ� ȯ���� ��û�մϴ�.
        </font></td>
    </tr>
    <tr> 
      <td height="10" colspan="2" style="font-size : 10pt;"><font face="����"></font></td>
    </tr>    
    <tr> 
      <td colspan=2 align='center' height="50" style="font-size : 9pt;"><font size="2" face="����">== ��&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;�� 
        ==</font></td>
    </tr>
    <tr bgcolor="#000000"> 
		<td colspan="2" align='center' height="60">
			<table width="100%" border="0" cellspacing="1" cellpadding="0">
				<tr bgcolor="#A6FFFF" align="center"> 
					<td style="font-size : 8pt;" width="5%" height="36" rowspan="3"><font face="����">����</font></td>
					<td style="font-size : 8pt;" width="15%" rowspan="3"><font face="����" >������ȣ</font></td>
					<td style="font-size : 8pt;" width="15%" rowspan="3"><font face="����">����</font></td>
					<td style="font-size : 8pt;" width="12%" align="center" bgcolor="#A6FFFF"  rowspan="3"><font face="����">�ڵ�����������</font></td>
					<td style="font-size : 8pt;" width="58%" colspan="3" height="20"><font face="����">ȯ�޽�û����</font></td>
				</tr>
				<tr>
					<td style="font-size : 8pt;" width="33%" align="center"  height="20" bgcolor="#A6FFFF" colspan="2"><font face="����">�����ں���</font></td>
					<td style="font-size : 8pt;" width="20%" align="center"  height="40" bgcolor="#A6FFFF" rowspan="2"><font face="����">�뵵����</font></td>
				</tr>
				<tr>
					<td style="font-size : 8pt;" width="20%" align="center" bgcolor="#A6FFFF" height="20"><font face="����">������</font></td>
					<td style="font-size : 8pt;" width="13%" align="center" bgcolor="#A6FFFF" height="20"><font face="����">��������</font></td>
					
				</tr>
			</table>
    </tr>
		</td>
    <tr>
      <td height="2" colspan="2"></td>
    </tr>
  </table>
  <table width='670' height="<%//=table2_h%>" border="0" cellpadding="0" cellspacing="0">
    <tr bgcolor="#000000">
		<td width="100%" height="15" align='center'>
			<table width="100%" border="0" cellspacing="1" cellpadding="0">
				<% if(FineList.size()>0){
					for(int i=0; i<fine_size; i++){ 
						Hashtable ht = (Hashtable)FineList.elementAt(i);		%>
				<tr bgcolor="#FFFFFF" align="center">
					<td width="5%" height="25" bgcolor="#FFFFFF" style="font-size : 8pt;"><font face="����"><%=i+1%></font></td>
					<td width="15%" style="font-size : 15pt;"><font face="����"><b><%=ht.get("CAR_NO")%></b></font></td>
					<td width="15%" style="font-size : 12;"><font face="����"><%=ht.get("CAR_NM")%></font></td>
					<td width="12%" style="font-size : 8pt;"><font face="����"><%=AddUtil.ChangeDate2(String.valueOf(ht.get("EXP_DT")))%></font></td>
					<td width="20%" style="font-size : 8pt;"><font face="����"><%=ht.get("FIRM_NM")%></font></td>
					<td width="13%" style="font-size : 8pt;"><font face="����"><%=AddUtil.ChangeDate2(String.valueOf(ht.get("MIGR_DT")))%></font></td>
					<td width="20%" style="font-size : 8pt;"><font face="����"><%=ht.get("CHA_CONT")%></font></td>
					
				</tr>
				<% 	}
					}	 %>
			</table>
		</td>
    </tr>
	<tr>
      <td height="2" colspan="2"></td>
    </tr>
  </table>
	<table width='670' height="<%//=table2_h%>" border="0" cellpadding="0" cellspacing="0">
    <tr bgcolor="#000000">
		<td width="100%" height="10" align='center'>
			<table width="100%" border="0" cellspacing="1" cellpadding="0">
				<tr bgcolor="#FFFFFF" align="center">
					<td width="10%" height="25" bgcolor="#A6FFFF" style="font-size : 8pt;"><font face="����"> �����</font></td>
					<td width="15%" style="font-size : 8pt;" ><font face="����"><%if(h_user.getBr_id().equals("S1")){%>��������<%}else if(h_user.getBr_id().equals("B1")){%>�λ�����<%}%></font></td>
					<td width="10%" style="font-size : 8pt;" bgcolor="#A6FFFF"><font face="����">���¹�ȣ</font></td>
					<td width="25%" style="font-size : 8pt;" ><font face="����"><%if(h_user.getBr_id().equals("S1")){%>140-004-023871<%}else if(h_user.getBr_id().equals("B1")){%>316-13-000119-8<%}%></font></td>
					<td width="10%" style="font-size : 8pt;"bgcolor="#A6FFFF"><font face="����">������</font></td>
					<td width="20%" style="font-size : 8pt;"><font face="����">(��)�Ƹ���ī</font></td>
				</tr>
			</table>
		</td>
    </tr>
  </table>
  <table width='670' height="<%//=height%>" border="0" cellpadding="0" cellspacing="0">
    <tr> 
      <td colspan=2 align='center' height="20"><font face="����">&nbsp;</font></td>
    </tr>
    <tr> 
      <td colspan=2 align='right' height="20" style="font-size : 10pt;"><font face="����">- �� -</font></td>
    </tr>
    <tr> 
      <td colspan=2 height="20"><font face="����">&nbsp;</font></td>
    </tr>
    <tr> 
      <td colspan="2"><font face="����">&nbsp;</font></td>
    </tr>
    <tr align="center"> 
      <td height="40" colspan="2"><img src=/acar/images/center/ceo_stp.gif ></td>
    </tr>
  </table>
  
</form>
</body>
</html>
<script language="JavaScript" type="text/JavaScript">	

	function onprint(){
		factory.printing.header 	= ""; //��������� �μ�
		factory.printing.footer 	= ""; //�������ϴ� �μ�
		factory.printing.portrait 	= true; //true-�����μ�, false-�����μ�    
		factory.printing.leftMargin 	= 12.0; //��������   
		factory.printing.rightMargin 	= 12.0; //��������
		factory.printing.topMargin 	= 30.0; //��ܿ���    
		factory.printing.bottomMargin 	= 30.0; //�ϴܿ���
		<%if(FineDocBn.getPrint_dt().equals("")){%>
		//factory.printing.Print(true, window);//arg1-��ȭ����ǥ�ÿ���(true or false), arg2-��ü������orƯ��������
		<%}%>
	}

</script>
