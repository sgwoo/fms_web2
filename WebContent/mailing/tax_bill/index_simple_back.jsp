<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.common.*, tax.*, acar.client.*, acar.user_mng.*"%>
<jsp:useBean id="IssueDb" scope="page" class="tax.IssueDatabase"/>
<jsp:useBean id="al_db"     class="acar.client.AddClientDatabase"      scope="page"/>

<%
	//���ݰ�꼭 ����
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	MaMenuDatabase nm_db = MaMenuDatabase.getInstance();
	UserMngDatabase umd = UserMngDatabase.getInstance();
	
	String gubun 		= request.getParameter("gubun")==null?"1":request.getParameter("gubun");
	String reg_code 	= request.getParameter("reg_code")==null?"":request.getParameter("reg_code");
	String tax_no 		= request.getParameter("tax_no")==null?"":request.getParameter("tax_no");
	String reg_dt 		= request.getParameter("reg_dt")==null?"":request.getParameter("reg_dt");
	String client_id 	= request.getParameter("client_id")==null?"":request.getParameter("client_id");
	String site_id 		= request.getParameter("site_id")==null?"":request.getParameter("site_id");
	
	if(gubun.length() >1 && reg_code.equals("") && tax_no.equals("")){
		if(gubun.length() == 28){//ex:1=201109210710013860==008812
			String t_gubun = gubun;
			gubun 		= t_gubun.substring(0,1);
			reg_code 	= t_gubun.substring(1,20);
			client_id	= t_gubun.substring(22,28);
		}
		if(gubun.length() == 30){//ex:1=201109210710013860=01=008812
			String t_gubun = gubun;
			gubun 		= t_gubun.substring(0,1);
			reg_code 	= t_gubun.substring(1,20);
			site_id 	= t_gubun.substring(21,23);
			client_id	= t_gubun.substring(24,30);
		}
	}
	
	if(!reg_code.equals("") && tax_no.equals("")){
		gubun = "1";
	}
	if(reg_code.equals("") && !tax_no.equals("")){
		gubun = "2";
	}
	
	Hashtable ht = IssueDb.getTaxMailCase(gubun, reg_code, tax_no, client_id, site_id);	
	
	if(String.valueOf(ht.get("CLIENT_ID")).equals("null") || String.valueOf(ht.get("CLIENT_ID")).equals("")){
		ht = IssueDb.getTaxMailCase2(gubun, reg_code, tax_no, client_id, site_id);
	}
	
	//������
	ClientBean client = al_db.getNewClient(client_id);
	
	//��������
	ClientSiteBean site = al_db.getClientSite(client_id, site_id);
	
	if(String.valueOf(ht.get("CLIENT_ID")).equals("null") || String.valueOf(ht.get("CLIENT_ID")).equals("")){
		ht.put("NAME", 		client.getFirm_nm());
		ht.put("CLIENT_ID", client_id);
		ht.put("SEQ", 		site_id);
		ht.put("REG_DT",	AddUtil.getDate());
		ht.put("TAX_CNT",	"1");
		ht.put("TAX_YEAR",	AddUtil.getDate(1));
		ht.put("TAX_MON",	AddUtil.getDate(2));		
	}
	
	//out.println(ht.get("USER_NM"));
	//out.println(ht.get("USER_H_TEL"));

	if(String.valueOf(ht.get("USER_NM")).equals("null") || String.valueOf(ht.get("USER_NM")).equals("")){	
		String tax_user_id = nm_db.getWorkAuthUser("���ݰ�꼭�����");
		UsersBean tax_user_bean = umd.getUsersBean(tax_user_id);
		
		ht.put("USER_NM",	tax_user_bean.getUser_nm());
		ht.put("USER_H_TEL",	tax_user_bean.getHot_tel());
	}
	
	//out.println(ht.get("USER_NM"));
	//out.println(ht.get("USER_H_TEL"));
	
	
	//������ 1���� ���� (���չ����� ����ڰ� ���� �����ϹǷ� ����� ���� ����)
	
	String mng_nm = "";
	String mng_hp = "";
	
	String l_cd = "";
	l_cd = c_db.getTaxRent_l_cd(tax_no);
	
	if ( !l_cd.equals("") ) {
	     
	     Hashtable ht1 = c_db.getDamdang(l_cd);
	     
	     mng_nm = String.valueOf(ht1.get("USER_NM"));
		 mng_hp = String.valueOf(ht1.get("HOT_TEL"));
	
	}
		
%>

<html>
<html lang="ko">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<meta http-equiv="X-UA-Compatible" content="IE=edge">

<title>���� ���ݰ�꼭 ���ϸ�</title>
<style type="text/css">
<!--
.style1 {
	color: #747474;
	font-weight: bold;
	font-family:nanumgothic;
}
.style2 {color: #747474}
.style3 {
	color: #ff00ff;
	font-weight: bold;
}
.style4 {color: #626262}
.style5 {color: #376100}
.style6 {
	color: #FFFFFF;
	font-weight: bold;
}
.style8 {color: #696969}
.style9 {
	color: #f75802;
}
-->
</style>


</head>
<body topmargin=0 leftmargin=0>
<table width=700 border=0 cellspacing=0 cellpadding=0 align="center">
    <tr>
        <td>
            <table width=700 border=0 cellspacing=0 cellpadding=0>
                <tr>
                    <td width=22>&nbsp;</td>
                    <td width=558><a href="https://www.amazoncar.co.kr" target="_blank" onFocus="this.blur();"><img src=https://fms5.amazoncar.co.kr/mailing/images/logo.gif width=332 height=52 border=0></a></td>           
                    <td width=114 valign=baseline>&nbsp;</td>
                </tr>
            </table>
        </td>
    </tr>
    <tr>
        <td height=7></td>
    </tr>
    <tr>
        <td><img src=https://fms5.amazoncar.co.kr/mailing/images/layout_top.gif width=700 height=21></td>
    </tr>
    <tr>
        <td height=5 background=https://fms5.amazoncar.co.kr/mailing/images/layout_bg.gif></td>
    </tr>
    <!-- ���� -->
    <tr>
        <td align=center style="font-size:20px;" background=https://fms5.amazoncar.co.kr/mailing/images/layout_bg.gif>�Ƹ���ī ���ڼ��ݰ�꼭 ���� �ȳ���</td>
    </tr>
    <tr>
        <td height=40 align=center background=https://fms5.amazoncar.co.kr/mailing/images/layout_bg.gif>&nbsp;</td>
    </tr>
    <tr align=center style="font-size:20px;" background=https://fms5.amazoncar.co.kr/mailing/images/layout_bg.gif>
                                            <td>
                                                <table width=90% border=0 cellspacing=0 cellpadding=0>
                                                    <tr>
                                                        <td width=31 align=left><img src=https://fms5.amazoncar.co.kr/mailing/tax_bill/images/info_left.gif width=11 height=67></td>
                                                        <td>
                                                            <table width=100% border=0 cellspacing=0 cellpadding=0>
                                                                <tr>
                                                                    <td height=27 align=left><img src=https://fms5.amazoncar.co.kr/mailing/tax_bill/images/arrow.gif width=10 height=11> &nbsp;<span style="font-family:nanumgothic;font-size:13px;"><%=ht.get("NAME")%>&nbsp;�� </span></td>
                                                                </tr>
                                                                <tr>
                                                                    <td height=18 style="font-family:nanumgothic;font-size:13px;"><span style="color:#ff00ff;font-weight:bold;"><%=ht.get("TAX_MON")%>��</span> ���ݰ�꼭�� ����Ǿ����ϴ�.<br>
																	�Ʒ� "���ݰ�꼭 �����ϱ�" ��ư�� �����ø� �ٷ� Ȯ�� �����մϴ�.</td>
                                                                </tr>
                                                            </table>
                                                        </td>
                                                        <td width=11><img src=https://fms5.amazoncar.co.kr/mailing/tax_bill/images/info_right.gif width=11 height=67></td>
                                                    </tr>
                                                </table>
                                            </td>
                                        </tr>    
    <tr>
        <td height=40 align=center background=https://fms5.amazoncar.co.kr/mailing/images/layout_bg.gif>&nbsp;</td>
    </tr>
    <tr align=center style="font-size:20px;" background=https://fms5.amazoncar.co.kr/mailing/images/layout_bg.gif>
                                            <td>
                                                <table width=90% border=0 cellspacing=0 cellpadding=0>
                                                    <tr bgcolor=aea8b7>
                                                        <td height=1 colspan=2></td>
                                                    </tr>
                                                    <tr bgcolor=dfdde2>
                                                        <td height=1 colspan=2></td>
                                                    </tr>
                                                    <tr>
                                                        <td width=40% height=23 align=center bgcolor=efeef1><span style="font-family:nanumgothic;font-size:12px;">�߱�����</span></td>
                                                        <td width=60% align=left>&nbsp;<span style="font-family:nanumgothic;font-size:12px;"><%=ht.get("REG_DT")%></span></td>
                                                    </tr>
                                                    <tr bgcolor=dfdde2>
                                                        <td height=1 colspan=2></td>
                                                    </tr>
                                                    <tr>
                                                        <td height=23 align=center bgcolor=efeef1><span style="font-family:nanumgothic;font-size:12px;">�����Ǽ�</span></td>
                                                        <td align=left>&nbsp;<span style="font-family:nanumgothic;font-size:12px;"><%=ht.get("TAX_CNT")%> ��</span></td>
                                                    </tr>
                                                    <tr bgcolor=dfdde2>
                                                        <td height=1 colspan=2></td>
                                                    </tr>
                                                    <tr bgcolor=aea8b7>
                                                        <td height=1 colspan=2></td>
                                                    </tr>
                                                </table>
                                            </td>
                                        </tr>
    <tr align=center style="font-size:20px;" background=https://fms5.amazoncar.co.kr/mailing/images/layout_bg.gif>
                                            <td height=50 align=center valign=bottom><a href="https://fms.amazoncar.co.kr/service/tax_index.jsp?client_id=<%=ht.get("CLIENT_ID")%>&r_site=<%=ht.get("SEQ")%>&s_yy=<%=ht.get("TAX_YEAR")%>&s_mm=<%=ht.get("TAX_MON")%>" target="_blank" onFocus="this.blur();"><button class="button" name="bill_doc" id="bill_doc">���ݰ�꼭 �����ϱ�</button></a></td>
                                        </tr>
                                        <!-- 
    <tr>
        <td height=30 style="font-size:10px;" align=right background=https://fms5.amazoncar.co.kr/mailing/images/layout_bg.gif>�� <a href="http://fms1.amazoncar.co.kr/mailing/tax_bill/index_info.jsp" target="_blank" onFocus="this.blur();">���Ź��</a>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
    </tr>
     -->                                        
    
    <tr>
        <td height=30 align=center background=https://fms5.amazoncar.co.kr/mailing/images/layout_bg.gif>&nbsp;</td>
    </tr>
    <tr>
        <td align=center background=https://fms5.amazoncar.co.kr/mailing/images/layout_bg.gif>
            <table width=700 border=0 cellspacing=0 cellpadding=0>
                <tr>
                    <td width=26>&nbsp;</td>
                    <td width=648>
                        <table width=648 border=0 cellspacing=0 cellpadding=0>
                            <tr>
                                <td><img src=https://fms5.amazoncar.co.kr/mailing/tax_bill/images/bar_03.gif width=648 height=21></td>
                            </tr>
                            <tr>
                                <td height=5></td>
                            </tr>
                            <tr>
                                <td>
                                    <table width=648 border=0 cellpadding=0 cellspacing=0 background=https://fms5.amazoncar.co.kr/mailing/tax_bill/images/con_bg.gif>
                                        <tr>
                                            <td><img src=https://fms5.amazoncar.co.kr/mailing/tax_bill/images/con_up.gif width=648 height=7></td>
                                        </tr>
                                        <tr>
                                            <td height=10></td>
                                        </tr>
                                        <tr>
                                            <td  align=left><span style="font-family:nanumgothic;font-size:13px;line-height:20px;">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;1. ��й�ȣ�� &quot;�� FMS&quot; �α��� ��й�ȣ�� �Է��ϼž� �մϴ�.<br>
											&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;2. ó�� �湮�Ͻô� ���� ����/���λ����-����ڵ�Ϲ�ȣ, ����-�ֹε�Ϲ�ȣ�� �Է��ϼž� �մϴ�.<br>
                                            &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;3. �Է��Ͻ� ��й�ȣ�� ��ġ���� ���� ��쿡�� <span style="color: #f75802;">IT�� 02-392-4243</span> �Ǵ� <span style="color: #f75802;">����(<a href=mailto:dev@amazoncar.co.kr><span style="font-family:nanumgothic;color: #f75802;">dev@amazoncar.co.kr</span></a>)</span>��<br>
                                            &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; �����ֽñ� �ٶ��ϴ�. </span>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td height=10></td>
                                        </tr>
                                        <tr>
                                            <td><img src=https://fms5.amazoncar.co.kr/mailing/tax_bill/images/con_dw.gif width=648 height=7></td>
                                        </tr>
                                    </table>                                   
                                </td>
                            </tr>
                            <tr>
                                <td height=30></td>
                            </tr>
                            <tr>
                                <td><img src=https://fms5.amazoncar.co.kr/mailing/tax_bill/images/bar_04.gif width=648 height=21></td>
                            </tr>
                            <tr>
                                <td height=5></td>
                            </tr>
                            <tr>
                                <td>
                                    <table width=648 border=0 cellpadding=0 cellspacing=0 background=https://fms5.amazoncar.co.kr/mailing/tax_bill/images/con_bg.gif>
                                        <tr>
                                            <td><img src=https://fms5.amazoncar.co.kr/mailing/tax_bill/images/con_up.gif width=648 height=7></td>
                                        </tr>
                                        <tr>
                                            <td height=10></td>
                                        </tr>
                                        <tr>
                            				<!-- ȸ�� ����� ����ó -->
                                            <td align=left style="font-family:nanumgothic;font-size:12px;line-height:20px;">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&quot;<span style="color: #f75802;">�� FMS</span>&quot;�� �α����Ͽ� ����ڸ� ���� �����ϰų� <span style="color: #f75802;">ȸ������ <%=ht.get("USER_H_TEL")%></span> ���� �����ֽñ� �ٶ��ϴ�. </span></td>
                                        </tr>
                                        <tr>
                                            <td height=10></td>
                                        </tr>
                                        <tr>
                                            <td><img src=https://fms5.amazoncar.co.kr/mailing/tax_bill/images/con_dw.gif width=648 height=7></td>
                                        </tr>
                                    </table>
                                </td>
                            </tr>
                            <tr>
                                <td height=30></td>
                            </tr>
                            <tr>
                                <td><img src=https://fms5.amazoncar.co.kr/mailing/tax_bill/images/bar_01.gif width=648 height=21></td>
                            </tr>
                            <tr>
                                <td height=5></td>
                            </tr>
                            <tr>
                                <td>
                                    <table width=648 border=0 cellpadding=0 cellspacing=0 background=https://fms5.amazoncar.co.kr/mailing/tax_bill/images/con_bg.gif>
                                        <tr>
                                            <td><img src=https://fms5.amazoncar.co.kr/mailing/tax_bill/images/con_up.gif width=648 height=7></td>
                                        </tr>
                                        <tr>
                                            <td height=10></td>
                                        </tr>
                                        <tr>
                                            <td align=left style="font-family:nanumgothic;font-size:13px;line-height:20px;">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;���Բ��� ������ ������ �ƴϽø� <span style="color: #f75802;">����(<a href=mailto:tax@amazoncar.co.kr><span style="font-family:nanumgothic;color: #f75802;">tax@amazoncar.co.kr</span></a>)</span>�� �����ֽñ� �ٶ��ϴ�.</span></td>
                                        </tr>
                                        <tr>
                                            <td height=10></td>
                                        </tr>
                                        <tr>
                                            <td><img src=https://fms5.amazoncar.co.kr/mailing/tax_bill/images/con_dw.gif width=648 height=7></td>
                                        </tr>
                                    </table>
                                </td>
                            </tr> 
                        </table>
                    </td>
                    <td width=26>&nbsp;</td>
                </tr>
            </table>
        </td>
    </tr>
    <tr>
        <td height=30 background=https://fms5.amazoncar.co.kr/mailing/images/layout_bg.gif></td>
    </tr>
    <tr>
        <td align=center background=https://fms5.amazoncar.co.kr/mailing/images/layout_bg.gif><img src=https://fms5.amazoncar.co.kr/mailing/images/line.gif width=667 height=1></td>
    </tr>
    <tr>
        <td height=20 background=https://fms5.amazoncar.co.kr/mailing/images/layout_bg.gif></td>
    </tr>
   <tr>
        <td align=center background=https://fms5.amazoncar.co.kr/mailing/images/layout_bg.gif style="font-family:nanumgothic;font-size:11px;">�� ������ �߽����� �����̹Ƿ� �ñ��� ������ <a href=mailto:tax@amazoncar.co.kr><span style="font-size:11px;color:#af2f98;font-family:nanumgothic;">���Ÿ���(tax@amazoncar.co.kr)</span></a>�� �����ֽñ� �ٶ��ϴ�.</span></td>
    </tr>
    <tr>
        <td height=20 background=https://fms5.amazoncar.co.kr/mailing/images/layout_bg.gif></td>
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
                    <td width=82><img src=https://fms5.amazoncar.co.kr/mailing/images/bottom_logo.png></td>
                    <td width=28>&nbsp;</td>
                    <td width=1 bgcolor=dbdbdb></td>
                    <td width=32>&nbsp;</td>
                    <td width=493><img src=https://fms5.amazoncar.co.kr/mailing/images/bottom_esti_right.gif border=0></td>
                </tr>
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