<html>
<head>
<meta http-equiv=Content-Type content=text/html; charset=euc-kr>
<title>�Ƹ���ī �ڵ����� ȯ�޴�� ����Ʈ �ȳ���</title>
<style type="text/css">
<!--
.style1 {color: #88b228}
.style2 {color: #747474}
.style3 {color: #ffffff}
.style4 {color: #707166; font-weight: bold;}
.style5 {color: #e86e1b}
.style6 {color: #385c9d; font-weight: bold;}
.style7 {color: #77786b}
.style8 {color: #e60011}
.style9 {color: #707166; font-weight: bold;}
.style10 {color: #454545; font-size:8pt;}
.style11 {color: #6b930f; font-size:8pt;}
.style12 {color: #77786b; font-size:8pt;}
.style14 {color: #af2f98; font-size:8pt;}
.style15 {color: #334ec5;}
-->
</style>
<link href=http://www.amazoncar.co.kr/style.css rel=stylesheet type=text/css>
</head>

<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.forfeit_mng.*, acar.user_mng.*, acar.estimate_mng.*"%>
<jsp:useBean id="FineDocDb" scope="page" class="acar.forfeit_mng.FineDocDatabase"/>
<jsp:useBean id="FineGovBn" 	scope="page" class="acar.forfeit_mng.FineGovBean"/>
<jsp:useBean id="FineDocBn" 	scope="page" class="acar.forfeit_mng.FineDocBean"/>
<%//@ include file="/acar/cookies.jsp" %>

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
	
	MaMenuDatabase nm_db = MaMenuDatabase.getInstance();
	
	FineDocBn = FineDocDb.getFineDoc(doc_id);
	FineGovBn = FineDocDb.getFineGov(FineDocBn.getGov_id());
	
	//���·Ḯ��Ʈ
	Vector FineList = FineDocDb.getFineDocListsCar_exp(doc_id);
	int fine_size = FineList.size();
	
	if(FineDocBn.getH_mng_id().equals(""))		FineDocBn.setH_mng_id(nm_db.getWorkAuthUser("�����������"));
	if(FineDocBn.getB_mng_id().equals(""))		FineDocBn.setB_mng_id("000155");

	
	
%>

<body topmargin=0 leftmargin=0>
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
                  <td height="20" colspan="2" style="font-size : 9pt;"><font face="����">150-874
                    ���� �������� ���ǵ��� 17-3 ��ȯ��º��� 802ȣ<%//=br1.get("BR_ADDR")%></font></td>
                  <td height="20" style="font-size : 9pt;" ><font face="����">Tel: 02-392-4243</font></td>
                  <td height="20" style="font-size : 9pt;" ><font face="����">Fax: 02-757-0803</font></td>
                </tr>
                <tr> 
                  <td height="20" style="font-size : 9pt;"><font face="����">�ѹ���<%//=h_user.getDept_nm()%>�� 
                    �Ⱥ���<%//=h_user.getUser_nm()%></font></td>
                  <td height="20" style="font-size : 9pt;"><font face="����">����� 
                    ���ֿ�<%//=b_user.getUser_nm()%>(tax200@amazoncar.co.kr)</font></td>
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
					<td style="font-size : 8pt;" width="10%" rowspan="3"><font face="����" >������ȣ</font></td>
					<td style="font-size : 8pt;" width="15%" rowspan="3"><font face="����">����</font></td>
					<td style="font-size : 8pt;" width="12%" align="center" bgcolor="#A6FFFF"  rowspan="3"><font face="����">�ڵ�����������</font></td>
					<td style="font-size : 8pt;" width="58%" colspan="3" height="20"><font face="����">ȯ�޽�û����</font></td>
				</tr>
				<tr>
					<td style="font-size : 8pt;" width="33%" align="center"  height="20" bgcolor="#A6FFFF" colspan="2"><font face="����">�����ں���</font></td>
					<td style="font-size : 8pt;" width="25%" align="center"  height="40" bgcolor="#A6FFFF" rowspan="2"><font face="����">�뵵����</font></td>
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
		<td width="100%" height="10" align='center'>
			<table width="100%" border="0" cellspacing="1" cellpadding="0">
				<% if(FineList.size()>0){
					for(int i=0; i<fine_size; i++){ 
						Hashtable ht = (Hashtable)FineList.elementAt(i);		%>
				<tr bgcolor="#FFFFFF" align="center">
					<td width="5%" height="25" bgcolor="#FFFFFF" style="font-size : 8pt;"><font face="����"><%=i+1%></font></td>
					<td width="10%" style="font-size : 8pt;"><font face="����"><%=ht.get("CAR_NO")%></font></td>
					<td width="15%" style="font-size : 8pt;"><font face="����"><%=ht.get("CAR_NM")%></font></td>
					<td width="12%" style="font-size : 8pt;"><font face="����"><%=AddUtil.ChangeDate2(String.valueOf(ht.get("EXP_DT")))%></font></td>
					<td width="20%" style="font-size : 8pt;"><font face="����"><%=ht.get("FIRM_NM")%></font></td>
					<td width="13%" style="font-size : 8pt;"><font face="����"><%=AddUtil.ChangeDate2(String.valueOf(ht.get("MIGR_DT")))%></font></td>
					<td width="25%" style="font-size : 8pt;"><font face="����"><%=ht.get("CHA_CONT")%></font></td>
					
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
					<td width="15%" style="font-size : 8pt;" ><font face="����">��������</font></td>
					<td width="10%" style="font-size : 8pt;" bgcolor="#A6FFFF"><font face="����">���¹�ȣ</font></td>
					<td width="25%" style="font-size : 8pt;" ><font face="����">140-004-023871</font></td>
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
      <td height="40" colspan="2"><img src=http://fms1.amazoncar.co.kr/acar/images/center/ceo_stp.gif ></td>
    </tr>
  </table>
  
</body>
</html>