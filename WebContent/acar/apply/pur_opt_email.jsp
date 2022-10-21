<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, java.io.*, acar.util.*, acar.common.*, acar.user_mng.*, acar.estimate_mng.*, acar.credit.*"%>
<jsp:useBean id="user_bean" class="acar.user_mng.UsersBean" scope="page"/>
<jsp:useBean id="a_db" scope="session" class="acar.cont.AddContDatabase"/>


<%
	String from_page = request.getParameter("from_page")==null?"":request.getParameter("from_page");
	String content_st = request.getParameter("content_st")==null?"":request.getParameter("content_st");
	String pack_id 	= request.getParameter("pack_id")==null?"":request.getParameter("pack_id");
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String est_nm 	= request.getParameter("est_nm")==null?"":request.getParameter("est_nm");
	
	String m_id 	= request.getParameter("m_id")==null?"":request.getParameter("m_id");
	String l_cd 	= request.getParameter("l_cd")==null?"":request.getParameter("l_cd");
	String cls_dt 	= request.getParameter("cls_dt")==null?"":request.getParameter("cls_dt");
	
	String mtype 	= request.getParameter("mtype")==null?"":request.getParameter("mtype"); //���Կɼ��� �������꼭���� ȣ���ϴ� ���
	
	String rent_dt  = "";
	String memo     = "";
	String est_talbe= "estimate";
	
	
	UserMngDatabase umd = UserMngDatabase.getInstance();
	EstiDatabase e_db = EstiDatabase.getInstance();
	
	//���̺� ��������
	est_talbe = e_db.getEstiPackEstTableNm(pack_id);
	
	Vector vt = e_db.getEstiPackList(pack_id, est_talbe);
	int vt_size = vt.size();
	
	for(int i=0; i<vt_size; i++){
    	Hashtable ht = (Hashtable)vt.elementAt(i);
		if(i==0){
			rent_dt = String.valueOf(ht.get("RENT_DT"));
			user_id = String.valueOf(ht.get("REG_ID"));
			memo    = String.valueOf(ht.get("MEMO"));
		}
		if(est_nm.equals("")) 	est_nm 	= String.valueOf(ht.get("EST_NM"));
	}
	
	//����� ���� ��ȸ
	if(!user_id.equals("") && !user_id.equals("system") && !user_id.equals("SYSTEM")){
		user_bean 	= umd.getUsersBean(user_id);
	}
	
	if(user_id.equals("") || user_id.equals("system") || user_id.equals("SYSTEM")){
		user_id = "";
		est_nm = "��";
	}
	
	//cont_view
	Hashtable base = a_db.getContViewCase(m_id, l_cd);
	
	//���������
	UserMngDatabase u_db = UserMngDatabase.getInstance();
	
	//���������
	UsersBean b_user = u_db.getUsersBean(String.valueOf(base.get("BUS_ID2")));
	
	
%>


<html>
<head>
<meta http-equiv=Content-Type content=text/html; charset=euc-kr>
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<title>�Ƹ���ī ���Կɼ����꼭</title>
<style type="text/css">
<!--
.style1 {color: #373737}
.style2 {color: #63676a}
.style3 {color: #ff8004}
.style4 {color: #c09b33; font-weight: bold;}
.style5 {color: #c39235}
.style6 {color: #8b8063;}
.style7 {color: #77786b}
.style8 {color: #e60011}
.style9 {color: #707166; font-weight: bold;}
.style10 {color: #454545; font-size:8pt;}
.style11 {color: #6b930f; font-size:8pt;}
.style12 {color: #77786b; font-size:8pt;}
.style14 {color: #af2f98; font-size:8pt;}
-->
</style>
<link href=http://www.amazoncar.co.kr/style.css rel=stylesheet type=text/css>

<script language="JavaScript">
<!--
//New �α���
	function getLogin2(member_id, pwd){	
		var w = 450;
		var h = 250;
		var winl = (screen.width - w) / 2;
		var wint = (screen.height - h) / 2;
		var SUBWIN="https://fms.amazoncar.co.kr/service/index.jsp?name="+member_id+"&passwd="+pwd;	
//		window.open(SUBWIN, "InfoUp", "left="+winl+", top="+wint+", width="+w+", height="+h+", scrollbars=yes");
		window.open(SUBWIN, "InfoUp1", "left=5, top=5, width=1240, height=760, scrollbars=yes, status=yes, menubar=yes, toolbar=yes, resizable=yes");		
		
	}
	
	//�˾������� ����
	function MM_openBrWindow(theURL,winName,features) { //v2.0
		window.open(theURL,winName,features);
	}		
//-->
</script>
</head>
<body topmargin=0 leftmargin=0>
<table width=700 border=0 cellspacing=0 cellpadding=0 align=center>
    <tr>
        <td>
            <table width=700 border=0 cellspacing=0 cellpadding=0>
                <tr>
                    <td width=22>&nbsp;</td>
                    <td width=558><a href=http://www.amazoncar.co.kr target=_blank onFocus=this.blur();><img src=https://fms5.amazoncar.co.kr/mailing/images/logo.gif width=332 height=52 border=0></a></td>
                    <td width=114 valign=baseline>&nbsp;</td>
                </tr>
            </table>
        </td>
    </tr>
    <tr>
        <td height=7></td>
    </tr>
    <tr>
        <td><img src=https://fms5.amazoncar.co.kr/mailing/images/layout_top_est.png></td>
    </tr>
    <tr>
        <td height=10 background=https://fms5.amazoncar.co.kr/mailing/images/layout_bg.gif></td>
    </tr>
    <tr>
        <td align=center background=https://fms5.amazoncar.co.kr/mailing/images/layout_bg.gif>
            <table width=676 border=0 cellspacing=0 cellpadding=0 background=https://fms5.amazoncar.co.kr/mailing/rent/images/e_bg_fine1.gif>
                <tr>
                    <td width=20>&nbsp;</td>
                    <td width=435 height=35 align="left"><span style="font-family:nanumgothic, Sans-serif;font-size:13px;"><b><%=base.get("FIRM_NM")%> </b>��</span></td>
                    <td width=221 align="left"><span style="font-family:nanumgothic, Sans-serif;font-size:12px;"><img src=https://fms5.amazoncar.co.kr/mailing/rent/images/e_ddj.gif align=absmiddle>&nbsp;&nbsp;<%=b_user.getUser_nm()%> <%=b_user.getUser_m_tel()%></span></td>
                </tr>
            </table>
        </td>
    </tr>
    <tr>
        <td align=center background=https://fms5.amazoncar.co.kr/mailing/images/layout_bg.gif>
            <table width=676 border=0 cellspacing=0 cellpadding=0 background=https://fms5.amazoncar.co.kr/mailing/rent/images/e_bg_fine2.gif>
                <tr>
                    <td height=10></td>
                </tr>
                <tr>
                    <td width=20>&nbsp;</td>
                    <td width=636>
                        <table width=100% border=0 cellspacing=0 cellpadding=0>
                            <tr>
                                <td height=24 align="left">
                                	<span style="font-family:nanumgothic, Sans-serif;font-size:13px;">
                                		���Կɼ� ���� �ʿ伭�� �ȳ��帳�ϴ�.
                                	</span>
                                </td>
                            </tr>
                            <tr>
                                <td height=10></td>
                            </tr>
                            <tr>
                                <td><span style="font-family: nanumgothic, Sans-serif; font-size: 13px; line-height: 20px; font-weight: bold;">[���� ������ ����] �غ񼭷��� ���������� �߼۹ٶ��ϴ�.</span></td>
                            </tr>
                            <tr>
                                <td height=10></td>
                            </tr>
                            <tr>
                                <td height=18 align="left">
                                	<span style="font-family: nanumgothic, Sans-serif; font-size: 13px; line-height: 20px;">
                                		<b>* <font style="text-decoration: underline;">���� �� ���λ����(�����)</font></b><br>
                                		&nbsp;&nbsp;&nbsp;�� �ڵ����絵����(�絵�� �� ����� ���� �ŷ���) <b style="color: blue;">2��</b><br>
                                		&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; - <span style="text-decoration: none;">�ڵ����絵����(�絵�� �� ����� ���� �ŷ���)</span> <span style="color: red; font-weight: bold;">�����</span> <span style="color: red; font-weight: bold;">�ΰ� ����</span> ��<br>
                                		&nbsp;&nbsp;&nbsp;�� ����� �ΰ����� 1��(�纻 ����)<br>
                                		&nbsp;&nbsp;&nbsp;�� �ڵ������谡������ �纻 1�� (<font style="font-weight: bold; color: blue;">[<%=AddUtil.ChangeDate2(cls_dt)%>]</font>(�������ڱ���)���� ���谡�� ����)
                            		</span>
                            	</td>
                            </tr>
                            <tr>
                                <td height=10></td>
                            </tr>
                            <tr>
                            	<td height=18 align="left">
                            		<span style="font-family: nanumgothic, Sans-serif; font-size: 13px; line-height: 20px;">
                                		<b>* <font style="text-decoration: underline;">���� �� ���λ������ ���谡��</font></b><br>
                                		&nbsp;&nbsp;&nbsp;�� �ڵ����絵����(�絵�� �� ����� ���� �ŷ���) <b style="color: blue;">2��</b><br>
                                		&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; - <span style="text-decoration: none;">�ڵ����絵����(�絵�� �� ����� ���� �ŷ���)</span> <span style="color: red; font-weight: bold;">�����</span>(���谡��) <span style="color: red; font-weight: bold;">�ΰ� ����</span> ��<br>
                                		&nbsp;&nbsp;&nbsp;�� ������������(����ڿ��� ���谡��Ȯ�ο�) 1��<br>
                                		&nbsp;&nbsp;&nbsp;�� �����(���谡��) �ΰ����� 1��(�纻����)<br>
                                		&nbsp;&nbsp;&nbsp;�� �ڵ������谡������ �纻 1��
                            		</span>
                            	</td>
                            </tr>
                            <tr>
                                <td height=10></td>
                            </tr>
                            <tr>
                            	<td height=18 align="left">
                            		<span style="font-family: nanumgothic, Sans-serif; font-size: 13px; line-height: 20px;">
                                		<b>* <font style="text-decoration: underline;">����</font></b><br>
                                		&nbsp;&nbsp;&nbsp;�� �ڵ����絵����(�絵�� �� ����� ���� �ŷ���) <b style="color: blue;">2��</b><br>
                                		&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; - <span style="text-decoration: none;">�ڵ����絵����(�絵�� �� ����� ���� �ŷ���)</span> <span style="color: red; font-weight: bold;">�����</span> <span style="color: red; font-weight: bold;">�ΰ� ����</span> ��<br>
                                		&nbsp;&nbsp;&nbsp;�� ���� �ΰ����� 1��(�纻����)<br>
                                		&nbsp;&nbsp;&nbsp;�� �ڵ������谡������ �纻 1��
                            		</span>
                            	</td>
                            </tr>
                            <tr>
                                <td height=10></td>
                            </tr>
                            <tr>
                            	<td height=18 align="left">
                            		<span style="font-family: nanumgothic, Sans-serif; font-size: 13px; line-height: 20px;">
                                		<b>* <font style="text-decoration: underline;">���λ���� �� ������ ����</font></b><br>
                                		&nbsp;&nbsp;&nbsp;�� �ڵ����絵����(�絵�� �� ����� ���� �ŷ���) <b style="color: blue;">2��</b><br>
                                		&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; - <span style="text-decoration: none;">�ڵ����絵����(�絵�� �� ����� ���� �ŷ���)</span> <span style="color: red; font-weight: bold;">�����</span> <span style="color: red; font-weight: bold;">�ΰ� ����</span> ��<br>
                                		&nbsp;&nbsp;&nbsp;�� �����(����) �ΰ����� 1��(�纻 ����)<br>
                                		&nbsp;&nbsp;&nbsp;�� �ǰ������ڰݵ��Ȯ�μ� (�������) <br>
                                		&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;��, ����ӿ��� ���ε��ε���� ��ü<br>
                                		&nbsp;&nbsp;&nbsp;�� �ڵ������谡������ �纻 1��
                            		</span>
                            	</td>
                            </tr>
                            <tr>
                                <td height=20></td>
                            </tr>
                            <tr>
                            	<td height=18 align="left">
                            		<span style="font-family: nanumgothic, Sans-serif; font-size: 13px; line-height: 20px;">
                                		�� ���ǻ��� : �Ÿ���(������)�� ���� <span style="color: red; font-weight: bold;">15�� �̳�</span>�� ���������� �Ϸ��Ͽ��� �Ͽ���, ���� ���� �߼�<br>
                                		<span style="padding-left: 78px;">��Ź�帳�ϴ�. (15�� �ʰ��� ���·ᰡ �ΰ��˴ϴ�.)</span>
                            		</span>
                            	</td>
                            </tr>
                        </table>
                    </td>
                    <td width=20>&nbsp;</td>
                </tr>
                <tr>
                    <td height=10></td>
                </tr>
                <tr>
                    <td colspan=3><img src=https://fms5.amazoncar.co.kr/mailing/rent/images/e_bg_fine_dw.gif></td>
                </tr>
            </table>
        </td>
    </tr>

    <tr>
        <td height=30 align=center background=https://fms5.amazoncar.co.kr/mailing/images/layout_bg.gif></td>
    </tr>
    <tr>
        <td align=center background=https://fms5.amazoncar.co.kr/mailing/images/layout_bg.gif>
            <table width=656 border=0 cellspacing=0 cellpadding=0>
                <tr>
                    <td align=center>
                        <table width=648 border=0 cellspacing=1 cellpadding=0 >
                            <tr>
								<td bgcolor=ffffff width=420 height=30 align="right">
									<div style="display:table; border: 1px solid #5cb85c; width: 350px; height: 25px; border-radius: 5px; background-color: #5cb85c;">
			                    		<span style="display:table-cell; text-align: center; vertical-align:middle; font-size: 14px; color: white; font-weight: bold; padding-top: 2px; font-family:nanumgothic, Sans-serif;">�ڵ����絵����(�絵�� �� ����� ���� �ŷ���)</span>
			                    	</div>
								</td>
								<td bgcolor=ffffff align=left>
									<span style="padding-left: 40px; padding-top: 3px;">
										<a href="http://fms1.amazoncar.co.kr/acar/off_ls_after/car_transfer_certificate.jsp?rent_mng_id=<%=m_id%>&rent_l_cd=<%=l_cd%>" target="_blank"><span style="font-family:nanumgothic, Sans-serif; font-size:14px;">����Ȯ��(2�� ���)</span></a>
									</span>
								</td>
							</tr>
							<tr>
			                    <td height=10></td>
			                </tr>
							<tr>
								<td bgcolor=ffffff width=420 height=30 align="right">
									<div style="display:table; border: 1px solid #5cb85c; width: 350px; height: 25px; border-radius: 5px; background-color: #5cb85c;">
			                    		<span style="display:table-cell; text-align: center; vertical-align:middle; font-size: 14px; color: white; font-weight: bold; padding-top: 2px; font-family:nanumgothic, Sans-serif;">���뿩 ���Կɼ� ���꼭</span>
			                    	</div>
								</td>
								<td bgcolor=ffffff align=left>
									<span style="padding-left: 40px; padding-top: 3px;">
									<% if ( mtype.equals("est") )  { %>
										<a href="http://fms1.amazoncar.co.kr/fms2/cls_cont/lc_cls_est_print.jsp?rent_mng_id=<%=m_id%>&rent_l_cd=<%=l_cd%>" target="_blank"><span style="font-family:nanumgothic, Sans-serif; font-size:14px;">����Ȯ��</span></a>
									<% } else { %>
										<a href="http://fms1.amazoncar.co.kr/fms2/cls_cont/lc_cls_print.jsp?rent_mng_id=<%=m_id%>&rent_l_cd=<%=l_cd%>" target="_blank"><span style="font-family:nanumgothic, Sans-serif; font-size:14px;">����Ȯ��</span></a>
									<% } %>
									</span>
								</td>
							</tr>
                        </table>
                    </td>
                </tr>
                <tr>
                    <td height=40></td>
                </tr>
                <tr>
                    <td align="left">
                    	<div style="display:table; border: 1px solid #656e7f; width: 180px; height: 25px; border-radius: 5px; background-color: #656e7f; margin-left: 15px;">
                    		<span style="display:table-cell; text-align: center; vertical-align:middle; font-size: 12px; color: white;  font-family:nanumgothic, Sans-serif;">���ԿɼǱ��񼭷� ȸ�� �ּ�</span>
                    	</div>
                    </td>
                </tr>
                <tr>
                    <td height=5></td>
                </tr>
                
                <tr>
                    <td align=center>
                        <table width=648 border=0 cellspacing=0 cellpadding=0>
                        	<tr>
                        		<td height=2 bgcolor=656e7f></td>
                        	</tr>
                            <tr>
                            	<td style="height: 60px; background-color: #F2F2F2;">
                            		<table width=648 border=0 cellspacing=0 cellpadding=20 bgcolor=f2f2f2>
                            			<tr>
                                			<td style="text-align: center;">
                                				<span style="font-family:nanumgothic, Sans-serif;font-size:13.5px; text-align: center;">
                                					�����ȣ: 07236&nbsp;&nbsp;|&nbsp;&nbsp;�ּ�: ����Ư���� �������� �ǻ���� 8, 802ȣ&nbsp;&nbsp;|&nbsp;&nbsp;(��)�Ƹ���ī �����: ������
                                				</span>
                                			</td>
                                		</tr>
                                	</table>
                                </td>
                            </tr>
                            <tr>
                            	<td height=1 bgcolor=d6d6d6></td>
                            </tr>
                        </table>
                    </td>
                </tr>
				<tr>
					<td height=30></td>
				</tr>                
            </table>
        </td>
    </tr>
    <tr>
        <td align=center background=https://fms5.amazoncar.co.kr/mailing/images/layout_bg.gif><img src=https://fms5.amazoncar.co.kr/mailing/images/line.gif width=667 height=1></td>
    </tr>
    <tr>
        <td height=20 background=https://fms5.amazoncar.co.kr/mailing/images/layout_bg.gif>&nbsp;</td>
    </tr>
    <tr>
        <td background=https://fms5.amazoncar.co.kr/mailing/images/layout_bg.gif>
            <table width=700 border=0 cellspacing=0 cellpadding=0>
                <tr>
                    <td width=35>&nbsp;</td>
                    <td width=85><img src=https://fms5.amazoncar.co.kr/mailing/images/bottom_logo.png></td>
                    <td width=28>&nbsp;</td>
                    <td width=1 bgcolor=dbdbdb></td>
                    <td width=32>&nbsp;</td>
                    <td width=493><img src=https://fms5.amazoncar.co.kr/mailing/images/bottom_esti_right.gif border=0></td>
                </tr>
                <map name=Map1>
                    <area shape=rect coords=283,53,403,67 href=mailto:tax@amazoncar.co.kr>
                </map>
            </table>
        </td>
    </tr>
    <tr>
        <td height=10 background=https://fms5.amazoncar.co.kr/mailing/images/layout_bg.gif></td>
    </tr>
    <tr>
        <td><img src=https://fms5.amazoncar.co.kr/mailing/images/layout_bottom.gif width=700 height=21></td>
    </tr>
</table>
</body>
</html>