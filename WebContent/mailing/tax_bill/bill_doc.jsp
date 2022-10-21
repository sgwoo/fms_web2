<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.common.*, tax.*, acar.user_mng.*, acar.client.*"%>
<jsp:useBean id="IssueDb" class="tax.IssueDatabase" scope="page"/>
<jsp:useBean id="al_db" class="acar.client.AddClientDatabase" scope="page"/>

<%
	CommonDataBase c_db = CommonDataBase.getInstance();
	MaMenuDatabase nm_db = MaMenuDatabase.getInstance();
	UserMngDatabase umd = UserMngDatabase.getInstance();
	
	String reg_id 		= request.getParameter("reg_id")==null?"":request.getParameter("reg_id");
	String gubun 		= request.getParameter("gubun")==null?"1":request.getParameter("gubun");
	String reg_code 	= request.getParameter("reg_code")==null?"":request.getParameter("reg_code");
	String item_id 	= request.getParameter("item_id")==null?"":request.getParameter("item_id");
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
	
	Hashtable ht = IssueDb.getTaxItemMailCase(gubun, reg_code, item_id, client_id, site_id);
	
	//������
	ClientBean client = al_db.getNewClient(client_id);
	
	//��������
	ClientSiteBean site = al_db.getClientSite(client_id, site_id);
	
	//��꼭�����
	UsersBean taxer_bean 	= umd.getUsersBean(nm_db.getWorkAuthUser("���ݰ�꼭�����"));
	
	if(String.valueOf(ht.get("CLIENT_ID")).equals("null") || String.valueOf(ht.get("CLIENT_ID")).equals("")){
		ht.put("NAME", 		client.getFirm_nm());
		ht.put("CLIENT_ID", client_id);
		ht.put("SEQ", 		site_id);
		ht.put("ITEM_DT",	AddUtil.getDate());
		ht.put("TAX_CNT",	"1");
		ht.put("TAX_YEAR",	AddUtil.getDate(1));
		ht.put("TAX_MON",	AddUtil.getDate(2));
	}
	
	//out.println(ht.get("USER_NM"));
	//out.println(ht.get("USER_H_TEL"));
	
	if(String.valueOf(ht.get("USER_NM")).equals("null") || String.valueOf(ht.get("USER_NM")).equals("")){	
		ht.put("USER_NM",	taxer_bean.getUser_nm());
		ht.put("USER_H_TEL",	taxer_bean.getHot_tel());		
	}
	
	//out.println(ht.get("USER_NM"));
	//out.println(ht.get("USER_H_TEL"));
	
	//������ 1���� ���� (���չ����� ����ڰ� ���� �����ϹǷ� ����� ���� ����)
	
	String mng_nm = "";
	String mng_hp = "";
	
	String l_cd = String.valueOf(ht.get("RENT_L_CD"));
	
	if(!item_id.equals("")){
		l_cd = c_db.getTaxItemListRent_l_cd(item_id);
	}
	
	if ( !l_cd.equals("") ) {     
	    Hashtable ht1 = c_db.getDamdang(l_cd);	     
	    mng_nm = String.valueOf(ht1.get("USER_NM"));
		mng_hp = String.valueOf(ht1.get("HOT_TEL"));	
	}
%>

<html>
<head>
<meta http-equiv=Content-Type content=text/html; charset=euc-kr>
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<title>�ŷ����� ���ϸ�</title>
<style type="text/css">
<!--
.style1 {
	color: #747474;
	font-weight: bold;
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
	font-weight: bold;
}
.button{
/*  	background-color: #8cb42c;  */
 	background-color: #78be20; 
	font-size: 14px;
	cursor: pointer;
	border-radius: 5px;
	color: #fff;
	border: 0;
	outline: 0;
	padding: 8px 10px;
	margin: 3px;
	text-decoration: none;
}
-->
</style>
<!-- <link href="http://fms1.amazoncar.co.kr/mailing/style.css" rel="stylesheet" type="text/css"> -->

</head>
<body topmargin=0 leftmargin=0>
<table width=700 border=0 cellspacing=0 cellpadding=0 align="center">
    <tr>
        <td>
            <table width=700 border=0 cellspacing=0 cellpadding=0 >
                <tr>
                    <td width=22>&nbsp;</td>
                    <td width=558><a href="https://www.amazoncar.co.kr" target="_blank" onFocus="this.blur();"><img src=https://fms5.amazoncar.co.kr/mailing/images/logo.gif width=332 height=52 border=0></a></td>
            		<!-- �� FMS�α��� ��ư -->
                    <td width=114 valign=baseline>&nbsp;<!--<a href="http://fms.amazoncar.co.kr/service/index.jsp" target="_blank" onFocus="this.blur();"><background=https://fms5.amazoncar.co.kr/mailing/images/button_fms_login.gif border=0></a>--></td>
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
    <tr>
        <td align=center background=https://fms5.amazoncar.co.kr/mailing/images/layout_bg.gif>
            <table width=677 border=0 cellspacing=0 cellpadding=0 style="background:url(https://fms5.amazoncar.co.kr/mailing/images/img_top_1.gif) no-repeat;">
                <tr>
                    <td width=436 valign=top>
                        <table width=436 border=0 cellspacing=0 cellpadding=0 height=309>
                            <tr>
                                <td width=35>&nbsp;</td>
                                <td align=center>
                                    <table width=401 border=0 cellspacing=0 cellpadding=0>
                                        <tr>
				                  			<td height=20></td>
				                  		</tr>
                                        <tr>
                                            <td width=401 height=58 align=left>&nbsp;&nbsp;&nbsp;<img src=https://fms5.amazoncar.co.kr/mailing/tax_bill/images/doc_info_title.gif></td>
                                        </tr>
                                        <tr>
                                            <td>
                                                <table width=401 border=0 cellspacing=0 cellpadding=0>
                                                    <tr>
                                                        <td width=31 align=left><img src=https://fms5.amazoncar.co.kr/mailing/tax_bill/images/info_left.gif width=11 height=67></td>
                                                        <td width=359>
                                                            <table width=359 border=0 cellspacing=0 cellpadding=0>
                                                                <tr>
                                                                    <td height=27 align=left><img src=https://fms5.amazoncar.co.kr/mailing/tax_bill/images/arrow.gif width=10 height=11> &nbsp;<span style="font-family:nanumgothic;font-size:13px;"><%=ht.get("NAME")%>&nbsp;�� </span></td>
                                                                </tr>
                                                                <tr>
                                                                    <td height=18 style="font-family:nanumgothic;font-size:13px;"><span style="color:#ff00ff;font-weight:bold;"><%=ht.get("TAX_MON")%>��</span> �ŷ������� ����Ǿ����ϴ�.<br>
																	�Ʒ� "�ŷ����� �����ϱ�"  ��ư�� �����ø� �ٷ� Ȯ�ΰ����մϴ�.</td>
                                                                </tr>
                                                            </table>
                                                        </td>
                                                        <td width=11><img src=https://fms5.amazoncar.co.kr/mailing/tax_bill/images/info_right.gif width=11 height=67></td>
                                                    </tr>
                                                </table>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td height="20">&nbsp;</td>
                                        </tr>
                                        <tr>
                                            <td>
                                                <table width=401 border=0 cellspacing=0 cellpadding=0>
                                                    <tr bgcolor=aea8b7>
                                                        <td height=1 colspan=2></td>
                                                    </tr>
                                                    <tr bgcolor=dfdde2>
                                                        <td height=1 colspan=2></td>
                                                    </tr>
                                                    <tr>
                                                        <td width=105 height=23 align=center bgcolor=efeef1><span style="font-family:nanumgothic;font-size:12px;">�߱�����</span></td>
                                                        <td width=306 align=left>&nbsp;<span style="font-family:nanumgothic;font-size:12px;"><%=ht.get("ITEM_DT")%></span></td>
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
                                        <tr>
                                            <td height=50 align=center valign=bottom>
                                            <%-- <a class="button" href="https://fms.amazoncar.co.kr/service/tax_index.jsp?client_id=<%=ht.get("CLIENT_ID")%>&r_site=<%=ht.get("SEQ")%>&s_yy=<%=ht.get("TAX_YEAR")%>&s_mm=<%=ht.get("TAX_MON")%>&gubun=tax_item" target="_blank" onFocus="this.blur();">�ŷ����� �����ϱ�</a> --%>
                                            <a class="button" href="https://client.amazoncar.co.kr/clientIndex?clientId=<%=ht.get("CLIENT_ID")%>&r_site=<%=ht.get("SEQ")%>&s_yy=<%=ht.get("TAX_YEAR")%>&s_mm=<%=ht.get("TAX_MON")%>&gubun=tax_item" target="_blank" onFocus="this.blur();">�ŷ����� �����ϱ�</a>
<%--                                             <a href="https://fms.amazoncar.co.kr/service/tax_index.jsp?client_id=<%=ht.get("CLIENT_ID")%>&r_site=<%=ht.get("SEQ")%>&s_yy=<%=ht.get("TAX_YEAR")%>&s_mm=<%=ht.get("TAX_MON")%>&gubun=tax_item" target="_blank" onFocus="this.blur();"><img src=https://fms5.amazoncar.co.kr/mailing/tax_bill/images/button_receive_doc.gif width=174 height=34 border=0></a> --%>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td height=30></td>
                                        </tr>
                                    </table>
                                </td>
                            </tr>
                        </table>
                    </td>
                    <td width=30>&nbsp;</td>
                    <td width=211 valign=top>
                        <table width=211 border=0 cellpadding=0 cellspacing=0>
                            <tr>
                            	<td width=20>&nbsp;</td>
                                <td width=191>
                                    <table width=191 border=0 cellspacing=0 cellpadding=0>
                                      <tr>
				                        <td height=90 align=left></td>
				                      </tr>
     
                                      <tr>
                                        <td align=left>&nbsp;&nbsp;&nbsp;<img src=https://fms5.amazoncar.co.kr/mailing/car_adm/images/sup_car.gif></td>
                                      </tr>
                                      <tr>
                                        <td height=5></td>
                                      </tr>
                                      <!-- ��������� ��ȭ��ȣ -->
                                      <tr>
                                        <td align=left height=17>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span style="font-family:nanumgothic;font-size:13px;font-weight:bold;color:#ffffff;"><%=mng_nm%>&nbsp;&nbsp;<%=mng_hp%></span>
                                            <!--[$user_h_tel$]-->
                                        </td>
                                      </tr>
                                      <tr>
                                        <td height=15></td>
                                      </tr>
                                      <tr>
                                        <td align=left>&nbsp;&nbsp;&nbsp;<img src=https://fms5.amazoncar.co.kr/mailing/car_adm/images/sup_acc.gif></td>
                                      </tr>
                                      <tr>
                                        <td height=5></td>
                                      </tr>
                                      <!-- ȸ������ ��ȭ��ȣ -->
                                      <tr>
                                        <td align=left height=17>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span style="font-family:nanumgothic;font-size:13px;font-weight:bold;color:#ffffff;"><%=ht.get("USER_NM")%>&nbsp;&nbsp;<%=ht.get("USER_H_TEL")%></span>
                                            <!--[$user_h_tel$]-->
                                        </td>
                                      </tr>
                                      <tr>
                                        <td height=15></td>
                                      </tr>
                                      <tr>
                                        <td align=left>&nbsp;&nbsp;&nbsp;<img src=https://fms5.amazoncar.co.kr/mailing/tax_bill/images/supervisor_2.gif width=70 height=20></td>
                                      </tr>
                                      <tr>
                                        <td height=5></td>
                                      </tr>
                                      <tr>
                                        <td align=left height=17>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span style="font-family:nanumgothic;font-size:13px;font-weight:bold;color:#ffffff;">TEL. 02-392-4243 </span></td>
                                      </tr>
                                      <tr>
                                        <td align=left height=17>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span style="font-family:nanumgothic;font-size:13px;font-weight:bold;color:#ffffff;">FAX. 02-757-0803 </span></td>
                                      </tr>
                                      <tr>
                                        <td height=10></td>
                                      </tr>
                                      <!-- ����� ��ȭ��ȣ -->
                                    </table>
                                </td>
                            </tr>
                        </table>
                    </td>
                </tr>
            </table>
        </td>
    </tr>
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
                                <td><img src=https://fms5.amazoncar.co.kr/mailing/tax_bill/images/bar_02.gif width=648 height=21></td>
                            </tr>
                            <tr>
                                <td height=5></td>
                            </tr>
                            <tr>
                                <td><img src=https://fms5.amazoncar.co.kr/mailing/tax_bill/images/doc_img_01.gif></td>
                            </tr>
							<tr>
								<td height=30></td>
							</tr>
							<tr>
                                <td><img src=https://fms5.amazoncar.co.kr/mailing/tax_bill/images/bar_07.gif width=648 height=21></td>
                            </tr>
                            <tr>
                                <td height=5></td>
                            </tr>
                            <tr>
                                <td>
                                    <table width=648 border=0 cellpadding=0 cellspacing=0 background=http://fms1.amazoncar.co.kr/mailing/tax_bill/images/con_bg.gif>
                                        <tr>
                                            <td colspan=3><img src=https://fms5.amazoncar.co.kr/mailing/tax_bill/images/con_up.gif width=648 height=7></td>
                                        </tr>
                                        <tr>
                                            <td colspan=3 height=10></td>
                                        </tr>
                                        <tr>
                                            <td width=20>&nbsp;</td>
                            <!-- ȸ�� ����� ����ó -->
                                            <td width=608 align=left>
                                                <table width=608 border=0 cellspacing=0 cellpadding=0>
                                                    <tr>
                                                        <td height=24><img src=https://fms5.amazoncar.co.kr/mailing/tax_bill/images/dot.gif width=4 height=6> <span style="font-family:nanumgothic;font-size:13px;line-height:22px;">���̱԰� ���ݰ�꼭�� ���� �� ����� �Ұ��մϴ�.<br>
	                                                    <img src=https://fms5.amazoncar.co.kr/mailing/tax_bill/images/dot.gif width=4 height=6> ������������� �������ڱ��� ����п� �����մϴ�.<br>
	                                                    &nbsp;&nbsp; (�Ⱓ�� ����� ���ݰ�꼭�� �������ݰ�꼭�� �߰����� / ����)<br>
                                                    	<img src=https://fms5.amazoncar.co.kr/mailing/tax_bill/images/dot.gif width=4 height=6> ���հ輼�ݰ�꼭�� �ŷ�����<br>
                                                    	&nbsp;&nbsp; 1. �ſ�(�ŷ����) ������<br>
														&nbsp;&nbsp; 2. ���� ������ �ŷ�����<br>
														&nbsp;&nbsp; 3. ��Ÿ������ ���� ���밡�ɿ��� ��������<br>
                                                    	<img src=https://fms5.amazoncar.co.kr/mailing/tax_bill/images/dot.gif width=4 height=6> <span style="color: #f75802;font-weight:bold;">�� ����/����(�ŷ����� �������� ����)�� �Ұ�</span>�մϴ�.<br>
														&nbsp;&nbsp; (�ΰ���ġ���� ��9��, ��16�� ����, ���ݰ�꼭 ������ ��õ�̶�� �� �� �ִ� ���� ����Ʈ��� ��� ������<br>&nbsp;&nbsp; ����� �־� ���� ��ü�� �Ұ�����)</span></td>
                                                    </tr>
                                                </table>
                                            </td>
                                            <td width=20>&nbsp;</td>
                                        </tr>
                                        <tr>
                                            <td colspan=3 height=7></td>
                                        </tr>
                                        <tr>
                                            <td colspan=3><img src=https://fms5.amazoncar.co.kr/mailing/tax_bill/images/con_dw.gif width=648 height=7></td>
                                        </tr>
                                    </table>
                                </td>
                            </tr>
                            <tr>
                                <td height=30></td>
                            </tr>
							<tr>
                                <td><img src=https://fms5.amazoncar.co.kr/mailing/tax_bill/images/bar_06.gif width=648 height=21></td>
                            </tr>
                            <tr>
                                <td height=5></td>
                            </tr>
                            <tr>
                                <td>
                                    <table width=648 border=0 cellpadding=0 cellspacing=0 background=http://fms1.amazoncar.co.kr/mailing/tax_bill/images/con_bg.gif>
                                        <tr>
                                            <td colspan=3><img src=https://fms5.amazoncar.co.kr/mailing/tax_bill/images/con_up.gif width=648 height=7></td>
                                        </tr>
                                        <tr>
                                            <td colspan=3 height=10></td>
                                        </tr>
                                        <tr>
                                            <td width=20>&nbsp;</td>
                            <!-- ȸ�� ����� ����ó -->
                                            <td width=608 align=left span style="font-family:nanumgothic;font-size:13px;line-height:22px;">��¥������ ���Ͻø� �ݵ�� <span style="color: #f75802;font-weight:bold;">ȸ������ <%=taxer_bean.getUser_nm()%></span> (<%=taxer_bean.getHot_tel()%>) ���� �����ֽñ� �ٶ��ϴ�.</td>
                                            <td width=20>&nbsp;</td>
                                        </tr>
                                        <tr>
                                            <td colspan=3 height=7></td>
                                        </tr>
                                        <tr>
                                            <td colspan=3><img src=https://fms5.amazoncar.co.kr/mailing/tax_bill/images/con_dw.gif width=648 height=7></td>
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
                                    <table width=648 border=0 cellpadding=0 cellspacing=0 background=http://fms1.amazoncar.co.kr/mailing/tax_bill/images/con_bg.gif>
                                        <tr>
                                            <td colspan=3><img src=https://fms5.amazoncar.co.kr/mailing/tax_bill/images/con_up.gif width=648 height=7></td>
                                        </tr>
                                        <tr>
                                            <td colspan=3 height=10></td>
                                        </tr>
                                        <tr>
                                            <td width=20>&nbsp;</td>
                            <!-- ȸ�� ����� ����ó -->
                                            <td width=608 align=left style="font-family:nanumgothic;font-size:13px;line-height:22px;"><span style="color: #f75802;font-weight:bold;">�� FMS</span>�� �α����Ͽ� <span style="color: #f75802;font-weight:bold;">��������</span>���� ����ڸ� ���� �����Ͻø� �˴ϴ�.</td>
                                            <td width=20>&nbsp;</td>
                                        </tr>
                                        <tr>
                                            <td colspan=3 height=7></td>
                                        </tr>
                                        <tr>
                                            <td colspan=3><img src=https://fms5.amazoncar.co.kr/mailing/tax_bill/images/con_dw.gif width=648 height=7></td>
                                        </tr>
                                    </table>
                                </td>
                            </tr>
                            <tr>
                                <td height=30></td>
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
        <td align=center background=https://fms5.amazoncar.co.kr/mailing/images/layout_bg.gif><background=https://fms5.amazoncar.co.kr/mailing/images/line.gif width=667 height=1></td>
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
        <td align=center background=https://fms5.amazoncar.co.kr/mailing/images/layout_bg.gif><background=https://fms5.amazoncar.co.kr/mailing/images/line.gif width=667 height=1></td>
    </tr>
    <tr>
        <td height=20 background=https://fms5.amazoncar.co.kr/mailing/images/layout_bg.gif>&nbsp;</td>
    </tr>
    <tr>
        <td background=https://fms5.amazoncar.co.kr/mailing/images/layout_bg.gif>
            <table width=700 border=0 cellspacing=0 cellpadding=0>
                <tr>
                    <td width=35>&nbsp;</td>
                    <td width=82><background=https://fms5.amazoncar.co.kr/mailing/images/bottom_logo.png></td>
                    <td width=28>&nbsp;</td>
                    <td width=1 bgcolor=dbdbdb></td>
                    <td width=32>&nbsp;</td>
                    <td width=493><background=https://fms5.amazoncar.co.kr/mailing/images/bottom_esti_right.gif border=0></td>
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