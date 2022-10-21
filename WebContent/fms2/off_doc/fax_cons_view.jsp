<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.user_mng.*, acar.common.*" %>
<jsp:useBean id="user_bean" class="acar.user_mng.UsersBean" scope="page"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	//����ں� ���� ��ȸ �� ���� ������
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String cmd 		= request.getParameter("cmd")==null?"":request.getParameter("cmd");
	
	String br_id = "";
	String br_nm = "";
	String user_nm = "";
	String id = "";
	String user_psd = "";
	String user_cd = "";
	String user_ssn = "";
	String user_ssn1 = "";
	String user_ssn2 = "";
	String dept_id = "";
	String dept_nm = "";
	String user_h_tel = "";
	String user_m_tel = "";
	String user_email = "";
	String user_pos = "";
	String lic_no = "";
	String lic_dt = "";
	String enter_dt = "";
	String user_zip = "";
	String user_addr = "";
	String content = "";
	String filename = "";
	String user_aut2 = "";
	String user_work = "";
	int count = 0;
	
	UserMngDatabase umd = UserMngDatabase.getInstance();
	//����� ���� ��ȸ
	user_bean 	= umd.getUsersBean(user_id);
	br_id 		= user_bean.getBr_id();
	br_nm 		= user_bean.getBr_nm();
	user_nm 	= user_bean.getUser_nm();
	id 			= user_bean.getId();
	user_psd 	= user_bean.getUser_psd();
	user_cd 	= user_bean.getUser_cd();
	user_ssn 	= user_bean.getUser_ssn();
	user_ssn1 	= user_bean.getUser_ssn1();
	user_ssn2 	= user_bean.getUser_ssn2();
	dept_id 	= user_bean.getDept_id();
	dept_nm 	= user_bean.getDept_nm();
	user_h_tel 	= user_bean.getUser_h_tel();
	user_m_tel 	= user_bean.getUser_m_tel();
	user_email 	= user_bean.getUser_email();
	user_pos 	= user_bean.getUser_pos();
	user_aut2 	= user_bean.getUser_aut();
	lic_no 		= user_bean.getLic_no();
	lic_dt 		= user_bean.getLic_dt();
	enter_dt 	= user_bean.getEnter_dt();
	content 	= user_bean.getContent();
	filename 	= user_bean.getFilename();
	user_work 	= user_bean.getUser_work();
	
	//����-������
	Hashtable br1 = c_db.getBranch(br_id);
	
	String br_addr 	= String.valueOf(br1.get("BR_ADDR"));
	String br_tel 	= String.valueOf(br1.get("TEL"));
	String br_fax 	= String.valueOf(br1.get("FAX"));
	
	if(dept_nm.equals("��������")){
		br_tel = "02-392-4242";
		br_fax = "02-3775-4243";
	}
	if(dept_nm.equals("�ѹ���")){
		br_tel = "02-392-4243";
	}
	
	String s_com_nm 	= request.getParameter("s_com_nm")==null?"":request.getParameter("s_com_nm");
	String s_agnt_nm 	= request.getParameter("s_agnt_nm")==null?"":request.getParameter("s_agnt_nm");
	String s_tel 		= request.getParameter("s_tel")==null?"":request.getParameter("s_tel");
	String s_fax 		= request.getParameter("s_fax")==null?"":request.getParameter("s_fax");
	String b_com_nm 	= request.getParameter("b_com_nm")==null?"":request.getParameter("b_com_nm");
	String b_agnt_nm 	= request.getParameter("b_agnt_nm")==null?"":request.getParameter("b_agnt_nm");
	String b_tel 		= request.getParameter("b_tel")==null?"":request.getParameter("b_tel");
	String b_fax 		= request.getParameter("b_fax")==null?"":request.getParameter("b_fax");
	String cnt 			= request.getParameter("cnt")==null?"":request.getParameter("cnt");
	String dt 			= request.getParameter("dt")==null?"":request.getParameter("dt");
	String title	 	= request.getParameter("title")==null?"":request.getParameter("title");
	String memo		 	= request.getParameter("memo")==null?"":request.getParameter("memo");
	
	String cont = HtmlUtil.htmlBR(memo);
%>

<html>
<head>
<meta http-equiv=Content-Type content=text/html; charset=euc-kr>
<title>FAXĿ��</title>
<style type=text/css>
<!--
.style1 {font-size: 12px; font-weight: bold;}

-->
</style>
<link href=http://www.amazoncar.co.kr/style.css rel=stylesheet type=text/css>
</head>
<body topmargin=0 leftmargin=0 rightmargin=0 bottommargin=0 <%if(cmd.equals("print")){%>onLoad="javascript:print(document)"<%}%>>

<center>
<table width=640 border=0 cellspacing=0 cellpadding=0>
    <tr>
        <td><img src=/fms2/off_doc/images/fax01_1.gif></td>
    </tr>
    <tr>
        <td>&nbsp;</td>
    </tr>
    <tr>
        <td align=right>
            <table width=640 border=0 cellspacing=0 cellpadding=0>
                <tr>
                    <td height=18 align=right><%=br_addr%></td>
                </tr>
                <tr>
                    <td height=18 align=right>TEL. <%=br_tel%> &nbsp;|&nbsp; FAX. <%=br_fax%> </td>
                </tr>
                <tr>
                    <td align=right style='font-size:11px'><b>http://www.amazoncar.co.kr</b></td>
                </tr>
            </table>
        </td>
    </tr>
    <tr>
        <td height=10></td>
    </tr>
    <tr>
        <td align=right>
            <table width=640 border=0 cellspacing=0 cellpadding=0>
                <tr>
                    <td colspan=7>
                        <table width=640 border=0 cellspacing=0 cellpadding=0>
                            <tr>
                                <td height=40 style='font-size:14px;'>&nbsp;&nbsp;<b><%=s_com_nm%> �� ����</b></td>
                                <td align=right valign=bottom><b><%=dt%></b></td>
                            </tr>
                        </table>
                    </td>
                </tr>
                <tr>
                    <td colspan=7 height=2 bgcolor=#000000></td>
                </tr>
                <tr>
                    <td height=15></td>
                </tr>
                <tr>
                    <td width=85 align=center height=24><span class=style1>��&nbsp; ��&nbsp;��</span></td>
                    <td width=15><img src=/fms2/off_doc/images/fax01_3.gif align=absmiddle></td>
                    <td width=214 style='font-size:14px;'><b><%=s_agnt_nm%></b></td>
                    <td width=12>&nbsp;</td>
                    <td width=85 align=center><span class=style1>��&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;��</span></td>
                    <td width=15><img src=/fms2/off_doc/images/fax01_3.gif align=absmiddle></td>
                    <td width=214 style='font-size:14px;'><b><%=b_com_nm%></b></td>
                </tr>
                <tr>
                    <td align=center height=24><span class=style1>��ȭ��ȣ</span></td>
                    <td><img src=/fms2/off_doc/images/fax01_3.gif align=absmiddle></td>
                    <td style='font-size:14px;'><b><%=s_tel%></b></td>
                    <td>&nbsp;</td>
                    <td align=center><span class=style1>��&nbsp; ��&nbsp;��</span></td>
                    <td><img src=/fms2/off_doc/images/fax01_3.gif align=absmiddle></td>
                    <td style='font-size:14px;'><b><%=b_agnt_nm%></b></td>
                </tr>
                <tr>
                    <td align=center height=24><span class=style1>�ѽ���ȣ</span></td>
                    <td><img src=/fms2/off_doc/images/fax01_3.gif align=absmiddle></td>
                    <td style='font-size:14px;'><b><%=s_fax%></b></td>
                    <td>&nbsp;</td>
                    <td align=center><span class=style1>��ȭ��ȣ</span></td>
                    <td><img src=/fms2/off_doc/images/fax01_3.gif align=absmiddle></td>                    
                    <td style='font-size:14px;'><b><%=b_tel%></b></td>
                </tr>
                <tr>
                    <td align=center height=24><span class=style1>��&nbsp; ��&nbsp;��</span></td>
                    <td><img src=/fms2/off_doc/images/fax01_3.gif align=absmiddle></td>
                    <td style='font-size:14px;'><b><%=cnt%>�� (ǥ������)</b></td>
                    <td>&nbsp;</td>
                    <td align=center><span class=style1>�ѽ���ȣ</span></td>
                    <td><img src=/fms2/off_doc/images/fax01_3.gif align=absmiddle></td>
                    <td style='font-size:14px;'><b><%=b_fax%></b></td>
                </tr>
                <tr>
                    <td height=13></td>
                </tr>
                <tr>
                    <td colspan=7 height=1 bgcolor=#000000></td>
                </tr>
                <tr>
                    <td colspan=7 height=40 align=absmiddle style='font-size:14px'>&nbsp;&nbsp;<img src=/fms2/off_doc/images/fax01_4.gif>&nbsp;&nbsp;<b>���·ᡤ����ᡤ������� ������ �߱ޱ�� �ȳ�</b></td>
                </tr>
                <tr>
                    <td colspan=7 height=2 bgcolor=#000000></td>
                </tr>
            </table>
        </td>
    </tr>
    <tr>
        <td height=40></td>
    </tr>
    <tr>
        <td valign=top align=center>
            <table width=620 border=0 cellspacing=0 cellpadding=0>
                <tr>
                    <td valign=top>&nbsp;���Բ��� ��ó ���� ���� ���·�(�ڵ����������), ���ᵵ�������, ������� ���� ��簡 ������ ����� ��<br>
                      &nbsp;�����ϰ� ���Բ� û���ϰ� �ֽ��ϴ�. ��翡 �����߰ų� ������ ����� ������ �ʿ��Ͻ� ��� <b>�������� ����<br>
                      &nbsp;�Ͻðų� �Ʒ��� ����ó�� ��û</b>�Ͻø� ���α���� ������ ������ �޾ƺ��� �� �ֽ��ϴ�.
                    </td>
                </tr>
                <tr>
		     		<td align=center>
			          	<table width=340 border=0 cellspacing=0 cellpadding=0>
			           		<tr>
			              		<td height=40></td>
			           		</tr>
							<tr>
								<td width=190 height=30><span class=style1>�� �ѱ����ΰ���</span></td>
								<td width=150><span class=style1>031)426-1281</span></td>
							</tr>
							<tr>
						   		<td height=30><span class=style1>�� ������ΰ�ӵ���</span></td>
								<td><span class=style1>031)8084-8947~8</span></td>
							</tr>
							<tr>
								<td height=26><span class=style1>�� �����ӵ��� �ֽ�ȸ��</span></td>
								<td>&nbsp;</td>
							</tr>
							<tr>
						  		<td height=20>&nbsp;&nbsp;&nbsp;<span class=style1>���Ϸο�����</span></td>
						    	<td><span class=style1>031)994-6400~1</span></td>
							</tr>
							<tr>
						   		<td height=20>&nbsp;&nbsp;&nbsp;<span class=style1>���ֿ�����</span></td>
						 		<td><span class=style1>031)894-6300~1</span></td>
							</tr>
							<tr>
						  		<td height=20>&nbsp;&nbsp;&nbsp;<span class=style1>�Ҿϻ꿵����</span></td>
						   		<td><span class=style1>031)522-6300~1</span></td>
							</tr>
							<tr>
						    	<td height=20>&nbsp;&nbsp;&nbsp;<span class=style1>���߿�����</span></td>
						    	<td><span class=style1>031)894-6200~1</span></td>
							</tr>
							<tr>
						    	<td height=20>&nbsp;&nbsp;&nbsp;<span class=style1>��翵����</span></td>
						 		<td><span class=style1>031)994-6300~1</span></td>
							</tr>
							<tr>
								<td height=30><span class=style1>�� ��⵵ �Ǽ�����</span></td>
								<td><span class=style1>031)429-6067~8</span></td>
							</tr>
							<tr>
						 		<td height=30><span class=style1>�� �Ű������̿���(��)</span></td>
						 		<td><span class=style1>032)560-6205</span></td>
							</tr>

							<tr>
								<td height=30><span class=style1>�� �����ӵ���</span></td>
						 		<td><span class=style1>070-7435-9041</span></td>
							</tr>
							<tr>
						   		<td height=30><span class=style1>�� ��õ�뱳(��)</span></td>
								<td><span class=style1>032)745-8200,8058</span></td>
							</tr>
							<tr>
						 		<td height=30><span class=style1>�� GK �ػ󵵷��ֽ�ȸ��</span></td>
						   		<td><span class=style1>1644-0082</span></td>
							</tr>
							<tr>
						  		<td height=30><span class=style1>�� ���� ȣ�� ���ð�ӵ���</span></td>
								<td><span class=style1>031)511-7676</span></td>
							</tr>
							<tr>
						    	<td height=30><span class=style1>�� ��õ�ýü����������̻���</span></td>
						  		<td><span class=style1>032)340-0902,0932,0952</span></td>
							</tr>
							<tr>
						   		<td height=30><span class=style1>�� ��絵�ð�������</span></td>
						     	<td><span class=style1>031)929-4848</span></td>
							</tr>
							<tr>
						  		<td height=30><span class=style1>�� �λ�ü����� ���ȴ�λ����</span></td>
						    	<td><span class=style1>051)780-0078~9</span></td>
							</tr>
							<tr>
						   		<td height=30><span class=style1>�� �Ⱦ�� �ü���������</span></td>
						 		<td><span class=style1>031)389-5327,5329,5334</span></td>
							</tr>
						 	<tr>
								<td height=15></td>
							</tr>			                             			
			       		</table>
			   		</td>
		  		</tr>
                <tr>
                    <td height=30 colspan=3></td>
                </tr>
            </table>
        </td>
    </tr>
	<tr>
  		<td height=30 style='font-size:12px;' align=center><b>* ��� �ѽ����뿡 ���� ���ǻ����� �����ø� �߽��ڿ��� �����ֽñ� �ٶ��ϴ�.</b></td>
	</tr>
</table>
<!--

<table width=595 border=0 cellspacing=0 cellpadding=0>
    <tr>
        <td height=60></td>
    </tr>
    <tr>
        <td><img src=/fms2/off_doc/images/fax_1.gif width=595 height=34></td>
    </tr>
    <tr>
        <td>&nbsp;</td>
    </tr>
    <tr>
        <td align=right>
            <table width=300 border=0 cellspacing=0 cellpadding=0>
                <tr>
                    <td height=18 align=right><%=br_addr%></td>
                </tr>
                <tr>
                    <td height=18 align=right>TEL. <%=br_tel%> | FAX. <%=br_fax%> </td>
                </tr>
            </table>
        </td>
    </tr>
    <tr>
        <td height=25></td>
    </tr>
    <tr>
        <td>
            <table width=595 border=0 cellpadding=0 cellspacing=2 bgcolor=#000000>
                <tr>
                    <td bgcolor=#FFFFFF>
                        <table width=591 border=0 cellpadding=0 cellspacing=0>
                            <tr>
                                <td width=78 height=30 align=center bgcolor=dadada><span class=style1>��&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;��</span></td>
                                <td width=217 bgcolor=#FFFFFF  style='font-size:14px;'>&nbsp;&nbsp;<b><%=s_com_nm%></b></td>
                                <td width=1 bgcolor=#000000></td>
                                <td width=78 align=center bgcolor=dadada><span class=style1>��&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;��</span></td>
                                <td width=217 bgcolor=#FFFFFF style='font-size:14px;'>&nbsp;&nbsp;<b><%=b_com_nm%></b></td>
                            </tr>
                            <tr>
                                <td colspan=5 height=1 bgcolor=#000000></td>
                            </tr>
                            <tr>
                                <td height=30 align=center bgcolor=dadada><span class=style1>��&nbsp;��&nbsp;��</span></td>
                                <td bgcolor=#FFFFFF style='font-size:14px;'>&nbsp;&nbsp;<b><%=s_agnt_nm%></b></td>
                                <td width=1 bgcolor=#000000></td>
                                <td align=center bgcolor=dadada><span class=style1>��&nbsp;��&nbsp;��</span></td>
                                <td bgcolor=#FFFFFF style='font-size:14px;'>&nbsp;&nbsp;<b><%=b_agnt_nm%></b></td>
                            </tr>
                            <tr>
                                <td colspan=5 height=1 bgcolor=#000000></td>
                            </tr>
                            <tr>
                                <td height=30 align=center bgcolor=dadada><span class=style1>��ȭ��ȣ</span></td>
                                <td bgcolor=#FFFFFF style='font-size:14px;'>&nbsp;&nbsp;<b><%=s_tel%></b></td>
                                <td width=1 bgcolor=#000000></td>
                                <td align=center bgcolor=dadada><span class=style1>��ȭ��ȣ</span></td>
                                <td bgcolor=#FFFFFF style='font-size:14px;'>&nbsp;&nbsp;<b><%=b_tel%></b></td>
                            </tr>
                            <tr>
                                <td colspan=5 height=1 bgcolor=#000000></td>
                            </tr>
                            <tr>
                                <td height=30 align=center bgcolor=dadada><span class=style1>�ѽ���ȣ</span></td>
                                <td bgcolor=#FFFFFF style='font-size:14px;'>&nbsp;&nbsp;<b><%=s_fax%></b></td>
                                <td width=1 bgcolor=#000000></td>
                                <td align=center bgcolor=dadada><span class=style1>�ѽ���ȣ</span></td>
                                <td bgcolor=#FFFFFF style='font-size:14px;'>&nbsp;&nbsp;<b><%=b_fax%></b></td>
                            </tr>
                            <tr>
                                <td colspan=5 height=1 bgcolor=#000000></td>
                            </tr>
                            <tr>
                                <td height=30 align=center bgcolor=dadada><span class=style1>��&nbsp;��&nbsp;��</span></td>
                                <td colspan=5 bgcolor=#FFFFFF style='font-size:14px;'>&nbsp;&nbsp;<b><%=cnt%>�� (ǥ������)</b></td>
                            </tr>
                            <tr>
                                <td colspan=5 height=1 bgcolor=#000000></td>
                            </tr>
                            <tr>
                                <td height=30 align=center bgcolor=dadada><span class=style1>��&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;��</span></td>
                                <td colspan=5 bgcolor=#FFFFFF style='font-size:14px;'>&nbsp;&nbsp;<b><%=dt%></b></td>
                            </tr>
                            <tr>
                                <td colspan=5 height=1 bgcolor=#000000></td>
                            </tr>
                            <tr>
                                <td height=30 align=center bgcolor=dadada><span class=style1>��&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;��</span></td>
                                <td colspan=5 bgcolor=#FFFFFF style='font-size:14px;'>&nbsp;&nbsp;<b><%=title%></b></td>
                            </tr>
                        </table>
                    </td>
                    </td>
                </tr>
            </table>
        </td>
    </tr>
    <tr>
        <td height=25></td>
    </tr>
    <tr>
        <td height=379 valign=top background=/fms2/off_doc/images/fax_3.gif>
            <table width=595 border=0 cellspacing=0 cellpadding=0>
                <tr>
                    <td height=60 colspan=3></td>
                </tr>
                <tr>
                    <td>
					  <table width=100% border=0 cellspacing=20 cellpadding=20>
					    <tr>
						  <td style='font-size:14px;'><b><%=cont%></b></td>
						</tr>
					  </table>
					</td>
                </tr>
                <tr>
                    <td colspan=3></td>
                </tr>
            </table>
        </td>
    </tr>
    <tr>
        <td height=30 align=center><span class=style1>* ��� �ѽ����뿡 ���� ���ǻ����� �����ø� �߽��ڿ��� �����ֽñ� �ٶ��ϴ�.</span></td>
    </tr>
</table>-->
<script language='javascript'>
<!--
//-->
</script>
</center>
</body>
</html>