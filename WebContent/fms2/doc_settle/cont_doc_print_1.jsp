<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.cont.*, acar.car_office.*, acar.res_search.*, acar.ext.*, acar.doc_settle.*"%>
<%@ page import="acar.user_mng.*, acar.car_sche.*, acar.fee.*, acar.insur.*, acar.accid.*"%>
<jsp:useBean id="d_db" scope="page" class="acar.doc_settle.DocSettleDatabase"/>
<jsp:useBean id="ins" 	class="acar.insur.InsurBean" 			scope="page"/>
<jsp:useBean id="user_bean" class="acar.user_mng.UsersBean" scope="page"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	UserMngDatabase umd = UserMngDatabase.getInstance();
	InsDatabase ins_db = InsDatabase.getInstance();
	AccidDatabase as_db = AccidDatabase.getInstance();
	
	String ch_cd[] = request.getParameterValues("ch_cd");
	
	int vid_size =	ch_cd.length;
	
	String ins_doc_no = "";
	
	for(int i=0;i < vid_size;i++){
		ins_doc_no = ch_cd[i];
	}
	
  //���躯��
	InsurChangeBean d_bean = ins_db.getInsChangeDoc(ins_doc_no);
	
	DocSettleBean doc = d_db.getDocSettleCommi("42",ins_doc_no);
	
	user_bean 	= umd.getUsersBean(doc.getUser_id1());
	
	//���躯�渮��Ʈ
	Vector ins_cha = ins_db.getInsChangeDocList(ins_doc_no);
	int ins_cha_size = ins_cha.size();
	InsurChangeBean cha = new InsurChangeBean();
	for(int j = 0 ; j < ins_cha_size ; j++){
		cha = (InsurChangeBean)ins_cha.elementAt(j);
	}
	
	//�����ȸ
	Hashtable cont = as_db.getRentCase(d_bean.getRent_mng_id(), d_bean.getRent_l_cd());
	
%>

<html>
<head><title>FMS</title>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<script language='JavaScript' src='/include/common.js'></script>
<%@ include file="/acar/getNaviCookies.jsp" %>
<script language='javascript'>
	
	onprint();


function onprint(){
	var userAgent = navigator.userAgent.toLowerCase();
	if (userAgent.indexOf("edge") > -1) {
		window.print();
	} else if (userAgent.indexOf("whale") > -1) {
		window.print();
	} else if (userAgent.indexOf("chrome") > -1) {
		window.print();
	} else if (userAgent.indexOf("firefox") > -1) {
		window.print();
	} else if (userAgent.indexOf("safari") > -1) {
		window.print();
	} else {
		factory.printing.header 	= ""; //��������� �μ�
		factory.printing.footer 	= ""; //�������ϴ� �μ�
		factory.printing.portrait 	= true; //true-�����μ�, false-�����μ�    
		factory.printing.leftMargin 	= 12.0; //��������   
		factory.printing.rightMargin 	= 12.0; //��������
		factory.printing.topMargin 	= 30.0; //��ܿ���    
		factory.printing.bottomMargin 	= 30.0; //�ϴܿ���
		factory.printing.Print(true, window);//arg1-��ȭ����ǥ�ÿ���(true or false), arg2-��ü������orƯ��������	
	}
}

<!--
	function pagesetPrint(){
		IEPageSetupX.header='';
		IEPageSetupX.footer='';
		IEPageSetupX.leftMargin=12;
		IEPageSetupX.rightMargin=12;
		IEPageSetupX.topMargin=30;
		IEPageSetupX.bottomMargin=30;	
		print();
	}
//-->
</script>
</head>
<body leftmargin="15" topmargin="1" onLoad="javascript:onprint()" >
<!-- <OBJECT id=IEPageSetupX classid="clsid:41C5BC45-1BE8-42C5-AD9F-495D6C8D7586" codebase="/pagesetup/IEPageSetupX.cab#version=1,0,18,0" width=0 height=0>	
	<param name="copyright" value="http://isulnara.com">
</OBJECT> -->
<object id=factory style="display:none" classid="clsid:1663ed61-23eb-11d2-b92f-008048fdd814" codebase="/smsx.cab#Version=6,3,439,30">
</object>
<form action="" name="form1" method="POST" >
  <table width='600' height="230" border="0" cellpadding="0" cellspacing="0">
    <tr> 
      <td height="30" align="center"></td>
    </tr>
    <tr> 
      <td height="50" align="center" style="font-size : 18pt;"><b><font face="����">�����̿��� Ȯ�ο�û��</font></b></td>
    </tr>
    <tr> 
      <td height="50" align='center'></td>
    </tr>
    <tr> 
      <td height="10" align='center'></td>
    </tr>
    <tr bgcolor="#000000"> 
      <td align='center' height="30"> 
	    <table width="100%" height="100%" border="0" cellspacing="1" cellpadding="0">
          <tr align="center" bgcolor="#FFFFFF"> 
            <td style="font-size : 10pt;  font-weight:bold" width="20%"><font face="����">������ȣ</font></td>
            <td style="font-size : 10pt;  font-weight:bold" width="15%"><font face="����">��������</font></td>
            <td style="font-size : 10pt;  font-weight:bold" width="15%"><font face="����">�����̿���</font></td>
            <td style="font-size : 10pt;  font-weight:bold" width="30%"><font face="����">���������ȣ</font></td>
            <td style="font-size : 10pt;  font-weight:bold" width="20%"><font face="����">����</font></td>			
          </tr>
        </table>
	  </td>
    </tr>
    <tr> 
      <td height="2" colspan="2"></td>
    </tr>	
  </table>
  <table width='600' " border="0" cellpadding="0" cellspacing="0">
    <tr bgcolor="#000000">
      <td width="100%" align='center'>
	    <table width="100%" border="0" cellspacing="1" cellpadding="0">
          <tr bgcolor="#FFFFFF" align="center"  height="50">
            <td style="font-size : 10pt;" width="20%"><font face="����"><%=cont.get("CAR_NO")%></font></td>
            <td style="font-size : 10pt;" width="15%"><font face="����"><%=AddUtil.ChangeDate2(d_bean.getCh_dt())%></font></td>
            <%
            		int s=0; 
								String app_value[] = new String[7];	
								
								if(cha.getCh_after().length() > 0){
									StringTokenizer st = new StringTokenizer(cha.getCh_after(),"||");
									while(st.hasMoreTokens()){
										app_value[s] = st.nextToken();
										//out.println(s+")"+app_value[s]);
										s++;
									}
								}
            %>
            <td style="font-size : 10pt;" width="15%" ><font face="����"><%=app_value[0]%></font></td>
            <td style="font-size : 10pt;" width="30%"><font face="����"><%=app_value[4]%></font></td>
            <td style="font-size : 10pt;" width="20%"><font face="����"><%=app_value[1]%></font></td>			
          </tr>          
      </table></td>
    </tr>
  </table>
  <table width='600' border="0" cellpadding="0" cellspacing="0">
    <tr> 
      <td colspan=4 align='center' height="40"><font face="����">&nbsp;</font></td>
    </tr>
    <tr> 
	  <td align='center' height="20"><font face="����">&nbsp;</font></td>	
      <td colspan=3 style="font-size : 13pt;"><font face="����">���� ���� ����� ������ Ȯ���� ��û�մϴ�.</font></td>
    </tr>
    <tr> 
      <td colspan=4 height="60"><font face="����">&nbsp;</font></td>
    </tr>
    <tr> 
      <td colspan=4 align='center' style="font-size : 13pt;"><font face="����"><%=AddUtil.getDate3()%></font></td>
    </tr>
    <tr> 
      <td colspan=4 height="80"><font face="����">&nbsp;</font></td>
    </tr>
    <tr> 
	  <td align='center' width="10%" height="20"><font face="����">&nbsp;</font></td>	
	  <td align='center' width="10%"><font face="����">&nbsp;</font></td>		  
	  <td align='center' width="10%"><font face="����">&nbsp;</font></td>		  
      <td align='right' width="70%" style="font-size : 13pt;"><font face="����">��&nbsp;&nbsp;&nbsp;��&nbsp;&nbsp;&nbsp;��&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;(��)</font></td>
    </tr>
    <tr> 
      <td colspan=4 height="40"><font face="����">&nbsp;</font></td>
    </tr>
    <tr> 
	  <td align='center' width="10%" height="20"><font face="����">&nbsp;</font></td>	
	  <td align='center' width="10%"><font face="����">&nbsp;</font></td>		  
	  <td align='center' width="10%"><font face="����">&nbsp;</font></td>		  
      <td align='right' width="70%" style="font-size : 13pt;"><font face="����">�����̿���&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;(��)</font></td>
    </tr>
    <tr> 
      <td colspan=4 height="80"><font face="����">&nbsp;</font></td>
    </tr>
    <tr> 
      <td colspan=4 height="30" style="font-size : 12pt;"><font face="����">�� �� ���� �����, �����̿��ڶ��� ���ʼ����� �Ͻð� �Ʒ� �ѽ���ȣ�� ȸ�����ֽʽÿ�.</font></td>
    </tr>
    <tr> 
      <td colspan=4 height="30" style="font-size : 12pt;"><font face="����">����� �ѽ���ȣ : <%=user_bean.getUser_nm()%> (FAX <%=user_bean.getI_fax()%>)</font></td>
    </tr>
    <tr> 
      <td colspan=4 height="30" style="font-size : 12pt;"><font face="����">��������� : <%=cont.get("USER_NM")%> (TEL <%=cont.get("USER_M_TEL")%>)</font></td>
    </tr>
    <tr> 
      <td colspan="4"><font face="����">&nbsp;</font></td>
    </tr>
    <tr align='right'> 
      <td height="40" colspan="4" style="font-size : 13pt;"><font face="����"><b>�ֽ�ȸ�� 
        �Ƹ���ī ����</b></font></td>
    </tr>
  </table>
</form>
</body>
</html>
