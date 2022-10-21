<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.common.*, acar.forfeit_mng.*, acar.user_mng.*, acar.estimate_mng.*, acar.insur.*"%>
<jsp:useBean id="FineDocDb" 	scope="page" class="acar.forfeit_mng.FineDocDatabase"/>
<jsp:useBean id="FineDocBn" 	scope="page" class="acar.forfeit_mng.FineDocBean"/>
<jsp:useBean id="InsDocListBn" scope="page" class="acar.insur.InsDocListBean"/>
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
	InsDatabase ai_db = InsDatabase.getInstance();
	//����
	FineDocBn = FineDocDb.getFineDoc(doc_id);
	//�������� ����Ʈ
	Vector DocList = ai_db.getInsDocLists(doc_id);
	//�����
	Hashtable ins_com = ai_db.getInsCom(FineDocBn.getGov_id());
	
	EstiDatabase e_db = EstiDatabase.getInstance();
	//����
	String var1 = e_db.getEstiSikVarCase("1", "", "ins1");//���μ���
	String var2 = e_db.getEstiSikVarCase("1", "", "ins2");	//�����?
	String var3 = e_db.getEstiSikVarCase("1", "", "ins_app1");//÷�μ���1
	String var4 = e_db.getEstiSikVarCase("1", "", "ins_app2");//÷�μ���2
	
	if(FineDocBn.getH_mng_id().equals(""))		FineDocBn.setH_mng_id(var1);
	if(FineDocBn.getB_mng_id().equals(""))		FineDocBn.setB_mng_id(var2);
	
	//���������
	UserMngDatabase u_db = UserMngDatabase.getInstance();
	UsersBean h_user = u_db.getUsersBean(FineDocBn.getH_mng_id());
	UsersBean b_user = u_db.getUsersBean(FineDocBn.getB_mng_id());
	
	Hashtable br1 = c_db.getBranch(b_user.getBr_id());
		
	//�μ⿩�� ����
	if(FineDocBn.getPrint_dt().equals("")){
		FineDocDb.changePrint_dt(doc_id, user_id);
	}

	//÷�μ��� ���� ���� => ���������� ÷�μ����� ���̺� ���ԵǾ� �־� ÷�μ����κ� ���� ����� �����Ѵ�.
	int app_doc_h = 0;
	String app_doc_v = "";
	int app_doc_size = app_doc_h/20;
	
	//���� ���μ�
	int tot_size = DocList.size();
	int line_h = 32;
	//������ ����
	int page_h = 850;
	//�� ���̺� �⺻ ����
	int table1_h = 465;
	int table2_h = tot_size*line_h;
	int table3_h = app_doc_h+120;
	
	//����������� ���ϱ�
	int page_cnt = ((table1_h+table2_h+table3_h)/page_h);
	if((table1_h+table2_h+table3_h)%page_h != 0) page_cnt = page_cnt + 1;
	
	//������ ���̺� ���� ���ϱ�
	int height = (page_h*page_cnt)-(table1_h+table2_h);	
%>

<html>
<head><title>FMS</title>
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--
	function onprint(){
		factory.printing.header 	= ""; //��������� �μ�
		factory.printing.footer 	= ""; //�������ϴ� �μ�
		factory.printing.portrait 	= true; //true-�����μ�, false-�����μ�    
		factory.printing.leftMargin 	= 12.0; //��������   
		factory.printing.rightMargin 	= 12.0; //��������
		factory.printing.topMargin 	= 30.0; //��ܿ���    
		factory.printing.bottomMargin 	= 10.0; //�ϴܿ���
		<%if(FineDocBn.getPrint_dt().equals("")){%>	
		factory.printing.Print(true, window);//arg1-��ȭ����ǥ�ÿ���(true or false), arg2-��ü������orƯ��������
		<%}%>
	}
//-->
</script>
</head>
<body leftmargin="15" topmargin="1" onLoad="javascript:onprint()" >
<object id="factory" style="display:none" classid="clsid:1663ed61-23eb-11d2-b92f-008048fdd814" codebase="/smsx.cab#Version=6,4,438,06"> 
</object> 
<form action="" name="form1" method="POST" >
  <table width='670' height="<%=table1_h%>" border="0" cellpadding="0" cellspacing="0">
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
                  <td height="20" style="font-size : 9pt;" ><font face="����">Fax:<%=br1.get("FAX")%></font></td>
                </tr>
                <tr> 
                  <td height="20" style="font-size : 9pt;"><font face="����"><%=h_user.getDept_nm()%>�� 
                    <%=h_user.getUser_nm()%></font></td>
                  <td height="20" style="font-size : 9pt;"><font face="����">����� 
                    <%=b_user.getUser_nm()%>(<%=b_user.getUser_email()%>)</font></td>
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
            <td height="25" style="font-size : 10pt;"><font face="����">��&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 
              ��</font></td>
            <td height="25" style="font-size : 10pt;"><font face="����">:</font></td>
            <td height="25" style="font-size : 10pt;"><font face="����"><%=ins_com.get("INS_COM_NM")%></font></td>
          </tr>
          <tr> 
            <td height="25" style="font-size : 10pt;"><font face="����">��&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 
              ��</font></td>
            <td height="25" style="font-size : 10pt;"><font face="����">:</font></td>
            <td height="25" style="font-size : 10pt;"><font face="����"><%=FineDocBn.getMng_dept()%> 
              <%if(!FineDocBn.getMng_nm().equals("")){%>
              &nbsp; ( <%=FineDocBn.getMng_pos()%> <%=FineDocBn.getMng_nm()%> 
              ) 
              <%}%>
              </font></td>
          </tr>
          <tr> 
            <td height="25" style="font-size : 10pt;"><font face="����">��&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 
              ��</font></td>
            <td height="25" style="font-size : 10pt;"><font face="����">:</font></td>
            <td height="25" style="font-size : 10pt;"><font face="����">�ڵ������� ���� 
              (��û)</font></td>
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
      <td align='center' height="30" width="13%"><font face="����">&nbsp;</font></td>
      <td width="87%" height="30" style="font-size : 10pt;"><font face="����">1. ��<%=FineDocBn.getGov_st()%>�� 
        ������ ������ ����մϴ�.</font></td>
    </tr>
	<!--
    <tr> 
      <td align='center' height="30"><font face="����">&nbsp;</font></td>
      <td height="30" style="font-size : 10pt;"><font face="����">2. ��<%=FineDocBn.getGov_st()%>�� ü���ߴ� �Ʒ� 
        ������ �ڵ������� ����� �Ʒ��� ���� ������ ���������� ��û�Ͽ���</font></td>
    </tr>
	-->
    <tr> 
      <td align='center' height="30"><font face="����">&nbsp;</font></td>
      <td height="30" style="font-size : 10pt;"><font face="����">2. �Ʒ��� ���� ��<%=FineDocBn.getGov_st()%>�� ü���� �ڵ��������� 
        ������ ��û�Ͽ��� ����ó�� �ٶ��ϴ�.</font></td>
    </tr>
    <tr> 
      <td height="31" colspan="2" style="font-size : 10pt;"><font face="����"><!-- ó���ٶ��ϴ�.--></font></td>
    </tr>
    <tr> 
      <td colspan=2 align='center' height="50" style="font-size : 10pt;"><font face="����">== ��&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;�� 
        ==</font></td>
    </tr>
    <tr bgcolor="#000000"> 
      <td colspan="2" align='center' height="10"> <table width="100%" border="0" cellspacing="1" cellpadding="0">
          <tr bgcolor="#FFFFFF" align="center"> 
            <td style="font-size : 8pt;  font-weight:bold" rowspan="2" width="5%"><font face="����">����</font></td>
            <td style="font-size : 8pt;  font-weight:bold" rowspan="2" width="15%"><font face="����">���ǹ�ȣ</font></td>
            <td style="font-size : 8pt;  font-weight:bold" rowspan="2" width="8%"><font face="����">��������</font></td>			
            <td height="25" colspan="2" style="font-size : 8pt;  font-weight:bold"><font face="����">������ȣ</font></td>
            <td width="12%" rowspan="2" style="font-size : 8pt;  font-weight:bold"><font face="����">������</font></td>
            <td width="10%" rowspan="2" style="font-size : 8pt;  font-weight:bold"><font face="����">��������</font></td>
            <td width="24%" rowspan="2" style="font-size : 8pt;  font-weight:bold"><font face="����">÷�μ���</font></td>
          </tr>
          <tr bgcolor="#FFFFFF"> 
            <td width="13%" align="center" style="font-size : 8pt;  font-weight:bold"><font face="����">������</font></td>
            <td style="font-size : 8pt;  font-weight:bold" width="13%" height="25" align="center"><font face="����">������</font></td>
          </tr>
        </table></td>
    </tr>
    <tr> 
      <td height="2" colspan="2"></td>
    </tr>
  </table>
  <table width='670' height="<%=table2_h%>" border="0" cellpadding="0" cellspacing="0">
    <tr bgcolor="#000000">
      <td width="100%" height="10" align='center'><table width="100%" border="0" cellspacing="1" cellpadding="0">
          <% if(DocList.size()>0){
				for(int i=0; i<DocList.size(); i++){ 
					InsDocListBn = (InsDocListBean)DocList.elementAt(i); %>		
          <tr bgcolor="#FFFFFF" align="center">
            <td width="5%" height="<%=line_h%>" bgcolor="#FFFFFF" style="font-size : 8pt;"><font face="����"><%=i+1%></font></td>
            <td width="15%" style="font-size : 7pt;"><font face="����"><%=InsDocListBn.getIns_con_no()%></font></td>
            <td width="8%" style="font-size : 8pt;"><font face="����"><%=InsDocListBn.getExp_st()%></font></td>			
            <td width="13%" style="font-size : 8pt;"><font face="����"><%=InsDocListBn.getCar_no_b()%></font></td>
            <td width="13%" style="font-size : 8pt;"><font face="����"><%=InsDocListBn.getCar_no_a()%></font></td>
            <td width="12%" style="font-size : 8pt;"><font face="����"><%=InsDocListBn.getCar_nm()%></font></td>
            <td width="10%" style="font-size : 8pt;"><font face="����"><%=InsDocListBn.getExp_dt()%></font></td>
            <td width="24%" style="font-size : 8pt;"><font face="����">
            <%if(InsDocListBn.getApp_st().equals("1")) {%><%=var3%><%}else{%><%=var4%><%}%></font></td>
          </tr>
          <% 	}
			} %>
      </table></td>
    </tr>
  </table>
  <table width='670' border="0" cellpadding="0" cellspacing="0">
    <tr>
      <td colspan=2 align='center' height="20"><font face="����">&nbsp;</font></td>
    </tr>
    <tr>
      <td colspan=2 align='right' height="20" style="font-size : 10pt;"><font size="2" face="����">- �� -</font></td>
    </tr>
    <tr>
      <td colspan=2 height="20"><font face="����">&nbsp;</font></td>
    </tr>
    <tr>
      <td colspan="2"><font face="����">&nbsp;</font></td>
    </tr>
    <tr align="center">
      <td height="40" colspan="2" style="font-size : 19pt;"><font face="����"><b>�ֽ�ȸ�� �Ƹ���ī ��ǥ�̻� ��&nbsp;&nbsp;��&nbsp;&nbsp;��</b></font></td>
    </tr>
  </table>
</form>
<DIV id=Layer1 style="Z-INDEX: 1; LEFT: 540px; WIDTH: 68px; POSITION: absolute; TOP: <%=table1_h+table2_h+table3_h-50%>px; HEIGHT: 68px"><IMG src="../../images/gikin.gif" width="110" height="110"></DIV>  
</body>
</html>
